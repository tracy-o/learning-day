defmodule Belfrage.RequestTransformers.ClassicAppFablLdpTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.ClassicAppFablLdp
  alias Belfrage.Envelope

  test "when a guid is not present, envelope is unmodified" do
    assert {
             :ok,
             %Envelope{
               request: %Envelope.Request{
                 query_params: %{
                   "foo" => "bar"
                 }
               }
             }
           } =
             ClassicAppFablLdp.call(%Envelope{
               request: %Envelope.Request{path_params: %{}, query_params: %{"foo" => "bar"}}
             })
  end

  test "when a guid is present, query_params, path_params, raw_headers and path are updated as expected" do
    guid = "cd988a73-6c41-4690-b785-c8d3abc2d13c"

    assert {
             :ok,
             %Envelope{
               request: %Envelope.Request{
                 query_params: %{
                   "subjectId" => ^guid,
                   "foo" => "bar"
                 },
                 path: "/fd/abl-classic",
                 path_params: %{
                   "name" => "abl-classic"
                 },
                 raw_headers: %{
                   "ctx-unwrapped" => "1"
                 }
               }
             }
           } =
             ClassicAppFablLdp.call(%Envelope{
               request: %Envelope.Request{path_params: %{"guid" => guid}, query_params: %{"foo" => "bar"}}
             })
  end
end
