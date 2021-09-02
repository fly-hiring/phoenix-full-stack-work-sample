defmodule Fly.Utils do
  @moduledoc false

  @doc """
  Generates a random binary value.
  """
  @spec random_value() :: binary()
  def random_value() do
    :crypto.strong_rand_bytes(20) |> Base.encode32(case: :lower)
  end

  @doc """
  Convert the data to camel case keys.
  """
  def to_camel(data) do
    # convert the keys in the args to be "camelCase" as expected by the server.
    data
    |> Recase.Enumerable.stringify_keys()
    |> Recase.Enumerable.convert_keys(&Recase.to_camel/1)
  end

  @doc """
  Stringify the keys in the data. Deeply converted.
  """
  def stringify(data) do
    Recase.Enumerable.stringify_keys(data)
  end
end
