defmodule Test.Support.Helper do
  def ingress_mox do
    quote do
      import Mox
      setup :verify_on_exit!
      setup :set_mox_global

      setup do
        Application.put_env(:ingress, :ingress, IngressMock)

        on_exit(fn ->
          Application.put_env(:ingress, :ingress, Ingress)
        end)
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
