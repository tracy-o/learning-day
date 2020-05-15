defmodule Belfrage.Concurrently do
  alias Belfrage.Struct

  def start(struct = %Struct{}) do
    struct.private.loop_id
    |> List.wrap()
    |> Stream.map(&Struct.add(struct, :private, %{loop_id: &1}))
  end

  def random_dedup_platform(structs) do
    structs
    |> Stream.chunk_by(& &1.private.platform)
    |> Stream.map(&Enum.random(&1))
  end

  def run(structs, cb) do
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
        {:cont, acc ++ [struct]}
    end)
  end
end
