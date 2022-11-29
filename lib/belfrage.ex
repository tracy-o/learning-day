defmodule Belfrage do
  alias Belfrage.{Processor, Struct, WrapperError}

  @callback handle(Struct.t()) :: Struct.t()

  def handle(struct = %Struct{}) do
    struct
    |> Processor.pre_request_pipeline()
    |> Processor.fetch_early_response_from_cache()
    |> response_or(&no_cached_response/1)
    |> Processor.post_response_pipeline()
  end

  defp response_or(struct, callback) do
    if struct.response.http_status do
      struct
    else
      callback.(struct)
    end
  end

  defp no_cached_response(struct) do
    struct
    |> Processor.request_pipeline()
    |> perform_call()
    |> Processor.response_pipeline()
  end

  defp perform_call(struct) do
    WrapperError.wrap(&Processor.perform_call/1, struct)
  end
end
