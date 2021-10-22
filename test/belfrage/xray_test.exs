defmodule Belfrage.XrayTest do
  use ExUnit.Case

  alias Belfrage.Xray
  import ExUnit.CaptureLog

  describe "start_tracing/2" do
    test "when called once, returns {:ok, trace}" do
      assert {:ok, _trace} = Xray.start_tracing("Belfrage")
    end

    test "when called twice, returns {:error, reason}" do
      Xray.start_tracing("Belfrage")

      assert {:error, %RuntimeError{message: _reason}} = Xray.start_tracing("Belfrage")
    end

    test "when called twice, logs an error" do
      assert capture_log(fn ->
               Xray.start_tracing("Belfrage")
               Xray.start_tracing("Belfrage")
             end) =~ "<AwsExRay> Tracing Context already exists on this process."
    end
  end
end
