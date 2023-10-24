defmodule Routes.Specs.CBBCLegacy do
  @moduledoc """
  This RouteSpec is temporary.
  It exists to allow CBBC migration from the "Childrens Responsive"
  platform to WebCore.
  Once migration is complete this plaform can be removed.
  """

  def specification do
    %{
      specs: %{
        email: "childrensfutureweb@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/CE/CBBC+Responsive+Runbook",
        platform: "ChildrensResponsive",
        examples: []
      }
    }
  end
end
