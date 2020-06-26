defmodule Support.Smoke.Assertions do
  alias Test.Support.Helper
  import ExUnit.Assertions

  @stack_ids Application.get_env(:smoke, :endpoint_to_stack_id_mapping)
  @expected_minimum_content_length 30

  def assert_smoke_response(test_properties, route_spec, response) do
    if expect_world_service_redirect?(test_properties, route_spec) do
      assert_world_service_redirect(response)
    else
      assert_basic_response(response)
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

  defp expect_world_service_redirect?(test_properties, %{pipeline: pipeline}) do
    test_properties.tld === ".co.uk" && "WorldServiceRedirect" in pipeline
  end
end
