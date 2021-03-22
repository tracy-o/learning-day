defmodule Belfrage.Authentication.Validator.Expiry do
  @callback valid?(non_neg_integer(), non_neg_integer()) :: boolean()

  def valid?(_threshold, expiry) when is_nil(expiry), do: false

  def valid?(threshold, expiry) when is_nil(threshold) do
    expired?(expiry, now_time())
  end

  def valid?(threshold, expiry) do
    expired?(expiry, now_time() + threshold)
  end

  defp expired?(expiry, now_time) do
    expiry > now_time
  end

  defp now_time() do
    System.os_time(:second)
  end
end
