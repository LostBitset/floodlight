defmodule FloodlightWeb.BetterLiveView.Behavior do
  alias Phoenix.LiveView.Socket

  @type sock_update :: map

  @callback mount(
              params :: Socket.unsigned_params | :not_mounted_at_router,
              session :: map,
              sock :: Socket.t(),
              mount_type :: :as_http | :as_live_view
            ) ::
              {:ok, sock_update} | {:ok, sock_update, keyword}

  @callback on_params(
              params :: Socket.unsigned_params,
              uri :: String.t(),
              sock :: Socket.t()
            ) ::
              {:noreply, sock_update}

  @callback on_event(
              event :: binary,
              params :: Socket.unsigned_params,
              sock :: Socket.t()
            ) ::
              {:noreply, sock_update} | {:reply, map, sock_update}

  @callback on_call(msg :: term, {pid, reference}, sock :: Socket.t()) ::
              {:noreply, sock_update} | {:reply, term, sock_update}

  @callback on_cast(msg :: term, sock :: Socket.t()) ::
              {:noreply, sock_update}

  @callback on_info(msg :: term, sock :: Socket.t()) ::
              {:noreply, sock_update}

  @callback on_async(
              name :: term,
              async_fun_result :: {:ok, term} | {:exit, term},
              sock :: Socket.t()
            ) ::
              {:noreply, sock_update}

  @optional_callbacks mount: 4,
                      on_params: 3,
                      on_event: 3,
                      on_call: 3,
                      on_info: 2,
                      on_cast: 2,
                      on_async: 3
end
