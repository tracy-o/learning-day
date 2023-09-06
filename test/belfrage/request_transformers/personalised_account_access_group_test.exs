defmodule Belfrage.RequestTransformers.PersonalisedAccessGroupTest do
  use ExUnit.Case, async: true
  alias Belfrage.{Envelope}
  alias Belfrage.RequestTransformers.PersonalisedAccountAccessGroup
  alias Belfrage.Authentication.BBCID

  @default_bbcid_state %{
    id_availability: true,
    foryou_flagpole: false,
    foryou_access_chance: 0,
    foryou_allowlist: []
  }

  test "generate correct hash values" do
    assert PersonalisedAccountAccessGroup.generate_hash_value("eyJkbiI6IkEgV2ViQ29yZSB1c2VyIiwicHMiOiIwIn0") == 26
    assert PersonalisedAccountAccessGroup.generate_hash_value("h1L8inzcJhfWPlkdrCgJPtCg6ViwNEduD64GDZKjJDc") == 95
    assert PersonalisedAccountAccessGroup.generate_hash_value("T2j1jevJaoCEmJj37afB6XOUbcfy9WE-4kBcLEkjagI") == 94
    assert PersonalisedAccountAccessGroup.generate_hash_value("som3pseud0n4me-w1thl3tt3rs-4nd-n4mb3rs") == 11
  end

  describe "when foryou-flagpole is GREEN" do
    test "redirect to /account if generated hash is larger than access chance" do
      Agent.update(BBCID, fn _state -> %{@default_bbcid_state | foryou_access_chance: 10, foryou_flagpole: true} end)

      envelope = %Envelope{
        request: %Envelope.Request{
          scheme: :https,
          host: "www.bbc.co.uk",
          path: "/foryou"
        },
        user_session: %Envelope.UserSession{
          user_attributes: %{
            pseudonym: "h1L8inzcJhfWPlkdrCgJPtCg6ViwNEduD64GDZKjJDc"
          }
        }
      }

      assert {
               :stop,
               %{
                 response: %{
                   http_status: 302,
                   body: "",
                   headers: %{
                     "location" => "https://www.bbc.co.uk/account",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private, max-age=0"
                   }
                 }
               }
             } = PersonalisedAccountAccessGroup.call(envelope)
    end

    test "redirect to /account if user is eligible and access_chance is 0" do
      Agent.update(BBCID, fn _state -> %{@default_bbcid_state | foryou_flagpole: true} end)

      envelope = %Envelope{
        request: %Envelope.Request{
          scheme: :https,
          host: "www.bbc.co.uk",
          path: "/foryou"
        },
        user_session: %Envelope.UserSession{
          user_attributes: %{
            pseudonym: "h1L8inzcJhfWPlkdrCgJPtCg6ViwNEduD64GDZKjJDc"
          }
        }
      }

      assert {
               :stop,
               %{
                 response: %{
                   http_status: 302,
                   body: "",
                   headers: %{
                     "location" => "https://www.bbc.co.uk/account",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private, max-age=0"
                   }
                 }
               }
             } = PersonalisedAccountAccessGroup.call(envelope)
    end

    test "Do not redirect if user is eligible and generated hash value is lower than access_chance" do
      Agent.update(BBCID, fn _state -> %{@default_bbcid_state | foryou_access_chance: 96, foryou_flagpole: true} end)

      envelope = %Envelope{
        request: %Envelope.Request{
          scheme: :https,
          host: "www.bbc.co.uk",
          path: "/foryou"
        },
        user_session: %Envelope.UserSession{
          user_attributes: %{
            pseudonym: "h1L8inzcJhfWPlkdrCgJPtCg6ViwNEduD64GDZKjJDc"
          }
        }
      }

      assert {
               :ok,
               %{
                 response: %Envelope.Response{}
               }
             } = PersonalisedAccountAccessGroup.call(envelope)
    end

    test "redirect to /account if pseudonym is not present" do
      Agent.update(BBCID, fn _state -> %{@default_bbcid_state | foryou_flagpole: true} end)

      envelope = %Envelope{
        request: %Envelope.Request{
          scheme: :https,
          host: "www.bbc.co.uk",
          path: "/foryou"
        },
        user_session: %Envelope.UserSession{
          user_attributes: %{}
        }
      }

      assert {
               :stop,
               %{
                 response: %{
                   http_status: 302,
                   body: "",
                   headers: %{
                     "location" => "https://www.bbc.co.uk/account",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private, max-age=0"
                   }
                 }
               }
             } = PersonalisedAccountAccessGroup.call(envelope)
    end

    test "Do not redirect if user has pn > access_chance but pseudonym is in foryou_allow_list" do
      Agent.update(BBCID, fn _state ->
        %{
          @default_bbcid_state
          | foryou_allowlist: ["h1L8inzcJhfWPlkdrCgJPtCg6ViwNEduD64GDZKjJDc"],
            foryou_flagpole: true
        }
      end)

      envelope = %Envelope{
        request: %Envelope.Request{
          scheme: :https,
          host: "www.bbc.co.uk",
          path: "/foryou"
        },
        user_session: %Envelope.UserSession{
          user_attributes: %{
            pseudonym: "h1L8inzcJhfWPlkdrCgJPtCg6ViwNEduD64GDZKjJDc"
          }
        }
      }

      assert {
               :ok,
               ^envelope
             } = PersonalisedAccountAccessGroup.call(envelope)
    end
  end

  describe "when foryou-flagpole is RED" do
    test "redirect to /account even if generated hash <= access chance" do
      Agent.update(BBCID, fn _state -> %{@default_bbcid_state | foryou_access_chance: 96} end)

      envelope = %Envelope{
        request: %Envelope.Request{
          scheme: :https,
          host: "www.bbc.co.uk",
          path: "/foryou"
        },
        user_session: %Envelope.UserSession{
          user_attributes: %{
            pseudonym: "h1L8inzcJhfWPlkdrCgJPtCg6ViwNEduD64GDZKjJDc"
          }
        }
      }

      assert {
               :stop,
               %{
                 response: %{
                   http_status: 302,
                   body: "",
                   headers: %{
                     "location" => "https://www.bbc.co.uk/account",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private, max-age=0"
                   }
                 }
               }
             } = PersonalisedAccountAccessGroup.call(envelope)
    end

    test "redirect to /account when pseudonym is not present" do
      Agent.update(BBCID, fn _state -> @default_bbcid_state end)

      envelope = %Envelope{
        request: %Envelope.Request{
          scheme: :https,
          host: "www.bbc.co.uk",
          path: "/foryou"
        },
        user_session: %Envelope.UserSession{
          user_attributes: %{}
        }
      }

      assert {
               :stop,
               %{
                 response: %{
                   http_status: 302,
                   body: "",
                   headers: %{
                     "location" => "https://www.bbc.co.uk/account",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private, max-age=0"
                   }
                 }
               }
             } = PersonalisedAccountAccessGroup.call(envelope)
    end

    test "redirect to /account even if pseudonym is present" do
      Agent.update(BBCID, fn _state -> @default_bbcid_state end)

      envelope = %Envelope{
        request: %Envelope.Request{
          scheme: :https,
          host: "www.bbc.co.uk",
          path: "/foryou"
        },
        user_session: %Envelope.UserSession{
          user_attributes: %{
            pseudonym: "h1L8inzcJhfWPlkdrCgJPtCg6ViwNEduD64GDZKjJDc"
          }
        }
      }

      assert {
               :stop,
               %{
                 response: %{
                   http_status: 302,
                   body: "",
                   headers: %{
                     "location" => "https://www.bbc.co.uk/account",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "private, max-age=0"
                   }
                 }
               }
             } = PersonalisedAccountAccessGroup.call(envelope)
    end
  end
end
