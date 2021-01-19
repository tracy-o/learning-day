defmodule Belfrage.Authentication.Validator.IssuerTest do
  use ExUnit.Case
  alias Belfrage.Authentication.Validator.Issuer

  describe "valid?/3" do
    setup do
      %{
        base_issuer: Application.get_env(:belfrage, :authentication)["iss"]
      }
    end

    test "when issuer and realm do match", %{base_issuer: base_issuer} do
      claims = %{
        "iss" => "#{base_issuer}/foo",
        "realm" => "foo"
      }

      assert Issuer.valid?(base_issuer, claims)
    end

    test "realm is top level route", %{base_issuer: base_issuer} do
      claims = %{
        "iss" => "#{base_issuer}",
        "realm" => "/"
      }

      assert Issuer.valid?(base_issuer, claims)
    end

    test "when issuer in claim has trailing /", %{base_issuer: base_issuer} do
      claims = %{
        "iss" => "#{base_issuer}/",
        "realm" => "/"
      }

      refute Issuer.valid?(base_issuer, claims)
    end

    test "when issuer in claim has trailing / but realm does not", %{base_issuer: base_issuer} do
      claims = %{
        "iss" => "#{base_issuer}/foo/",
        "realm" => "/foo"
      }

      refute Issuer.valid?(base_issuer, claims)
    end

    test "when issuers in claim and base issuer has trailing /", %{base_issuer: base_issuer} do
      claims = %{
        "iss" => "#{base_issuer}/",
        "realm" => "/"
      }

      assert Issuer.valid?(base_issuer <> "/", claims)
    end

    test "when base issuer and issuer do not match", %{base_issuer: base_issuer} do
      claims = %{
        "iss" => "http://example.com/foo",
        "realm" => "foo"
      }

      refute Issuer.valid?(base_issuer, claims)
    end

    test "when issuer and realm do match, with realm prefixed with /", %{base_issuer: base_issuer} do
      claims = %{
        "iss" => "#{base_issuer}/foo",
        "realm" => "/foo"
      }

      assert Issuer.valid?(base_issuer, claims)
    end

    test "when issuer and realm do not match", %{base_issuer: base_issuer} do
      claims = %{
        "iss" => "#{base_issuer}/foo",
        "realm" => "bar"
      }

      refute Issuer.valid?(base_issuer, claims)
    end

    test "when iss claim is not provided", %{base_issuer: base_issuer} do
      claims = %{
        "realm" => "bar"
      }

      refute Issuer.valid?(base_issuer, claims)
    end

    test "when realm claim is not provided", %{base_issuer: base_issuer} do
      claims = %{
        "iss" => "#{base_issuer}/foo"
      }

      refute Issuer.valid?(base_issuer, claims)
    end

    test "when neither iss or realm claims are provided", %{base_issuer: base_issuer} do
      claims = %{}

      refute Issuer.valid?(base_issuer, claims)
    end
  end
end
