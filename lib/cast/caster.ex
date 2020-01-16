defmodule Cast.Caster do
  @moduledoc """
  Provides common casting functions
  """
  require Regex

  @string_re ~r"^\"(.*)\"$"

  @doc """
  Cast charlist into integer

  Examples

    iex> integer('456')
    456

    iex> integer('-67')
    -67
  """
  def integer(v) when is_list(v), do: List.to_integer(v)

  @doc """
  Cast charlist into float

  Examples

    iex> float('456')
    456.0

    iex> float('-67.678')
    -67.678
  """
  def float(v) when is_list(v) do
    List.to_float(v)
  rescue
    _e in [ArgumentError] ->
      integer(v) + 0.0
  end


  @doc """
  Cast double-quoted charlist into String

  Examples

    iex> string('"hello"')
    "hello"
  """
  def string(v) when is_list(v) do
    v
    |> List.to_string()
    |> (&Regex.replace(@string_re, &1, "\\1")).()
  end
end
