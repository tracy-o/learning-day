defmodule Ingress.Application do
  @moduledoc false

  use Application

  def start(_type, [env: :prod] = args) do
    Application.put_env(:ingress, :instance_role_name, System.get_env("INSTANCE_ROLE_NAME"))

    Ingress.Supervisor.start_link(args)
  end

  def start(_type, args) do
    Ingress.Supervisor.start_link(args)
  end
end
