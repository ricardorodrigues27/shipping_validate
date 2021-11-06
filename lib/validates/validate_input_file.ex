defmodule ShippingValidate.Validates.ValidateInputFile do
  @moduledoc """
  Module responsible to extract and validate input file for shipping info
  """

  @default_input_file "./default.json"

  @doc """
    Validate input file and extract data with given path.
    If options not have a path will get the default input file

  ## Examples

      iex> ValidateInputFile.call(input_file: "./example.json")
      {:ok, [
        %{"name": "Entrega normal SP", "active": true, "min_price_in_cents": 1, "range_postcode_valid": ["01000000", "19999999"]}
      ]}

      iex> ValidateInputFile.call(input_file: "./file_doesnt_exists.json")
      {:error, :enoent}

      iex> ValidateInputFile.call(input_file: "./invalid_data.json")
      {:error, :wrong_data}
  """
  @spec call(opts :: Keyword.t()) :: {:ok, List.t()} | {:error, atom()}
  def call(opts \\ []) do
    input_file =
      Keyword.get(opts, :input_file, @default_input_file)
      |> Path.expand()

    with {:ok, binary} <- File.read(input_file),
         {:ok, input_data} <- Jason.decode(binary),
         {:ok, input_data} <- validate_input_data(input_data) do
      {:ok, input_data}
    else
      error -> handle_error(error)
    end
  end

  @spec validate_input_data(input_data :: any()) :: {:ok, List.t()} | {:error, atom()}
  defp validate_input_data(input_data) when is_list(input_data) and length(input_data) > 0 do
    Enum.all?(input_data, fn
      %{"name" => _, "active" => _, "min_price_in_cents" => _, "range_postcode_valid" => _} ->
        true

      _ ->
        false
    end)
    |> case do
      true -> {:ok, input_data}
      false -> {:error, :wrong_data}
    end
  end

  defp validate_input_data(_), do: {:error, :wrong_data}

  @spec handle_error({:error, any()}) :: {:error, atom()}
  defp handle_error({:error, error}) when error in [:enoent, :eaccess, :eisdir, :enotdir, :enomem], do: {:error, :unabled_to_open_input_file}
  defp handle_error({:error, %Jason.DecodeError{}}), do: {:error, :invalid_json_file}
  defp handle_error(error), do: error
end
