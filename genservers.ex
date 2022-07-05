# A behaviour module for implementing the server of a client-server relation
# used to keep state, execute code asynchronously, etc

# Genserver vs Task vs Agent vs spawn - When to use what?

# When not to use Genserver
# In Elixir, code organization is done by modules and functions, processes are not necessary.
# If you don't need a process, then you don't need a process. 
# Use processes only to model runtime properties, such as mutable state, concurrency and failures, never for code organization.


# Example:

defmodule Stack do
  use GenServer

  # Client

  def start_link(default) when is_list(default) do
    GenServer.start_link(__MODULE__, default)
  end

  def push(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def pop(pid) do
    GenServer.call(pid, :pop)
  end

  # Server (callbacks)
  
  # Invoked when the server is started. start_link/3 or start/3, it will block until it returns
  @impl true
  def init(stack) do
    # Process.flag(:trap_exit, true)
    {:ok, stack, {:continue, :init_state}}
    #{:ok, stack}
  end
  
  @impl true
  def handle_continue(:init_state, state) do
    IO.puts "In handle_continue"
    {:noreply, state}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end
  
  @impl true
  def handle_call(:pop, _from, []), do: raise "Stack underflow"

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end
  
  # Invoked when the server is about to exit. It should do any cleanup required.
  @impl true
  def terminate(reason, _state) do
    IO.inspect "Terminating due to #{inspect(reason)}"
  end
end

{:ok, pid} = GenServer.start_link(Stack, [:hello])

Stack.push(pid, :world)
Stack.pop(pid)

# Pop multiple times
Stack.pop(pid) # Raises exception resulting in terminate/2 call

# Restart genserver, send exit signal
{:ok, pid} = GenServer.start_link(Stack, [:hello])
Process.exit(pid, :boom) # Linked genserver process exits and IEX exits without terminate call

# Enable trapping exits and retry
{:ok, pid} = GenServer.start_link(Stack, [:hello])
Process.exit(pid, :boom) # This time terminate/2 is invoked -> "Terminating due to :boom" -> genserver process exits and IEX exits

# When trap_exit is set to true, exit signals arriving to a process are converted to {'EXIT', From, Reason} messages, 
# which can be received as ordinary messages.
# If you trap exists and then the linked process when killed will send you a {:EXIT, #PID<0.113.0>, :boom} and your process will not crash
# See demo below...
{:ok, pid} = GenServer.start_link(Stack, [:hello])
Process.flag(:trap_exit, true) # Parent trapping exits
Process.exit(pid, :boom)                          
flush() # IEX process did not exit and instead Received {:EXIT, #PID<0.180.0>, :boom}


# Introspect the state of the process and trace system events that happen during its execution, such as received messages, sent replies and state changes
# More here: https://hexdocs.pm/elixir/1.13/GenServer.html#module-debugging-with-the-sys-module
# Get genserver state :sys.get_state(Name)
# :sys.trace(pid, true) -> Start tracing the process, logs messages and state changes
# :sys.trace(pid, false) -> Stop tracing the process
# :sys.statistics(pid, true) # turn on collecting process statistics
# :sys.statistics(pid, false) # turn off collecting process statistics
# :sys.statistics(pid, :get) # get process statistics

# Genserver Callbacks

# init(args)
# Invoked when the server is started. start_link/3 or start/3, it will block until it returns

# Return values 
# {:ok, state}
# | {:ok, state, timeout() | :hibernate | {:continue, term()}}
# | :ignore
# | {:stop, reason :: any()}

# ----------------
# handle_call(request, from, state)
# Invoked to handle synchronous call/3 messages. call/3 will block until a reply is received

# Return values:
# * {:reply, reply, new_state}
# * {:noreply, new_state}
# * {:noreply, new_state, timeout()}
# * {:noreply, new_state, :hibernate}
# * {:noreply, new_state, {:continue, term()}}                      -> handle_continue/2 will be invoked immediately after with the value continue as first argument.
# * {:stop, reason, reply, new_state} | {:stop, reason, new_state}  -> stops the loop and terminate/2 will be invoked


# What is Hibernate?
#   On returning hibernate the genserver will hibernate and will only continue the loop once a message is in its message queue. 
#   However, if a message is already in the message queue, the process will continue the loop immediately. 
#   Hibernating a GenServer causes garbage collection and leaves a continuous heap that minimises the memory used by the process.
#   Normally it should only be used when a message is not expected soon and minimising the memory of the process is shown to be beneficial.

# What is timeout?
#   The return value of init/1 or any of the handle_* callbacks may include a timeout value in milliseconds (default infinity)
#   when the specified number of milliseconds have elapsed with no message arriving, handle_info/2 is called with :timeout as the first argument.
#   If any message arrives before the specified number of milliseconds elapse, the timeout is cleared and that message is handled as usual.
#   If the process has any message already waiting when the timeout() value is returned, the timeout is ignored and the waiting message is handled as usual. 

# ----------------
# handle_cast(request, state)
# Invoked to handle asynchronous cast/2 messages. Does not block the caller.
# Can't reply back, return values are similar to handle_call

# ----------------
# handle_continue(continue, state)
# Invoked to handle continue instructions.
# It is useful for performing work after initialization or for splitting the work in a callback in multiple steps, updating the process state along the way.

# ----------------
# handle_info(msg, state)
# Handle regular messages, incudes messages send by Kernel.send/2, Process.send_after/4, etc

#-----------------
# format_status(reason, pdict_and_state) -> Format genserver state for :sys.get_status/1 or :sys.get_status/2 calls

#-----------------
# code_change(old_vsn, state, extra) -> Invoked to change the state of the GenServer when a different version of a module is loaded (hot code swapping)

#-----------------
# terminate(reason, state)
# Invoked when the server is about to exit. It should do any cleanup required.
# If the GenServer receives an exit signal (that is not :normal) from any process
# then it is not trapping exits it will exit abruptly with the same reason and so not call terminate/2

# Called if the GenServer traps exits (using Process.flag/2)
# Called when 
#   parent process sends an exit signal
#   returns a :stop tuple or invalid value
#   raises (via Kernel.raise/2) or exits (via Kernel.exit/1)
  
# If reason is neither :normal, :shutdown, nor {:shutdown, term} an error is logged.
