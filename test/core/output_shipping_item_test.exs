defmodule ShippingValidate.Core.OutputShippingItemTest do
  use ExUnit.Case
  doctest ShippingValidate.Core.OutputShippingItem
  alias ShippingValidate.Core.OutputShippingItem

  describe "build/2" do
    test "return the output struct passing method and incompatibilities" do
      assert %OutputShippingItem{method: "test method", valid: true, incompatibilities: []} =
               OutputShippingItem.build("test method", [])
    end

    test "return the value for 'valid' equal false when passing incompatibilities" do
      assert %OutputShippingItem{
               method: "test method",
               valid: false,
               incompatibilities: ["some incompatibiliy"]
             } = OutputShippingItem.build("test method", ["some incompatibiliy"])
    end
  end
end
