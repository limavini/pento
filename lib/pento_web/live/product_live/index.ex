defmodule PentoWeb.ProductLive.Index do
  # LiveView is a GenServer
  # LiveView is controlled by a behaviour
  # The behaviour calls mount and then render
  # We're not in control about what really happens under the hood
  # The behaviour controls the flow of our LiveView

  # CRC -> Construct, Reduce, Convert

  # <%= %> renders everytime the values inside of it changes
  # <% %> renders only on mount stage

  use PentoWeb, :live_view

  alias Pento.Catalog
  alias Pento.Catalog.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     # adds a key: value pair to socket :assigns
     # you can access these values using @greeting on an .leex file
     |> assign(:greeting, "Welcome to Pento!")
     |> assign(:products, list_products())}
  end

  @impl true
  # Runs before mount/3
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  defp list_products do
    Catalog.list_products()
  end
end
