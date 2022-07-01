# HELPER FUNCTIONS
defmodule CLI do
  def add2(x) do
    x + 2
  end

  def enum_task(range) do
    range
    |> Enum.map(fn x -> Task.async(fn -> CLI.add2(x) end) end)
    |> Enum.map(&Task.await/1)
  end

  def enum_only(range) do
    range
    |> Enum.map(fn x -> CLI.add2(x) end)
  end

  def async_stream_task(range) do
    range |> Task.async_stream(&CLI.add2/1, ordered: false) |> Enum.to_list()
  end
end

# Stream
Stream.map([1, 2, 3], fn x -> CLI.add2(x) end)
Enum.map([1, 2, 3], fn x -> CLI.add2(x) end)
Stream.map([1, 2, 3], fn x -> CLI.add2(x) end) |> Enum.to_list()

# summary -> Stream is lazy Enum. (mostly)

# PROBLEM of CONCURRENCY - SPIKES!!
1..100 |> CLI.enum_task()

# :observer.start()

# ASYNC_STREAM
1..100 |> CLI.async_stream_task()
1..10000 |> CLI.async_stream_task()
1..1_000_000 |> CLI.async_stream_task()

1..1000_000 |> CLI.enum_only()
#  to spawn or not to - sasa juric
1..1000_000 |> CLI.enum_task()
1..1_000_000 |> CLI.async_stream_task()
