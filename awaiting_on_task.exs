# Aim: Run a process and wait for it to finish and return results. Carry on with your own work.

defmodule CLI do
  def run() do
    Task.async(fn ->
      Process.sleep(1000)
      IO.inspect("Slept for 1 minute")
      5
    end)
  end
end

defmodule CallerProcess do
  CLI.run()
  |> Task.await()

  self() |> IO.inspect(label: "pid")
  Process.sleep(6000)
end
