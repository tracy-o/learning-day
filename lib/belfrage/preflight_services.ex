defmodule Belfrage.PreflightServices do
  alias Belfrage.Clients.HTTP

  defmacro __using__(preflight_opts) do
    quote bind_quoted: [preflight_opts: preflight_opts] do
      @behaviour Belfrage.Behaviours.PreflightService

      @http_client Application.compile_env(:belfrage, :http_client, HTTP)

      require Logger

      alias Belfrage.Cache
      alias Belfrage.Clients.HTTP
      alias Belfrage.Envelope

      def call(envelope = %Envelope{}) do
        case Cache.PreflightMetadata.get(
               Keyword.fetch!(unquote(preflight_opts), :cache_prefix),
               cache_key(envelope)
             ) do
          {:ok, metadata} ->
            {:ok, metadata}

          {:error, :preflight_data_not_found} ->
            make_request(request(envelope))
            |> format_response()
            |> maybe_callback_success()
            |> maybe_put_in_cache(
              Keyword.fetch!(unquote(preflight_opts), :cache_prefix),
              cache_key(envelope)
            )
        end
      end

      defp format_response(response) do
        case response do
          {:ok, %HTTP.Response{body: payload, status_code: 200}} ->
            try do
              Json.decode!(payload)
            rescue
              _ ->
                Logger.log(:error, "", %{
                  msg: "Unable to parse preflight JSON",
                  response: response
                })

                {:error, :preflight_data_error}
            end

          {:ok, %HTTP.Response{status_code: status_code}} when status_code in [404, 410] ->
            {:error, :preflight_data_not_found}

          {:ok, response = %HTTP.Response{}} ->
            Logger.log(:error, "", %{
              msg: "HTTP Preflight Service unaccepted status code",
              response: response
            })

            {:error, :preflight_data_error}

          {:error, reason} ->
            Logger.log(:error, "", %{
              msg: "HTTP Preflight Service request error",
              reason: reason
            })

            {:error, :preflight_data_error}
        end
      end

      def callback_success(response), do: response

      defp maybe_callback_success(response = {:error, _}), do: response

      defp maybe_callback_success(response) do
        callback_success(response)
      end

      defp maybe_put_in_cache(response = {:error, _}, _cache_prefix, _cache_key), do: response

      defp maybe_put_in_cache(response = {:ok, data}, cache_prefix, cache_key) do
        Cache.PreflightMetadata.put(cache_prefix, cache_key, data)
        response
      end

      defp make_request(request) do
        @http_client.execute(struct!(HTTP.Request, request), :Preflight)
      end

      defoverridable callback_success: 1
    end
  end
end
