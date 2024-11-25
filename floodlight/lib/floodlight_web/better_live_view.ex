defmodule FloodlightWeb.BetterLiveView do
  @spec wants_type(keyword, atom) :: boolean
  defp wants_type(opts, ty) do
    Enum.member?(opts[:wants], ty)
  end

  defmacro __using__(opts \\ []) do
    quote do
      @behaviour FloodlightWeb.BetterLiveView.Behavior

      @type sock_update :: map

      def mount(_, _, sock) do
        wrapped_update = mount(sock, if connected?(sock) do
          :as_live_view
        else
          :as_http
        end)
        case wrapped_update do
          {:ok, up} -> {:ok, assign(sock, up)}
          {:ok, up, kw} -> {:ok, assign(sock, up), kw}
          other -> other
        end
      end

      unquote(
        if wants_type(opts, :param) do
          quote do
            def define_params(params, uri, sock) do
              fixup on_params(params, uri, sock), sock
            end
          end
        end
      )

      unquote(
        if wants_type(opts, :event) do
          quote do
            def handle_event(event, params, sock) do
              fixup on_event(event, params, sock), sock
            end
          end
        end
      )

      unquote(
        if wants_type(opts, :call) do
          quote do
            def handle_call(msg, pr, sock) do
              fixup on_call(msg, pr, sock), sock
            end
          end
        end
      )

      unquote(
        if wants_type(opts, :cast) do
          quote do
            def handle_cast(msg, sock) do
              fixup on_cast(msg, sock), sock
            end
          end
        end
      )

      unquote(
        if wants_type(opts, :info) do
          quote do
            def handle_info(msg, sock) do
              fixup on_info(msg, sock), sock
            end
          end
        end
      )

      unquote(
        if wants_type(opts, :async) do
          quote do
            def handle_async(name, async_fun_result, sock) do
              fixup on_async(name, async_fun_result, sock), sock
            end
          end
        end
      )

      @spec fixup(
        resp ::
            {:noreply, sock_update}
          | {:reply, term, sock_update},
        sock :: Socket.t()
      ) ::
          {:noreply, Socket.t()}
        | {:reply, term, Socket.t()}
      defp fixup(resp, sock) do
        case resp do
          {:noreply, up} -> {:noreply, assign(sock, up)}
          {:reply, data, up} -> {:reply, data, assign(sock, up)}
          other -> other
        end
      end
    end
  end
end
