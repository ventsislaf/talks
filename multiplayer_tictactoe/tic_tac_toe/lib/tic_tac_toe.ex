# lib/tic_tac_toe.ex

defmodule TicTacToe do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(TicTacToe.GameSupervisor, []),
      supervisor(Registry, [:unique, Registry.TicTacToe])
    ]

    opts = [strategy: :one_for_one, name: TicTacToe.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
