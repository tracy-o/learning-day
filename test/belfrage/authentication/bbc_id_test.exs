defmodule Belfrage.Authentication.BBCIDTest do
  use ExUnit.Case, async: true

  alias Belfrage.Authentication.BBCID

  test "Set default opts on startup" do
    pid = start_supervised!({BBCID, name: :bbc_id_test})

    assert BBCID.available?(pid)

    assert BBCID.get_opts(pid) == %{
             id_availability: true,
             foryou_flagpole: false,
             foryou_access_chance: 0,
             foryou_allowlist: []
           }
  end

  test "Update default opts if options keyword list is provided on statrup" do
    pid = start_supervised!({BBCID, name: :bbc_id_test, available: false})

    refute BBCID.available?(pid)

    assert BBCID.get_opts(pid) == %{
             id_availability: false,
             foryou_flagpole: false,
             foryou_access_chance: 0,
             foryou_allowlist: []
           }
  end

  test "Set and get options" do
    pid = start_supervised!({BBCID, name: :bbc_id_test})

    opts = %{
      id_availability: false,
      foryou_flagpole: true,
      foryou_access_chance: 1,
      foryou_allowlist: ["some-id"]
    }

    BBCID.set_opts(pid, opts)

    refute BBCID.available?(pid)
    assert BBCID.get_opts(pid) == opts
  end
end
