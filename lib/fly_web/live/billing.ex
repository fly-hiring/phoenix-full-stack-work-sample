defmodule FlyWeb.AppLive.Billing do
  use FlyWeb, :live_view
  alias Phoenix.LiveView.Socket
  require Logger

  alias Fly.Client

  @impl true
  def mount(_params, session, socket) do
    socket =
      assign(socket,
        config: client_config(session),
        state: :loading,
      )

    # Only make the API call if the websocket is setup. Not on initial render.
    if connected?(socket) do
      {:ok, socket}
    else
      {:ok, socket}
    end
  end

  defp client_config(session) do
    Fly.Client.config(access_token: session["auth_token"] || System.get_env("FLYIO_ACCESS_TOKEN"))
  end
end
