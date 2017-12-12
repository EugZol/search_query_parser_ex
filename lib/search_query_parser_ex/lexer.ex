defmodule SearchQueryParserEx.Lexer do
  @ops ["&", "|", "!", " ", "(", ")"]

  def string(str) do
    str = prepare_string(str)
    result =
      Regex.scan(~r/[[:alnum:]\-]+|[&|()!\s]/u, str)
      |> Enum.map(&to_token/1)

    result
  end

  defp to_token([x]), do: to_token(x)
  defp to_token(op) when op in @ops, do: {String.to_atom(op), 1}
  defp to_token(str) when is_bitstring(str), do: {:term, 1, str}

  defp prepare_string(str) do
    str
    |> String.replace(~r/\s/u, " ")
    |> String.replace(~r/[&]+/u, "&")
    |> String.replace(~r/[|]+/u, "|")
    |> String.replace(~r/[^[:alnum:]\-()&|!]+/u, " ")
    |> String.replace(~r/([^[:alnum:]]|^)\-/u, "\\1")
    |> String.replace(~r/\-([^[:alnum:]]|$)/u, "\\1")
    |> String.replace(~r/ ?([|&]) ?/u, "\\1")
    |> String.replace(~r/(!) /u, "\\1")
    |> String.replace(~r/(\() /u, "\\1")
    |> String.replace(~r/ (\))/u, "\\1")
    |> String.trim
  end
end
