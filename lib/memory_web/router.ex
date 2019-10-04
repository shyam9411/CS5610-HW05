defmodule MemoryWeb.Router do
  use MemoryWeb, :router

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

  scope "/", MemoryWeb do
    pipe_through :browser

    get "/", PageController, :index
    post "/games/", PageController, :game
  end

  # Other scopes may use custom stacks.
  # scope "/api", Memory do
  #   pipe_through :api
  # end
end
