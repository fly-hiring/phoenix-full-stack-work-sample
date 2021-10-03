defmodule FlyWeb.AppLive.Index do
  use FlyWeb, :live_view
  alias Phoenix.LiveView.Socket
  alias FlyWeb.Endpoint
  alias FlyWeb.Monitor
  require Logger
  @apps_monitor_topic "apps_monitor"

  alias Fly.Client
  alias FlyWeb.Components.{HeaderBreadcrumbs, AppList, TabSelector, VolumeList, SideApp}

  @impl true
  def mount(_params, session, socket) do
    socket =
      assign(socket,
        config: client_config(session),
        state: :loading,
        apps: [],
        authenticated: true,
        selectedTab: "apps",
        selectedApp: nil,
      )

    # Only make the API call if the websocket is setup. Not on initial render.
    if connected?(socket) do
      # Subscribe to the VM usage monitor simulation
      Endpoint.subscribe(@apps_monitor_topic)
      socket = fetch_apps(socket)
      # Start the simulation for the machine usage
      Monitor.start(socket.assigns.apps)
      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  defp client_config(session) do
    Fly.Client.config(access_token: session["auth_token"] || System.get_env("FLYIO_ACCESS_TOKEN"))
  end

  defp fetch_apps(socket) do
    case Client.fetch_apps(socket.assigns.config) do
      {:ok, apps} ->
        assign(socket, :apps, apps)

      {:error, :unauthorized} ->
        put_flash(socket, :error, "Not authenticated")

      {:error, reason} ->
        Logger.error("Failed to load apps. Reason: #{inspect(reason)}")

        put_flash(socket, :error, reason)
    end
  end
  @impl true
  def handle_event("select-tab", %{"tab" => tab}, %Socket{} = socket) do
    {:noreply, socket |> assign(:selectedTab, tab)}
  end
  @impl true
  def handle_event("select-app", %{"app_id" => appId}, %Socket{assigns: %{apps: apps}} = socket) do
    appData = apps |> Enum.find(fn app -> app["id"] == appId end)
    {:noreply, socket |> assign(:selectedApp, appData)}
  end
  def handle_event("close-app", _, %Socket{} = socket) do
    {:noreply, socket |> assign(:selectedApp, nil)}
  end
  @impl true
  def handle_info(%{event: "new_monitoring", payload: data}, socket) do
    #send_update(
    #  SurveyResultsLive,
    #  id: socket.assigns.survey_results_component_id)
    socket = socket |> assign(:apps, data)
    {:noreply, socket}
  end
end
