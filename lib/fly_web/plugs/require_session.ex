defmodule FlyWeb.Plugs.RequireSession do
  alias FlyWeb.Router.Helpers, as: Routes

  def init(default_url), do: default_url

  def call(conn, _opts) do
    case Plug.Conn.get_session(conn, "auth_token") do
      token when is_binary(token) ->
        conn

      nil ->
        new_session_path = Routes.session_path(conn, :new)

        conn
        |> set_redirect_url(conn.request_path)
        |> Phoenix.Controller.redirect(to: new_session_path)
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
