defmodule Belfrage.Transformers.ChameleonTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Belfrage.Test.StubHelper

  alias Belfrage.Transformers.Chameleon
  alias Belfrage.Struct

  describe "when the chameleon dial is on" do
    test "chameleon => 'on' mapping exists in struct.private.features" do
      stub_dial(:chameleon, "on")

      {:ok, struct} = Chameleon.call([], %Struct{})
      assert %{:chameleon => "on"} == struct.private.features
    end
  end

  describe "when the chameleon dial is off" do
    test "the features map doesn't contain a chameleon key or value" do
      stub_dial(:chameleon, "off")

      {:ok, struct} = Chameleon.call([], %Struct{})
      assert %{:chameleon => "off"} == struct.private.features
    end
  end
end
