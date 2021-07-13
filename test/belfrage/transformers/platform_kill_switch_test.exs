defmodule Belfrage.Transformers.PlatformKillSwitchTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.PlatformKillSwitch
  alias Belfrage.Struct

  defp struct_with_platform(platform_name) do
    %Struct{
      private: %Struct.Private{platform: platform_name}
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
    test "and the platform is Webcore, the pipeline is stopped and a 500 response is added to the Struct" do
      activate_webcore_kill_switch()

      assert {
               :stop_pipeline,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   http_status: 500,
                   headers: %{
                     "content-length" => "0"
                   }
                 }
               }
             } = PlatformKillSwitch.call([], struct_with_platform(Webcore))
    end

    test "and the platform is Fabl, the pipeline continues and the struct is unchanged" do
      activate_webcore_kill_switch()
      original_struct = struct_with_platform(Fabl)
      assert {:ok, ^original_struct} = PlatformKillSwitch.call([], original_struct)
    end

    test "and the platform is nil, the pipeline continues and the struct is unchanged" do
      disable_webcore_kill_switch()
      original_struct = struct_with_platform(nil)
      assert {:ok, ^original_struct} = PlatformKillSwitch.call([], original_struct)
    end
  end

  describe "when the Webcore kill switch is inactive" do
    test "and the platform is Webcore, the pipeline continues and the struct is unchanged" do
      disable_webcore_kill_switch()
      original_struct = struct_with_platform(Webcore)
      assert {:ok, ^original_struct} = PlatformKillSwitch.call([], original_struct)
    end

    test "and the platform is Fabl, the pipeline continues and the struct is unchanged" do
      disable_webcore_kill_switch()
      original_struct = struct_with_platform(Fabl)
      assert {:ok, ^original_struct} = PlatformKillSwitch.call([], original_struct)
    end

    test "and the platform is nil, the pipeline continues and the struct is unchanged" do
      disable_webcore_kill_switch()
      original_struct = struct_with_platform(nil)
      assert {:ok, ^original_struct} = PlatformKillSwitch.call([], original_struct)
    end
  end
end
