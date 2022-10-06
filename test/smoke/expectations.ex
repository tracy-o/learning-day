defmodule Belfrage.SmokeTestCase.Expectations do
  @stack_ids Application.get_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]
  @expected_minimum_content_length 30
  @redirects_statuses Application.get_env(:belfrage, :redirect_statuses)

  alias Test.Support.Helper

  def expect_response(test_properties, response, expected_status_code) do
    cond do
      is_test_only_route(test_properties) ->
        expected_test_route(response, test_properties)

      expected_status_code in @redirects_statuses ->
        expected_redirect(response, expected_status_code, test_properties)

      true ->
        expected_response(response, expected_status_code, test_properties)
    end
  end

  defp expected_test_route(response, test_properties) do
    with {true, _} <- expected_status(response, 404),
         {true, _} <- expected_stack_id(response, test_properties) do
      {true, ""}
    else
      {false, message} -> {false, message}
    end
  end

  defp expected_redirect(response, expected_status_code, test_properties) do
    with {true, _} <- expected_status(response, expected_status_code),
         {true, _} <- expected_response_with_location(response),
         {true, _} <- expected_response_not_stale(response),
         {true, _} <- expected_stack_id(response, test_properties) do
      {true, ""}
    else
      {false, msg} -> {false, msg}
    end
  end

  def expected_response(response, expected_status_code, test_properties) do
    with {true, _} <- expected_status(response, expected_status_code),
         {true, _} <- expected_response_with_body(response),
         {true, _} <- expected_response_not_stale(response),
         {true, _} <- expected_stack_id(response, test_properties) do
      {true, ""}
    else
      {false, msg} -> {false, msg}
    end
  end

  defp is_test_only_route(test_properties) do
    smoke_env = test_properties.smoke_env
    only_on = test_properties.matcher.only_on

    smoke_env == "live" and only_on == "test"
  end

  def expected_response_with_body(response) do
    predicate = not is_nil(response.body) and String.length(response.body) > @expected_minimum_content_length
    msg = "response.body is nil or is too short (must have length of #{@expected_minimum_content_length})"

    {predicate, msg}
  end

  def expected_response_with_location(response) do
    location_header = Helper.get_header(response.headers, "location")
    predicate = not is_nil(location_header) and String.length(location_header) > 0
    msg = "'location' header is empty string, nil or does not exist."

    {predicate, msg}
  end

  defp expected_status(response, expected_status) do
    msg = "expected #{inspect(expected_status)}, received #{inspect(response.status)}"

    {response.status == expected_status, msg}
  end

  def expected_response_not_stale(response) do
    predicate = {"belfrage-cache-status", "STALE"} not in response.headers
    msg = "returned header: #{inspect({"belfrage-cache-status", "STALE"})}"

    {predicate, msg}
  end

  def expected_stack_id(response, test_properties) do
    expected_stack_id_header = Map.get(@stack_ids, test_properties.target)
    predicate = Helper.header_item_exists(response.headers, expected_stack_id_header)
    msg = "expected #{test_properties.target} but was not present in headers: #{inspect(response.headers)}"

    {predicate, msg}
  end
end
