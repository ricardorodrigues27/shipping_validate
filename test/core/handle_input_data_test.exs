defmodule ShippingValidate.Core.HandleInputDataTest do
  use ExUnit.Case
  doctest ShippingValidate.Core.HandleInputData
  alias ShippingValidate.Core.HandleInputData
  alias ShippingValidate.Core.OutputShippingItem

  describe "call/3" do
    test "handle input data with cep and price and return output data" do
      response =
        HandleInputData.call(
          [
            %{
              "name" => "Entrega normal SP",
              "active" => true,
              "min_price_in_cents" => 1,
              "range_postcode_valid" => ["01000000", "19999999"]
            }
          ],
          "01234567",
          2000
        )

      assert response == [
               %OutputShippingItem{
                 method: "Entrega normal SP",
                 valid: true,
                 incompatibilities: []
               }
             ]
    end

    test "handle input data with incompatibilities and return output data" do
      response =
        HandleInputData.call(
          [
            %{
              "name" => "Shipping disabled",
              "active" => false,
              "min_price_in_cents" => 1,
              "range_postcode_valid" => ["01000000", "19999999"]
            },
            %{
              "name" => "Shipping with cep outside the range",
              "active" => true,
              "min_price_in_cents" => 1,
              "range_postcode_valid" => ["00100000", "01000000"]
            },
            %{
              "name" => "Shipping high price",
              "active" => true,
              "min_price_in_cents" => 2500,
              "range_postcode_valid" => ["01000000", "19999999"]
            },
            %{
              "name" => "Shipping with all incompatibilities",
              "active" => false,
              "min_price_in_cents" => 2500,
              "range_postcode_valid" => ["00100000", "01000000"]
            }
          ],
          "01234567",
          2000
        )

      assert response == [
               %OutputShippingItem{
                 method: "Shipping disabled",
                 valid: false,
                 incompatibilities: ["Disabled shipping"]
               },
               %OutputShippingItem{
                 method: "Shipping with cep outside the range",
                 valid: false,
                 incompatibilities: ["Zip code outside the delivery area for this method"]
               },
               %OutputShippingItem{
                 method: "Shipping high price",
                 valid: false,
                 incompatibilities: ["Minimum price not reached for this method"]
               },
               %OutputShippingItem{
                 method: "Shipping with all incompatibilities",
                 valid: false,
                 incompatibilities: [
                   "Minimum price not reached for this method",
                   "Zip code outside the delivery area for this method",
                   "Disabled shipping"
                 ]
               }
             ]
    end
  end
end
