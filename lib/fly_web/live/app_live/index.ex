defmodule FlyWeb.AppLive.Index do
  use FlyWeb, :live_view

  require Logger

  alias Fly.Client
  alias FlyWeb.Components.HeaderBreadcrumbs

  @impl true
  def mount(_params, session, socket) do
    socket =
      assign(socket,
        config: client_config(session),
        state: :loading,
        apps: [],
        authenticated: true
      )

    # Only make the API call if the websocket is setup. Not on initial render.
    if connected?(socket) do
      {:ok, fetch_apps(socket)}
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

  def status_bg_color(app) do
    case app["status"] do
      "running" -> "bg-green-100"
      "dead" -> "bg-red-100"
      _ -> "bg-yellow-100"
    end
  end

  def status_text_color(app) do
    case app["status"] do
      "running" -> "text-green-800"
      "dead" -> "text-red-800"
      _ -> "text-yellow-800"
    end
  end
end
