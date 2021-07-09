defmodule Belfrage.Transformers.PlatformKillSwitchTest do
  use ExUnit.Case

  alias Belfrage.Transformers.PlatformKillSwitch
  alias Belfrage.Struct

  defp struct_with_platform(platform_name) do
    %Struct{
      private: %Struct.Private{platform: platform_name}
    }
  end

  describe "when the Webcore kill switch is active" do
    test "and the platform is Webcore, the pipeline is stopped and a 500 response is added to the Struct" do
      assert {
               :stop_pipeline,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   http_status: 500
                 }
               }
             } = PlatformKillSwitch.call([], struct_with_platform("Webcore"))
    end

    test "and the platform is Fabl, the pipeline continues and the struct is unchanged" do
      original_struct = struct_with_platform("Fabl")
      assert {:ok, original_struct} = PlatformKillSwitch.call([], original_struct)
    end
  end

  describe "when the Webcore kill switch is inactive" do
    test "and the platform is Webcore, the pipeline continues and the struct is unchanged" do
      original_struct = struct_with_platform("Webcore")
      assert {:ok, original_struct} = PlatformKillSwitch.call([], original_struct)
    end

    test "and the platform is Fabl, the pipeline continues and the struct is unchanged" do
      original_struct = struct_with_platform("Fabl")
      assert {:ok, original_struct} = PlatformKillSwitch.call([], original_struct)
    end
  end
end
