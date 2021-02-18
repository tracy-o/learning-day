defmodule Belfrage.Application do
  @moduledoc false

  use Application

  @routefile_location Application.get_env(:belfrage, :routefile_location)

  def start(_type, args) do
    Code.compile_file(@routefile_location)
    Belfrage.Supervisor.start_link(args)
  end
end
