defmodule Belfrage.Clients.HTTPTest do
  alias Belfrage.Clients.HTTP
  use ExUnit.Case

  describe "&build_options/1" do
    test "builds options with timeout value" do
      assert HTTP.build_options(%HTTP.Request{timeout: 1_000}) == %{
               request_timeout: 1_000
             }
    end
  end
end
