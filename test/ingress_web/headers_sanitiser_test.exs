defmodule IngressWeb.HeadersSanitiserTest do
  use ExUnit.Case

  alias IngressWeb.HeadersSanitiser

  describe "edge cache header" do
    test "returns true when edge cache is '1'" do
      assert HeadersSanitiser.cache(%{edge: "1"}, nil) == true
    end

    test "returns false when edge cache is '0'" do
      assert HeadersSanitiser.cache(%{edge: "0"}, nil) == false
    end

    test "returns false when edge cache is ''" do
      assert HeadersSanitiser.cache(%{edge: ""}, nil) == false
    end

    test "returns false when edge cache is '11'" do
      assert HeadersSanitiser.cache(%{edge: "11"}, nil) == false
    end

    test "returns false when edge cache is not present" do
      assert HeadersSanitiser.cache(%{}, nil) == false
    end
  end

  describe "country headers" do
    test "uses edge country when set and edge cache is set" do
      assert HeadersSanitiser.country(%{edge: "de"}, true) == "de"
    end

    test "uses x country when edge country is set and edge cache is not set" do
      assert HeadersSanitiser.country(%{edge: "gb", varnish: "fr"}, false) == "fr"
    end

    test "uses x country when edge country is not set" do
      assert HeadersSanitiser.country(%{edge: nil, varnish: "it"}, true) == "it"
    end

    test "defaults to 'gb' when neither country headers are set" do
      assert HeadersSanitiser.country(%{edge: nil, varnish: nil}, true) == "gb"
    end
  end

  describe "host headers" do
    test "uses edge host when set" do
      assert HeadersSanitiser.host(%{edge: "www.test.bbc.co.uk"}, false) == "www.test.bbc.co.uk"
    end

    test "uses forwarded host when edge host is not set" do
      assert HeadersSanitiser.host(%{edge: nil, forwarded: "www.test.bbc.com"}, false) ==
               "www.test.bbc.com"
    end

    test "uses http host when edge host and forwarded host are not set" do
      assert HeadersSanitiser.host(
               %{edge: nil, forwarded: nil, http: "www.http-host.bbc.co.uk"},
               false
             ) == "www.http-host.bbc.co.uk"
    end
  end
end
