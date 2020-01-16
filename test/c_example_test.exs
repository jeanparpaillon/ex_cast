defmodule CExampleTest do
  use ExUnit.Case

  test "enum Numbers" do
    assert %{one: 1, two: 2, three: 3} = CExample.Numbers.mapping()

    assert 1 = CExample.Numbers.value(:one)
    assert 2 = CExample.Numbers.value(:two)
    assert 3 = CExample.Numbers.value(:three)

    assert :one = CExample.Numbers.key(1)
    assert :two = CExample.Numbers.key(2)
    assert :three = CExample.Numbers.key(3)
  end

  test "enum Buddies" do
    assert %{world: 0, planet: 1, universe: 2} = CExample.Buddies.mapping()

    assert 0 = CExample.Buddies.value(:world)
    assert 1 = CExample.Buddies.value(:planet)
    assert 2 = CExample.Buddies.value(:universe)

    assert :world = CExample.Buddies.key(0)
    assert :planet = CExample.Buddies.key(1)
    assert :universe = CExample.Buddies.key(2)
  end
end
