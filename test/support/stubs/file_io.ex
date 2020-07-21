defmodule Belfrage.Helpers.FileIOStub do
  @behaviour Belfrage.Helpers.FileIO

  def read(path) do
    {:ok, "content for file #{path}"}
  end

  def read!(path) do
    File.read!(path)
  end
end
