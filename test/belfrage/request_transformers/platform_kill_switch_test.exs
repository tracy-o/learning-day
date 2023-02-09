defmodule Belfrage.RequestTransformers.PlatformKillSwitchTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.PlatformKillSwitch
  alias Belfrage.Envelope

  defp envelope_with_platform(platform_name) do
    %Envelope{
      private: %Envelope.Private{platform: platform_name}
    }
  end

  defp activate_webcore_kill_switch() do
    stub(Belfrage.Dials.ServerMock, :state, fn :webcore_kill_switch ->
      Belfrage.Dials.WebcoreKillSwitch.transform("active")
    end)
  end

  defp disable_webcore_kill_switch() do
    stub(Belfrage.Dials.ServerMock, :state, fn :webcore_kill_switch ->
      Belfrage.Dials.WebcoreKillSwitch.transform("inactive")
    end)
  end

  describe "when the Webcore kill switch is active" do
    test "and the platform is Webcore, the pipeline is stopped and a 500 response is added to the Envelope" do
      activate_webcore_kill_switch()

      assert {
               :stop,
               %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 500
                 }
               }
             } = PlatformKillSwitch.call(envelope_with_platform("Webcore"))
    end

    test "and the platform is Fabl, the pipeline continues and the envelope is unchanged" do
      activate_webcore_kill_switch()
      original_envelope = envelope_with_platform("Fabl")
      assert {:ok, ^original_envelope} = PlatformKillSwitch.call(original_envelope)
    end

    test "and the platform is nil, the pipeline continues and the envelope is unchanged" do
      disable_webcore_kill_switch()
      original_envelope = envelope_with_platform(nil)
      assert {:ok, ^original_envelope} = PlatformKillSwitch.call(original_envelope)
    end
  end

  describe "when the Webcore kill switch is inactive" do
    test "and the platform is Webcore, the pipeline continues and the envelope is unchanged" do
      disable_webcore_kill_switch()
      original_envelope = envelope_with_platform("Webcore")
      assert {:ok, ^original_envelope} = PlatformKillSwitch.call(original_envelope)
    end

    test "and the platform is Fabl, the pipeline continues and the envelope is unchanged" do
      disable_webcore_kill_switch()
      original_envelope = envelope_with_platform("Fabl")
      assert {:ok, ^original_envelope} = PlatformKillSwitch.call(original_envelope)
    end

    test "and the platform is nil, the pipeline continues and the envelope is unchanged" do
      disable_webcore_kill_switch()
      original_envelope = envelope_with_platform(nil)
      assert {:ok, ^original_envelope} = PlatformKillSwitch.call(original_envelope)
    end
  end
end
