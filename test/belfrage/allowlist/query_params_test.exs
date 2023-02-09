defmodule Belfrage.Allowlist.QueryParamsTest do
  use ExUnit.Case, async: true
  alias Belfrage.Envelope
  alias Belfrage.Allowlist.QueryParams

  test "allows all query strings when allowlist is *" do
    envelope =
      %Envelope{}
      |> Envelope.add(:request, %{
        query_params: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Envelope.add(:private, %{
        query_params_allowlist: "*"
      })

    assert %{
             "a" => "b",
             "c" => "d"
           } == QueryParams.filter(envelope).request.query_params
  end

  test "rejects all query strings when allowlist is empty" do
    envelope =
      %Envelope{}
      |> Envelope.add(:request, %{
        query_params: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Envelope.add(:private, %{
        query_params_allowlist: []
      })

    assert %{} == QueryParams.filter(envelope).request.query_params
  end

  test "filters query strings when allowlist is not empty" do
    envelope =
      %Envelope{}
      |> Envelope.add(:request, %{
        query_params: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Envelope.add(:private, %{
        query_params_allowlist: ["a"]
      })

    assert %{
             "a" => "b"
           } == QueryParams.filter(envelope).request.query_params
  end

  test "allowlist in envelope defaults to empty" do
    assert %Envelope{private: %Envelope.Private{query_params_allowlist: []}} = %Envelope{}
  end
end
