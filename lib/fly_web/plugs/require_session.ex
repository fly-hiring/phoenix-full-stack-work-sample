defmodule FlyWeb.Plugs.RequireSession do
  import Phoenix.LiveView
  alias FlyWeb.Router.Helpers, as: Routes

  ## LiveView Callbacks

  def mount(_params, session, socket) do
    case session do
      %{"auth_token" => user_id} ->
        {:cont, assign_new(socket, :user_id, fn -> user_id end)}

      %{} ->
        {:halt, Phoenix.LiveView.redirect(socket, to: Routes.session_path(socket, :new))}
    end
  end

  ## Plug Callbacks

  def init(default_url), do: default_url

  def call(conn, _opts) do
    case Plug.Conn.get_session(conn, "auth_token") do
      token when is_binary(token) ->
        conn

      nil ->
        conn
        |> set_redirect_url(conn.request_path)
        |> Phoenix.Controller.redirect(to: Routes.session_path(conn, :new))
        |> Plug.Conn.halt()
    end
  end

  def get_redirect_url(conn, default_url) do
    case Plug.Conn.get_session(conn, "redirect_url") do
      nil -> default_url
      url -> url
    end
  end

  def clear_redirect_url(conn) do
    Plug.Conn.delete_session(conn, "redirect_url")
  end

  def set_redirect_url(conn, url) do
    Plug.Conn.put_session(conn, "redirect_url", url)
  end
end
