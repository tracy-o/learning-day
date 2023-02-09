defmodule Belfrage.RequestTransformers.WorldServiceTopicsGuid do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    if topics_guid?(envelope) do
      {
        :ok,
        Envelope.add(envelope, :private, %{
          platform: "MozartNews",
          origin: Application.get_env(:belfrage, :mozart_news_endpoint)
        })
      }
    else
      {:ok, envelope}
    end
  end

  defp topics_guid?(envelope) do
    if envelope.request.path_params["id"] do
      String.length(envelope.request.path_params["id"]) != 12
    else
      false
    end
  end
end
