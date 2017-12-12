defmodule SearchQueryParserExTest do
  use ExUnit.Case
  doctest SearchQueryParserEx

  describe ".to_ts_query/3" do
    test "produces PostgreSQL ts_query structures with wrapping" do
      {:ok, r} = SearchQueryParserEx.to_ts_query("cats !dogs !собаки || (birds & 'птицы*  ) ^", false, true, "russian")
      expected = "(((to_tsquery('russian', 'cats')<->(!!to_tsquery('russian', 'dogs')))<->(!!to_tsquery('russian', 'собаки')))||(to_tsquery('russian', 'birds')&&to_tsquery('russian', 'птицы')))"
      assert r == expected
    end

    test "produces PostgreSQL ts_query without wrapping" do
      {:ok, r} = SearchQueryParserEx.to_ts_query("cats !dogs !собаки || (birds & 'птицы*  ) ^")
      expected = "(((cats:*<->(!dogs:*))<->(!собаки:*))|(birds:*&птицы:*))"
      assert r == expected
    end
  end
end
