defmodule Test.Support.Helper do
  def ingress_mox do
    quote do
      import Mox
      setup :verify_on_exit!
      setup :set_mox_global
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
