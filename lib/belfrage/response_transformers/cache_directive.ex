defmodule Belfrage.ResponseTransformers.CacheDirective do
  @moduledoc """
  - Parses the Cache-Control header, and saves result to `struct.response.cache_directive`
  - Removes the Cache-Control response header, so it is not stored in the cache
  """

  alias Belfrage.{CacheControl, Struct, Struct.Private, Metrics.Statix, Event}
  alias Belfrage.Behaviours.ResponseTransformer
  @behaviour ResponseTransformer

  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(
        struct = %Struct{
          response: %Struct.Response{headers: %{"cache-control" => cache_control}},
          private: %Private{personalised_request: personalised_request}
        }
      ) do
    response_headers = Map.delete(struct.response.headers, "cache-control")

    struct
    |> Struct.add(:response, %{
      cache_directive:
        cache_directive(
          CacheControl.Parser.parse(cache_control),
          ttl_multiplier(struct.private),
          personalised_request
        ),
      headers: response_headers
    })
  end

  @impl true
  def call(struct), do: struct

  defp ttl_multiplier(%Private{platform: platform}) do
    if platform == Webcore do
      @dial.state(:webcore_ttl_multiplier)
    else
      @dial.state(:non_webcore_ttl_multiplier)
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
    Stump.log(
      :info,
      "The request is personalised, however the response cache-control header is set to \"public\" - setting cacheability to \"private\""
    )

    Statix.increment("request.personalised.unexpected_public_response", 1, tags: Event.global_dimensions())

    %Belfrage.CacheControl{cache_control | cacheability: "private", max_age: 0}
  end

  defp cache_directive(cache_control = %Belfrage.CacheControl{max_age: max_age}, ttl_multiplier, _personalised_request) do
    %Belfrage.CacheControl{cache_control | max_age: dial_multiply(max_age, ttl_multiplier)}
  end
end
