defmodule Belfrage.Transformers.UserSession do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{raw_headers: %{"cookie" => cookie}}}) do
    then(rest, Struct.add(struct, :private, %{authenticated: authenticated?(cookie)}))
  end

  def call(rest, struct) do
    then(rest, struct)
  end

  defp authenticated?(cookie) do
    parse_cookie(cookie)
    |> Map.has_key?("ckns_id")
  end

  defp parse_cookie(""), do: %{}

  defp parse_cookie(cookie) do
    cookie
    |> String.split(";")
    |> Enum.map(&String.split(&1, "="))
    |> Map.new(&List.to_tuple/1)
  end
end
