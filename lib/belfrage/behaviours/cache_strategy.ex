defmodule Belfrage.Behaviours.CredentialStrategy do
  @type freshness :: :stale | :fresh

  @callback store(Belfrage.Struct.t()) :: {:ok, true} | {:ok, false}
  @callback fetch(Belfrage.Struct.t()) :: {:ok, freshness, Belfrage.Struct.Response.t()}
end
