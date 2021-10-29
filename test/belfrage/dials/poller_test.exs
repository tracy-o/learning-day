defmodule Belfrage.Dials.PollerTest do
  # Can't be async because it updates dials which is a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Dials.Poller
  alias Belfrage.Dials.LiveServer, as: DialsServer

  test "polls and updates dials values" do
    # The test updates one of the dials called :logging_level
    assert DialsServer.state(:logging_level) == :error

    overwrite_dials_config(~s({"logging_level": "debug"}))
    start_supervised!({Poller, startup_polling_delay: 0, polling_interval: 0, name: :test_dials_poller})

    wait_for(fn -> DialsServer.state(:logging_level) == :debug end)

    overwrite_dials_config(~s({"logging_level": "error"}))
    wait_for(fn -> DialsServer.state(:logging_level) == :error end)
  end

  describe "read_dials/0" do
    test "returns the contents of the dials file" do
      contents =
        get_dials_file_path()
        |> File.read!()
        |> Application.get_env(:belfrage, :json_codec).decode!()

      assert Poller.read_dials() == {:ok, contents}
    end

    test "returns error if dials file doesn't exist" do
      restore_dials_config_on_exit()
      set_dials_file_path("/some/non-existent/file")
      assert Poller.read_dials() == {:error, :enoent}
    end

    test "returns error if dials file contains invalid JSON" do
      overwrite_dials_config("not json")
      assert {:error, _} = Poller.read_dials()
    end
  end

  defp overwrite_dials_config(contents) do
    restore_dials_config_on_exit()
    new_file_path = System.tmp_dir!() |> Path.join("dials.json")
    File.write!(new_file_path, contents)
    set_dials_file_path(new_file_path)
  end

  defp restore_dials_config_on_exit() do
    original_file_path = get_dials_file_path()
    on_exit(fn -> set_dials_file_path(original_file_path) end)
  end

  defp get_dials_file_path() do
    Application.get_env(:belfrage, :dials_location)
  end

  defp set_dials_file_path(file_path) do
    Application.put_env(:belfrage, :dials_location, file_path)
  end
end
