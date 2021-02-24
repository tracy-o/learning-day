defmodule Belfrage.Concurrently do
  alias Belfrage.Struct

  def start(struct = %Struct{}) do
    candidate_loop_ids = struct.private.loop_id |> List.wrap()

    candidate_loop_ids
    |> Stream.map(
      &Struct.add(struct, :private, %{
        loop_id: &1,
        candidate_loop_ids: candidate_loop_ids
      })
    )
  end

  def run(structs, cb) do
    m = Stump.metadata() |> Enum.into([])

    structs
    |> Task.async_stream(fn struct ->
      Stump.metadata(m)
      cb.(struct)
    end)
    |> Stream.map(&elem(&1, 1))
    |> Enum.to_list()
  end

  def pick_early_response(structs) do
    Enum.reduce_while(structs, [], fn
      struct = %Struct{response: %Struct.Response{http_status: http_status}}, _acc when not is_nil(http_status) ->
        {:halt, struct}

      struct, acc ->
        # maybe FIXME Depending on outcome of RESFRAME-3478, we can change this to
        # [struct | acc] which is faster, but will reverse the list of structs.
        # It depends if order of the structs matters when prioritising internal
        # responses such as redirects from the request pipeline.
        {:cont, acc ++ [struct]}
    end)
  end
end
