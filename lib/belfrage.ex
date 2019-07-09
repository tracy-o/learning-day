defmodule Belfrage do
  alias Belfrage.{Processor, Struct}

  @callback handle(Struct.t()) :: Struct.t()

  def handle(struct = %Struct{}) do
    struct
    |> prepare_request()
    |> check_cache()
    |> generate_response()
  end

  defp prepare_request(struct) do
    struct
    |> Processor.get_loop()
    |> Processor.generate_request_hash()
  end

  # temporary, only for demo purposes
  defp check_cache(struct = %Struct{private: %Struct.Private{loop_id: loop_id}})
       when loop_id == ["load_test", "no_cache"] do
    struct
  end

  defp check_cache(struct), do: Processor.query_cache_for_early_response(struct)

  defp generate_response(struct = %Struct{response: %Struct.Response{http_status: http_status}})
       when http_status != nil do
    struct
    |> Processor.init_post_response_side_effects()
  end

  defp generate_response(struct) do
    struct
    |> Processor.request_pipeline()
    |> Processor.perform_call()
    |> Processor.response_pipeline()
    |> Processor.init_post_response_side_effects()
  end
end
