defmodule Belfrage.Allowlist.QueryParamsTest do
  use ExUnit.Case
  alias Belfrage.Struct
  alias Belfrage.Allowlist.QueryParams

  test "allows all query strings when allowlist is *" do
    struct =
      %Struct{}
      |> Struct.add(:request, %{
        query_params: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Struct.add(:private, %{
        query_params_allowlist: "*"
      })

    assert %{
             "a" => "b",
             "c" => "d"
           } == QueryParams.filter(struct).request.query_params
  end

  test "rejects all query strings when allowlist is empty" do
    struct =
      %Struct{}
      |> Struct.add(:request, %{
        query_params: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Struct.add(:private, %{
        query_params_allowlist: []
      })

    assert %{} == QueryParams.filter(struct).request.query_params
  end

  test "filters query strings when allowlist is not empty" do
    struct =
      %Struct{}
      |> Struct.add(:request, %{
        query_params: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Struct.add(:private, %{
        query_params_allowlist: ["a"]
      })

    assert %{
             "a" => "b"
           } == QueryParams.filter(struct).request.query_params
  end

  test "allowlist in struct defaults to empty" do
    assert %Struct{private: %Struct.Private{query_params_allowlist: []}} = %Struct{}
  end
end
