defmodule Belfrage.Dials.ElectionBannerNiStory do
    @behaviour Belfrage.Dial
  
    @impl Belfrage.Dial
    def transform("on"), do: "on"
  
    @impl Belfrage.Dial
    def transform("off"), do: "off"
  end
  