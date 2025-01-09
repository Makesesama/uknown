defmodule PokequizWeb.Router do
  use PokequizWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PokequizWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PokequizWeb do
    pipe_through :browser

    get "/", PageController, :home
    live "/quiz", QuizLive.Show
    
    live "/whois", WhoisLive.Show

    live "/weight_comparison", WeightComparisonLive.Show

    live "/quiz_sessions", SessionsLive.Index, :index
    live "/quiz_sessions/new", SessionsLive.Index, :new
    live "/quiz_sessions/:id/edit", SessionsLive.Index, :edit

    live "/quiz_sessions/:id", SessionsLive.Show, :show
    live "/quiz_sessions/:id/show/edit", SessionsLive.Show, :edit
    
  end

  # Other scopes may use custom stacks.
  # scope "/api", PokequizWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
    if Application.compile_env(:pokequiz, :dev_routes) do
      # If you want to use the LiveDashboard in production, you should put
      # it behind authentication and allow only admins to access it.
      # If your application does not have an admins-only section yet,
      # you can use Plug.BasicAuth to set up some basic authentication
      # as long as you are also using SSL (which you should anyway).
      import Phoenix.LiveDashboard.Router

      scope "/dev" do
        pipe_through :browser

        live_dashboard "/dashboard", metrics: PokequizWeb.Telemetry
        forward "/mailbox", Plug.Swoosh.MailboxPreview
      end
    end
end
