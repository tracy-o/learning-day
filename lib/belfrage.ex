defmodule Belfrage do
  alias Belfrage.{Processor, Struct}

  @callback handle(Struct.t()) :: Struct.t()

  @spec handle(Belfrage.Struct.t()) :: map
  def handle(struct = %Struct{}) do
    struct
    |> Belfrage.Concurrently.start()
    |> Belfrage.Concurrently.run(fn struct ->
      struct
      |> prepare_request()
      |> check_cache()
    end)
    |> Belfrage.Concurrently.pick_early_response()
    |> generate_response()
  end

  defp prepare_request(struct) do
    struct
    |> Processor.get_loop()
    |> Processor.allowlists()
    |> Processor.generate_request_hash()
  end

  defp check_cache(struct), do: Processor.query_cache_for_early_response(struct)

  defp generate_response(struct = %Struct{response: %Struct.Response{http_status: http_status}})
       when http_status != nil do
    struct
    |> Processor.init_post_response_pipeline()
  end

  defp generate_response(structs) do
    structs
    |> Belfrage.Concurrently.run(&Processor.request_pipeline/1)
    |> Belfrage.Concurrently.pick_early_response()
    |> Processor.perform_call()
    |> Processor.response_pipeline()
    |> Processor.init_post_response_pipeline()
  end
end
