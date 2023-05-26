defmodule Belfrage.RequestTransformers.BBCXAuth do
  use Belfrage.Behaviours.Transformer

  #
  # https://datatracker.ietf.org/doc/html/rfc7617#section-2
  #
  @auth_scheme_test "Basic " <> Base.encode64("bbcx:cihWhx2WAaQrMSUaw1N9B0tq")
  @auth_scheme_live "Basic " <> Base.encode64("bbcx:reforest-dislike-commit")

  @impl Transformer
  def call(
        envelope = %Envelope{
          request: %Envelope.Request{raw_headers: raw_headers},
          private: %Envelope.Private{production_environment: prod_env}
        }
      ) do
    envelope =
      Envelope.add(envelope, :request, %{
        raw_headers:
          Map.merge(raw_headers, %{
            "authorization" => auth_scheme(prod_env)
          })
      })

    {:ok, envelope}
  end

  defp auth_scheme("test"), do: @auth_scheme_test
  defp auth_scheme(_), do: @auth_scheme_live
end
