Mix.install([
  {:benchee, "~> 1.3"},
  {:explorer, "~> 0.8"}
])

alias Explorer.Series

s1 = 100_001..1 |> Enum.to_list() |> Series.from_list()
# s = 200_000..100_000 |> Enum.to_list() |> Series.from_list()

s2 = 100_001..1 |> Enum.to_list()
# s3 = 200_000..100_000 |> Enum.to_list()

defmodule SeriesCrunch do
  alias Explorer.Series

  def run(s1) do
    # aggregate functions
    Series.mean(s1)
  end
end

defmodule EnumCrunch do
  def run(s1) do
    # Returns boolean mask of left == right, element-wise.
    Enum.sum(s1) / Enum.count(s1)
  end
end

defmodule Enum2Crunch do
  def run(s1) do
    # Returns boolean mask of left == right, element-wise.
    {count, sum} = Enum.reduce(s1, {0, 0}, fn x, {count, sum} -> {count + 1, x + sum} end)
    sum / count
  end
end

Benchee.run(
  %{
    "Series" => fn -> SeriesCrunch.run(s1) end,
    "Enum.sum / Enum.count " => fn -> EnumCrunch.run(s2) end,
    "Enum.reduce" => fn -> Enum2Crunch.run(s2) end
  },
  warmup: 2,
  time: 3
)
