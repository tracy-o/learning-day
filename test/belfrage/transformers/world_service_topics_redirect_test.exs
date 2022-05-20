defmodule Belfrage.Transformers.WorldServiceTopicsRedirectTest do
  use ExUnit.Case

  alias Belfrage.Transformers.WorldServiceTopicsRedirect
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}

  describe "When route :id is a guid" do
    test "origin and platform gets changed to mozart" do
      struct = %Struct{
        request: %Request{path: "/portuguese/topics/15f1bcf6-b6ab-48e8-b708-efed41e43d31"},
        private: %Private{origin: "simorgh", platform: Simorgh}
      }

      assert WorldServiceTopicsRedirect.call([], struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://mozart-news.example.com", platform: MozartNews})}
    end

    test "When the route has query params, origin and platform gets changed to mozart" do
      struct = %Struct{
        request: %Request{path: "/portuguese/topics/15f1bcf6-b6ab-48e8-b708-efed41e43d31?query=science%20caf%C3%A9"},
        private: %Private{origin: "simorgh", platform: Simorgh}
      }

      assert WorldServiceTopicsRedirect.call([], struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://mozart-news.example.com", platform: MozartNews})}
    end

    test "When the route has trailing slashes, origin and platform gets changed to mozart" do
      struct = %Struct{
        request: %Request{path: "/portuguese/topics/15f1bcf6-b6ab-48e8-b708-efed41e43d31/////////////"},
        private: %Private{origin: "simorgh", platform: Simorgh}
      }

      assert WorldServiceTopicsRedirect.call([], struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://mozart-news.example.com", platform: MozartNews})}
    end
  end

  describe "When route :id is not a guid" do
    test "origin and platform should be left unaltered" do
      struct = %Struct{
        request: %Request{path: "/pidgin/topics/c0823e52dd0t"},
        private: %Private{origin: "simorgh", platform: Simorgh}
      }

      assert WorldServiceTopicsRedirect.call([], struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "simorgh", platform: Simorgh})}
    end

    test "when the route has query params, origin and platform should be left unaltered" do
      struct = %Struct{
        request: %Request{path: "/pidgin/topics/c0823e52dd0t?query=science%20caf%C3%A9"},
        private: %Private{origin: "simorgh", platform: Simorgh}
      }

      assert WorldServiceTopicsRedirect.call([], struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "simorgh", platform: Simorgh})}
    end

    test "when the route has trailing slashes, origin and platform should be left unaltered" do
      struct = %Struct{
        request: %Request{path: "/pidgin/topics/c0823e52dd0t?query=science%20caf%C3%A9"},
        private: %Private{origin: "simorgh", platform: Simorgh}
      }

      assert WorldServiceTopicsRedirect.call([], struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "simorgh", platform: Simorgh})}
    end
  end
end
