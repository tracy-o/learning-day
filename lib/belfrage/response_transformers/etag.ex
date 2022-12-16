defmodule Belfrage.ResponseTransformers.Etag do
  use Belfrage.Behaviours.Transformer

  @doc """
  Etag support is specified per route spec by the "etag" field.
  This field is then merged into the Struct, and found at struct.private.etag.

  If struct.private.etag is not true then we simply return the original struct.

  If struct.private.etag is true then we generate an etag from the response body, and
  add an "etag" response header with a value equal to the generated etag.
  """
  @impl Transformer
  def call(struct = %Struct{private: %Struct.Private{etag: true}}) do
    struct =
      struct.response.body
      |> generate_etag()
      |> add_etag_header(struct)

    {:ok, struct}
  end

  def call(struct = %Struct{}), do: {:ok, struct}

  defp generate_etag(binary) do
    etag =
      :sha
      |> :crypto.hash(binary)
      |> Base.encode16(case: :lower)

    ~s("#{etag}")
  end

  defp add_etag_header(etag, struct) do
    headers = Map.put(struct.response.headers, "etag", etag)
    Struct.add(struct, :response, %{headers: headers})
  end
end
