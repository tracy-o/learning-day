defmodule Mix.TaskAssets.RouteSpecTemplates do
  defmacro __using__(_) do
    quote do
      @route_spec_template """
      defmodule Routes.Specs.{{ route_spec.name }} do
        def specification do
          %{
            specs: [
              {{ route_spec.specs }}
            ]
          }
        end
      end
      """
      @personalised_route_spec_template """
      defmodule Routes.Specs.{{ route_spec.name }} do
        def specification do
          %{
            preflight_pipeline: [],
            specs: [
              {{ route_spec.specs }}
            ]
          }
        end
      end
      """
      @platform_template """
      %{
        email: "Please type your team's EMAIL here",
        slack_channel: "Please type your team's SLACK CHANNEL here",
        runbook: "Please link the relevant RUNBOOK here",
        platform: "{{ platform.name }}",
        examples: []
      }
      """
    end
  end
end
