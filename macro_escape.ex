defmodule FooBar do
  @fname [:is_one, :is_two, :is_three]
  @fvalues [%{1 => "one"}, %{2 => "two"}, %{3 => "three"}]

  for {f, val} <- Enum.zip(@fname, @fvalues) do
    # %{1 => "one"} is not a quoted expression.
    val = Macro.escape(val)
    def unquote(f)(unquote(val)), do: true
    def unquote(f)(_), do: false
  end

  #### PATTERN MATCHING ON SIMPLE VALUES - NO NEED FOR MACRO.escape
  # @fvalues [1, 2, 3]

  # for {f, val} <- Enum.zip(@fname, @fvalues) do
  #   def unquote(f)(unquote(val)), do: true
  #   def unquote(f)(_), do: false
  # end

  #### {:val, [] Elixir} is the AST, not 1 (the value of `val`) - thats why the warning says `val` is not used.
  # for {f, val} <- Enum.zip(@fname, @fvalues) do
  #   def unquote(f)(val), do: true
  #   def unquote(f)(_), do: false
  # end
end

FooBar.is_one(%{1 => "one"})
|> IO.inspect(label: "is_one")

# FooBar.is_two(4)
# |> IO.inspect(label: "is_two")

FooBar.__info__(:functions) |> IO.inspect(label: "functions")
