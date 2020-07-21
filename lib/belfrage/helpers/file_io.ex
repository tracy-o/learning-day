defmodule Belfrage.Helpers.FileIO do
  @type path :: String.t()
  @callback read(path) :: {:ok, String.t()} | {:error, atom()}
  @callback read!(path) :: String.t()

  defdelegate read(path), to: File
  defdelegate read!(path), to: File
end
