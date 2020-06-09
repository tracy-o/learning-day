defmodule Belfrage.Smoke.Assertions do
  use ExUnit.Case
  alias Test.Support.Helper

  def redirects_to(resp, expected_location) do
    location = Helper.get_header(resp.headers, "location")
    assert not is_nil(location), "Expected location header to be set."
    assert location =~ expected_location
  end

  def has_content_length_over(resp, expected_min_content_length) do
    assert not is_nil(resp.body) and String.length(resp.body) > expected_min_content_length
  end

  def has_status(resp, expected_status) do
    assert resp.status_code == expected_status
  end
end
