defmodule Routes.Specs.NoEtagSupport do
  def specification do
    %{
      specs: %{
        email: "some@email.com",
        runbook: "Some runbook",
        platform: "MozartNews",
        etag: false
      }
    }
  end
end
