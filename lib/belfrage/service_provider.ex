defmodule Belfrage.ServiceProvider do
  alias Belfrage.{Struct, Services}
  alias Belfrage.Struct.Private

  def dispatch(struct = %Struct{private: private = %Private{}}) do
    service = service_for(private.origin)
    service.dispatch(struct)
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
