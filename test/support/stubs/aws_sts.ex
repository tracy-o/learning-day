defmodule Belfrage.AWS.STSStub do
  @behaviour Belfrage.AWS.STS

  @doc """
  Build a real STS assume role ExAws operation
  """
  def assume_role(role_arn, role_name) do
    ExAws.STS.assume_role(role_arn, role_name)
  end
end
