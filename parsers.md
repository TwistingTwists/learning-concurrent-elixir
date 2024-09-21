# What are parser combinators?

### Parser 

fn parser(String) -> (Tree, String)

### Combinator

# Why are they better than regex?

- recursive! 
- lookahead! 
- context-sensitive grammars (html!)
- composability
- Errors and dragons!


Grammar!  Yeay! 

# Enter - Pegasus! 



Let's tackle this problem using both regex and parser combinators in Elixir, and then provide the ABNF grammar notation for balanced parentheses.
Regex solution in Elixir:
While regex is not the ideal tool for handling balanced parentheses (especially for nested structures), here's an attempt that works for simple cases:
```elixir
defmodule BalancedParentheses do
  def balanced?(str) do
    regex = ~r/^(\((?:[^()]|\g<1>)*\))*$/
    Regex.match?(regex, str)
  end
end

# Usage

IO.puts BalancedParentheses.balanced?("((()))") # true
IO.puts BalancedParentheses.balanced?("(()())") # true
IO.puts BalancedParentheses.balanced?("(()") # false
```

This regex uses recursion to match nested parentheses, but it has limitations and can be inefficient for deeply nested structures.
Parser combinator solution in Elixir using NimbleParsec:

```elixir
defmodule BalancedParentheses do
  import NimbleParsec

  parentheses =
    empty()
    |> ignore(ascii_char([?(]))
    |> repeat(
      lookahead_not(ascii_char([?), ?(]))
      |> choice([
        ascii_char([not ?( and not ?)]),
        parsec(:parentheses)
      ])
    )
    |> ignore(ascii_char([?)]))

  defparsec :parse, repeat(choice([parentheses, ascii_char([not ?( and not ?)])])) |> eos()

  def balanced?(str) do
    case parse(str) do
      {:ok, _, "", _, _, _} -> true
      _ -> false
    end
  end
end

# Usage
IO.puts BalancedParentheses.balanced?("((()))") # true
IO.puts BalancedParentheses.balanced?("(()())") # true
IO.puts BalancedParentheses.balanced?("(()") # false
```


This parser combinator approach is more robust and can handle complex nested structures.
ABNF grammar notation for balanced parentheses:
Here's the ABNF grammar notation for balanced parentheses:

```text
balanced-parentheses = *( balanced-group / non-parenthesis )

balanced-group = "(" *( balanced-group / non-parenthesis ) ")"

non-parenthesis = %x01-27 / %x2A-5B / %x5D-7F
                  ; Any ASCII character except "(" and ")"
```

Explanation:
balanced-parentheses is the main rule, allowing any number of balanced groups or non-parenthesis characters.
balanced-group is defined recursively, allowing nested balanced groups.
non-parenthesis includes any ASCII character except "(" and ")".
This ABNF grammar accurately describes the structure of balanced parentheses, including nested structures. It's more expressive and precise than the regex solution, and aligns well with the parser combinator approach in terms of handling complex nested structures.
