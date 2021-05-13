defmodule PentoWeb.DemographicLive.FormComponent do
  use PentoWeb, :live_component
  alias Pento.Survey.Demographic
  alias Pento.Survey
  # mount/1 -> single argument is the socket. Invoked when the component
  # is first rendered from the parent live view

  # update/2 -> two arguments are assigns and socket.
  # It adds additional content to the socket each time live_component/3 is called

  # render/1 -> the one argument is socket assigns. Renders like any other live view

  # Stateless components are always mounted, updated and rendered whenever
  # parent LiveView state changes

  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_demographic()
     |> assign_changeset()}
  end

  def assign_demographic(%{assigns: %{user: user}} = socket) do
    assign(socket, :demographic, %Demographic{user_id: user.id})
  end

  def assign_changeset(%{assigns: %{demographic: demographic}} = socket) do
    assign(socket, :changeset, Survey.change_demographic(demographic))
  end
end
