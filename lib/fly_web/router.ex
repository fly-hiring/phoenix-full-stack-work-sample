defmodule FlyWeb.Router do
  use FlyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FlyWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug FlyWeb.Plugs.RequireSession, "/"
  end

  scope "/", FlyWeb do
    pipe_through [:browser, :authenticated]

    get "/", Plugs.Redirect, to: "/apps"

    live_session :authenticated, on_mount: FlyWeb.Plugs.RequireSession do
      live "/apps", AppLive.Index, :index
      live "/apps/:name", AppLive.Show, :show
    end
  end

  scope "/", FlyWeb do
    pipe_through :browser

    delete "/session/destroy", SessionController, :delete, as: "delete_session"
    resources "/session", SessionController, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", FlyWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: FlyWeb.Telemetry
    end
  end
end
