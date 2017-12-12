defmodule SearchQueryParserEx.AstTest do
  alias SearchQueryParserEx, as: A

  use ExUnit.Case, async: true

  doctest SearchQueryParserEx.Ast

  describe ".to_string/1" do
    test "converts ast to string representation" do
      expected = "(((a<->b)&c)|((d<->e)&(f|(!g))))"

      {:ok, result} = A.parse("a b&c|d e&(f|!g)")
      assert A.to_string(result) == expected
    end
  end
end
