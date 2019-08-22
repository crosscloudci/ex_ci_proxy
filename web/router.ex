defmodule ExCiProxy.Router do
  use ExCiProxy.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExCiProxy do
    pipe_through [:api]
    resources "/ciproxy/v1/ci_status_build/commit_ref", PageController, except: [:new, :edit]
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExCiProxy do
  #   pipe_through :api
  # end
end
