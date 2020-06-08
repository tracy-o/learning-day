defmodule Belfrage.Smoke.Rules do
  alias Belfrage.RouteSpec
  alias Test.Support.Helper

  defmodule Checker do
    def redirects_to(resp, expected_location) do
      Helper.get_header(resp.headers, "location") =~ expected_location
    end

    def has_content_length_over(resp, expected_min_content_length) do
      not is_nil(resp.body) and String.length(resp.body) > expected_min_content_length
    end

    def has_status(resp, expected_status) do
      resp.status_code == expected_status
    end
  end

  def valid_response?(test_properties = %{using: loop_id, smoke_env: smoke_env, target: _target}, resp) do
    rules = smoke_rules_for(loop_id, smoke_env) |> add_defaults_if_required()

    Enum.any?(rules, fn
      {rule_matcher, check, assertion_value} ->
        case Kernel.match?(rule_matcher, test_properties) do
          true ->
            apply(Checker, check, [resp, assertion_value])

          false ->
            false
        end
    end)
  end

  defp smoke_rules_for(loop_id, smoke_env) do
    route_spec = Module.concat([Routes, Specs, loop_id])

    case do_collect_rules(route_spec, smoke_env) do
      [] -> do_collect_rules(Module.concat([Routes, Platforms, route_spec.specs()[:platform]]), smoke_env)
      rules -> rules
    end
  end

  defp do_collect_rules(module, smoke_env) do
    case Kernel.function_exported?(module, :smoke_rules, 1) do
      true -> module.smoke_rules(smoke_env)
      false -> []
    end
  end

  defp add_defaults_if_required([]) do
    [
      {%{}, :has_status, 200},
      {%{}, :has_content_length_over, 30}
    ]
  end

  defp add_defaults_if_required(rules), do: rules
end
