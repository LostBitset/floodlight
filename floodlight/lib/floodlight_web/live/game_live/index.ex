defmodule FloodlightWeb.GameLive.Index do

  use FloodlightWeb, :live_view
  use FloodlightWeb.BetterLiveView, wants: [:event]
  alias FloodlightWeb.Endpoint

  defp mount(_, :as_http) do
    Endpoint.subscribe("chat")
    {:ok, %{
      username: gen_username(),
      messages: [],
    }}
  end

  defp mount(_, :as_live_view) do
    Endpoint.subscribe("chat")
    {:ok, %{
      username: gen_username(),
      messages: [],
    }}
  end

  def on_event("send", %{"text" => text}, sock) do
    Endpoint.broadcast("chat", "message", %{
      text: text,
      name: sock.assigns.username,
    })
    {:noreply, %{}}
  end

  def handle_info(_, sock) do
    IO.puts "yeeeeeEEEEeeeEEt"
    {:noreply, sock}
  end

  def on_info(%{event: "message", payload: msg}, sock) do
    IO.puts "yeet"
    {:noreply, %{
      messages: sock.assign.messages ++ [msg],
    }}
  end

  defp gen_username do
    "User #{:rand.uniform(999)}"
  end
end
