defmodule PentoWeb.ModalComponent do
  # Follow the Phoenix.LiveComponent behaviour
  use PentoWeb, :live_component

  @impl true
  # assigns are the values included in modal_opts on live_helpers.ex
  # The phx- events will be sent to the target at phx-target
  def render(assigns) do
    ~L"""
    <div id="<%= @id %>" class="phx-modal"
      phx-capture-click="close"
      phx-window-keydown="close"
      phx-key="escape"
      phx-target="#<%= @id %>"
      phx-page-loading>

      <div class="phx-modal-content">
        <%= live_patch raw("&times;"), to: @return_to, class: "phx-modal-close" %>
        <%= live_component @socket, @component, @opts %>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("close", _, socket) do
    {:noreply, push_patch(socket, to: socket.assigns.return_to)}
  end
end
