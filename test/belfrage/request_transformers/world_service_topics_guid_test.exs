defmodule Belfrage.RequestTransformers.WorldServiceTopicsGuidTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.WorldServiceTopicsGuid
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}

  describe "When path_params :id is a guid" do
    setup do
      struct = %Struct{
        request: %Request{
          path: "/portuguese/topics/15f1bcf6-b6ab-48e8-b708-efed41e43d31",
          path_params: %{"id" => "15f1bcf6-b6ab-48e8-b708-efed41e43d31"}
        },
        private: %Private{origin: "https://simorgh.example.com", platform: "Simorgh"}
      }

      %{
        struct: struct
      }
    end

    test "origin and platform gets changed to mozart", %{struct: struct} do
      assert WorldServiceTopicsGuid.call(struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://mozart-news.example.com", platform: "MozartNews"})}
    end

    test "When the route has query params, origin and platform gets changed to mozart", %{struct: struct} do
      struct =
        Struct.add(struct, :request, %{
          path: "/portuguese/topics/15f1bcf6-b6ab-48e8-b708-efed41e43d31?query=science%20caf%C3%A9",
          query_params: %{"query" => "science café"}
        })

      assert WorldServiceTopicsGuid.call(struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://mozart-news.example.com", platform: "MozartNews"})}
    end

    test "When the route has trailing slashes, origin and platform gets changed to mozart", %{struct: struct} do
      struct =
        Struct.add(struct, :request, %{path: "/portuguese/topics/15f1bcf6-b6ab-48e8-b708-efed41e43d31/////////////"})

      assert WorldServiceTopicsGuid.call(struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://mozart-news.example.com", platform: "MozartNews"})}
    end
  end

  describe "When path_params :id is not a guid" do
    setup do
      struct = %Struct{
        request: %Request{
          path: "/pidgin/topics/c0823e52dd0t",
          path_params: %{"id" => "c0823e52dd0t"}
        },
        private: %Private{origin: "https://simorgh.example.com", platform: "Simorgh"}
      }

      %{
        struct: struct
      }
    end

    test "origin and platform should be left unaltered", %{struct: struct} do
      assert WorldServiceTopicsGuid.call(struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://simorgh.example.com", platform: "Simorgh"})}
    end

    test "when the route has query params, origin and platform should be left unaltered", %{struct: struct} do
      struct =
        Struct.add(struct, :request, %{
          path: "/pidgin/topics/c0823e52dd0t?query=science%20caf%C3%A9",
          query_params: %{"query" => "science café"}
        })

      assert WorldServiceTopicsGuid.call(struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://simorgh.example.com", platform: "Simorgh"})}
    end

    test "when the route has trailing slashes, origin and platform should be left unaltered", %{struct: struct} do
      struct = Struct.add(struct, :request, %{path: "/pidgin/topics/c0823e52dd0t///////////////////"})

      assert WorldServiceTopicsGuid.call(struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://simorgh.example.com", platform: "Simorgh"})}
    end
  end

  describe "When path_params :id is not provided" do
    setup do
      struct = %Struct{
        request: %Request{
          path: "/pidgin/topics/c0823e52dd0t"
        },
        private: %Private{origin: "https://simorgh.example.com", platform: "Simorgh"}
      }

      %{
        struct: struct
      }
    end

    test "origin and platform should be left unaltered", %{struct: struct} do
      assert WorldServiceTopicsGuid.call(struct) ==
               {:ok, Struct.add(struct, :private, %{origin: "https://simorgh.example.com", platform: "Simorgh"})}
    end
  end
end
