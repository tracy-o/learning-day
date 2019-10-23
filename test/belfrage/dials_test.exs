defmodule Belfrage.DialsTest do
  use ExUnit.Case

  alias Belfrage.Dials

  @dials_location Application.get_env(:belfrage, :dials_location)
  @json_codec Application.get_env(:belfrage, :json_codec)

  setup do
    Dials.refresh_now()
    original_dials = File.read!(@dials_location)

    on_exit(fn ->
      File.write!(@dials_location, original_dials)
      Dials.refresh_now()
    end)

    :ok
  end

  describe "&state/0" do
    test "state returns ttl_multiplier dial value" do
      assert Dials.state() == %{"ttl_multiplier" => "1"}
    end

    test "Changing the file and refreshing gives the new dials value" do
      File.write!(@dials_location, @json_codec.encode!(%{ttl_multiplier: "2"}))

      Dials.refresh_now()
      assert Dials.state() == %{"ttl_multiplier" => "2"}
    end

    test "Writing unparsable JSON to the file returns the initial dials values" do
      File.write!(@dials_location, "{}}}}\\inva\"id: \nJSON!!</what?>}")

      Dials.refresh_now()
      assert Dials.state() == %{"ttl_multiplier" => "1"}
    end

    test "A missing file returns the initial dials values" do
      File.rm(@dials_location)

      Dials.refresh_now()
      assert Dials.state() == %{"ttl_multiplier" => "1"}
    end

    test "A missing file at initialisation returns an empty hash" do
      Supervisor.which_children(Belfrage.Supervisor)
      |> List.keyfind(Belfrage.Dials, 0)
      |> elem(1)
      |> Process.exit(:testing)

      File.rm(@dials_location)

      Dials.init(nil)
      assert Dials.state() == %{}
    end

    test "Invalid JSON file at initialisation returns an empty hash" do
      Supervisor.which_children(Belfrage.Supervisor)
      |> List.keyfind(Belfrage.Dials, 0)
      |> elem(1)
      |> Process.exit(:testing)

      File.write!(@dials_location, "{}}}}\\inva\"id: \nJSON!!</what?>}")

      Dials.init(nil)
      assert Dials.state() == %{}
    end
  end

  describe "&ttl_multiplier/" do
    test "gets the ttl_multiplier from the dials as an integer" do
      assert Dials.ttl_multiplier() == 1
    end

    test "Changing the file and gives the new ttl multiplier value" do
      File.write!(@dials_location, @json_codec.encode!(%{ttl_multiplier: "2"}))

      Dials.refresh_now()
      assert Dials.ttl_multiplier() == 2
    end

    test "Dials file doesn't contain ttl_multiplier it returns the default ttl value of 1" do
      File.write!(@dials_location, @json_codec.encode!(%{something: "else"}))

      Dials.refresh_now()
      assert Dials.ttl_multiplier() == 1
    end

    test "Writing unparsable JSON to the file returns the initial ttl value" do
      File.write!(@dials_location, "{}}}}\\inva\"id: \nJSON!!</what?>}")

      Dials.refresh_now()
      assert Dials.ttl_multiplier() == 1
    end

    test "A missing file returns the initial dials values" do
      File.rm(@dials_location)

      Dials.refresh_now()
      assert Dials.ttl_multiplier() == 1
    end
  end
end
