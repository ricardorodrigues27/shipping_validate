defmodule ShippingValidate.Validates.ValidateCepTest do
  use ExUnit.Case
  doctest ShippingValidate.Validates.ValidateCep
  alias ShippingValidate.Validates.ValidateCep

  describe "call/1" do
    test "return cep if is valid size and format" do
      assert {:ok, "15130000"} = ValidateCep.call("15130000")
    end

    test "return an error if cep size is invalid" do
      assert {:error, :invalid_cep_size} = ValidateCep.call("1234567")
    end

    test "return an error if cep format is invalid" do
      assert {:error, :invalid_cep_format} = ValidateCep.call("aa123456")
    end
  end
end
