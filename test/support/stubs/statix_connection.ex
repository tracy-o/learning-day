defmodule Belfrage.StatixConnectionStub do
  @behaviour ExMetrics.Statsd.StatixConnection

  def init(), do: :ok
  def connected?(), do: true
  def decrement(_, _, _), do: :ok
  def gauge(_, _, _), do: :ok
  def histogram(_, _, _), do: :ok
  def increment(_, _, _), do: :ok
  def set(_, _, _), do: :ok
  def timing(_, _, _), do: :ok
end
