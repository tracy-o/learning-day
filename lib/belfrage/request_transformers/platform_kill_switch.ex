defmodule Belfrage.RequestTransformers.PlatformKillSwitch do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Struct.Private

  @dial Application.get_env(:belfrage, :dial)

  @platform_map %{
    Webcore => :webcore_kill_switch
  }

  @impl Transformer
  def call(struct = %Struct{private: %Private{platform: platform}}) do
    if killswitch_active?(platform) do
      {:stop, Struct.add(struct, :response, %{http_status: 500})}
    else
      {:ok, struct}
    end
  end

  defp killswitch_active?(platform) do
    if dial = @platform_map[platform] do
      @dial.state(dial)
    end
  end
end
