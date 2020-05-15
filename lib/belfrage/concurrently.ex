defmodule Belfrage.Concurrently do
  alias Belfrage.Struct

  def start(struct = %Struct{}) do
    loop_ids = List.wrap(struct.private.loop_id)

    loop_ids
    |> Stream.map(&Struct.add(struct, :private, %{loop_id: &1}))
  end

  def random_dedup_platform(structs) do
    structs
    |> Stream.chunk_by(& &1.private.platform)
    |> Stream.map(&Enum.random(&1))
  end

  @doc """
  For all structs, run
  """
  def run(structs, cb) do
    # does async_stream affect order of structs here?
    structs
    |> Task.async_stream(cb)
    |> Stream.map(&elem(&1, 1))
    |> Enum.to_list()
  end

  def pick_early_response(structs) do
    Enum.reduce_while(structs, [], fn
      struct = %Struct{response: %Struct.Response{http_status: http_status}}, acc when not is_nil(http_status) ->
        {:halt, struct}

      struct, acc ->
        {:cont, [struct | acc]}
    end)
  end
end
