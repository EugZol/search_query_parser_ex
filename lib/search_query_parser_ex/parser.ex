defmodule SearchQueryParserEx.Parser do
  alias SearchQueryParserEx.Lexer

  def parse(s) when is_bitstring(s) do
    :search_query_parser_backend.parse(Lexer.string(s))
  end
end
