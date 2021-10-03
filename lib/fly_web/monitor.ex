defmodule FlyWeb.Monitor do
  use GenServer
  alias FlyWeb.Endpoint
  @apps_monitor_topic "apps_monitor"
  def start(apps) do
    GenServer.start_link(__MODULE__,apps, [name: __MODULE__])
  end
  def init(apps) do
    run_monitor()
    {:ok, apps}
  end

  defp run_monitor() do
    Process.send_after(self(), :fetch_load, 3000)
  end

  def handle_info(:fetch_load, state) do
    new_state =
      state
      |> Enum.map(&Map.put(&1, "usage",%{ "cpu" => Enum.random(0..100), "ram" => Enum.random(0..100) }))
    Endpoint.broadcast(@apps_monitor_topic, "new_monitoring", new_state)
    run_monitor()
    {:noreply, new_state}
  end
end
