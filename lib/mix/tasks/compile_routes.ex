defmodule Mix.Tasks.CompileRoutes do
  use Mix.Task

  def run([]) do
    penv = Application.get_env(:belfrage, :production_environment)
    run([penv])
  end

  def run([env]) do
    IO.puts("|  Compiling routes for #{env}")
    compile_routes(env)

    IO.puts "|  Done."
    path = "#{dir()}/Elixir.Routes.Routefiles.*"
    IO.puts "|  ls #{path}"
    IO.puts :os.cmd('ls #{path}')
    IO.puts "\n"
  end

  defp compile_routes("test") do
    Application.put_env(:belfrage, :production_environment, "test")
    compile_file("lib/routes/routefiles/main.ex")
    Application.put_env(:belfrage, :production_environment, "live")
    compile_file("lib/routes/routefiles/main.ex")
    Application.put_env(:belfrage, :production_environment, "test")
  end

  defp compile_routes("sandbox") do
    compile_file("lib/routes/routefiles/sandbox.ex")
  end

  defp compile_routes(_) do
    #compile_file("lib/routes/routefiles/main.ex")
    :noop
  end

  defp compile_file(file) do
    IO.puts file
    [{module, binary}] = Code.compile_file(file)
    filename = "#{dir()}/#{module}.beam"

    File.write(filename, binary)
    IO.puts "|  Compiled #{module}"
  end

  defp dir do
    "#{File.cwd!}/_build/#{Mix.env()}/lib/belfrage/ebin"
  end
end
