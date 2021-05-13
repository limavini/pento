defmodule Pento.Catalog do
  @moduledoc """
  The Catalog context.

  Contexts are like the boundaries of an application.

  Context has there responsibilities
  - Access External Services
  - Abstract Away Tedious Details
  - Handle Uncertainty
  - Presente a single, common API

  Calls to Repo should all stay at the Context level

  REMEMBER: The Context is a WITH-LAND.
            You should use with/1 to handle uncertainty
  """

  import Ecto.Query, warn: false
  alias Pento.Repo
  alias Pento.Catalog.{Product, Search}

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  def markdown_product(product, amount) do
    with %{valid?: true} = changeset <-
           Product.decrease_price_changeset(product, %{unit_price: amount}),
         {:ok, response} <-
           Repo.update(changeset) do
      response
    else
      %{valid?: false} = changeset -> changeset
      {:error, reason} -> IO.puts("Unable to update price. #{reason}")
      e -> e
    end
  end

  def search_product(%{"sku" => sku} = attrs) do
    with %{valid?: true} <- Search.changeset(%Search{}, attrs),
         Ecto.Schema = result <- Repo.get_by(Product, sku: sku) do
      result
    else
      %{valid?: false} = changeset -> changeset
      e -> e
    end
  end

  def list_products_with_user_ratings(user) do
    # Gets ratings only for a user
    Product.Query.with_user_ratings(user)
    |> Repo.all()
  end
end
