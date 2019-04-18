defmodule Ingress.Processor do
  alias Ingress.{LoopsRegistry, Struct, Loop, Pipeline, Services}

  @service Application.get_env(:ingress, :service, Services.HTTP)

  def get_loop(struct = %Struct{}) do
    LoopsRegistry.find_or_start(struct)

    case Loop.state(struct) do
      {:ok, loop} -> Map.put(struct, :private, Map.merge(struct.private, loop))
      _ -> loop_state_failure()
    end
  end

  def request_pipeline(struct = %Struct{}) do
    case Pipeline.process(struct) do
      {:ok, struct} -> struct
      {:redirect, struct} -> struct
      {:error, _struct, msg} -> raise "Pipeline failed #{msg}"
    end
  end

  def perform_call(struct = %Struct{}) do
    # For now, we are only invoking lambdas
    @service.dispatch(struct)
  end

  def resp_pipeline(struct = %Struct{}) do
    struct
  end

  defp loop_state_failure do
    raise "Failed to load loop state."
  end
end
