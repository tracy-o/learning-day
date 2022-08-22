defmodule Routes.Platforms do
  def list() do
    Path.expand("../routes/platforms", __DIR__)
    |> File.ls!()
    |> Enum.map(&Path.basename(&1, ".ex"))
    |> Enum.map(&Macro.camelize/1)
  end
end
