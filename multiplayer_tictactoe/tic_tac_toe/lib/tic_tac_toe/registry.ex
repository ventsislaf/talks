# lib/tic_tac_toe/registry.ex
defmodule TicTacToe.Registry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def game_process(name) do
    case TicTacToe.Game.whereis(name) do
      :undefined -> GenServer.call(__MODULE__, {:game_process, name})
      pid -> pid
    end
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:game_process, name}, _from, state) do
    game_pid = case TicTacToe.Game.whereis(name) do
      :undefined ->
        {:ok, pid} = TicTacToe.GameSupervisor.start_child(name)
        pid
      pid ->
        pid
    end
    {:reply, game_pid, state}
  end
end
