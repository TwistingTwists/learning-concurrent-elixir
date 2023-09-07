defmodule WhoOwnsMe do
  @moduledoc """
  Identfiy who is the parent and who is the caller for this process.

  adapted from Sequin.io blog
  """

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def do_the_thing(pid \\ __MODULE__, n) do
    GenServer.call(pid, {:do_the_thing, n})
  end

  @impl GenServer
  def init(_opts) do
    {:ok, %{}}
  end

  defp log(message) do
    now = DateTime.utc_now() |> DateTime.truncate(:second)
    IO.puts("#{now}: #{message}")
  end

  @impl GenServer
  def handle_call({:do_the_thing, n}, from, state) do
    Task.async(fn ->
      log("Sleeping for 2 seconds...")

      log(
        "\n handle_call: \n self:  #{inspect(self())} \n $callers: #{inspect(Process.get(:"$callers"))} \n $initial_call: #{inspect(Process.get(:"$initial_call"))} \n $ancestors: #{inspect(Process.get(:"$ancestors"))} \n"
      )

      Process.sleep(2000)

      GenServer.reply(from, n * 1000)
    end)

    {:noreply, state}
  end

  @impl GenServer
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  def test do
    {:ok, pid} = start_link()
    log("test: #{inspect(self())}")
    log("pid? of start_link: #{inspect(pid)}")

    try do
      1..5
      |> Enum.map(fn n ->
        Task.async(fn ->
          log(
            "\n Task.async: \n self:  #{inspect(self())} \n $callers: #{inspect(Process.get(:"$callers"))} \n $initial_call: #{inspect(Process.get(:"$initial_call"))} \n $ancestors: #{inspect(Process.get(:"$ancestors"))} \n"
          )

          # log("Task.async: #{inspect(Process.get_keys())}")
          do_the_thing(n)
        end)
      end)
      |> Task.await_many()
      |> inspect()
      |> log()
    after
      GenServer.stop(pid)
    end
  end
end

WhoOwnsMe.test()
