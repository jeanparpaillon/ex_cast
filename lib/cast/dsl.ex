defmodule Cast.DSL do
  @moduledoc """
  Provides DSL for importing Cast types
  """
  require Logger

  import SweetXml

  @doc """
  Declares an enumeration module

  Arguments
  * `name`: name of the generated module
  * `opts`: keyword list, one of:
    * `contains`: one of the value of the enumeration to extract (for anonymous
      enumerations)
    * `name`: name of the enumeration

  Generates a module with following functions:
  * `mapping/0`: returns a `%{atom => integer}` map
  * `key/1`: returns the atom key for a given integer. Raise if invalid value.
  * `value/1`: returns the integer value for a given atom key. Raise if invalid
    key.
  """
  defmacro enum(name, opts) do
    quote do
      @enums {unquote(name), unquote(opts)}
    end
  end

  @doc """
  Declares a constant

  Arguments:
  * `name`: name of the constant in the AST
  * `opts`: keyword list
    * `name: valid function name`: if constant name is not a valid function
      name, this option gives the name of the function to generate

  Generates a function to access value.
  """
  defmacro const(name, opts \\ []) do
    quote do
      @consts {unquote(name), unquote(opts)}
    end
  end

  defmacro __before_compile__(env) do
    ast =
      env.module
      |> Module.get_attribute(:ast)
      |> parse_ast()

    enums = Module.get_attribute(env.module, :enums)
    consts = Module.get_attribute(env.module, :consts)

    quote do
      unquote(def_enums(env, ast, enums))
      unquote(def_consts(env, ast, consts))
    end
  end

  defp parse_ast(filename) do
    Logger.debug("Loading C AST from #{filename}")

    filename
    |> File.read!()
    |> SweetXml.parse()
  end

  defp def_consts(env, ast, consts),
    do: Enum.map(consts, &def_const(env, ast, &1))

  defp def_const(_env, ast, {name, opts}) do
    cast = Keyword.get(opts, :cast, & &1)

    const =
      ast
      |> xpath(~x"/GCC_XML/Variable[@name='#{name}']/@init")
      |> cast.()
      |> Macro.escape()

    name = Keyword.get(opts, :name, name)

    quote do
      def unquote(name)(), do: unquote(const)
    end
  end

  defp def_enums(env, ast, enums),
    do: Enum.map(enums, &def_enum(env, ast, &1))

  defp def_enum(env, ast, {name, opts}) do
    module = Module.concat(env.module, name)

    enum =
      {Keyword.get(opts, :contains), Keyword.get(opts, :name)}
      |> case do
        {nil, nil} ->
          raise "enum: one of :contains or :name option is required"

        {contains, nil} ->
          extract_anon_enum(ast, contains)

        {nil, name} ->
          extract_enum(ast, name)

        _ ->
          raise "enum: one of :contains or :name option is required"
      end
      |> Enum.reduce(%{}, &Map.put(&2, List.to_atom(&1.name), List.to_integer(&1.value)))

    quote do
      defmodule unquote(module) do
        unquote(def_enum_mapping(enum))
        unquote(def_enum_value(enum))
        unquote(def_enum_key(enum))
      end
    end
  end

  defp def_enum_mapping(enum) do
    enum = Macro.escape(enum)

    quote do
      def mapping, do: unquote(enum)
    end
  end

  defp def_enum_value(enum) do
    Enum.map(enum, fn {key, value} ->
      quote do
        def value(unquote(key)), do: unquote(value)
      end
    end)
  end

  defp def_enum_key(enum) do
    Enum.map(enum, fn {key, value} ->
      quote do
        def key(unquote(value)), do: unquote(key)
      end
    end)
  end

  defp extract_anon_enum(ast, contains) do
    ast
    |> xpath(~x"/GCC_XML/Enumeration[EnumValue/@name='#{contains}']/EnumValue"l,
      name: ~x"@name",
      value: ~x"@init"
    )
  end

  defp extract_enum(ast, name) do
    ast
    |> xpath(~x"/GCC_XML/Enumeration[@name='#{name}']/EnumValue"l,
      name: ~x"@name",
      value: ~x"@init"
    )
  end
end
