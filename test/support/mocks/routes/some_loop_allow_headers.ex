defmodule Routes.Specs.SomeLoopAllowHeaders do
  def specs do
    %{
      owner: "Some person",
      runbook: "Some runbook",
      platform: Webcore,
      headers_allowlist: ["one_header", "cookie", "another_header"]
    }
  end
end
