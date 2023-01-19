defmodule Belfrage.Mvt.HeadersTest do
  use ExUnit.Case

  alias Belfrage.Mvt
  alias Belfrage.Struct

  describe "remove_original_headers" do
    test "if private.mvt_project_id not set no filtering is performed" do
      # This scenario isn't likely to occur as we would expect no mvt headers to
      # be sent when the `mvt_project_id` is not set.

      headers = %{
        "bbc-mvt-complete" => "1",
        "bbc-mvt-1" => "experiment;button_colour;blue",
        "mvt-override" => "true"
      }

      struct =
        %Struct{}
        |> Struct.add(:request, %{raw_headers: headers})

      assert headers == Mvt.Headers.remove_original_headers(struct).request.raw_headers
    end

    test "if project set then bbc-mvt-{i}, bbc-mvt-complete and mvt-* are removed from raw_headers" do
      headers = %{
        "bbc-mvt-complete" => "1",
        "bbc-mvt-1" => "experiment;button_colour;blue",
        "mvt-override_experiment" => "an mvt override header"
      }

      struct =
        %Struct{}
        |> Struct.add(:request, %{raw_headers: headers})
        |> Struct.add(:private, %{mvt_project_id: 2})

      assert %{} ==
               Mvt.Headers.remove_original_headers(struct).request.raw_headers
    end
  end

  describe "put_mvt_headers/2" do
    test "does not add mvt headers when none set" do
      struct = %Struct{}

      assert %{} == Mvt.Headers.put_mvt_headers(%{}, struct.private)
    end

    test "adds mvt headers when set with \"type;value\"" do
      struct_with_mvt = %Struct{
        private: %Struct.Private{
          mvt: %{
            "mvt-button_colour" => {1, nil},
            "mvt-sidebar" => {3, "feature;false"},
            "mvt-banner_colour" => {4, nil},
            "mvt-footer_colour" => {7, "experiment;red"}
          }
        }
      }

      assert %{"mvt-sidebar" => "feature;false", "mvt-footer_colour" => "experiment;red"} ==
               Mvt.Headers.put_mvt_headers(%{}, struct_with_mvt.private)
    end

    test "does not put 'bbc-mvt-complete' header even when in private.mvt" do
      struct_with_mvt = %Struct{
        private: %Struct.Private{
          mvt: %{
            "bbc-mvt-complete" => {nil, "1"}
          }
        }
      }

      assert %{} == Mvt.Headers.put_mvt_headers(%{}, struct_with_mvt.private)
    end
  end
end