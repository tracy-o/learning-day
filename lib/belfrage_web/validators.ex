defmodule BelfrageWeb.Validators do
  def in_range?(param, range) do
    case Integer.parse(param) do
      {p, ""} -> p in range
      _ -> false
    end
  end

  def matches?(param, regex) do
    String.match?(param, regex)
  end

  def is_language?(param) do
    String.match?(param, ~r/^([a-zA-Z]{2})$/)
  end

  def is_valid_length?(param, range) do
    String.length(param || "") in range
  end

  def starts_with?(param, start_string) do
    String.starts_with?(param, start_string)
  end
end
