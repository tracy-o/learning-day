defmodule BelfrageWeb.RequestHeaders.SanitiserTest do
  use ExUnit.Case

  alias BelfrageWeb.RequestHeaders.Sanitiser

  describe "edge cache header" do
    test "returns true when edge cache is '1'" do
      assert Sanitiser.cache(%{edge: "1"}, nil) == true
    end

    test "returns false when edge cache is '0'" do
      assert Sanitiser.cache(%{edge: "0"}, nil) == false
    end

    test "returns false when edge cache is ''" do
      assert Sanitiser.cache(%{edge: ""}, nil) == false
    end

    test "returns false when edge cache is '11'" do
      assert Sanitiser.cache(%{edge: "11"}, nil) == false
    end

    test "returns false when edge cache is not present" do
      assert Sanitiser.cache(%{}, nil) == false
    end
  end

  describe "country headers" do
    test "uses edge country when set and edge cache is set" do
      assert Sanitiser.country(%{edge: "de"}, true) == "de"
    end

    test "uses x country when edge country is set and edge cache is not set" do
      assert Sanitiser.country(%{edge: "gb", varnish: "fr"}, false) == "fr"
    end

    test "uses x country when edge country is not set" do
      assert Sanitiser.country(%{edge: nil, varnish: "it"}, true) == "it"
    end

    test "defaults to 'gb' when neither country headers are set" do
      assert Sanitiser.country(%{edge: nil, varnish: nil}, true) == "gb"
    end
  end

  describe "host headers" do
    test "uses edge host when set" do
      assert Sanitiser.host(%{edge: "www.test.bbc.co.uk"}, false) == "www.test.bbc.co.uk"
    end

    test "uses forwarded host when edge host is not set" do
      assert Sanitiser.host(%{edge: nil, forwarded: "www.test.bbc.com"}, false) ==
               "www.test.bbc.com"
    end

    test "uses http host when neither edge or forwarded host are set" do
      assert Sanitiser.host(%{edge: nil, forwarded: nil, http: "www.test.bbc.com"}, false) ==
               "www.test.bbc.com"
    end

    test "when a host starting with a . is present, it is removed" do
      assert Sanitiser.host(%{edge: ".www.test.bbc.com"}, false) ==
               "www.test.bbc.com"
    end

    test "uses http host when edge host and forwarded host are not set" do
      assert Sanitiser.host(%{edge: nil, forwarded: nil, http: "www.http-host.bbc.co.uk"}, false) ==
               "www.http-host.bbc.co.uk"
    end
  end

  describe "is_uk headers" do
    test "uses edge header when edge_cache is true" do
      assert Sanitiser.is_uk(%{edge: "yes", varnish: nil}, true) == true
      assert Sanitiser.is_uk(%{edge: "no", varnish: "yes"}, true) == false
    end

    test "uses varnish header when edge cache is false" do
      assert Sanitiser.is_uk(%{edge: "no", varnish: "yes"}, false) == true
      assert Sanitiser.is_uk(%{edge: "yes", varnish: "no"}, false) == false
    end

    test "is false when neither headers are set" do
      assert Sanitiser.is_uk(%{edge: nil, varnish: nil}, true) == false
      assert Sanitiser.is_uk(%{edge: nil, varnish: nil}, false) == false
    end
  end

  describe "scheme headers" do
    test "uses edge scheme when set" do
      assert Sanitiser.scheme(%{edge: "https"}, false) == :https
    end

    test "defaults to https when edge scheme is not set" do
      assert Sanitiser.scheme(%{edge: nil}, false) == :https
    end

    test "defaults to https when edge scheme is invalid" do
      assert Sanitiser.scheme(%{edge: "foo"}, false) == :https
    end

    test "use only 1 scheme edge scheme is set with multiple values" do
      assert Sanitiser.scheme(%{edge: "http,https"}, false) == :http
    end
  end

  describe "varnish headers" do
    test "returns true when varnish id is set" do
      assert Sanitiser.varnish(%{varnish: "12345354"}, false) == true
    end

    test "returns false when the varnish id is nil" do
      assert Sanitiser.varnish(%{varnish: nil}, false) == false
    end
  end

  describe "cdn headers" do
    test "returns true when cdn is set" do
      assert Sanitiser.cdn(%{http: "1"}, false) == true
    end

    test "returns false when the cdn is nil" do
      assert Sanitiser.cdn(%{cdn: nil}, false) == false
    end

    test "returns false when the cdn is empty" do
      assert Sanitiser.cdn(%{cdn: ""}, false) == false
    end
  end

  describe "language headers" do
    test "returns the language when set" do
      assert Sanitiser.language(%{varnish: "en"}, nil) == "en"
    end

    test "returns the language_chinese when set" do
      assert Sanitiser.language_chinese(%{varnish: "trad"}, nil) == "trad"
    end

    test "returns the language_serbian when set" do
      assert Sanitiser.language_serbian(%{varnish: "lat"}, nil) == "lat"
    end
  end
end
