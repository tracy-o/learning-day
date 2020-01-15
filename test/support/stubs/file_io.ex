defmodule Belfrage.Helpers.FileIOStub do
  @behaviour Belfrage.Helpers.FileIO

  def read(path) do
    {:ok, "content for file #{path}"}
  end
end
