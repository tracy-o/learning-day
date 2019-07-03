defmodule Ingress.ServiceProviderTest do
  use ExUnit.Case

  alias Ingress.{Services, ServiceProvider}

  describe "ServiceProvider.service_for/1" do
    test "when origin is http it returns the HTTP Service" do
      assert Services.HTTP == ServiceProvider.service_for("http://www.bbc.co.uk")
    end

    test "when origin is https it returns the HTTP Service" do
      assert Services.HTTP == ServiceProvider.service_for("https://www.bbc.co.uk")
    end

    test "when origin is not http/s it returns the Lambda Service" do
      assert Services.Lambda == ServiceProvider.service_for("lambda-presentation-layer")
    end
  end
end
