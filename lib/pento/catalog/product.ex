defmodule Pento.Catalog.Product do
  # The Product module is like the core of the application,
  # and the Context (Catalog) is like the boundary (api)
  use Ecto.Schema
  import Ecto.Changeset

  # Schema is like a translation between the database table and elixir
  schema "products" do
    field :description, :string
    field :name, :string
    field :sku, :integer
    field :unit_price, :float

    timestamps()
  end

  @doc false
  # changeset/2 transform a struct into a changeset
  # returns a struct with %{valid?: boolean} so you can validate

  # Changeset ensures data safety
  # Changeset casts unustructured data into a known one.
  # Ensure a common interface for responses
  def changeset(product, attrs) do
    # Struct that we want to change
    product
    # Filter data passed into params
    |> cast(attrs, [:name, :description, :unit_price, :sku])
    # Validate data
    |> validate_required([:name, :description, :unit_price, :sku])
    |> unique_constraint(:sku)
  end

  @doc false
  def decrease_price_changeset(product, attrs) do
    product
    |> cast(attrs, [:unit_price])
    |> validate_number(:unit_price, less_than: product.unit_price)
  end
end
