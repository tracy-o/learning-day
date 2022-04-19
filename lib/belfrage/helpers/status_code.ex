defmodule Belfrage.Helpers.StatusCode do
  alias Belfrage.Struct

  def put(struct, code) when is_number(code) do
    Struct.add(struct, :response, %{http_status: code})
  end
end
