defmodule TicTacToe.GameSupervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def start_child(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  def init(_) do
    children = [
      worker(TicTacToe.Game, [], restart: :temporary)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

  def game_process(name) do
    case TicTacToe.Game.whereis(name) do
      [{pid, _}] -> 
        pid
      _ -> 
        {:ok, pid} = TicTacToe.GameSupervisor.start_child(name)
        pid
    end
  end

end
