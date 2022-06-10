defmodule Belfrage.Cache.DistributedTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Belfrage.Cache.Distributed

  test "store/1" do
    struct = %Struct{
      request: %Struct.Request{request_hash: "distributed-cache-test"},
      response: %Struct.Response{body: "<p>Hello</p>"}
    }

    Belfrage.Clients.CCPMock
    |> expect(:put, fn ^struct -> :ok end)

    Distributed.store(struct)
  end

  test "store/1 respects ccp_enabled" do
    stub_dial(:ccp_enabled, "false")

    struct = %Struct{
      request: %Struct.Request{request_hash: "distributed-cache-test"},
      response: %Struct.Response{body: "<p>Hello</p>"}
    }

    Belfrage.Clients.CCPMock
    |> expect(:put, 0, fn ^struct -> :ok end)

    Distributed.store(struct)
  end

  describe "store/1 respects fallback_write_sample" do
    test "when fallback_write_sample is 0, no structs are cached" do
      struct = %Struct{
        request: %Struct.Request{request_hash: "distributed-cache-test"},
        response: %Struct.Response{body: "<p>Hello</p>"},
        private: %Struct.Private{fallback_write_sample: 0}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 0, fn ^struct -> :ok end)

      for _n <- 1..100 do
        Distributed.store(struct)
      end
    end

    test "when fallback_write_sample is 1, all structs are cached" do
      struct = %Struct{
        request: %Struct.Request{request_hash: "distributed-cache-test"},
        response: %Struct.Response{body: "<p>Hello</p>"},
        private: %Struct.Private{fallback_write_sample: 1}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 100, fn ^struct -> :ok end)

      for _n <- 1..100 do
        Distributed.store(struct)
      end
    end

    test "when fallback_write_sample is 0.5, around 50% of structs are cached" do
      struct = %Struct{
        request: %Struct.Request{request_hash: "distributed-cache-test"},
        response: %Struct.Response{body: "<p>Hello</p>"},
        private: %Struct.Private{fallback_write_sample: 0.5}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 50, fn ^struct -> :ok end)

      :rand.seed(:exsss, {8, 234, 102})

      for _n <- 1..100 do
        Distributed.store(struct)
      end
    end

    test "when fallback_write_sample is 1 and ccp is disabled, no structs are cached" do
      stub_dial(:ccp_enabled, "false")

      struct = %Struct{
        request: %Struct.Request{request_hash: "distributed-cache-test"},
        response: %Struct.Response{body: "<p>Hello</p>"},
        private: %Struct.Private{fallback_write_sample: 1}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 0, fn ^struct -> :ok end)

      for _n <- 1..100 do
        Distributed.store(struct)
      end
    end
  end
end
