defmodule Belfrage.Transformers.PlatformKillSwitch do
  use Belfrage.Transformers.Transformer
  alias Belfrage.Struct.Private

  @dial Application.get_env(:belfrage, :dial)

  @platform_map %{
    Webcore => :webcore_kill_switch
  }

  @impl true
  def call(rest, struct = %Struct{private: %Private{platform: platform}}) do
    if killswitch_active?(platform) do
      {:stop_pipeline, Struct.add(struct, :response, %{http_status: 500})}
    else
      then_do(rest, struct)
    end
  end

  defp killswitch_active?(platform) do
    if dial = @platform_map[platform] do
      @dial.state(dial)
    end
  end
end
