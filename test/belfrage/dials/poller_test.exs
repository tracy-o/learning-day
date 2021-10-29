defmodule Belfrage.Dials.PollerTest do
  # Can't be async because it updates dials which is a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Dials.Poller
  alias Belfrage.Dials.LiveServer, as: DialsServer
  alias Belfrage.Helpers.FileIOMock

  test "polls and updates dials values" do
    # The test updates one of the dials called :logging_level
    assert DialsServer.state(:logging_level) == :error

    stub_dials_file(~s({"logging_level": "debug"}))
    start_supervised!({Poller, startup_polling_delay: 0, polling_interval: 0, name: :test_dials_poller})

    wait_for(fn -> DialsServer.state(:logging_level) == :debug end)

    stub_dials_file(~s({"logging_level": "error"}))
    wait_for(fn -> DialsServer.state(:logging_level) == :error end)
  end

  describe "read_dials/0" do
    test "returns the contents of the dials file" do
      file_path = Application.get_env(:belfrage, :dials_location)
      expect(FileIOMock, :read, fn ^file_path -> {:ok, ~s({"dial": "value"})} end)
      assert Poller.read_dials() == {:ok, %{"dial" => "value"}}
    end

    test "returns error if dials file doesn't exist" do
      stub(FileIOMock, :read, fn _file_path -> {:error, :enoent} end)
      assert Poller.read_dials() == {:error, :enoent}
    end

    test "returns error if dials file contains invalid JSON" do
      expect(FileIOMock, :read, fn _file_path -> {:ok, "not json"} end)
      assert {:error, _} = Poller.read_dials()
    end
  end

  defp stub_dials_file(contents) do
    stub(FileIOMock, :read, fn _dials_location -> {:ok, contents} end)
  end
end
