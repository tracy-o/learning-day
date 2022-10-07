defmodule Belfrage.SmokeTestCase.Expectations do
  @stack_ids Application.get_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]
  @expected_minimum_content_length 30
  @redirects_statuses Application.get_env(:belfrage, :redirect_statuses)

  alias Test.Support.Helper

  def expect_response(response, test_properties) do
    cond do
      is_test_only_route(test_properties) ->
        expected_test_route(response, test_properties)

      test_properties.expected_status in @redirects_statuses ->
        expected_redirect(response, test_properties)

      true ->
        expected_response(response, test_properties)
    end
  end

  defp expected_test_route(response, test_properties) do
    expect_all([
      expected_status(response, 404),
      expected_stack_id(response, test_properties)
    ])
  end

  defp expected_redirect(response, test_properties) do
    expect_all([
      expected_status(response, test_properties),
      expected_response_with_location(response),
      expected_response_not_stale(response),
      expected_stack_id(response, test_properties)
    ])
  end

  defp expected_response(response, test_properties) do
    expect_all([
      expected_status(response, test_properties),
      expected_response_with_body(response),
      expected_response_not_stale(response),
      expected_stack_id(response, test_properties)
    ])
  end

  defp is_test_only_route(test_properties) do
    smoke_env = test_properties.smoke_env
    only_on = test_properties.matcher.only_on

    smoke_env == "live" and only_on == "test"
  end

  defp expected_response_with_body(response) do
    msg_on_error(
      not is_nil(response.body) and String.length(response.body) > @expected_minimum_content_length,
      "response.body is nil or is too short (must have length of #{@expected_minimum_content_length})"
    )
  end

  defp expected_response_with_location(response) do
    location_header = Helper.get_header(response.headers, "location")

    msg_on_error(
      not is_nil(location_header) and String.length(location_header) > 0,
      "'location' header is empty string, nil or does not exist."
    )
  end

  defp expected_status(response, _test_properties = %{expected_status: expected_status}) do
    msg_on_error(
      response.status == expected_status,
      "expected #{inspect(expected_status)}, received #{inspect(response.status)}"
    )
  end

  defp expected_response_not_stale(response) do
    msg_on_error(
      {"belfrage-cache-status", "STALE"} not in response.headers,
      "returned header: #{inspect({"belfrage-cache-status", "STALE"})}"
    )
  end

  defp expected_stack_id(response, test_properties) do
    expected_stack_id_header = Map.get(@stack_ids, test_properties.target)

    msg_on_error(
      Helper.header_item_exists(response.headers, expected_stack_id_header),
      "expected #{test_properties.target} but was not present in headers: #{inspect(response.headers)}"
    )
  end

  defp msg_on_error(predicate, msg) do
    if predicate do
      :ok
    else
      {:error, msg}
    end
  end

  defp expect_all([]), do: :ok
  defp expect_all([{:error, msg} | _rest]), do: {:error, msg}
  defp expect_all([:ok | rest]), do: expect_all(rest)
end
