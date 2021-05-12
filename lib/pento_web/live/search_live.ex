defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view
  alias Pento.Catalog.Search
  alias Pento.Catalog

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:changeset, Search.changeset(%Search{}))
     |> assign(:product, nil)}
  end

  def handle_event("search", %{"search" => attrs}, socket) do
    IO.inspect(attrs)

    case Catalog.search_product(attrs) do
      Ecto.Changeset = changeset ->
        {:noreply, assign(socket, :changeset, changeset)}

      re ->
        {:noreply, assign(socket, :product, re)}
        |> IO.inspect()
    end
  end
end
