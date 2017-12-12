defmodule SearchQueryParserExTest do
  use ExUnit.Case
  doctest SearchQueryParserEx

  describe ".to_ts_query/3" do
    test "produces PostgreSQL ts_query structures from bare string" do
      {:ok, r} = SearchQueryParserEx.to_ts_query("cats !dogs !собаки || (birds & 'птицы*  ) ^")
      expected = "(((to_tsquery('english', 'cats:*') <-> (!! to_tsquery('english', 'dogs:*'))) <-> (!! to_tsquery('english', 'собаки:*'))) || (to_tsquery('english', 'birds:*') && to_tsquery('english', 'птицы:*')))"
      assert r == expected
    end
  end
end
