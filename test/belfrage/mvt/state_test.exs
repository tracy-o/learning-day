defmodule Belfrage.Mvt.StateTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.{Mvt, Struct}
  alias Belfrage.Struct.Response

  describe "get_vary_headers/1" do
    test "gets single mvt vary header" do
      ["mvt-button-colour"] =
        Mvt.State.get_vary_headers(%Struct{
          response: %Response{
            headers: %{
              "vary" => "something,mvt-button-colour,something-else"
            }
          }
        })
    end

    test "gets multiple mvt vary headers" do
      ["mvt-button-colour", "mvt-sidebar-colour"] =
        Mvt.State.get_vary_headers(%Struct{
          response: %Response{
            headers: %{
              "vary" => "something,mvt-button-colour,something-else,mvt-sidebar-colour"
            }
          }
        })
    end

    test "returns empty list when no mvt vary headers present" do
      [] =
        Mvt.State.get_vary_headers(%Struct{
          response: %Response{
            headers: %{
              "vary" => "something,something-else"
            }
          }
        })
    end

    test "returns empty list when no vary header present" do
      [] =
        Mvt.State.get_vary_headers(%Struct{
          response: %Response{
            headers: %{}
          }
        })
    end
  end
end
