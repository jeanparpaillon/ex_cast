defmodule Cast do
  @moduledoc """
  This module provides macros to generate elixir code from C AST.

  # Usage

  First you need to generate an XML representation of C AST thanks to
  [castxml](https://github.com/CastXML) (version >= 0.2), in GCC mode (other
  modes may be supported in the future).

  `castxml` has many options. Its usage is out of the scope of this document.
  However, generating AST from a simple C project may be as simple as:

  ```sh
  castxml -c -x c -std=gnu11 --castxml-cc-gnu gcc --castxml-gccxml -o ast.xml hello.c
  ```

  The module where you want to generate elixir code from C AST must begin with:

  ```elixir
  use Cast, ast: "/path/to/ast.xml"
  ```

  Then, you can use the following macros to generate constants accessors or
  enumeration modules:

  * [`enum/2`](`Cast.DSL.enum/2`)
  * [`const/{1,2}`](`Cast.DSL.const/2`)

  WARNING: XML parsing is done through DOM parser, memory usage can be really
  high

  # Example:

    Given following C code:

    ```C
    const int version = 1;

    enum pets {
      elephant = 0,
      mouse
    }
    ```

    Following elixir module:

    ```elixir
    defmodule Hello do
      use Cast, ast: "/path/to/ast.xml

      const :version, cast: &integer/1
      enum Pets, name: "pets"
    end
    ```

    Will result in:

    ```elixir
    %{elephant: 0, mouse: 1} = Hello.Pets.mapping()

    0 == Hello.Pets.value :elephant
    1 == Hello.Pets.value :mouse

    :elephant == Hello.Pets.key 0
    :mouse == Hello.Pets.key 1

    1 == Hello.version()
    ```

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
