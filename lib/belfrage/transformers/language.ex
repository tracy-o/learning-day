defmodule Belfrage.Transformers.Language do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    # TODO
    # We use the naming `default_language` in the route spec, to future-proof the tenant's API, so
    # that when Belfrage has logic to set the language depending on a cookie for webcore requests,
    # we don't have to change `language` to `default_language` in the route specs, as it's already done.
    #
    # The logic to use a cookie/header language instead of the default, will be done in this
    # request transformer.

    then(
      rest,
      Belfrage.Struct.add(struct, :request, %{language: struct.private.default_language})
    )
  end
end
