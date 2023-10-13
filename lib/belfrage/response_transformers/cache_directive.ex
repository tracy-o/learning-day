defmodule Belfrage.ResponseTransformers.CacheDirective do
  @moduledoc """
  - Parses the Cache-Control header, and saves result to `envelope.response.cache_directive`
  - Removes the Cache-Control response header, so it is not stored in the cache
  """
  require Logger

  alias Belfrage.{CacheControl, Envelope, Envelope.Private}
  use Belfrage.Behaviours.Transformer

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(
        envelope = %Envelope{
          response: %Envelope.Response{headers: %{"cache-control" => cache_control}},
          private: %Private{personalised_request: personalised_request}
        }
      ) do
    response_headers = Map.delete(envelope.response.headers, "cache-control")

    {
      :ok,
      envelope
      |> Envelope.add(:response, %{
        cache_directive:
          cache_directive(
            CacheControl.Parser.parse(cache_control),
            ttl_multiplier(envelope.private),
            personalised_request
          ),
        headers: response_headers
      })
    }
  end

  def call(envelope), do: {:ok, envelope}

  defp ttl_multiplier(%Private{platform: platform}) do
    if platform == "Webcore" do
      @dial.get_dial(:webcore_ttl_multiplier)
    else
      @dial.get_dial(:non_webcore_ttl_multiplier)
    end
  end

  defp dial_multiply(nil, _ttl_multiplier), do: nil

  defp dial_multiply(max_age, ttl_multiplier) do
    max_age
    |> Kernel.*(ttl_multiplier)
    |> to_integer()
  end

  defp to_integer(max_age) when is_float(max_age), do: round(max_age)
  defp to_integer(max_age), do: max_age

  defp cache_directive(cache_control = %Belfrage.CacheControl{max_age: max_age}, ttl_multiplier, _personalised_request)
       when ttl_multiplier == 0 do
    %Belfrage.CacheControl{cache_control | cacheability: "private", max_age: dial_multiply(max_age, ttl_multiplier)}
  end

  defp cache_directive(cache_control = %Belfrage.CacheControl{cacheability: "public"}, _ttl_multiplier, true) do
    Logger.log(
      :info,
      "The request is personalised, however the response cache-control header is set to \"public\" - setting cacheability to \"private\""
    )

    :telemetry.execute([:belfrage, :request, :personalised, :unexpected_public_response], %{count: 1})

    %Belfrage.CacheControl{cache_control | cacheability: "private", max_age: 0}
  end

  defp cache_directive(cache_control = %Belfrage.CacheControl{max_age: max_age}, ttl_multiplier, _personalised_request) do
    %Belfrage.CacheControl{cache_control | max_age: dial_multiply(max_age, ttl_multiplier)}
  end
end
