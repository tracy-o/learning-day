defmodule BelfrageWeb.Validators do
  @moduledoc """
  This file includes functions that can be used to assist capability teams with validating the requests made against their routes.
  Examples of how the validators can be used can be seen below:

  ```
  handle "/weather/error/:status", using: "Weather", examples: ["/weather/error/404", "/weather/error/500"] do
    return_404 if: !integer_in_range?(status, [404, 500])
  end
  ```
  """

  @doc """
  ## Examples
    iex> integer_in_range?("2", 1..999)
    true

    iex> integer_in_range?("a", 1..999)
    false

    iex> integer_in_range?("1.5", 1..999)
    false

    iex> integer_in_range?("404", [404, 500])
    true

    iex> integer_in_range?("500", [404, 500])
    true

    iex> integer_in_range?("405", [404, 500])
    false
  """
  def integer_in_range?(param, range) do
    case Integer.parse(param) do
      {p, ""} -> p in range
      _ -> false
    end
  end

  @doc """
  ## Examples
    iex> matches?("123a", ~r/^[0-9]{1,4}[a-f]?$/)
    true

    iex> matches?("a123a", ~r/^[0-9]{1,4}[a-f]?$/)
    false

    iex> matches?("123z", ~r/^[0-9]{1,4}[a-f]?$/)
    false
  """
  def matches?(param, regex) do
    String.match?(param, regex)
  end

  @doc """
  ## Examples
    iex> is_language?("en")
    true

    iex> is_language?("english")
    false
  """
  def is_language?(param) do
    String.match?(param, ~r/^([a-zA-Z]{2})$/)
  end

  @doc """
  ## Examples
    iex> is_valid_length?("abc", 1..3)
    true

    iex> is_valid_length?("123", 1..3)
    true

    iex> is_valid_length?("abcd", 1..3)
    false

    iex> is_valid_length?("", 1..3)
    false
  """
  def is_valid_length?(param, range) do
    case Integer.parse(param) do
      {p, ""} -> length(Integer.digits(p)) in range
      _ -> String.length(param || "") in range
    end
  end

  @doc """
  ## Examples
    iex> starts_with?("/weather", "/")
    true

    iex> starts_with?("weather", "/")
    false
  """
  def starts_with?(param, start_string) do
    String.starts_with?(param, start_string)
  end

  @doc """
  Documentation on short ID generation: https://confluence.dev.bbc.co.uk/display/cps/Generating+Short+IDs
  ## Examples
    iex> is_tipo_id?("cx6pk6ve3kkt")
    true

    iex> is_tipo_id?("zx11pk6ve3kkb")
    false
  """
  def is_tipo_id?(param) do
    String.match?(param, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,11}t$/)
  end

  @doc """
  Documentation on short ID generation: https://confluence.dev.bbc.co.uk/display/cps/Generating+Short+IDs
  ## Examples
    iex> is_cps_id?("23247541")
    true

    iex> is_cps_id?("world-europe-66026851")
    true

    iex> is_cps_id?("entertainment+arts-10636043")
    true

    iex> is_cps_id?("science_and_environment")
    true

    iex> is_cps_id?("entertainment_and_arts")
    true

    iex> is_cps_id?("uk")
    true

    iex> is_cps_id?("zx11pk6ve3kkb")
    false

    iex> is_cps_id?("uk-England-London")
    false

    iex> is_cps_id?("world-europe-66026851gb")
    false

    iex> is_cps_id?("election-2019-50319040")
    true

    iex> is_cps_id?("election-2015-northern-ireland-32488247")
    true
  """
  def is_cps_id?(param) do
    String.match?(
      param,
      ~r/\A[a-z-_+]{2,}-[0-9]+[a-z-]+-[0-9]{5,9}\z|\A[a-z-_+]{2,}-[0-9]+-[0-9]{5,9}\z|\A[a-z-_+]{2,}-[0-9]{5,9}\z|\A[a-z-_+]{2,}\z|\A[0-9]{5,9}\z/
    )
  end

  @doc """
  Validates numeric CPS IDs. For example Sport CPS IDs are typically numeric.
  Documentation on short ID generation: https://confluence.dev.bbc.co.uk/display/cps/Generating+Short+IDs
  ## Examples
    iex> is_numeric_cps_id?("23247541")
    true

    iex> is_numeric_cps_id?("world-europe-66026851")
    false

    iex> is_numeric_cps_id?("zx11pk6ve3kkb")
    false
  """
  def is_numeric_cps_id?(param) do
    String.match?(param, ~r/^[0-9]{5,9}$/)
  end

  @doc """
  ## Examples
    iex> is_guid?("ea49bb5e-9a7d-4456-98df-b7087ecc0788")
    true

    iex> is_guid?("ea49bb5e-9a7d-4456-98df")
    false
  """
  def is_guid?(param) do
    String.match?(param, ~r/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/)
  end

  @doc """
  Validate asset GUIDs in the following format: 'asset:cf7402da-c94c-4400-8662-c7ebd65ba957'
  ## Examples
    iex> is_asset_guid?("asset:cf7402da-c94c-4400-8662-c7ebd65ba957")
    true

    iex> is_asset_guid?("cf7402da-c94c-4400-8662")
    false
  """
  def is_asset_guid?(param) do
    String.match?(param, ~r/^asset:[a-z,0-9,-]{36}$/)
  end

  @doc """
  ## Examples
    iex> is_zid?("zbdmwty")
    true

    iex> is_zid?("zi10")
    false
  """
  def is_zid?(param) do
    String.match?(param, ~r/^z[bcdfghjkmnpqrstvwxy2346789]{6,10}$/)
  end

  @doc """
  Validate ISO 8601 dates in the format 'yyyy-MM-dd'
  ## Examples
    iex> is_iso_date?("2023-09-18")
    true

    iex> is_iso_date?("2023-02-31")
    false

    iex> is_iso_date?("2023-09")
    false

    iex> is_iso_date?("not-a-date")
    false
  """
  def is_iso_date?(date) do
    case Date.from_iso8601(date) do
      {:ok, _date} -> true
      _ -> false
    end
  end

  @doc """
  Validate ISO 8601 months in the format 'yyyy-MM'
  ## Examples
    iex> is_iso_month?("2023-09")
    true

    iex> is_iso_month?("2023-13")
    false

    iex> is_iso_month?("2023-09-18")
    false

    iex> is_iso_month?("not-a-date")
    false
  """
  def is_iso_month?(month) do
    String.match?(month, ~r/^\d{4}-(0[1-9]|1[0-2])$/)
  end

  @doc """
  Validate ISO 8601 dates in the format '202y-MM-dd' (i.e. from the year 2020-2029)
  ## Examples
    iex> is_2020s_iso_date?("2020-09-18")
    true

    iex> is_2020s_iso_date?("2029-09-18")
    true

    iex> is_2020s_iso_date?("2019-09-18")
    false

    iex> is_2020s_iso_date?("2030-09-18")
    false

    iex> is_2020s_iso_date?("3020-09-18")
    false

    iex> is_2020s_iso_date?("2120-09-18")
    false
  """
  def is_2020s_iso_date?(date) do
    String.match?(date, ~r/^202[0-9]/) and is_iso_date?(date)
  end

  @doc """
  Validate ISO 8601 months in the format '202y-MM' (i.e. from the year 2020-2029)
  ## Examples
    iex> is_2020s_iso_month?("2020-09")
    true

    iex> is_2020s_iso_month?("2029-09")
    true

    iex> is_2020s_iso_month?("2019-09")
    false

    iex> is_2020s_iso_month?("2030-09")
    false

    iex> is_2020s_iso_month?("3020-09")
    false

    iex> is_2020s_iso_month?("2120-09")
    false
  """
  def is_2020s_iso_month?(date) do
    String.match?(date, ~r/^202[0-9]/) and is_iso_month?(date)
  end
end
