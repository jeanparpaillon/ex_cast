defmodule CExample do
  use Cast, ast: "test/support/c_example/hello.xml"

  const :version, cast: &integer/1
  const :app, cast: &string/1

  enum Numbers, contains: "one"
  enum Buddies, name: "buddy"
end
