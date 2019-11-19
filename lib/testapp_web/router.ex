defmodule TestappWeb.Router do
  use TestappWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TestappWeb do
    pipe_through :api
    post "/visited_links", VisitController, :visited_links
    get "/visited_domains", VisitController, :visited_domains
  end
end
