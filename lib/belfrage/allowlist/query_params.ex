defmodule Belfrage.Allowlist.QueryParams do
  alias Belfrage.Envelope
  alias Envelope.Private

  def filter(envelope = %Envelope{private: %Private{query_params_allowlist: "*"}}), do: envelope

  def filter(envelope = %Envelope{request: request, private: %Private{query_params_allowlist: allowlist}}) do
    Envelope.add(envelope, :request, %{query_params: request.query_params |> Map.take(allowlist)})
  end
end
