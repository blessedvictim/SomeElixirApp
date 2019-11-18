defmodule Testapp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      TestappWeb.Endpoint
      # {Redix, name: :redix, host: "80.241.209.42"}
      # Starts a worker by calling: Testapp.Worker.start_link(arg)
      # {Testapp.Worker, arg},
    ]

    # System.get_env("REDIS_HOST") |> :logger.warning()

    children =
      case System.get_env("REDIS_HOST") do
        host when is_bitstring(host) -> children ++ [{Redix, name: :redix, host: host}]
        _ -> raise "Error: can't find REDIS_HOST"
      end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Testapp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    TestappWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
