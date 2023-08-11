defmodule Belfrage.Cache.DistributedTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Envelope
  alias Belfrage.Cache.Distributed

  test "when the path is the home page it just returns '/hash" do
    envelope = %Envelope{
      request: %Envelope.Request{request_hash: "cb5fooc91cd8b32dcec1fe441a0854fd", path: "/"},
      response: %Envelope.Response{body: "<p>Hello</p>"}
    }

    updated_envelope = %Envelope{
      request: %Envelope.Request{request_hash: "/cb5fooc91cd8b32dcec1fe441a0854fd", path: "/"},
      response: %Envelope.Response{body: "<p>Hello</p>"}
    }

    Belfrage.Clients.CCPMock
    |> expect(:put, fn ^updated_envelope -> :ok end)

    Distributed.store(envelope)
  end

  test "prepends the path to the key, in the format 'path/hash'" do
    envelope = %Envelope{
      request: %Envelope.Request{request_hash: "cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
      response: %Envelope.Response{body: "<p>Hello</p>"}
    }

    updated_envelope = %Envelope{
      request: %Envelope.Request{request_hash: "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
      response: %Envelope.Response{body: "<p>Hello</p>"}
    }

    Belfrage.Clients.CCPMock
    |> expect(:put, fn ^updated_envelope -> :ok end)

    Distributed.store(envelope)
  end

  test "the prepended path wont be longer than 500 characters" do
    path =
      "411b934f5c22c0bfc5e5ad3b40354c515dd2e2f2daab32716d89bc59a08066ee647f91afbd9c266d479703aa829c08ac2470f5cd60417fd7ce0bcc568a2a56f46a6b999902946b493d3657271140ba9b260e1b37954173d5633cdbfef9413ce3a53c4483191533e8dd418ff3f23ab774d1e2c4685f80e6ddea6920c755401bc125c3c334c105e075640d3a1d202889e5bd90252fbdcf6050b77213e4cc063595b2cea73538c15c5da8f2f90acb3e808fdd73221323ef029789f70fbcee4280a197db2d71f26f5916277355d2010b439086aad0ab5138b94516b9e1c4be8148d64a0f82f3434801b2aa8e1fb90337bd2dd899d425d2d2df3dfb30f"

    request_hash = "cb5fooc91cd8b32dcec1fe441a0854fd"

    amended_request_hash = Distributed.prepend_path(path, request_hash)
    [extracted_path | _tail] = String.split(amended_request_hash, "/#{request_hash}")

    assert String.length(extracted_path) <= 500
  end

  test "store/1" do
    envelope = %Envelope{
      request: %Envelope.Request{request_hash: "cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
      response: %Envelope.Response{body: "<p>Hello</p>"}
    }

    updated_envelope = %Envelope{
      request: %Envelope.Request{request_hash: "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
      response: %Envelope.Response{body: "<p>Hello</p>"}
    }

    Belfrage.Clients.CCPMock
    |> expect(:put, fn ^updated_envelope -> :ok end)

    Distributed.store(envelope)
  end

  describe "store/1 respects fallback_write_sample" do
    test "when fallback_write_sample is 0, no envelopes are cached" do
      envelope = %Envelope{
        request: %Envelope.Request{request_hash: "cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
        response: %Envelope.Response{body: "<p>Hello</p>"},
        private: %Envelope.Private{fallback_write_sample: 0}
      }

      updated_envelope = %Envelope{
        request: %Envelope.Request{request_hash: "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
        response: %Envelope.Response{body: "<p>Hello</p>"},
        private: %Envelope.Private{fallback_write_sample: 0}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 0, fn ^updated_envelope -> :ok end)

      for _n <- 1..100 do
        Distributed.store(envelope)
      end
    end

    test "when fallback_write_sample is 1, all envelopes are cached" do
      envelope = %Envelope{
        request: %Envelope.Request{request_hash: "cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
        response: %Envelope.Response{body: "<p>Hello</p>"},
        private: %Envelope.Private{fallback_write_sample: 1}
      }

      updated_envelope = %Envelope{
        request: %Envelope.Request{request_hash: "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
        response: %Envelope.Response{body: "<p>Hello</p>"},
        private: %Envelope.Private{fallback_write_sample: 1}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 100, fn ^updated_envelope -> :ok end)

      for _n <- 1..100 do
        Distributed.store(envelope)
      end
    end

    test "when fallback_write_sample is 0.5, around 50% of envelopes are cached" do
      envelope = %Envelope{
        request: %Envelope.Request{request_hash: "cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
        response: %Envelope.Response{body: "<p>Hello</p>"},
        private: %Envelope.Private{fallback_write_sample: 0.5}
      }

      updated_envelope = %Envelope{
        request: %Envelope.Request{request_hash: "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd", path: "/news/live"},
        response: %Envelope.Response{body: "<p>Hello</p>"},
        private: %Envelope.Private{fallback_write_sample: 0.5}
      }

      Belfrage.Clients.CCPMock
      |> expect(:put, 50, fn ^updated_envelope -> :ok end)

      :rand.seed(:exsss, {8, 234, 102})

      for _n <- 1..100 do
        Distributed.store(envelope)
      end
    end
  end
end
