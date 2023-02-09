defmodule Belfrage.Xray.EnableTest do
  use ExUnit.Case, async: true

  alias Belfrage.Xray.Enable
  alias Belfrage.Test.XrayHelper
  alias Belfrage.Envelope

  describe "call/1" do
    test "when `xray_enabled` is true the envelope is left unchanged" do
      envelope = %Envelope{
        private: %Envelope.Private{
          xray_enabled: true
        },
        request: %Envelope.Request{
          xray_segment: XrayHelper.build_segment([])
        }
      }

      assert Enable.call(envelope) == envelope
    end

    test "when `xray_enabled` is false the `xray_segment` is removed from the envelope" do
      envelope = %Envelope{
        private: %Envelope.Private{
          xray_enabled: false
        },
        request: %Envelope.Request{
          xray_segment: XrayHelper.build_segment([])
        }
      }

      assert Enable.call(envelope).request.xray_segment == nil
    end
  end
end
