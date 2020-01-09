defmodule Belfrage.AWS.STS do
  @type role_arn :: String.t()
  @type role_name :: String.t()

  @callback assume_role(role_arn, role_name) :: ExAws.Operation.Query.t()

  defdelegate assume_role(role_arn, role_name), to: ExAws.STS
end
