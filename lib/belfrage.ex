defmodule Belfrage do
  alias Belfrage.{Processor, Envelope, WrapperError}

  @callback handle(Envelope.t()) :: Envelope.t()

  def handle(envelope = %Envelope{}) do
    envelope
    |> Processor.pre_request_pipeline()
    |> Processor.fetch_early_response_from_cache()
    |> response_or(&no_cached_response/1)
    |> Processor.post_response_pipeline()
  end

  defp response_or(envelope, callback) do
    if envelope.response.http_status do
      envelope
    else
      callback.(envelope)
    end
  end

  defp no_cached_response(envelope) do
    envelope
    |> Processor.request_pipeline()
    |> perform_call()
    |> Processor.response_pipeline()
  end

  defp perform_call(envelope) do
    WrapperError.wrap(&Processor.perform_call/1, envelope)
  end
end
