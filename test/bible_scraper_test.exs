defmodule BibleScraperTest do
  use ExUnit.Case
  doctest BibleScraper

  test "greets the world" do
    assert BibleScraper.hello() == :world
  end
end
