defmodule Belfrage.Nodes do
  @doc ~S"""
  Selects nodes by name.

  ## Examples

      iex> filter_by_node_name([:"a_name@127.0.0.1", :"other_name@127.0.0.1"], "a_name")
      [:"a_name@127.0.0.1"]


      iex> filter_by_node_name([:"a_name@127.0.0.1", :"other_name@127.0.0.1"], "non_existant")
      []
  """
  def filter_by_node_name(node_list, node_name) do
    node_list
    |> Enum.filter(fn node ->
      node
      |> Atom.to_string()
      |> String.starts_with?(node_name)
    end)
  end
end
