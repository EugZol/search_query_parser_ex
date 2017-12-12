defmodule SearchQueryParserEx do
  import Kernel, except: [to_string: 1]

  defdelegate parse(s), to: SearchQueryParserEx.Parser
  defdelegate reduce(ast, f), to: SearchQueryParserEx.Ast
  defdelegate to_string(s), to: SearchQueryParserEx.Ast

  def to_ts_query(str, language \\ "english", prefix \\ true) do
    language = String.replace(language, ~r/[^a-zA-Z]/, "")
    with {:ok, ast} <- parse(str)
    do
      result =
        reduce(ast, fn
          {:" ", x, y} -> ~s{(#{x} <-> #{y})}
          {:"|", x, y} -> ~s{(#{x} || #{y})}
          {:"&", x, y} -> ~s{(#{x} && #{y})}
          {:"!", x}    -> ~s{(!! #{x})}
          x ->
            if prefix do
              ~s{to_tsquery('#{language}', '#{x}:*')}
            else
              ~s{to_tsquery('#{language}', '#{x}')}
            end
        end)
      {:ok, result}
    else
      {:error, error} -> {:error, error}
    end
  end
end
