defmodule Belfrage.Dials.CcpEnabled do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("true"), do: true

  @impl Belfrage.Dial
  def transform("false"), do: false
end