defmodule Belfrage.Clients.HTTP.ErrorTest do
  use ExUnit.Case

  alias Belfrage.Clients.HTTP

  doctest HTTP.Error

  test "implements String.Chars protocol" do
    error = %HTTP.Error{reason: :timeout}
    expected = "%Belfrage.Clients.HTTP.Error{reason: :timeout}"

    assert expected == "#{error}"
  end
end
