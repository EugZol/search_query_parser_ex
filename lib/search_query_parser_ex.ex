defmodule SearchQueryParserEx do
  import Kernel, except: [to_string: 1]

  defdelegate parse(s), to: SearchQueryParserEx.Parser
  defdelegate reduce(ast, f), to: SearchQueryParserEx.Ast
  defdelegate to_string(s), to: SearchQueryParserEx.Ast

  def to_ts_query(str, prefix \\ true, wrap \\ false, language \\ "english") do
    language = String.replace(language, ~r/[^a-zA-Z]/, "")
    with {:ok, ast} <- parse(str)
    do
      result = reduce(ast, &unwrap(&1, prefix, wrap, language))
      {:ok, result}
    else
      {:error, error} -> {:error, error}
    end
  end

  defp op(:" ", _), do: "<->"
  defp op(atom, _wrap = true), do: op(atom, false) |> String.duplicate(2)
  defp op(atom, false), do: Kernel.to_string(atom)

  defp unwrap({atom, x, y}, _prefix, wrap, _language), do: ~s{(#{x}#{op(atom, wrap)}#{y})}
  defp unwrap({atom, x}, _prefix, wrap, _language), do: ~s{(#{op(atom, wrap)}#{x})}
  defp unwrap(x, prefix, wrap, language) do
    x =
      if prefix do
        x <> ":*"
      else
        x
      end
    if wrap do
      ~s{to_tsquery('#{language}', '#{x}')}
    else
      x
    end
  end
end
