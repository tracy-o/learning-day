defmodule Belfrage.ResponseTransformers.MvtMapperTest do
  use ExUnit.Case

  alias Belfrage.Struct
  alias Belfrage.ResponseTransformers.MvtMapper

  test "generates mvt_vary value based on returned mvt headers" do
    {:ok, struct_with_mvt_vary} =
      MvtMapper.call(%Struct{
        private: %Struct.Private{
          mvt_project_id: 1,
          mvt: %{
            "mvt-button_colour" => {1, "experiment;red"},
            "mvt-sidebar" => {5, "feature;false"},
            "bbc-mvt-complete" => {nil, "0"}
          }
        },
        response: %Struct.Response{
          headers: %{
            "vary" => "some_stuff,mvt-button_colour,mvt-sidebar"
          }
        }
      })

    assert struct_with_mvt_vary.private.mvt_vary == ["bbc-mvt-complete", "bbc-mvt-1", "bbc-mvt-5"]
  end

  test "mvt_vary always includes 'bbc-mvt-complete' when mvt project id is set" do
    {:ok, struct_with_mvt_vary} =
      MvtMapper.call(%Struct{
        private: %Struct.Private{
          mvt_project_id: 1,
          mvt: %{
            "mvt-button_colour" => {1, "experiment;red"}
          }
        },
        response: %Struct.Response{
          headers: %{
            "vary" => "some_stuff"
          }
        }
      })

    assert struct_with_mvt_vary.private.mvt_vary == ["bbc-mvt-complete"]
  end

  test "generates mvt_vary value based on returned mvt headers ignoring additional mvt response values" do
    {:ok, struct_with_mvt_vary} =
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

    assert struct_with_mvt_vary.private.mvt_vary == ["bbc-mvt-complete", "bbc-mvt-1", "bbc-mvt-5"]
  end

  test "removes unused mvt headers from the allow list based on returned mvt headers" do
    {:ok, struct_with_mvt_vary} =
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

  test "headers_allowlist always includes 'bbc-mvt-complete' when mvt project id is set" do
    {:ok, struct_with_mvt_vary} =
      MvtMapper.call(%Struct{
        private: %Struct.Private{
          headers_allowlist: ["bbc-mvt-1", "bbc-mvt-2", "bbc-mvt-3", "bbc-mvt-4", "bbc-mvt-5", "bbc-mvt-complete"],
          mvt_project_id: 1,
          mvt: %{
            "mvt-button_colour" => {1, "experiment;red"}
          }
        },
        response: %Struct.Response{
          headers: %{
            "vary" => "some_stuff"
          }
        }
      })

    assert struct_with_mvt_vary.private.headers_allowlist == ["bbc-mvt-complete"]
  end

  test "does not run mvt response logic when mvt is not enabled" do
    {:ok, struct_with_no_mvt} = MvtMapper.call(%Struct{})

    assert struct_with_no_mvt.private.headers_allowlist == []
  end

  # we will assume the environment is test here as `Belfrage.Mvt.Allowlist`
  # should filter out override headers when not on test. If we don't send an
  # override header there is no way we should receive one either.
  describe "mvt-* override header on test environment" do
    test "if override header in mvt map and in vary, add to mvt_vary" do
      {:ok, struct_with_mvt_vary} =
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

      assert struct_with_mvt_vary.private.mvt_vary == ["bbc-mvt-complete", "mvt-some_experiment"]
    end

    test "if override header in mvt map but not in vary, don't add to mvt_vary" do
      {:ok, struct_with_mvt_vary} =
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

      assert struct_with_mvt_vary.private.mvt_vary == ["bbc-mvt-complete"]
    end

    test "if override header not in mvt map but in vary, don't add to mvt_vary" do
      {:ok, struct_with_mvt_vary} =
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

      assert struct_with_mvt_vary.private.mvt_vary == ["bbc-mvt-complete"]
    end
  end
end
