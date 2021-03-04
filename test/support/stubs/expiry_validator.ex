defmodule Belfrage.Authentication.Validator.ExpiryStub do
  alias Belfrage.Authentication.Validator.Expiry

  @behaviour Expiry

  defdelegate valid?(threshold, expiry), to: Expiry
end
