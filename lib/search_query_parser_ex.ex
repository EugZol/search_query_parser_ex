defmodule SearchQueryParserEx do
  defdelegate parse(s), to: SearchQueryParserEx.Parser
  defdelegate to_string(s), to: SearchQueryParserEx.Ast
end
