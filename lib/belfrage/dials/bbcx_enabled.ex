defmodule Belfrage.Dials.BBCXEnabled do
  @moduledoc """
  Allows disabling BBCX content by pointing to the original Origin.
  """

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform("true"), do: true

  @impl Belfrage.Dial
  def transform("false"), do: false
end
