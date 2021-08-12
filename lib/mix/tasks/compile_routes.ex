defmodule Mix.Tasks.CompileRoutes do
  @moduledoc """
  EXPERIMENTAL
  ------------

  This modules allows to compile Routefiles against different cosmos environments

  Usage:
  `mix compile_routes <cosmos_env>`

  `mix compile_routes`       compile the route for the Cosmos TEST environment
  `mix compile_routes live`  compile the route for a specific environment

  Routefiles will be compile to beam files, e.g.:
  _build/test/lib/belfrage/ebin/Elixir.Routes.Routefiles.Test.beam
          ^                                               ^
          ┕ Mix Env                            Cosmos Env ┙

  This could be used to test building multiple files at compilation time in CI
  instead of postponing the additional compilation tasks to runtime.
  It also provide a file version of the compiled Routefiles instead of keeping in-memory
  versions as we currently have.

  """
  use Mix.Task

  def run([]) do
    run(["test"])
  end

  def run([env]) when env in ["test", "live"] do
    IO.puts("|  Compiling routes for Cosmos #{env}")
    compile_routes(env)

    IO.puts "|  Done."
    path = "#{dir()}/Elixir.Routes.Routefiles.*"
    IO.puts "|  ls #{path}"

    # credo:disable-for-next-line
    IO.puts :os.cmd('ls #{path}')
    IO.puts "\n"
  end

  def run([env]) do
    raise "Unexpected Cosmos env: #{env}"
  end

  defp compile_routes("test") do
    original_cosmos_env = cosmos_env()

    Application.put_env(:belfrage, :production_environment, "test")
    compile_file("lib/routes/routefiles/main.ex")
    Application.put_env(:belfrage, :production_environment, "live")
    compile_file("lib/routes/routefiles/main.ex")
    Application.put_env(:belfrage, :production_environment, original_cosmos_env)
  end

  defp compile_routes(_) do
    :noop
  end

  defp compile_file(file) do
    IO.puts "|  Compiling #{file} ..."
    [{module, binary}] = Code.compile_file(file)
    File.mkdir_p(dir())
    filename = "#{dir()}/#{module}.beam"

    File.write(filename, binary)
    IO.puts "|  Compiled #{module}"
  end

  defp dir do
    "#{File.cwd!}/_build/routes"
  end

  def cosmos_env do
    Application.get_env(:belfrage, :production_environment)
  end
end
