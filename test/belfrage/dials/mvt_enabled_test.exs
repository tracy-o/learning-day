defmodule Belfrage.Dials.MvtEnabledTest do
    use ExUnit.Case, async: true
    alias Belfrage.Dials.MvtEnabled
  
    test "transform/1 converts string representation of 'true' to boolean" do
      assert MvtEnabled.transform("true") == true
    end
  
    test "transform/1 converts string representation of 'false' to boolean" do
      assert MvtEnabled.transform("false") == false
    end
  end
  