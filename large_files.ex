# from blog: https://pspdfkit.com/blog/2021/the-perils-of-large-files-in-elixir/?utm_source=elixir-merge

# ```markdown
# These results may be a bit surprising at first, but there’s a valid explanation: Our cache store is under very little load, so it doesn’t trigger automatic garbage collection. This behavior can be observed in many applications that don’t have much traffic; while numbers may vary, in my experience, processes that receive a read request every two to three seconds can suffer from this problem.

# There are different ways to mitigate this issue, the simplest one being changing the return value of handle_call/3 from {:reply, contents, base_path} to {:reply, contents, base_path, :hibernate}. By instructing the process to hibernate, the runtime triggers a garbage collection and releases all unneeded references. Hibernation comes at a (tiny) CPU cost when “waking up” the process (which happens automatically when it receives a new request).
# ```
defmodule Perils.Examples.Cache do
  use GenServer

  def start_link(base_path) do
    GenServer.start_link(__MODULE__, base_path, name: __MODULE__)
  end

  def init(base_path) do
    {:ok, base_path}
  end

  def read(file_name) do
    GenServer.call(__MODULE__, {:read, file_name})
  end

  def handle_call({:read, file_name}, _from, base_path) do
    full_path = Path.join(base_path, file_name)
    contents = File.read!(full_path)
    {:reply, contents, base_path}
  end
end

Mix.install([:req])
# Code.require_file("./customcache.ex")
url = "http://ipv4.download.thinkbroadband.com/200MB.zip"
# ReqCache.download(url)
# :erlang.memory(:total)
# |> IO.inspect(label: "Total before read")
# req = Req.new(http_errors: :raise)
# Req.get!(req, url: url)
# Perils.Examples.Cache.read("large.dat")

# :erlang.memory(:total)
# |> IO.inspect(label: "Total after read")
