defmodule Belfrage.Release.TestRoutefile do
  use Distillery.Releases.Plugin

  def before_assembly(release, _opts) do
    compile_routes("test", release)

    release
  end

  defp compile_routes("test", release) do
    original_cosmos_env = cosmos_env()

    Application.put_env(:belfrage, :production_environment, "test")
    compile_file("lib/routes/routefiles/main.ex", release)
    Application.put_env(:belfrage, :production_environment, original_cosmos_env)
  end

  defp compile_routes(_, _release) do
    :noop
  end

  defp compile_file(file, release) do
    IO.puts "|  Compiling #{file} ..."
    [{module, binary}] = Code.compile_file(file)
    filename = "#{dir(release)}/#{module}.beam"

    File.write(filename, binary)
    IO.puts "|  Compiled #{module} in #{dir(release)}"
  end

  # output_dir: "_build/prod/rel/belfrage"
  # target dir: prod/rel/belfrage/lib/belfrage-0.2.0/ebin
  defp dir(release) do
    release.profile.output_dir <> "/lib/" <> to_string(release.name) <> "-" <> release.version <> "/ebin"
  end

  def cosmos_env do
    Application.get_env(:belfrage, :production_environment)
  end
end
