defmodule TestappWeb.Router do
  use TestappWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", TestappWeb do
    pipe_through :api
    post "/post_json", VisitController, :post_urls
    get "/visited_domains", VisitController, :visited_domains
  end
end
