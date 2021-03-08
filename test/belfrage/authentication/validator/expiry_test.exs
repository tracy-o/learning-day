defmodule Belfrage.Authentication.Validator.ExpiryTest do
  use ExUnit.Case, async: true
  alias Belfrage.Authentication.Validator.Expiry

  describe "valid?/2" do
    setup do
      %{
        threshold: Application.get_env(:belfrage, :authentication)["jwt_expiry_threshold"]
      }
    end

    test "when the expiry is not within the threshold", %{threshold: threshold} do
      assert Expiry.valid?(threshold, System.os_time(:second) + threshold + 2)
    end

    test "when the expiry is within the threshold", %{threshold: threshold} do
      refute Expiry.valid?(threshold, System.os_time(:second) + threshold - 2)
    end

    test "when the expiry is in the past", %{threshold: threshold} do
      refute Expiry.valid?(threshold, System.os_time(:second) - 1)
    end
  end
end
