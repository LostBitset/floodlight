defmodule Floodlight.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FloodlightWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:floodlight, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Floodlight.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Floodlight.Finch},
      # Start a worker by calling: Floodlight.Worker.start_link(arg)
      # {Floodlight.Worker, arg},
      # Start to serve requests, typically the last entry
      FloodlightWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Floodlight.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FloodlightWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
