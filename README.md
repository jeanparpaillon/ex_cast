# Cast

Whenever you need to interface with C code, you will need to deal with
constants, enumerations, etc.

Cast (for C-AST) allows to build elixir code directly from C AST.

## Requirements

Cast uses C AST built with [castxml](https://github.com/CastXML).

## Usage

See `Cast` module documentation and examples in `test/support`.

## Installation

The package can be installed by adding `cast` to your list of dependencies in
`mix.exs`:

```elixir
def deps do
  [
    {:cast, "~> 0.1.0"}
  ]
end
```
