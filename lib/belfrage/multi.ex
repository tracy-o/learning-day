defmodule Belfrage.Multi do
  alias Belfrage.Struct

  @doc """
  Order of the loop_ids affect which platform gets called
  first.
  """
  def duplicate_struct(struct = %Struct{}) do
    loop_ids = List.wrap(struct.private.loop_id)

    Enum.map(loop_ids, fn loop_id ->
      Struct.add(struct, :private, %{loop_id: loop_id})
    end)
  end

  @doc """
  For all structs, run
  """
  def concurrently(structs, cb) do
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
