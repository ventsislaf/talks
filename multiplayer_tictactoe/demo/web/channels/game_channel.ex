defmodule Demo.GameChannel do
  use Phoenix.Channel

  def join("game:" <> name, _params, socket) do
    game = TicTacToe.GameSupervisor.game_process(name)
    case TicTacToe.Game.join(game, socket.assigns.player) do
      {:ok, symbol, game_state} ->
        send self(), {:after_join, game_state}
        socket =
          socket
          |> assign(:game, name)
          |> assign(:symbol, symbol)
        {:ok, game_state, socket}
      :error ->
        {:error, %{reason: "full game"}}
    end
  end

  def handle_in("put", %{"index" => index}, socket) do
    game = TicTacToe.GameSupervisor.game_process(socket.assigns.game)
    case TicTacToe.Game.put(game, socket.assigns.symbol, String.to_integer(index)) do
      {:ok, game_state} ->
        broadcast! socket, "update_board", game_state
      {:draw, game_state} ->
        broadcast! socket, "finish_game", game_state
      {:winner, _symbol, game_state} ->
        broadcast! socket, "finish_game", game_state
      _ ->
        :ok
    end
    {:noreply, socket}
  end

  def handle_in("new_round", _params, socket) do
    game = TicTacToe.GameSupervisor.game_process(socket.assigns.game)
    game_state = TicTacToe.Game.new_round(game)
    broadcast! socket, "new_round", game_state
    {:noreply, socket}
  end

  def handle_info({:after_join, game_state}, socket) do
    broadcast! socket, "new_player", game_state
    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    game = TicTacToe.GameSupervisor.game_process(socket.assigns.game)
    TicTacToe.Game.leave(game, socket.assigns.symbol)
    broadcast! socket, "player_left", %{}
  end
end
