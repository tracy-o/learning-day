defmodule Belfrage.Releases.Plugins.Routefiles do
  use Distillery.Releases.Plugin

  def before_assembly(release, _opts) do
    compile_routes(release)

    release
  end

  def after_assembly(release, _opts) do
    release
  end

  def before_package(release, _opts) do
    release
  end

  def after_package(release, _opts) do
    release
  end

  defp compile_routes(release) do
    original_cosmos_env = cosmos_env()

    Application.put_env(:belfrage, :production_environment, "test")
    compile_file("lib/routes/routefiles/main.ex", release)
    Application.put_env(:belfrage, :production_environment, original_cosmos_env)
  end


  # Used with the overlays in rel/config.exs to be added to the release
  defp compile_file(file, release) do
    IO.puts "|  Compiling #{file} ..."
    [{module, binary}] = Code.compile_file(file)
    filename = "#{dir(release)}/#{module}.beam"

    File.write(filename, binary)
    IO.puts "|  Compiled #{module} in #{dir(release)}"
  end

  # _build/prod/lib/belfrage/ebin/Elixir.Routes.Routefiles.Test.beam
  defp dir(release) do
    "_build/" <> to_string(release.env) <> "/lib/" <> to_string(release.name) <> "/ebin"
  end

  def cosmos_env do
    Application.get_env(:belfrage, :production_environment)
  end
end
