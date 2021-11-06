defmodule ShippingValidate.CLI do
  @moduledoc """
  synopsis:
    Validate cep and price based on shipping input file
  usage:
    $ shipping_validate {options} cep price ...
  options:
    (optional) --input-file="./default.json" Input file path.
  """

  def main([]), do: IO.puts(@moduledoc)
  def main([help_opt]) when help_opt == "-h" or help_opt == "--help", do: IO.puts(@moduledoc)

  def main(args) do
    case parse_args(args) do
      {:ok, result} -> response(result)
      {:error, _error} -> IO.puts(@moduledoc)
    end
  end

  defp parse_args(args) do
    {opts, args, _errors} = OptionParser.parse(args, strict: [input_file: :string])

    case process_args(opts, args) do
      {:ok, result} -> {:ok, result}
      {:error, error} -> {:error, error}
    end
  end

  defp process_args(opts, [cep, price] = args) when length(args) == 2 do
    price = String.to_integer(price)
    {:ok, Keyword.merge(opts, cep: cep, price: price)}
  end

  defp process_args(_opts, args) do
    IO.puts("Wrong arguments: ")
    IO.inspect(args)
    {:error, :unabled_to_process_args}
  end

  defp response(opts) do
    opts
    |> ShippingValidate.run_validate()
    |> case do
      {:ok, result} ->
        result
        |> Jason.encode!(pretty: true)
        |> IO.puts()

      {:error, error} ->
        IO.puts("Something goes wrong:")
        IO.inspect(error)
        IO.puts(@moduledoc)
    end
  end
end
