defmodule Support.Smoke.Assertions do
  alias Test.Support.Helper
  import ExUnit.Assertions

  @stack_ids Application.get_env(:smoke, :endpoint_to_stack_id_mapping)
  @expected_minimum_content_length 30

  def assert_smoke_response(test_properties, route_spec, response) do
    case {world_service_redirect?(route_spec), com_to_uk_redirect?(route_spec), test_properties.tld} do
      {true, false, ".co.uk"} -> assert_world_service_redirect(response)
      {false, true, ".com"} -> assert_com_to_uk_redirect(response)
      _ -> assert_basic_response(response)
    end

    refute Helper.get_header(response.headers, "bfa")

    expected_stack_id_header = Map.get(@stack_ids, test_properties.target)
    assert Helper.header_item_exists(response.headers, expected_stack_id_header)
  end

  defp assert_basic_response(response) do
    assert response.status_code == 200

    assert not is_nil(response.body) and String.length(response.body) > @expected_minimum_content_length
  end

  defp assert_world_service_redirect(response) do
    location = Helper.get_header(response.headers, "location")
    assert location =~ ".com"
  end

  defp assert_com_to_uk_redirect(response) do
    location = Helper.get_header(response.headers, "location")
    assert location =~ ".co.uk"
    assert response.status_code == 302
  end

  defp world_service_redirect?(%{pipeline: pipeline}) do
    "WorldServiceRedirect" in pipeline
  end

  defp com_to_uk_redirect?(%{pipeline: pipeline}) do
    "ComToUKRedirect" in pipeline
  end
end
