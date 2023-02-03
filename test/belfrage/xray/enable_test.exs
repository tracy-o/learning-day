defmodule Belfrage.Xray.EnableTest do
  use ExUnit.Case, async: true

  alias Belfrage.Xray.Enable
  alias Belfrage.Test.XrayHelper
  alias Belfrage.Struct

  describe "call/1" do
    test "when `xray_enabled` is true the struct is left unchanged" do
      struct = %Struct{
        private: %Struct.Private{
          xray_enabled: true
        },
        request: %Struct.Request{
          xray_segment: XrayHelper.build_segment([])
        }
      }

      assert Enable.call(struct) == struct
    end

    test "when `xray_enabled` is false the `xray_segment` is removed from the struct" do
      struct = %Struct{
        private: %Struct.Private{
          xray_enabled: false
        },
        request: %Struct.Request{
          xray_segment: XrayHelper.build_segment([])
        }
      }

      assert Enable.call(struct).request.xray_segment == nil
    end
  end
end
