defmodule Belfrage.ServiceProviderTest do
  use ExUnit.Case, async: true

  alias Belfrage.{Services, ServiceProvider}

  describe "service_for/1" do
    test "when origin is http it returns the HTTP Service" do
      assert ServiceProvider.service_for("http://www.bbc.co.uk") == Services.HTTP
    end

    test "when origin is https it returns the HTTP Service" do
      assert ServiceProvider.service_for("https://www.bbc.co.uk") == Services.HTTP
    end

    test "when origin is https://fabl it returns the HTTP Service" do
      assert ServiceProvider.service_for("https://fabl.test.api.bbci.co.uk") == Services.Fabl
    end

    test "when origin doesnt match the other scenarios it returns the Webcore Service" do
      assert ServiceProvider.service_for("arn:aws:lambda:eu-west-1:123456:function:webcore") == Services.Webcore
    end
  end
end
