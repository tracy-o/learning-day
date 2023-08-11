defmodule Belfrage.Behaviours.ServiceTest do
  use ExUnit.Case, async: true
  import Mock

  alias Belfrage.{
    Behaviours.Service,
    Envelope,
    Services
  }

  describe "call dispatch/1" do
    test "when origin is http it returns the HTTP Service" do
      do_test_dispatch("http://www.bbc.co.uk", Services.HTTP)
    end

    test "when origin is https it returns the HTTP Service" do
      do_test_dispatch("https://www.bbc.co.uk", Services.HTTP)
    end

    test "when origin is https://fabl it returns the HTTP Service" do
      do_test_dispatch("https://fabl.test.api.bbci.co.uk", Services.Fabl)
    end

    test "when origin doesnt match the other scenarios it returns the Webcore Service" do
      do_test_dispatch("arn:aws:lambda:eu-west-1:123456:function:webcore", Services.Webcore)
    end
  end

  defp do_test_dispatch(origin, service) do
    envelope = %Envelope{private: %Envelope.Private{origin: origin}}

    with_mock service, dispatch: fn envelope -> envelope end do
      assert envelope == Service.dispatch(envelope)
      assert_called(service.dispatch(envelope))
    end
  end
end
