defmodule RakiaWeb.Router do
  use RakiaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug RakiaWeb.Context
  end

  scope "/api" do
    pipe_through [:api, :graphql]

    forward "/", Absinthe.Plug, schema: RakiaWeb.Schema
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: RakiaWeb.Schema,
      # interface: :simple,
      context: %{pubsub: RakiaWeb.Endpoint}
  end
end
