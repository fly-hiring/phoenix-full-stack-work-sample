defmodule Fly.ClientLive do
  @moduledoc """
  Perform the live GraphQL query
  """
  require Logger

  @behaviour Fly.ClientBehaviour

  @doc """
  Perform the query against a real GraphQL server
  """
  @impl true
  def perform_query(query_string, args, config, fun_name) do
    Logger.info("Live request for #{inspect(fun_name)}")
    Neuron.query(query_string, args, config)
  end

  @impl true
  def perform_http_get(url, _opts) do
    HTTPoison.get(url)
  end
end
