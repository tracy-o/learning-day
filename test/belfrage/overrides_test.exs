defmodule Belfrage.OverridesTest do
  use ExUnit.Case
  alias Belfrage.{Envelope, Overrides}

  describe "&should_cache_bust?/1" do
    test "when cache bust override IS provided" do
      envelope = %Envelope{
        private: %Envelope.Private{
          overrides: %{
            "belfrage-cache-bust" => nil
          }
        }
      }

      assert Overrides.should_cache_bust?(envelope)
    end

    test "when cache bust override is NOT provided" do
      envelope = %Envelope{
        private: %Envelope.Private{
          overrides: %{}
        }
      }

      refute Overrides.should_cache_bust?(envelope)
    end
  end
end
