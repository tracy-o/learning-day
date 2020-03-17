defmodule Belfrage.QueryParamsTest do
  use ExUnit.Case
  alias Belfrage.Struct
  alias Belfrage.QueryParams

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
           } == QueryParams.allowlist(struct).request.query_params
  end

  test "allows all query strings when production env is test, and platform is mozart" do
    struct =
      %Struct{}
      |> Struct.add(:request, %{
        query_params: %{
          "a" => "b",
          "c" => "d"
        }
      })
      |> Struct.add(:private, %{
        platform: :mozart,
        production_environment: "test",
        query_params_allowlist: ["only_allow_this_normally"]
      })

    assert %{
             "a" => "b",
             "c" => "d"
           } == QueryParams.allowlist(struct).request.query_params
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

    assert %{} == QueryParams.allowlist(struct).request.query_params
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
           } == QueryParams.allowlist(struct).request.query_params
  end

  test "allowlist in struct defaults to empty" do
    assert %Struct{private: %Struct.Private{query_params_allowlist: []}} = %Struct{}
  end
end
