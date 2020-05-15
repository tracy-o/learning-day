defmodule Belfrage.RequestHash do
  alias Belfrage.Struct

  @default_signature_keys [
    :country,
    :has_been_replayed?,
    :host,
    :is_uk,
    :language,
    :language_chinese,
    :language_serbian,
    :method,
    :path,
    :query_params,
    :scheme,
    :cdn?
  ]

  def generate(struct) do
    case Belfrage.Overrides.should_cache_bust?(struct) do
      true ->
        cache_bust_request_hash()

      false ->
        extract_keys(struct)
        |> Crimpex.signature()
    end
    |> update_struct(struct)
  end

  defp extract_keys(struct) do
    Map.take(struct.request, build_signature_keys(struct))
  end

  defp build_signature_keys(%Struct{
         private: %Struct.Private{signature_keys: %{skip: skip_keys, add: add_keys}}
       }) do
    (@default_signature_keys ++ add_keys) -- skip_keys
  end

  defp update_struct(request_hash, struct) do
    Struct.add(struct, :request, %{request_hash: request_hash})
  end

  defp cache_bust_request_hash do
    "cache-bust." <> UUID.uuid4()
  end
end
