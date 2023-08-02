defmodule Belfrage.Logger.FormatterTest do
  alias Belfrage.Logger.Formatter
  use ExUnit.Case, async: true

  @message "my log"

  describe "app/4" do
    test "returns formatted log" do
      assert [log, "\n"] = Formatter.app(:error, @message, "", [])
      assert log =~ ~s("message":"my log","level":"error")
    end

    test "handles metadata with an :envelope" do
      assert [log, "\n"] =
               Formatter.app(:error, @message, {{2023, 2, 13}, {00, 00, 00, 000}},
                 erl_level: :error,
                 application: :belfrage,
                 domain: [:elixir],
                 envelope: %Belfrage.Envelope{
                   request: %Belfrage.Envelope.Request{path: "/content/cps/learning_english/"}
                 }
               )

      assert log =~ ~s("message":"my log","level":"error")
    end
  end

  describe "GTM Formatter log" do
    test "formatter returns properly formatted log when metadata has :access" do
      metadata = [
        access: true,
        method: "GET",
        request_path: "/status",
        query_string: "foo=bar",
        status: 200,
        host: "www.test.bbc.co.uk",
        scheme: "https",
        bsig: "bsig-1234",
        bbc_request_id: "bbc_r_id_1234",
        belfrage_cache_status: "MISS",
        cache_control: "max-age=0, private, must-revalidate",
        content_length: 1234,
        bid: "bid-1234",
        location: "https://www.test.bbc.co.uk",
        req_svc_chain: "GTM,BELFRAGE",
        vary: "Accept-Encoding,Accept-Language,Accept,User-Agent"
      ]

      [response] = Formatter.access(:access, "", {{2022, 1, 1}, {0, 0, 0, 1000}}, metadata)

      assert [
               "\"2022-01-01T00:00:00.001000Z",
               "GET",
               "https",
               "www.test.bbc.co.uk",
               "/status",
               "foo=bar",
               "200",
               "GTM,BELFRAGE",
               "bbc_r_id_1234",
               "bsig-1234",
               "bid-1234",
               "MISS",
               "max-age=0, private, must-revalidate",
               "Accept-Encoding,Accept-Language,Accept,User-Agent",
               "1234",
               "https://www.test.bbc.co.uk\"\n"
             ] = String.split(response, "\" \"")
    end
  end
end
