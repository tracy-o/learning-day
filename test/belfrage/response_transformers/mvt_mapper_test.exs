defmodule Belfrage.ResponseTransformers.MvtMapperTest do
  alias Belfrage.Struct
  use ExUnit.Case

  alias Belfrage.ResponseTransformers.MvtMapper

  test "generates mvt_vary value based on returned mvt headers" do
    struct_with_mvt_vary =
      MvtMapper.call(%Struct{
        private: %Struct.Private{
          mvt: %{"mvt-button_colour" => {1, "experiment;red"}, "mvt-sidebar" => {5, "feature;false"}}
        },
        response: %Struct.Response{
          headers: %{
            "vary" => "some_stuff,mvt-button_colour, mvt-sidebar"
          }
        }
      })

    assert struct_with_mvt_vary.private.mvt_vary == ["bbc-mvt-1", "bbc-mvt-5"]
  end

  test "generates mvt_vary value based on returned mvt headers ignoring additional mvt response values" do
    struct_with_mvt_vary =
      MvtMapper.call(%Struct{
        private: %Struct.Private{
          mvt: %{"mvt-button_colour" => {1, "experiment;red"}, "mvt-sidebar" => {5, "feature;false"}}
        },
        response: %Struct.Response{
          headers: %{
            "vary" => "some_stuff,mvt-button_colour,mvt-sidebar,mvt-unknown"
          }
        }
      })

    assert struct_with_mvt_vary.private.mvt_vary == ["bbc-mvt-1", "bbc-mvt-5"]
  end
end
