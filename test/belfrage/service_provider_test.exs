defmodule Belfrage.ServiceProviderTest do
  use ExUnit.Case

  alias Belfrage.{Services, ServiceProvider}

  describe "ServiceProvider.service_for/1" do
    test "when origin is http it returns the HTTP Service" do
      assert Services.HTTP == ServiceProvider.service_for("http://www.bbc.co.uk")
    end

    test "when origin is https it returns the HTTP Service" do
      assert Services.HTTP == ServiceProvider.service_for("https://www.bbc.co.uk")
    end

    test "when origin doesnt match the other scenarios it returns the Webcore Service" do
      assert Services.Webcore == ServiceProvider.service_for("arn:aws:lambda:eu-west-1:123456:function:webcore")
    end
  end
end
