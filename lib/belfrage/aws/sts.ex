defmodule Belfrage.AWS.STS do
  defdelegate assume_role(role_arn, role_name), to: ExAws.STS
end
