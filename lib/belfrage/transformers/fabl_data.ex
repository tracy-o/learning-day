defmodule Belfrage.Transformers.FablData do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    then(rest, build_fabl_path(struct))
  end

  defp build_fabl_path(struct) do
    Struct.add(struct, :request, %{path: "/module/" <> struct.request.path_params["name"]})
  end
end
