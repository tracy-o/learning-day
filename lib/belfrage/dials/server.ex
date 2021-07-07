defmodule Belfrage.Dials.Server do
  @type dial :: atom()
  @callback state(dial) :: any()
end
