defmodule ShippingValidate.Core.HandleInputData do
  @moduledoc """
  Module responsible to handle input data with given cep and price
  """

  alias ShippingValidate.Core.OutputShippingItem

  @incompatibility_active "Disabled shipping"
  @incompatibility_cep_range "Zip code outside the delivery area for this method"
  @incompatibility_min_price "Minimum price not reached for this method"

  @doc """
    Handler input data with validations based on cep and price and returning output data with incompatibilities

  ## Examples

      iex> HandleInputData.call(
        [%{"name": "Entrega normal SP", "active": true, "min_price_in_cents": 1, "range_postcode_valid": ["01000000", "19999999"]}],
        "01234567", 2000)
      [%OutputShippingItem{method: "Entrega normal SP", valid: true, incompatibilities: []}]

      iex> HandleInputData.call(
        [%{"name": "Entrega normal SP", "active": false, "min_price_in_cents": 1, "range_postcode_valid": ["01000000", "19999999"]}],
        "01234567", 2000)
      [%OutputShippingItem{method: "Entrega normal SP", valid: false, incompatibilities: ["Disabled shipping"]}]
  """
  @spec call(input_data :: List.t(), cep :: String.t(), price :: Integer.t()) :: [
          OutputShippingItem.t()
        ]
  def call(input_data, cep, price) do
    Enum.map(input_data, fn shipping_item ->
      incompatibilities = calculate_incompatibilities(shipping_item, cep, price)

      OutputShippingItem.build(shipping_item["name"], incompatibilities)
    end)
  end

  @spec calculate_incompatibilities(
          shipping_item :: Map.t(),
          cep :: String.t(),
          price :: Integer.t()
        ) :: [String.t()]
  defp calculate_incompatibilities(shipping_item, cep, price) do
    incompatibilities =
      []
      |> check_is_active(shipping_item)
      |> check_cep_range(shipping_item, cep)
      |> check_price(shipping_item, price)

    incompatibilities
  end

  @spec check_is_active(incompatibilities :: [String.t()], shipping_item :: Map.t()) :: [
          String.t()
        ]
  defp check_is_active(incompatibilities, %{"active" => false}),
    do: [@incompatibility_active | incompatibilities]

  defp check_is_active(incompatibilities, _shipping_item), do: incompatibilities

  @spec check_cep_range(
          incompatibilities :: [String.t()],
          shipping_item :: Map.t(),
          cep :: String.t()
        ) :: [String.t()]
  defp check_cep_range(incompatibilities, %{"range_postcode_valid" => [min_cep, max_cep]}, cep)
       when cep < min_cep or cep > max_cep,
       do: [@incompatibility_cep_range | incompatibilities]

  defp check_cep_range(incompatibilities, _shipping_item, _cep), do: incompatibilities

  @spec check_price(
          incompatibilities :: [String.t()],
          shipping_item :: Map.t(),
          price :: Integer.t()
        ) :: [String.t()]
  defp check_price(incompatibilities, %{"min_price_in_cents" => min_price}, price)
       when price < min_price,
       do: [@incompatibility_min_price | incompatibilities]

  defp check_price(incompatibilities, _shipping_item, _price), do: incompatibilities
end
