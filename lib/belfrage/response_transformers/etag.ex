defmodule Belfrage.ResponseTransformers.Etag do
  alias Belfrage.Struct
  @behaviour Belfrage.Behaviours.ResponseTransformer

  @doc """
  Etag support is specified per route spec by the "put_etag" field.
  This field is then merged into the Struct, and found at struct.private.put_etag.

  If struct.private.put_etag is not true or an "if-none-match" header is not present
  in the reqeust then we simply return the original struct.

  If struct.private.put_etag is true and an "if-none-match" header is present in the
  request, then we generate an etag from the response body, and:

  * If the generated etag is equal to the etag supplied by the client, we set the response
    body to an empty string, the http_status to 304, and add an "etag" response header with
    a value equal to the generated etag.

  * If the generated etag is not equal to the etag supplied by the client, then we simply
    add an "etag" response header with a value equal to the generated etag.
  """
  @impl true
  def call(
        struct = %Struct{
          request: %Struct.Request{raw_headers: %{"if-none-match" => client_etag}},
          private: %Struct.Private{put_etag: true}
        }
      ) do
    etag = generate_etag(struct.response.body)

    if etag == client_etag do
      not_modified_response(struct, etag)
    else
      add_etag_header(struct, etag)
    end
  end

  @impl true
  def call(struct = %Struct{}), do: struct

  # Sets the response body to an empty string, the http_status to 304,
  # and add an "etag" response header with a value equal to the supplied etag.
  defp not_modified_response(struct, etag) do
    struct
    |> add_etag_header(etag)
    |> Struct.add(:response, %{body: "", http_status: 304})
  end

  defp generate_etag(binary) do
    etag =
      :sha
      |> :crypto.hash(binary)
      |> Base.encode16(case: :lower)

    ~s("#{etag}")
  end

  defp add_etag_header(struct, etag) do
    headers = Map.put(struct.response.headers, "etag", etag)
    Struct.add(struct, :response, %{headers: headers})
  end
end
