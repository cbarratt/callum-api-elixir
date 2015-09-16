defmodule Callumapi.Router do
  use Phoenix.Router

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

  scope "/api/v1", Callumapi do
    pipe_through :api

    resources "/weighins", WeightController
  end

  scope "/", Callumapi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
