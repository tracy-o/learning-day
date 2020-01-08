defmodule Belfrage.AWS.STS do
  @type role_arn :: String.t()
  @type role_name :: String.t()

  @callback assume_role(role_arn, role_name) :: :assume_role_successfully | :fail_to_assume

  defdelegate assume_role(role_arn, role_name), to: ExAws.STS
end
