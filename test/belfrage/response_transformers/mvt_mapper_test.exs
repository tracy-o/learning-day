defmodule Belfrage.ResponseTransformers.MvtMapperTest do
  use ExUnit.Case
  import Test.Support.Helper, only: [set_environment: 1]

  alias Belfrage.Struct
  alias Belfrage.ResponseTransformers.MvtMapper

  test "generates mvt_vary value based on returned mvt headers" do
    struct_with_mvt_vary =
      MvtMapper.call(%Struct{
        private: %Struct.Private{
          mvt_project_id: 1,
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
          mvt_project_id: 1,
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

  test "removes unused mvt header slots from the allow list based on returned mvt headers" do
    struct_with_mvt_vary =
      MvtMapper.call(%Struct{
        private: %Struct.Private{
          headers_allowlist: ["bbc-mvt-1", "bbc-mvt-2", "bbc-mvt-3", "bbc-mvt-4", "bbc-mvt-5"],
          mvt_project_id: 1,
          mvt: %{"mvt-button_colour" => {1, "experiment;red"}, "mvt-sidebar" => {5, "feature;false"}}
        },
        response: %Struct.Response{
          headers: %{
            "vary" => "mvt-button_colour,mvt-sidebar"
          }
        }
      })

    assert struct_with_mvt_vary.private.headers_allowlist == ["bbc-mvt-1", "bbc-mvt-5"]
  end

  test "does not run mvt response logic when mvt is not enabled" do
    struct_with_no_mvt = MvtMapper.call(%Struct{})

    assert struct_with_no_mvt.private.headers_allowlist == []
  end

  describe "mvt-* override header on test environment" do
    setup do
      set_environment("test")
    end

    test "if override header in mvt map and in vary, add to mvt_vary" do
      struct_with_mvt_vary =
        MvtMapper.call(%Struct{
          private: %Struct.Private{
            mvt_project_id: 1,
            mvt: %{"mvt-some_experiment" => {:override, "experiment;red"}}
          },
          response: %Struct.Response{
            headers: %{
              "vary" => "mvt-some_experiment,mvt-button_colour,mvt-sidebar,mvt-unknown"
            }
          }
        })

      assert struct_with_mvt_vary.private.mvt_vary == ["mvt-some_experiment"]
    end

    test "if override header in mvt map but not in vary, don't add to mvt_vary" do
      struct_with_mvt_vary =
        MvtMapper.call(%Struct{
          private: %Struct.Private{
            mvt_project_id: 1,
            mvt: %{"mvt-some_experiment" => {:override, "experiment;red"}}
          },
          response: %Struct.Response{
            headers: %{
              "vary" => "mvt-sidebar,mvt-unknown"
            }
          }
        })

      assert struct_with_mvt_vary.private.mvt_vary == []
    end

    test "if override header not in mvt map but in vary, don't add to mvt_vary" do
      struct_with_mvt_vary =
        MvtMapper.call(%Struct{
          private: %Struct.Private{
            mvt_project_id: 1,
            mvt: %{}
          },
          response: %Struct.Response{
            headers: %{
              "vary" => "mvt-some_experiment"
            }
          }
        })

      assert struct_with_mvt_vary.private.mvt_vary == []
    end
  end

  describe "override header on live environment" do
    setup do
      set_environment("live")
    end

    test "if override header in mvt map and the vary, don't add to mvt header" do
      struct_with_mvt_vary =
        MvtMapper.call(%Struct{
          private: %Struct.Private{
            mvt_project_id: 1,
            mvt: %{"mvt-some_experiment" => {:override, "experiment;red"}}
          },
          response: %Struct.Response{
            headers: %{
              "vary" => "mvt-some_experiment,mvt-button_colour,mvt-sidebar,mvt-unknown"
            }
          }
        })

      assert struct_with_mvt_vary.private.mvt_vary == []
    end
  end
end
