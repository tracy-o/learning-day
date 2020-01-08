defmodule Belfrage.AWS.STSStub do
  @behaviour Belfrage.AWS.STS

  def assume_role(_role_arn, _role_name) do
    :ok
  end
end
