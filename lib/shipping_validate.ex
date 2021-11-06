defmodule ShippingValidate do
  @moduledoc """
  Module responsible to keep the context and define your business logic.
  """

  alias ShippingValidate.Core.HandleInputData
  alias ShippingValidate.Core.OutputShippingItem
  alias ShippingValidate.Validates.ValidateCep
  alias ShippingValidate.Validates.ValidateInputFile

  @doc """
  Validate input_file, cep and price and return the output data

  ## Examples

      iex> ShippingValidate.run_validate([cep: "12345678", price: 3000])
      [%OutputShippingItem{}]

      iex> ShippingValidate.run_validate([input_file: "./other_file.json", cep: "12345678", price: 3000])
      [%OutputShippingItem{}]

  """
  @spec run_validate(opts :: Keyword.t()) :: {:ok, [OutputShippingItem.t()]} | {:error, any()}
  def run_validate(opts \\ []) do
    cep = Keyword.get(opts, :cep)
    price = Keyword.get(opts, :price)

    with {:ok, cep} <- ValidateCep.call(cep),
         {:ok, input_data} <- ValidateInputFile.call(opts),
         output_data <- HandleInputData.call(input_data, cep, price) do
      {:ok, output_data}
    else
      error -> error
    end
  end

  def test(to) do
    Keyword.get(to, :ok, "testando")
  end
end
