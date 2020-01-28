defmodule Belfrage.OverridesTest do
  use ExUnit.Case
  alias Belfrage.{Struct, Overrides}

  describe "&should_cache_bust?/1" do
    test "when cache bust override IS provided" do
      struct = %Struct{
        private: %Struct.Private{
          overrides: %{
            "belfrage-cache-bust" => nil
          }
        }
      }

      assert Overrides.should_cache_bust?(struct)
    end

    test "when cache bust override is NOT provided" do
      struct = %Struct{
        private: %Struct.Private{
          overrides: %{}
        }
      }

      refute Overrides.should_cache_bust?(struct)
    end
  end
end
