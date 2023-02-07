defmodule Belfrage.JSonCodedTests do
  use ExUnit.Case, async: true

  describe "Valid json object" do
    test "encode / decode of a list" do
      data = [1, 2, 3]

      assert {:ok, encoded_data} = Json.encode(data)
      assert {:ok, ^data} = Json.decode(encoded_data)
    end

    test "encode / decode of a map" do
      data = %{
        "name" => "Mr.Ettore^Berardi!",
        "surname" => "Did.I.Say-Mr.Ettore^Berardi?@bbc.co.uk"
      }

      assert {:ok, encoded_data} = Json.encode(data)
      assert {:ok, ^data} = Json.decode(encoded_data)
    end

    test "encode! / decode! of a list" do
      data = [1, 2, 3]

      assert data |> Json.encode!() |> Json.decode!() == data
    end

    test "encode! / decode! of a map" do
      data = %{
        "name" => "Mr.Ettore^Berardi!",
        "surname" => "Did.I.Say-Mr.Ettore^Berardi?@bbc.co.uk"
      }

      assert data |> Json.encode!() |> Json.decode!() == data

      data = %{
        name: "Mr.Ettore^Berardi!",
        surname: "#Did.I.Say-Mr.Ettore^Berardi?@bbc.co.uk#"
      }

      assert data |> Json.encode!() |> Json.decode!() == %{
               "name" => "Mr.Ettore^Berardi!",
               "surname" => "#Did.I.Say-Mr.Ettore^Berardi?@bbc.co.uk#"
             }
    end
  end

  describe "Invalid json object" do
    test "decoding error" do
      assert {:error, %ErlangError{}} = Json.decode("{\"name\": \"bruno}")
    end
  end
end
