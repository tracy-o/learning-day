defmodule Belfrage.PreflightTransformers.AssetTypePlatformSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.PreflightServices.AresData

  @webcore_asset_types ["MAP", "CSP", "PGL", "STY"]

  @doc """
  Makes a GET request to the FABL module: ares-data.
  If a response with a 200 status code and a payload that
  contains a Webcore asset type is returned, then the following
  tuple is returned:

    {:ok, %Envelope{private: %Private{platform: "Webcore"}}}

  If a response with a 200 status code and a payload that
  does not contain a Webcore asset type is returned, then the
  following tuple is returned:

    {:ok, %Envelope{private: %Private{platform: "MozartNews"}}}

  If a response with a 404 status code is returned, then the
  following tuple is returned:

    {:ok, %Envelope{private: %Private{platform: "MozartNews"}}}

  otherwise an error tuple is returned:

    {:error, status_code}
  """
  @impl Transformer
  def call(envelope = %Envelope{}) do
    case AresData.call(envelope) do
      {:ok, asset_type} ->
        select_platform(envelope, asset_type)

      {:error, :preflight_data_not_found} ->
        {:ok, Envelope.add(envelope, :private, %{platform: "MozartNews"})}

      {:error, :preflight_data_error} ->
        {:error, envelope, 500}
    end
  end

  defp select_platform(envelope, asset_type) do
    if asset_type in @webcore_asset_types do
      {:ok, Envelope.add(envelope, :private, %{platform: "Webcore"})}
    else
      {:ok, Envelope.add(envelope, :private, %{platform: "MozartNews"})}
    end
  end
end
