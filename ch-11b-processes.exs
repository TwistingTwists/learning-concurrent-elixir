defmodule LinksTest do
  def chain(0) do
    IO.puts("chain called with 0, wating 2000 ms before exit")
    :timer.sleep(200)
    exit(:chain_breaks_here)
  end

  def chain(n) do
    Process.flag(:trap_exit, true)
    IO.puts("chain called with #{n}")
    :timer.sleep(300)
    spawn_link(__MODULE__, :chain, [n - 1])

    receive do
      {:EXIT, pid, reason} ->
        :timer.sleep(500)
        IO.puts("Child process exits with reason #{reason}")
    end
  end
end

IO.inspect(self(), label: "parent process?")

LinksTest.chain(10)

receive do
  {:EXIT, b, a} -> IO.inspect("parent process received exit - #{inspect(b)} ; #{inspect(a)}")
end
