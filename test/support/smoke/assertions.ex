defmodule Support.Smoke.Assertions do
  alias Test.Support.Helper

  @stack_ids Application.get_env(:smoke, :endpoint_to_stack_id_mapping)

  def redirects_to(resp, expected_location, _test_properties) do
    case Helper.get_header(resp.headers, "location") do
      nil ->
        error("Redirect location header not set")

      location ->
        expect(
          location =~ expected_location,
          ["Redirect location header failed", expected_location, location]
        )
    end
  end

  def has_content_length_over(resp, expected_min_content_length, _test_properties) do
    expect(
      not is_nil(resp.body) and String.length(resp.body) > expected_min_content_length,
      ["Small response body.", Integer.to_string(expected_min_content_length), inspect(resp.body)]
    )
  end

  def has_status(resp, expected_status, _test_properties) do
    expect(
      resp.status_code == expected_status,
      ["Wrong status code.", Integer.to_string(expected_status), Integer.to_string(resp.status_code)]
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
      ["Did not find stack id in response headers.", inspect(expected_stack_id_header), inspect(resp.headers)]
    )
  end

  defp expect(true, _msg), do: :ok
  defp expect(false, [msg, expected, actual]), do: error(msg) <> expected(expected) <> actual(actual)
  defp expect(false, msg), do: msg

  defp error(msg), do: red(msg)
  defp expected(msg), do: cyan("\nExpected: " <> msg)
  defp actual(msg), do: yellow("\nActual: " <> msg)

  defp cyan(msg), do: IO.ANSI.cyan() <> msg <> IO.ANSI.default_color()
  defp red(msg), do: IO.ANSI.red() <> msg <> IO.ANSI.default_color()
  defp yellow(msg), do: IO.ANSI.yellow() <> msg <> IO.ANSI.default_color()
end
