defmodule Belfrage.RequestTransformers.SportRssFeedsPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.SportRssFeedsPlatformDiscriminator
  alias Belfrage.Struct

  test "when the guid matches the allowlist the request is pointed to the rss FABL module" do
    fabl_endpoint = Application.get_env(:belfrage, :fabl_endpoint)

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 platform: Fabl,
                 origin: ^fabl_endpoint
               },
               request: %Struct.Request{
                 path: "/fd/rss",
                 path_params: %{
                   "name" => "rss"
                 },
                 query_params: %{
                   "guid" => "cd988a73-6c41-4690-b785-c8d3abc2d13c"
                 },
                 raw_headers: %{
                   "ctx-unwrapped" => "1"
                 }
               }
             },
             {:replace, ["CircuitBreaker"]}
           } =
             SportRssFeedsPlatformDiscriminator.call(%Struct{
               request: %Struct.Request{path_params: %{"discipline" => "cd988a73-6c41-4690-b785-c8d3abc2d13c"}}
             })
  end

  test "when the guid does not match the allowlist the request continues to Karanga" do
    karanga_endpoint = Application.get_env(:belfrage, :karanga_endpoint)

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 platform: Karanga,
                 origin: ^karanga_endpoint
               }
             }
           } =
             SportRssFeedsPlatformDiscriminator.call(%Struct{
               private: %Struct.Private{
                 platform: Karanga,
                 origin: karanga_endpoint
               },
               request: %Struct.Request{path_params: %{"discipline" => "football"}}
             })
  end
end
