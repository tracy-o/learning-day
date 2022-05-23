defmodule Belfrage.Mvt.Allowlist do
  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  def add(struct = %Struct{private: %Private{mvt_project_id: project_id}}) when project_id > 0 do
    raw_headers = struct.request.raw_headers

    allowlist =
      struct.private.headers_allowlist
      |> Enum.concat(mvt_headers())
      |> Enum.concat(mvt_override_headers(raw_headers))

    Struct.add(struct, :private, %{headers_allowlist: allowlist})
  end

  def add(struct), do: struct

  defp mvt_headers() do
    1..20
    |> Enum.map(fn i -> "bbc-mvt-#{i}" end)
    |> Enum.concat(["bbc-mvt-complete"])
  end

  defp mvt_override_headers(raw_headers) do
    if Application.get_env(:belfrage, :production_environment) == "test" do
      Enum.filter(raw_headers, fn {name, _} -> String.starts_with?(name, "mvt-") end)
      |> Enum.map(fn {name, _val} -> name end)
    else
      []
    end
  end
end
