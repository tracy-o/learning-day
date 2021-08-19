defmodule Belfrage.Transformers.Echo do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(_rest, struct) do
    {
      :stop_pipeline,
      Struct.add(struct, :response, %{
        http_status: 200,
        headers: %{},
        body: """
        Hey, ho!
        PATH:           #{struct.request.path}
        PIPELINE:       #{struct.private.pipeline}
        ROUTE_RELEASE:  #{Application.get_env(:belfrage, :route_rel)}
        """
      })
    }
  end
end
