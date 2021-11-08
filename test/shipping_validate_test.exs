defmodule ShippingValidateTest do
  use ExUnit.Case
  alias ShippingValidate.Core.OutputShippingItem

  describe "run_validate/1" do
    test "validate cep and price with input file and return output data" do
      assert {:ok, response} =
               ShippingValidate.run_validate(
                 input_file: "./test/input_valid.json",
                 cep: "01234567",
                 price: 2000
               )

      assert response == [
               %OutputShippingItem{
                 method: "Entrega normal SP",
                 valid: true,
                 incompatibilities: []
               }
             ]
    end
  end
end
