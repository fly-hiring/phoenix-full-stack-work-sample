defmodule Fly.Client.TemplateOptions do
  @moduledoc """
  Options for creating a new app from a template. Process fetched data from
  GraphQL API.
  """
  require Logger
  alias __MODULE__

  defstruct organizations: [],
            regions: [],
            request_region: nil,
            personal_org_id: nil,
            vm_sizes: []

  def transform(
        {:ok,
         %{
           "organizations" => %{"nodes" => orgs},
           "platform" => %{
             "regions" => regions,
             "vmSizes" => vm_sizes,
             "requestRegion" => request_region
           }
         }}
      ) do
    organizations =
      Enum.map(orgs, fn %{"id" => id, "name" => name} ->
        %{id: id, name: name}
      end)

    # Find the first "PERSONAL" org and return that ID
    personal_org_id =
      orgs
      |> Enum.find(fn
        %{"type" => "PERSONAL"} -> true
        _other -> false
      end)
      |> case do
        %{"id" => org_id} -> org_id
        nil -> nil
      end

    regions =
      Enum.reduce(regions, %{}, fn %{"code" => code, "name" => name}, acc ->
        Map.put(acc, code, name)
      end)

    {:ok,
     %TemplateOptions{
       organizations: organizations,
       regions: regions,
       personal_org_id: personal_org_id,
       request_region: request_region,
       vm_sizes: parse_vm_sizes(vm_sizes)
     }}
  end

  def transform({:ok, other}) do
    Logger.debug("Failed match on #{inspect(other)}")
    Logger.error("Failed to match in from_raw transformation")
    {:error, "Failed to parse TemplateOptions data"}
  end

  def transform({:error, _reason} = error), do: error

  @doc """
  Convert the VM options to options structured for UI selection.
  """
  def vm_options(%TemplateOptions{vm_sizes: vm_sizes} = _options) do
    # <option value="shared-cpu-1x@1024">shared-cpu-1x - 1 GB</option>
    Enum.flat_map(vm_sizes, fn %{name: name, memory: memory} ->
      Enum.map(memory, fn mem ->
        display = "#{name} - #{friendly_size(mem)}"
        value = "#{name}@#{mem}"
        # returns tuple format compatible with select inputs
        {display, value}
      end)
    end)
  end

  @doc """
  Convert the Regions map to options structured for UI selection.
  """
  def region_options(%TemplateOptions{regions: regions}) do
    # Sort the regions by the name. Putting them in a map makes the order based
    # on the key, which isn't guaranteed to match up alphabetically with the
    # name.

    Enum.map(regions, fn {code, name} ->
      {name, code}
    end)
    # Sort alphabetically by the display name
    |> Enum.sort_by(fn {name, _code} -> name end)
  end

  @doc """
  Convert the Organizations data to options structured for UI selection.
  """
  def organization_options(%TemplateOptions{organizations: organizations}) do
    Enum.map(organizations, fn %{id: id, name: name} ->
      {name, id}
    end)
  end

  @doc false
  def parse_vm_sizes(vm_sizes) do
    Enum.map(vm_sizes, fn %{"name" => name, "memoryIncrementsMb" => memory} ->
      %{name: name, memory: memory}
    end)
  end

  defp friendly_size(256), do: "256 MB"
  defp friendly_size(1024), do: "1 GB"
  defp friendly_size(2048), do: "2 GB"
  defp friendly_size(4096), do: "4 GB"
  defp friendly_size(8192), do: "8 GB"
  defp friendly_size(16384), do: "16 GB"
  defp friendly_size(32768), do: "32 GB"
  defp friendly_size(65536), do: "64 GB"
end
