defmodule Belfrage.ServiceProviderTest do
  use ExUnit.Case

  alias Belfrage.{Services, ServiceProvider}

  describe "ServiceProvider.service_for/1" do
    test "when the origin ends with service-worker.js it returns the ServiceWorker Service" do
      assert Services.Lambda.ServiceWorker == ServiceProvider.service_for("http://www.bbc.co.uk/service-worker.js")
    end

    test "when the origin ends with graphql it returns the Graphql Service" do
      assert Services.Lambda.Graphql == ServiceProvider.service_for("http://www.bbc.co.uk/graphql")
    end

    test "when origin is http it returns the HTTP Service" do
      assert Services.HTTP == ServiceProvider.service_for("http://www.bbc.co.uk")
    end

    test "when origin is https it returns the HTTP Service" do
      assert Services.HTTP == ServiceProvider.service_for("https://www.bbc.co.uk")
    end

    test "when origin doesnt match the other scenarios it returns the Pwa Service" do
      assert Services.Lambda.Pwa == ServiceProvider.service_for("lambda-presentation-layer")
    end
  end
end
