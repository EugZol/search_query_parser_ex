defmodule SearchQueryParserEx.LexerTestHelper do
  def term(x), do: {:term, 1, x}
  def op(x), do: {String.to_atom(x), 1}
end

defmodule SearchQueryParserEx.LexerTest do
  alias SearchQueryParserEx.Lexer, as: L

  import SearchQueryParserEx.LexerTestHelper

  use ExUnit.Case, async: true

  doctest SearchQueryParserEx.Lexer

  describe ".string/1" do
    [
      {
        ~s[preserves "-" inside of a word],
        "mini-model",
        [term("mini-model")]
      },
      {
        ~s[removes "-" if not inside of a word],
        "-mini- -model-",
        [term("mini"), op(" "), term("model")]
      },
      {
        "preserves unicode",
        "幸运1",
        [term("幸运1")]
      },
      {
        "removes several spaces and non-al-num in a row",
        "  too  many   * spaces$#(  )*\"\"  \t",
        [term("too"), op(" "), term("many"), op(" "), term("spaces"), op(" "), op("("), op(")")]
      },
      {
        "changes && to & and || to |, removing extra spaces",
        "a && b || c d",
        [term("a"), op("&"), term("b"), op("|"), term("c"), op(" "), term("d")]
      },
      {
        "removes spaces at brackets correctly",
        "(a b  ) \t(c& d )(e) (   f",
        [op("("), term("a"), op(" "), term("b"), op(")"), op(" "), op("("), term("c"), op("&"),
          term("d"), op(")"), op("("), term("e"), op(")"), op(" "), op("("), term("f")]
      },
      {
        "cleans up complex expressions",
        "cats !dogs !собаки || (birds & птицы*  ) ^",
        [term("cats"), op(" "), op("!"), term("dogs"), op(" "), op("!"), term("собаки"),
          op("|"), op("("), term("birds"), op("&"), term("птицы"), op(")")]
      },
    ]
    |> Enum.map(fn {description, input, output} ->
      output = Macro.escape(output)
      test description do
        r = L.string(unquote(input))
        assert r == unquote(output)
      end
    end)
  end
end
