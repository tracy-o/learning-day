defmodule Belfrage.Mvt.Allowlist do
  alias Belfrage.Envelope

  def add(envelope) do
    raw_headers = envelope.request.raw_headers
    project_id = envelope.private.mvt_project_id

    allowlist =
      envelope.private.headers_allowlist
      |> Enum.concat(mvt_headers(project_id))
      |> Enum.concat(mvt_override_headers(raw_headers))

    Envelope.add(envelope, :private, %{headers_allowlist: allowlist})
  end

  defp mvt_headers(project_id) do
    if project_id > 0 do
      1..20
      |> Enum.map(fn i -> "bbc-mvt-#{i}" end)
      |> Enum.concat(["bbc-mvt-complete"])
    else
      []
    end
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
