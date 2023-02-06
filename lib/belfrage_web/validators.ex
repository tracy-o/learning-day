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
  ## Examples
    iex> is_guid?("ea49bb5e-9a7d-4456-98df-b7087ecc0788")
    true

    iex> is_guid?("ea49bb5e-9a7d-4456-98df")
    false
  """
  def is_guid?(param) do
    String.match?(param, ~r/[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}/)
  end
end
