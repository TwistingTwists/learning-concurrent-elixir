defmodule Uniqs.Application do

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Livebook.Utils.UniqueTask
    ]

    opts = [strategy: :one_for_one, name: Uniqs.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
