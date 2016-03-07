defmodule BlankAssertions do
  defmacro assert(expr) do
    if contains_blank?(expr) do
      code = Macro.escape(expr)
      quote do
        raise ExUnit.AssertionError, expr: unquote(code)
      end
    else
      quote do
        ExUnit.Assertions.assert(unquote(expr))
      end
    end
  end

  defmacro refute(expr) do
    if contains_blank?(expr) do
      code = Macro.escape(expr)
      quote do
        raise ExUnit.AssertionError, expr: unquote(code)
      end
    else
      quote do
        ExUnit.Assertions.refute(unquote(expr))
      end
    end
  end

  def assert(value, opts) do
    ExUnit.Assertions.assert(value, opts)
  end

  defp contains_blank?(expr) do
    {_, blank} = Macro.prewalk(expr, false, &blank?/2)
    blank
  end

  defp blank?(node, true) do
    {node, true}
  end

  defp blank?({expr, _, _} = node, _acc) do
    {node, expr == :__}
  end

  defp blank?(expr, _acc) do
    {expr, expr == :__}
  end
end