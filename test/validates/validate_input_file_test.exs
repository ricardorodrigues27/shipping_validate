defmodule ShippingValidate.Validates.ValidateInputFileTest do
  use ExUnit.Case
  doctest ShippingValidate.Validates.ValidateInputFile
  alias ShippingValidate.Validates.ValidateInputFile

  describe "call/1" do
    test "return the input data content from json file if is valid" do
      assert {:ok, input_data} = ValidateInputFile.call(input_file: "./test/input_valid.json")

      assert input_data == [
               %{
                 "name" => "Entrega normal SP",
                 "active" => true,
                 "min_price_in_cents" => 1,
                 "range_postcode_valid" => ["01000000", "19999999"]
               }
             ]
    end

    test "return an error if file could not be found" do
      assert {:error, :unabled_to_open_input_file} =
               ValidateInputFile.call(input_file: "./test/missing_file.json")
    end

    test "return an error if file not have a json content" do
      assert {:error, :invalid_json_file} =
               ValidateInputFile.call(input_file: "./test/wrong_json_file.txt")
    end

    test "return an error if json file have a wrong data" do
      assert {:error, :wrong_data} = ValidateInputFile.call(input_file: "./test/wrong_data.json")
    end
  end
end
