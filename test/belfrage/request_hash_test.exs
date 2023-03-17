defmodule Belfrage.RequestHashTest do
  use ExUnit.Case, async: true
  import Belfrage.Test.PersonalisationHelper
  import Test.Support.Helper, only: [set_env: 2]

  alias Belfrage.RequestHash
  alias Belfrage.{Envelope, RouteState}

  @route_state_id {"SomeRouteState", "Webcore"}

  @envelope %Envelope{
    request: %Envelope.Request{
      scheme: :https,
      path: "/news/clips/abc123",
      country: "gb",
      method: "GET",
      has_been_replayed?: false
    }
  }

  @envelope_with_different_country %Envelope{
    request: %Envelope.Request{
      path: "/news/clips/abc123",
      country: "usa",
      method: "GET"
    }
  }
  @envelope_with_different_path %Envelope{
    request: %Envelope.Request{
      path: "/sport/football/abc123",
      country: "gb",
      method: "GET"
    }
  }

  @envelope_for_cache_bust_request %Envelope{
    private: %Envelope.Private{
      overrides: %{
        "belfrage-cache-bust" => nil
      }
    }
  }

  describe "Belfrage.RequestHash.generate/1" do
    test "when given a valid path and country" do
      assert is_binary(RequestHash.generate(@envelope))
    end

    test "varies on method" do
      post_envelope = Belfrage.Envelope.add(@envelope, :request, %{method: "POST"})

      refute RequestHash.generate(@envelope) == RequestHash.generate(post_envelope)
    end

    test "varies on query_params" do
      query_string_envelope = Belfrage.Envelope.add(@envelope, :request, %{query_params: %{"foo" => "bar"}})

      refute RequestHash.generate(@envelope) == RequestHash.generate(query_string_envelope)
    end

    test "varies for replayed traffic" do
      replayed_envelope = Belfrage.Envelope.add(@envelope, :request, %{has_been_replayed?: true})

      refute RequestHash.generate(@envelope) == RequestHash.generate(replayed_envelope)
    end

    test "varies for origin simulator traffic" do
      replayed_envelope = Belfrage.Envelope.add(@envelope, :request, %{origin_simulator?: true})

      refute RequestHash.generate(@envelope) == RequestHash.generate(replayed_envelope)
    end

    test "given the path is the same, when the country is not the same assert the request_hashes are different" do
      refute RequestHash.generate(@envelope) == RequestHash.generate(@envelope_with_different_country)
    end

    test "given the country is the same, when the path is not the same assert the request_hashes are different" do
      refute RequestHash.generate(@envelope) == RequestHash.generate(@envelope_with_different_path)
    end

    test "builds repeatable request hash" do
      hash_one = RequestHash.generate(@envelope)
      hash_two = RequestHash.generate(@envelope)

      refute String.starts_with?(hash_one, "cache-bust.")
      refute String.starts_with?(hash_two, "cache-bust.")

      assert hash_one == hash_two
    end

    test "when the request hash is used to cache bust requests should be unique" do
      hash_one = RequestHash.generate(@envelope_for_cache_bust_request)
      hash_two = RequestHash.generate(@envelope_for_cache_bust_request)

      assert String.starts_with?(hash_one, "cache-bust.")
      assert String.starts_with?(hash_two, "cache-bust.")

      refute hash_one == hash_two
    end

    test "varies on scheme" do
      https_envelope = @envelope
      http_envelope = @envelope |> Belfrage.Envelope.add(:request, %{scheme: :http})

      refute RequestHash.generate(https_envelope) == RequestHash.generate(http_envelope)
    end

    test "varies on host" do
      co_uk_host_envelope = Belfrage.Envelope.add(@envelope, :request, %{host: "www.bbc.co.uk"})
      com_host_envelope = Belfrage.Envelope.add(@envelope, :request, %{host: "www.bbc.com"})

      refute RequestHash.generate(co_uk_host_envelope) == RequestHash.generate(com_host_envelope)
    end

    test "varies on is_uk" do
      is_uk_envelope = @envelope |> Belfrage.Envelope.add(:request, %{is_uk: true})
      is_not_uk_envelope = @envelope |> Belfrage.Envelope.add(:request, %{is_uk: false})

      refute RequestHash.generate(is_uk_envelope) == RequestHash.generate(is_not_uk_envelope)
    end

    test "varies on cdn?" do
      envelope_with_cdn = @envelope |> Belfrage.Envelope.add(:request, %{cdn?: true})
      envelope_without_cdn = @envelope |> Belfrage.Envelope.add(:request, %{cdn?: false})

      refute RequestHash.generate(envelope_with_cdn) == RequestHash.generate(envelope_without_cdn)
    end

    test "when a key is removed the request hash doesn't vary on it" do
      uk_envelope = @envelope |> Belfrage.Envelope.add(:private, %{signature_keys: %{add: [], skip: [:country]}})

      kr_envelope =
        @envelope
        |> Belfrage.Envelope.add(:request, %{country: "kr"})
        |> Belfrage.Envelope.add(:private, %{signature_keys: %{add: [], skip: [:country]}})

      assert RequestHash.generate(uk_envelope) == RequestHash.generate(kr_envelope)
    end

    test "when a key is added the request hash does vary on it" do
      envelope_one =
        @envelope
        |> Belfrage.Envelope.add(:request, %{payload: "one"})
        |> Belfrage.Envelope.add(:private, %{signature_keys: %{add: [:payload], skip: []}})

      envelope_two =
        @envelope
        |> Belfrage.Envelope.add(:request, %{payload: "two"})
        |> Belfrage.Envelope.add(:private, %{signature_keys: %{add: [:payload], skip: []}})

      refute RequestHash.generate(envelope_one) == RequestHash.generate(envelope_two)
    end

    test "request hash does not vary when the request is the same" do
      envelope =
        @envelope
        |> Belfrage.Envelope.add(:request, %{raw_headers: %{"foo" => "boo"}})

      assert RequestHash.generate(envelope) == RequestHash.generate(envelope)
    end

    test "varies on raw_headers, when differs" do
      envelope_one = @envelope |> Belfrage.Envelope.add(:request, %{raw_headers: %{"foo" => "boo"}})
      envelope_two = @envelope |> Belfrage.Envelope.add(:request, %{raw_headers: %{"foo" => "bar"}})

      refute RequestHash.generate(envelope_one) == RequestHash.generate(envelope_two)
    end

    test "does not vary on raw MVT header when it is not in :mvt_seen in RouteState state" do
      pid = start_supervised!({RouteState, @route_state_id})

      :sys.replace_state(pid, fn state ->
        Map.put(state, :mvt_seen, %{"mvt-button_colour" => DateTime.utc_now()})
      end)

      assert RequestHash.generate(%Envelope{
               request: %Envelope.Request{
                 raw_headers: %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "experiment;sidebar_colour;red"
                 }
               },
               private: %Envelope.Private{
                 route_state_id: @route_state_id
               }
             }) ==
               RequestHash.generate(%Envelope{
                 request: %Envelope.Request{
                   raw_headers: %{
                     "foo" => "bar"
                   }
                 }
               })
    end

    test "does not vary on raw MVT header with datetime older than :mvt_vary_header_ttl after a :reset msg is sent" do
      set_env(:mvt_vary_header_ttl, 10_000)
      pid = start_supervised!({RouteState, @route_state_id})
      now = DateTime.utc_now()

      :sys.replace_state(pid, fn state ->
        Map.put(state, :mvt_seen, %{"mvt-button_colour" => DateTime.add(now, -20, :second)})
      end)

      send(pid, :reset)

      assert RequestHash.generate(%Envelope{
               request: %Envelope.Request{
                 raw_headers: %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "experiment;button_colour;red"
                 }
               },
               private: %Envelope.Private{
                 route_state_id: @route_state_id
               }
             }) ==
               RequestHash.generate(%Envelope{
                 request: %Envelope.Request{
                   raw_headers: %{
                     "foo" => "bar"
                   }
                 }
               })
    end

    test "does not vary on raw MVT header when no RouteState can be found" do
      assert RequestHash.generate(%Envelope{
               request: %Envelope.Request{
                 raw_headers: %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "experiment;button_colour;red"
                 }
               }
             }) ==
               RequestHash.generate(%Envelope{
                 request: %Envelope.Request{
                   raw_headers: %{
                     "foo" => "bar"
                   }
                 }
               })
    end

    test "does not vary on different experiment values when MVT headers not in :mvt_seen in RouteState state" do
      pid = start_supervised!({RouteState, @route_state_id})

      :sys.replace_state(pid, fn state ->
        Map.put(state, :mvt_seen, %{"mvt-sidebar_colour" => DateTime.utc_now()})
      end)

      assert RequestHash.generate(%Envelope{
               request: %Envelope.Request{
                 raw_headers: %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "experiment;button_colour;red"
                 }
               },
               private: %Envelope.Private{
                 route_state_id: @route_state_id
               }
             }) ==
               RequestHash.generate(%Envelope{
                 request: %Envelope.Request{
                   raw_headers: %{
                     "foo" => "bar",
                     "bbc-mvt-1" => "experiment;button_colour;green"
                   }
                 }
               })
    end

    test "varies on different experiment values for MVT header in :mvt_seen in RouteState state" do
      pid = start_supervised!({RouteState, @route_state_id})

      :sys.replace_state(pid, fn state ->
        Map.put(state, :mvt_seen, %{"mvt-button_colour" => DateTime.utc_now()})
      end)

      refute RequestHash.generate(%Envelope{
               request: %Envelope.Request{
                 raw_headers: %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "experiment;button_colour;red"
                 }
               },
               private: %Envelope.Private{
                 route_state_id: @route_state_id
               }
             }) ==
               RequestHash.generate(%Envelope{
                 request: %Envelope.Request{
                   raw_headers: %{
                     "foo" => "bar",
                     "bbc-mvt-1" => "experiment;button_colour;green"
                   }
                 }
               })
    end

    test "varies on raw MVT header in :mvt_seen in RouteState state" do
      pid = start_supervised!({RouteState, @route_state_id})

      :sys.replace_state(pid, fn state ->
        Map.put(state, :mvt_seen, %{"mvt-button_colour" => DateTime.utc_now()})
      end)

      refute RequestHash.generate(%Envelope{
               request: %Envelope.Request{
                 raw_headers: %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "experiment;button_colour;red"
                 }
               },
               private: %Envelope.Private{
                 route_state_id: @route_state_id
               }
             }) ==
               RequestHash.generate(%Envelope{
                 request: %Envelope.Request{
                   raw_headers: %{
                     "foo" => "bar"
                   }
                 }
               })
    end

    test "varies on different raw MVT headers in :mvt_seen in RouteState state" do
      pid = start_supervised!({RouteState, @route_state_id})

      :sys.replace_state(pid, fn state ->
        Map.put(state, :mvt_seen, %{
          "mvt-button_colour" => DateTime.utc_now(),
          "mvt-sidebar_colour" => DateTime.utc_now()
        })
      end)

      refute RequestHash.generate(%Envelope{
               request: %Envelope.Request{
                 raw_headers: %{
                   "foo" => "bar",
                   "bbc-mvt-1" => "experiment;button_colour;red"
                 }
               },
               private: %Envelope.Private{
                 route_state_id: @route_state_id
               }
             }) ==
               RequestHash.generate(%Envelope{
                 request: %Envelope.Request{
                   raw_headers: %{
                     "foo" => "bar",
                     "bbc-mvt-1" => "experiment;sidebar_colour;red"
                   }
                 },
                 private: %Envelope.Private{
                   route_state_id: @route_state_id
                 }
               })
    end

    test "never vary on cookie header" do
      envelope_one =
        @envelope
        |> Belfrage.Envelope.add(:request, %{raw_headers: Map.merge(%{"foo" => "bar"}, %{"cookie" => "yummy"})})

      envelope_two = @envelope |> Belfrage.Envelope.add(:request, %{raw_headers: %{"foo" => "bar"}})

      assert RequestHash.generate(envelope_one) == RequestHash.generate(envelope_two)
    end

    test "does not vary on personalisation headers" do
      non_personalised = @envelope
      personalised = authenticate_request(@envelope)
      assert RequestHash.generate(personalised) == RequestHash.generate(non_personalised)
    end
  end

  describe "put/1" do
    test "generates and sets request_hash" do
      refute @envelope.request.request_hash
      envelope = RequestHash.put(@envelope)
      assert envelope.request.request_hash
      assert envelope.request.request_hash == RequestHash.generate(@envelope)
    end
  end
end
