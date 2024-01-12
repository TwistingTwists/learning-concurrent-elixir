defmodule Uniqs.Application do

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Uniqs.Worker.start_link(arg)
      # {Uniqs.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Uniqs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
