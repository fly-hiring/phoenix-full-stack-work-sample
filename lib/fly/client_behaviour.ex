defmodule Fly.ClientBehaviour do
  @moduledoc """
  Define the behaviour that the Client interface uses. Keeps live and test API in sync.
  """

  @type query_string :: String.t()
  @type args :: map()
  @type fun_name :: atom()

  @callback perform_query(query_string, args, config :: keyword(), fun_name) :: {:ok, map()} | {:error, String.t()}

  @callback perform_http_get(url :: String.t(), opts :: keyword()) ::
              {:ok, HTTPoison.Response.t() | HTTPoison.AsyncResponse.t()}
              | {:error, HTTPoison.Error.t()}
end
