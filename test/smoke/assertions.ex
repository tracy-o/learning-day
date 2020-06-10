defmodule Belfrage.Smoke.Assertions do
  alias Test.Support.Helper

  @stack_ids Application.get_env(:smoke, :endpoint_to_stack_id_mapping)

  def redirects_to(resp, expected_location, _test_properties) do
    location = Helper.get_header(resp.headers, "location")

    expect(location =~ expected_location, "Redirect location failed, #{cyan(location)} =~ #{yellow(expected_location)}")
  end

  def has_content_length_over(resp, expected_min_content_length, _test_properties) do
    expect(
      not is_nil(resp.body) and String.length(resp.body) > expected_min_content_length,
      red("Small response body.") <>
        expected(Integer.to_string(expected_min_content_length)) <> actual(inspect(resp.body))
    )
  end

  def has_status(resp, expected_status, _test_properties) do
    expect(
      resp.status_code == expected_status,
      error("Wrong status code.") <>
        expected(Integer.to_string(expected_status)) <> actual(Integer.to_string(resp.status_code))
    )
  end

  def not_a_fallback(resp, _test_properties) do
    expect(
      not Helper.header_item_exists(resp.headers, %{id: "bfa", value: "1"}),
      error("Received a Belfrage fallback.")
    )
  end

  def correct_stack_id(resp, %{target: target}) do
    expected_stack_id_header = Map.get(@stack_ids, target)
    found_stack_id_header? = Helper.header_item_exists(resp.headers, expected_stack_id_header)

    expect(
      found_stack_id_header?,
      error("Did not find stack id in response headers. ") <>
        expected(inspect(expected_stack_id_header)) <> actual(inspect(resp.headers))
    )
  end

  defp expect(true, _msg), do: :ok
  defp expect(false, msg), do: msg

  defp error(msg), do: red(msg)
  defp expected(msg), do: cyan("\nExpected: " <> msg)
  defp actual(msg), do: yellow("\nActual: " <> msg)

  defp cyan(msg), do: IO.ANSI.cyan() <> msg <> IO.ANSI.default_color()
  defp red(msg), do: IO.ANSI.red() <> msg <> IO.ANSI.default_color()
  defp yellow(msg), do: IO.ANSI.yellow() <> msg <> IO.ANSI.default_color()
end
