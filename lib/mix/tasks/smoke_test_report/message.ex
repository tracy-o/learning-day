defmodule Mix.Tasks.ReportSmokeTestResults.Message do
  @type context :: any()
  @type ex_unit_error :: {:error, %ExUnit.AssertionError{} | %MachineGun.Error{} | any(), context}

  @spec format(ExUnit.Test.t(), ex_unit_error) :: String.t()
  def format(failure, {:error, assertion_error = %ExUnit.AssertionError{}, _context}) do
    "#{failure.name}\n\n" <> "```#{ExUnit.Formatter.format_assertion_error(assertion_error)}```"
  end

  @spec format(ExUnit.Test.t(), ex_unit_error) :: String.t()
  def format(_failure, {:error, %MachineGun.Error{}, _trace}) do
    "Failed to send smoke test request. Contact us in #help-belfrage slack channel."
  end

  @spec format(ExUnit.Test.t(), ex_unit_error) :: String.t()
  def format(_failure, _error), do: "Unexpected error occured. Contact us in #help-belfrage slack channel."
end
