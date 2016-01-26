defmodule Callumapi.Weight do
  use Ecto.Model

  schema "weighins" do
    field :withings_id, :integer
    field :weight
    field :bodyfat_mass
    field :bodyfat_percentage
    field :lean_mass
    field :taken_at

    timestamps
  end
end
