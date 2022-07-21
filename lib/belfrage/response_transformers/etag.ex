defmodule Belfrage.ResponseTransformers.Etag do
  alias Belfrage.Struct
  @behaviour Belfrage.Behaviours.ResponseTransformer

  @doc """
  Etag support is specified per route spec by the "put_etag" field.
  This field is then merged into the Struct, and found at struct.private.put_etag.

  If struct.private.put_etag is not true then we simply return the original struct.

  If struct.private.put_etag is true then we generate an etag from the response body, and
  add an "etag" response header with a value equal to the generated etag.
  """
  @impl true
  def call(struct = %Struct{private: %Struct.Private{put_etag: true}}) do
    struct.response.body
    |> generate_etag()
    |> add_etag_header(struct)
  end

  @impl true
  def call(struct = %Struct{}), do: struct

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
