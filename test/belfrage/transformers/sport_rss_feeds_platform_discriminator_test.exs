defmodule Belfrage.Transformers.SportRssFeedsPlatformDiscriminatorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.SportRssFeedsPlatformDiscriminator
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
                   "guid" => "4d38153b-987e-4497-b959-8be7c968d4d1"
                 },
                 raw_headers: %{
                   "ctx-unwrapped" => "1"
                 }
               }
             }
           } =
             SportRssFeedsPlatformDiscriminator.call([], %Struct{
               request: %Struct.Request{path_params: %{"discipline" => "4d38153b-987e-4497-b959-8be7c968d4d1"}}
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
             SportRssFeedsPlatformDiscriminator.call([], %Struct{
               private: %Struct.Private{
                 platform: Karanga,
                 origin: karanga_endpoint
               },
               request: %Struct.Request{path_params: %{"discipline" => "football"}}
             })
  end
end
