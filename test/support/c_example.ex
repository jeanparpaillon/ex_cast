defmodule CExample do
  use Cast, ast: "test/support/c_example/hello.xml"

  enum Numbers, contains: "one"
  enum Buddies, name: "buddy"
end
