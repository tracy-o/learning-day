defmodule Belfrage.Transformers.Language do
  use Belfrage.Transformers.Transformer
  alias Belfrage.Struct
  alias Belfrage.Struct.Request

  # TODO
  # We use the naming `default_language` in the route spec, to future-proof the tenant's API, so
  # that when Belfrage has logic to set the language depending on a cookie for webcore requests,
  # we don't have to change `language` to `default_language` in the route specs, as it's already done.
  #
  # The logic to use a cookie/header language instead of the default, will be done in this
  # request transformer.

  @impl true
  def call(rest, struct = %Struct{request: %Request{language: nil}}) do
    then(
      rest,
      Belfrage.Struct.add(struct, :request, %{language: struct.private.default_language})
    )
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end
end
