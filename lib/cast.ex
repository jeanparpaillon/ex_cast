defmodule Cast do
  @moduledoc """
  Functions to navigate into C AST produced by castxml

  XML parsing is done through SweetXml: memory usage can be really high
  """

  @type ast :: term
  @type enum_filter :: {:contains, String.t()}
  @type enum_filters :: [enum_filter]

  defmacro __using__(opts) do
    ast_src = Keyword.fetch!(opts, :ast)

    quote do
      import Cast.DSL, only: [enum: 2, const: 1, const: 2]
      import Cast.Caster
      Module.put_attribute(__MODULE__, :ast, unquote(ast_src))
      Module.register_attribute(__MODULE__, :enums, accumulate: true)
      Module.register_attribute(__MODULE__, :consts, accumulate: true)

      @before_compile Cast.DSL
    end
  end
end
