defmodule FooBar do
  @fname [:is_one, :is_two, :is_three]
  @fvalues [1, 2, 3]

  for {f, val} <- Enum.zip(@fname, @fvalues) do
    def unquote(f)(unquote(val)), do: true
    def unquote(f)(_), do: false
  end
  |> IO.inspect(label: "for loop")
end

FooBar.is_one(1)
|> IO.inspect(label: "is_one")

FooBar.is_two(4)
|> IO.inspect(label: "is_two")

# FooBar.__info__(:functions) |> IO.inspect(label: "functions")
