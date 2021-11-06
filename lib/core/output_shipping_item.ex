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

      iex> OutputShippingItem.build("example method", [])
      %OutputShippingItem{method: "example method", valid: true, incompatibilities: []}

      iex> OutputShippingItem.build("example method", ["example incompatibility"])
      %OutputShippingItem{method: "example method", valid: false, incompatibilities: ["example incompatibility"]}
  """
  @spec build(name :: String.t(), incompatibilities :: [String.t()]) :: t()
  def build(name, incompatibilities) when length(incompatibilities) > 0,
    do: %__MODULE__{method: name, valid: false, incompatibilities: incompatibilities}

  def build(name, incompatibilities),
    do: %__MODULE__{method: name, valid: true, incompatibilities: incompatibilities}
end
