# Aim: Run a process and wait for it to finish and return results. Carry on with your own work.

defmodule CLI do
  def run() do
    Task.async(fn ->
      self()
      |> IO.inspect(label: "task is running in self(): ")

      Process.sleep(1000)
      IO.inspect("Slept for 1 minute")

      receive do
        {:ok, num} ->
          IO.inspect(num, label: "received a num")
          num + 10

        anything_else ->
          IO.inspect(anything_else, label: "received anything else")
      end
    end)
  end
end

defmodule CallerProcess do
  task =
    CLI.run()
    |> IO.inspect(label: "task")

  send(task.pid, {:ok, 666})
  |> IO.inspect(label: "send")

  task |> Task.await() |> IO.inspect(label: "task output ")

  self() |> IO.inspect(label: "pid")
  Process.sleep(60000)
end
