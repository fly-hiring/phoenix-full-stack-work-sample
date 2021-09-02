defmodule FlyWeb.SessionController do
  use FlyWeb, :controller
  require Logger

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    token = get_session(conn, "auth_token")
    render(conn, "new.html", auth_token: token, error_message: nil)
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"session" => %{"auth_token" => auth_token}}) do
    config = Fly.Client.config(access_token: auth_token)

    case Fly.Client.fetch_current_user(config) do
      {:ok, user} ->
        Logger.debug("Authenticated as #{inspect(user)}")
        redirect_to = FlyWeb.Plugs.RequireSession.get_redirect_url(conn, "/")

        conn
        |> delete_session("auth_token")
        |> put_session("auth_token", auth_token)
        |> FlyWeb.Plugs.RequireSession.clear_redirect_url()
        |> redirect(to: redirect_to)

      {:error, :unauthorized} ->
        render(conn, "new.html", error_message: "Invalid token")

      {:error, reason} ->
        render(conn, "new.html", error_message: reason)
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session("auth_token")
    |> configure_session(renew: true)
    |> clear_session()
    |> redirect(to: Routes.session_path(conn, :new))
  end
end
