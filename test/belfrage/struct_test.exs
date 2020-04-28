defmodule Belfrage.StructTest do
  use ExUnit.Case
  alias Belfrage.Struct

  describe "loggable/1" do
    test "removes response body" do
      assert "REMOVED" == Struct.loggable(%Struct{}).response.body
    end
  end
end
