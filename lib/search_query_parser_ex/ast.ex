defmodule SearchQueryParserEx.Ast do
  @binary_ops [:"&", :"|", :" "]
  @unary_ops  [:"!"]

  import Kernel, except: [to_string: 1]

  def reduce({op, x, y}, f) when op in @binary_ops, do: f.({op, reduce(x, f), reduce(y, f)})
  def reduce({op, x}, f) when op in @unary_ops, do: f.({op, reduce(x, f)})
  def reduce(x, f) when is_bitstring(x), do: f.(x)

  def to_string(ast), do: reduce(ast, &print_ast/1)

  defp print_ast({:" ", x, y}), do: "(#{x}<->#{y})"
  defp print_ast({:"!", x}), do: "(!#{x})"
  defp print_ast({op, x, y}), do: "(#{x}#{op}#{y})"
  defp print_ast(x), do: Kernel.to_string(x)
end
