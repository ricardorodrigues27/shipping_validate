defmodule ShippingValidate.Core.OutputShippingItem do
  @moduledoc """
  Module responsible to build output shipping item struct
  """

  @derive Jason.Encoder
  defstruct method: "", valid: true, incompatibilities: []
  @type t :: %__MODULE__{method: String.t(), valid: boolean(), incompatibilities: [String.t()]}

  @doc """
    Calculate valid info based on incompatiblities and return output shipping item struct

  ## Examples

      iex> ShippingValidate.Core.OutputShippingItem.build("example method", [])
      %ShippingValidate.Core.OutputShippingItem{method: "example method", valid: true, incompatibilities: []}

      iex> ShippingValidate.Core.OutputShippingItem.build("example method", ["example incompatibility"])
      %ShippingValidate.Core.OutputShippingItem{method: "example method", valid: false, incompatibilities: ["example incompatibility"]}
  """
  @spec build(method :: String.t(), incompatibilities :: [String.t()]) :: t()
  def build(method, incompatibilities) when length(incompatibilities) > 0,
    do: %__MODULE__{method: method, valid: false, incompatibilities: incompatibilities}

  def build(method, incompatibilities),
    do: %__MODULE__{method: method, valid: true, incompatibilities: incompatibilities}
end
