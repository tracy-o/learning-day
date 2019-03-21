defmodule IngressWeb do
  # Namespace for anything web related.

  def business_adapter do
    quote do
      def ingress do
        Application.get_env(:ingress, :ingress)
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
