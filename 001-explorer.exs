Mix.install([
  {:benchee, "~> 1.3"},
  {:explorer, "~> 0.8.0"}
])

alias Explorer.Series

s1 = 100_001..1 |> Enum.to_list() |> Series.from_list()
s = 200_000..100_000 |> Enum.to_list() |> Series.from_list()

s2 = 100_001..1 |> Enum.to_list()
s3 = 200_000..100_000 |> Enum.to_list()

defmodule SeriesCrunch do
  alias Explorer.Series

  def run(s1, s2) do
    # Returns boolean mask of left == right, element-wise.
    Series.equal(s1, s2)
  end
end

defmodule EnumCrunch do
  def run(s1, s2) do
    # Returns boolean mask of left == right, element-wise.
    Enum.zip_reduce(s1, s2, [], fn x, y, acc -> [x == y | acc] end)
  end
end

Benchee.run(
  %{
    "Series" => fn -> SeriesCrunch.run(s, s1) end,
    "Enum" => fn -> EnumCrunch.run(s2, s3) end
  },
  warmup: 2,
  time: 3
)
