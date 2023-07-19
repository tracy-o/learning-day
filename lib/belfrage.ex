defmodule Belfrage do
  alias Belfrage.{Processor, Envelope}

  @spec handle(Envelope.t()) :: Envelope.t()
  def handle(envelope = %Envelope{}) do
    envelope
    |> Processor.pre_request_pipeline()
    |> response_or(&preflight_success/1)
    |> Processor.post_response_pipeline()
  end

  defp preflight_success(envelope) do
    envelope
    |> Processor.fetch_early_response_from_cache()
    |> response_or(&no_cached_response/1)
  end

  defp no_cached_response(envelope) do
    envelope
    |> Processor.request_pipeline()
    |> Processor.perform_call()
    |> Processor.response_pipeline()
  end

  defp response_or(envelope, callback) do
    if envelope.response.http_status do
      envelope
    else
      callback.(envelope)
    end
  end
end
