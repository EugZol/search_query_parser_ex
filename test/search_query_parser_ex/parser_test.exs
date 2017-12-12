defmodule SearchQueryParserEx.ParserTest do
  alias SearchQueryParserEx, as: P

  use ExUnit.Case, async: true

  doctest SearchQueryParserEx.Parser

  describe ".parse/1" do
    test "parses complex expressions" do
      # (((a b) & c) | ((d e) & (f | (! g))))
      expected =
        {
          :|,
          {
            :&,
            {:" ", "a", "b"},
            "c"
          },
          {
            :&,
            {:" ", "d", "e"},
            {
              :|,
              "f",
              {:!, "g"}
            }
          }
        }

      {:ok, result} = P.parse("a b&c|d e&(f|!g)")
      assert result == expected
    end
  end
end
