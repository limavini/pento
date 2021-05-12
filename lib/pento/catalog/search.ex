defmodule Pento.Catalog.Search do
  import Ecto.Changeset
  alias Pento.Catalog.Search
  defstruct [:sku]
  @types %{sku: :string}

  def changeset(%Search{} = search_term, attrs \\ %{}) do
    {search_term, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required(:sku)
    |> validate_length(:sku, min: 7)
    |> update_change(:sku, &String.to_integer/1)
  end
end
