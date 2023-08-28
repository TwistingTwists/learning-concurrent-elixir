defmodule LinksTestNoTrap do
  def chain(0) do
    type = :not_normal
    IO.puts(" #{type} exit in the last link :0 ")
    :timer.sleep(300)
    exit(type)
  end

  def chain(n) do
    # Process.flag(:trap_exit, true)
    :timer.sleep(300)
    pid = spawn_link(__MODULE__, :chain, [n - 1])
    IO.puts("create link in a chain no. #{n} - #{inspect(pid)}")

    receive do
      msg -> IO.puts("#{n} received #{inspect(msg)}")
    end
  end
end

IO.inspect(self(), label: "parent process?")

LinksTestNoTrap.chain(10)

receive do
  {:EXIT, b, a} -> IO.inspect("parent process received exit - #{inspect(b)} ; #{inspect(a)}")
  msg -> IO.inspect("parent process received msg - #{inspect(msg)} ")
end
