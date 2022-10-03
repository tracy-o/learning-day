defmodule BelfrageWeb.Validators do
  @moduledoc """
  This file is for validating routes.
  Example validator usage looks like this:

  ```
  handle "/weather/error/:status", using: "Weather", examples: ["/weather/error/404", "/weather/error/500"] do
    return_404 if: !in_range?(status, [404, 500])
  end
  ```
  """

  @doc """
  ## Examples
    iex> in_range?("2", 1..999)
    true

    iex> in_range?("a", 1..999)
    false

    iex> in_range?("1.5", 1..999)
    false

    iex> in_range?("404", [404, 500])
    true

    iex> in_range?("500", [404, 500])
    true

    iex> in_range?("405", [404, 500])
    false
  """
  def in_range?(param, range) do
    case Integer.parse(param) do
      {p, ""} -> p in range
      _ -> false
    end
  end

  @doc """
  ## Examples
    iex> matches?("123a", ~r/^\\d{1,4}[a-f]?$/)
    true

    iex> matches?("a123a", ~r/^\d{1,4}[a-f]?$/)
    false

    iex> matches?("123z", ~r/^\d{1,4}[a-f]?$/)
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
end
