defmodule Belfrage.ResponseTransformers.Etag do
  use Belfrage.Behaviours.Transformer

  @doc """
  Etag support is specified per route spec by the "etag" field.
  This field is then merged into the Envelope, and found at envelope.private.etag.

  If envelope.private.etag is not true then we simply return the original envelope.

  If envelope.private.etag is true then we generate an etag from the response body, and
  add an "etag" response header with a value equal to the generated etag.
  """
  @impl Transformer
  def call(envelope = %Envelope{private: %Envelope.Private{etag: true}}) do
    envelope =
      envelope.response.body
      |> generate_etag()
      |> add_etag_header(envelope)

    {:ok, envelope}
  end

  def call(envelope = %Envelope{}), do: {:ok, envelope}

  defp generate_etag(binary) do
    etag =
      :sha
      |> :crypto.hash(binary)
      |> Base.encode16(case: :lower)

    ~s("#{etag}")
  end

  defp add_etag_header(etag, envelope) do
    headers = Map.put(envelope.response.headers, "etag", etag)
    Envelope.add(envelope, :response, %{headers: headers})
  end
end
