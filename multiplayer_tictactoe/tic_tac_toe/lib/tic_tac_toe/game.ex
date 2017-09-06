# lib/tic_tac_toe/game.ex

defmodule TicTacToe.Game do
  use GenServer

  @initial_score %{x: 0, ties: 0, o: 0}

  defstruct(
    board: %TicTacToe.Board{},
    x: nil,
    o: nil,
    first: :x,
    next: :x,
    score: @initial_score,
    finished: false
  )

  def start_link(name) do
    GenServer.start_link(__MODULE__, nil, name: via_tuple(name))
  end

  def join(game, player) do
    GenServer.call(game, {:join, player})
  end

  def leave(game, symbol) do
    GenServer.cast(game, {:leave, symbol})
  end

  def put(game, symbol, pos) do
    GenServer.call(game, {:put, symbol, pos})
  end

  def new_round(game) do
    GenServer.call(game, :new_round)
  end

  def whereis(name) do
    :gproc.whereis_name({:n, :l, {:game, name}})
  end

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {:game, name}}}
  end

  def init(_) do
    {:ok, %TicTacToe.Game{}}
  end

  def handle_call(:new_round, _from, state) do
    new_state =
      %{state | board: %TicTacToe.Board{}, finished: false}
      |> next_round()
    {:reply, new_state, new_state}
  end

  def handle_call({:join, player}, _form, %{x: nil} = state) do
    new_state = %{state | x: player}
    {:reply, {:ok, :x, new_state}, new_state}
  end

  def handle_call({:join, player}, _form, %{o: nil} = state) do
    new_state = %{state | o: player}
    {:reply, {:ok, :o, new_state}, new_state}
  end

  def handle_call({:join, _player}, _from, state) do
    {:reply, :error, state}
  end

  def handle_call({:put, _symbol, _pos}, _from, %{finished: true} = state) do
    {:reply, :finished, state}
  end

  def handle_call({:put, symbol, position}, _from, %{next: symbol} = state) do
    case TicTacToe.Board.put(state.board, symbol, position) do
      {:ok, board} ->
        state = %{state | board: board}
        cond do
          winner = TicTacToe.Board.winner(board) ->
            new_state = finish_game(state, winner)
            {:reply, {:winner, winner, new_state}, new_state}
          TicTacToe.Board.full?(board) ->
            new_state = finish_game(state, :ties)
            {:reply, {:draw, new_state}, new_state}
          true ->
            new_state = next_turn(state)
            {:reply, {:ok, new_state}, new_state}
        end
      :error ->
        {:reply, :retry, state}
    end
  end

  def handle_call({:put, _symbol, _position}, _form, state) do
    {:reply, :cheat, state}
  end

  def handle_cast({:leave, symbol}, state) do
    new_state =
      state
      |> remove_player(symbol)
      |> reset_score()
      |> reset_board()

    if empty?(new_state) do
      {:stop, :normal, new_state}
    else
      {:noreply, new_state}
    end
  end

  defp finish_game(state, symbol) do
    score = Map.update!(state.score, symbol, &(&1 + 1))
    %{state | score: score, finished: true}
  end

  defp next_turn(%{next: :x} = state) do
    %{state | next: :o}
  end

  defp next_turn(%{next: :o} = state) do
    %{state | next: :x}
  end

  defp next_round(%{first: :x} = state) do
    %{state | first: :o, next: :o}
  end

  defp next_round(%{first: :o} = state) do
    %{state | first: :x, next: :x}
  end

  defp empty?(%{x: nil, o: nil}) do
    true
  end

  defp empty?(%{x: _, o: _}) do
    false
  end

  defp remove_player(state, symbol) do
    Map.put(state, symbol, nil)
  end

  defp reset_score(state) do
    %{state | score: @initial_score}
  end

  defp reset_board(state) do
    %{state | board: %TicTacToe.Board{}}
  end
end
