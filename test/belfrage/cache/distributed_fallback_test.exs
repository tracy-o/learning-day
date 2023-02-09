defmodule Belfrage.Cache.DistributedTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Envelope
  alias Belfrage.Cache.Distributed

  test "store/1" do
    envelope = %Envelope{
      request: %Envelope.Request{request_hash: "distributed-cache-test"},
      response: %Envelope.Response{body: "<p>Hello</p>"}
    }

    Belfrage.Clients.CCPMock
    |> expect(:put, fn ^envelope -> :ok end)

    Distributed.store(envelope)
  end

  describe "store/1 respects fallback_write_sample" do
    test "when fallback_write_sample is 0, no envelopes are cached" do
      envelope = %Envelope{
        request: %Envelope.Request{request_hash: "distributed-cache-test"},
        response: %Envelope.Response{body: "<p>Hello</p>"},
        private: %Envelope.Private{fallback_write_sample: 0}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 0, fn ^envelope -> :ok end)

      for _n <- 1..100 do
        Distributed.store(envelope)
      end
    end

    test "when fallback_write_sample is 1, all envelopes are cached" do
      envelope = %Envelope{
        request: %Envelope.Request{request_hash: "distributed-cache-test"},
        response: %Envelope.Response{body: "<p>Hello</p>"},
        private: %Envelope.Private{fallback_write_sample: 1}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 100, fn ^envelope -> :ok end)

      for _n <- 1..100 do
        Distributed.store(envelope)
      end
    end

    test "when fallback_write_sample is 0.5, around 50% of envelopes are cached" do
      envelope = %Envelope{
        request: %Envelope.Request{request_hash: "distributed-cache-test"},
        response: %Envelope.Response{body: "<p>Hello</p>"},
        private: %Envelope.Private{fallback_write_sample: 0.5}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 50, fn ^envelope -> :ok end)

      :rand.seed(:exsss, {8, 234, 102})

      for _n <- 1..100 do
        Distributed.store(envelope)
      end
    end
  end
end
