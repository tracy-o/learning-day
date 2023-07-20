defmodule Belfrage.Behaviours.Service do
  alias Belfrage.{Envelope, Services}

  @callback dispatch(Envelope.t()) :: Envelope.t()

  @spec dispatch(Envelope.t()) :: Envelope.t()
  def dispatch(envelope = %Envelope{private: private}) do
    service = service_for(private.origin)
    service.dispatch(envelope)
  end

  defp service_for(origin) do
    cond do
      origin == :stubbed_session_origin -> Services.StubbedSession
      origin =~ ~r[^http(s)?://fabl] -> Services.Fabl
      origin =~ ~r[bbcx-internal] -> Services.BBCX
      origin =~ ~r[^http(s)?://] -> Services.HTTP
      true -> Services.Webcore
    end
  end
end
