defmodule Belfrage.Allowlist.Headers do
  alias Belfrage.Envelope
  alias Envelope.Private

  def filter(envelope = %Envelope{private: %Private{headers_allowlist: "*"}}), do: envelope

  def filter(envelope = %Envelope{request: request, private: %Private{headers_allowlist: allowlist}}) do
    Envelope.add(envelope, :request, %{raw_headers: request.raw_headers |> Map.take(allowlist)})
  end
end
