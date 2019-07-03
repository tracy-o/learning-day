defmodule BelfrageMock do
  @behaviour Belfrage
  alias Belfrage.{Struct}

  @impl Belfrage
  def handle(struct = Struct), do: struct
end
