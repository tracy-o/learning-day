defmodule Belfrage.ServiceProvider do
  alias Belfrage.{Envelope, Services}
  alias Belfrage.Envelope.Private

  def dispatch(envelope = %Envelope{private: private = %Private{}}) do
    service = service_for(private.origin)
    service.dispatch(envelope)
  end

  def service_for(origin) do
    cond do
      origin == :stubbed_session_origin -> Services.StubbedSession
      origin =~ ~r[^http(s)?://fabl] -> Services.Fabl
      origin =~ ~r[^http(s)?://] -> Services.HTTP
      true -> Services.Webcore
    end
  end
end
