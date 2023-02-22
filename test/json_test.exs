defmodule Belfrage.JsonTest do
  use ExUnit.Case

  @test_map %{
    "envelope" => %{
      "private" => %{
        "counter" => %{},
        "owner" => nil,
        "response_pipeline" => [],
        "checkpoints" => %{},
        "preview_mode" => "off",
        "candidate_route_state_ids" => []
      }
    }
  }

  test "returns string for a short json jiffy-encoded as string" do
    assert is_binary(:jiffy.encode(@test_map))
    assert is_binary(Json.encode!(@test_map))
  end

  test "returns string for a long json jiffy-encoded as iolist" do
    large_test_map = generate_large_map()

    assert is_list(:jiffy.encode(large_test_map))
    assert is_binary(Json.encode!(large_test_map))
  end

  defp generate_large_map() do
    Enum.reduce(
      1..20,
      @test_map,
      fn n, map -> Map.put(map, "some_new_key_" <> Integer.to_string(n), @test_map) end
    )
  end
end
