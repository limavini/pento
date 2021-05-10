defmodule Pento.Promo.Recipient do
  defstruct [:first_name, :email]
  @types %{first_name: :string, email: :string}

  alias Pento.Promo.Recipient
  import Ecto.Changeset

  def changeset(%Recipient{} = user, attrs) do
    # The given data on cast/3 may be either a changeset,
    # a schema struct or a {data, types} tuple. ...

    {user, @types}
    |> cast(attrs, Map.keys(@types))
    |> validate_required([:first_name, :email])
    |> validate_format(:email, ~r/@/)
  end
end
