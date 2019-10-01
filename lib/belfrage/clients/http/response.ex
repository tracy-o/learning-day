defmodule Belfrage.Clients.HTTP.Response do
  defstruct [
    :status_code,
    :body,
    headers: []
  ]
end