defmodule Demo.PlayerController do
  use Demo.Web, :controller

  plug :scrub_params, "player" when action in [:create]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"player" => player_params}) do
    player = Map.get(player_params, "name", "Anonymous")

    conn
    |> Demo.Auth.login(player)
    |> redirect(to: game_path(conn, :new))
  end

  def delete(conn, _params) do
    conn
    |> Demo.Auth.logout()
    |> redirect(to: player_path(conn, :new))
  end
end
