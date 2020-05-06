defmodule Belfrage.Multi do
  alias Belfrage.Struct

  @doc """
  Order of the loop_ids affect which platform gets called
  first.
  """
  def duplicate_struct(struct = %Struct{}) do
    loop_ids = List.wrap(struct.private.loop_id)

    loop_ids
    |> Stream.map(&Struct.add(struct, :private, %{loop_id: &1}))
    # as we are before the Processor.get_loop, we don't have the platform in the struct
    |> Stream.chunk_by(fn struct -> Belfrage.RouteSpec.specs_for(struct.private.loop_id).platform end)
    |> Stream.map(&Enum.random(&1))
    |> Stream.each(fn struct ->
      IO.inspect(struct.private.loop_id)
    end)
  end

  @doc """
  For all structs, run
  """
  def concurrently(structs, cb) do
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
