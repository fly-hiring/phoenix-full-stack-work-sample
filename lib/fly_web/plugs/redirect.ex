defmodule FlyWeb.Plugs.Redirect do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> Phoenix.Controller.redirect(opts)
    |> halt()
  end
end
