defmodule Belfrage.Helpers.FileIO do
  @type path :: String.t()
  @callback read(path) :: {:ok, String.t()} | {:error, atom()}

  defdelegate read(path), to: File
end
