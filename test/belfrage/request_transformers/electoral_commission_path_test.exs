defmodule Belfrage.Re.RequestTransformers.ElectoralCommissionPathTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.ElectoralCommissionPath
  alias Belfrage.Envelope

  test "prepends and apends the path with api/v1 and token" do
    assert {
             :ok,
             %Envelope{
               request: %Envelope.Request{
                 path: "/api/v1/postcode/MK36EB/?token=f110d812b94d8cdf517765ff8657b89e8b08ebd6"
               }
             }
           } ==
             ElectoralCommissionPath.call(%Envelope{
               request: %Envelope.Request{
                 path: "/election2023postcode/MK36EB"
               }
             })
  end
end
