defmodule Belfrage.Transformers.PlatformKillSwitch do
  use Belfrage.Transformers.Transformer
  alias Belfrage.Struct.{Private}

  @dial Application.get_env(:belfrage, :dial)

  @platform_map %{
    Webcore => :webcore_kill_switch
  }

  @impl true
  def call(rest, struct = %Struct{private: %Private{platform: platform}}) do
    if killswitch_active(platform) do
      {:stop_pipeline, Struct.add(struct, :response, %{http_status: 500})}
    else
      then(rest, struct)
    end
  end

  defp killswitch_active(platform) do
    platform_dial_name = @platform_map[platform]

    case platform_dial_name do
      nil -> false
      _ -> @dial.state(platform_dial_name)
    end
  end
end
