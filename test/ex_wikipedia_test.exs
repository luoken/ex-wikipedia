defmodule ExWikipediaTest do
  use ExUnit.Case
  doctest ExWikipedia

  test "greets the world" do
    assert ExWikipedia.hello() == :world
  end
end
