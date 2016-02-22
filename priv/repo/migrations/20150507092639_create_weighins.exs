defmodule Callum.Repo.Migrations.CreateWeighins do
  use Ecto.Migration

  def change do
    create table(:weighins) do
      add :withings_id, :integer
      add :weight, :string
      add :bodyfat_mass, :string
      add :bodyfat_percentage, :string
      add :lean_mass, :string
      add :taken_at, :string

      timestamps
    end
  end
end
