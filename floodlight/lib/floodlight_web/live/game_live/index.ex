defmodule FloodlightWeb.GameLive.Index do

  use FloodlightWeb, :live_view
  use FloodlightWeb.BetterLiveView, wants: [:event, :info]
  alias FloodlightWeb.Endpoint

  defp mount(_, :as_http) do
    {:ok, initial_assigns()}
  end

  defp mount(_, :as_live_view) do
    Endpoint.subscribe("chat")
    {:ok, initial_assigns()}
  end

  defp initial_assigns, do: %{
    username: gen_username(),
    messages: [],
  }

  def on_event("send", %{"text" => text}, sock) do
    Endpoint.broadcast("chat", "message", %{
      text: text,
      name: sock.assigns.username,
    })
    {:noreply, %{}}
  end

  def on_info(%{event: "message", payload: msg}, sock) do
    IO.puts "yeet"
    {:noreply, %{
      messages: sock.assigns.messages ++ [msg],
    }}
  end

  defp gen_username do
    "User #{:rand.uniform(999)}"
  end
end
