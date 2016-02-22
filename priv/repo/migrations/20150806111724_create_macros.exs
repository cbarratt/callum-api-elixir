defmodule Callum.Repo.Migrations.CreateMacros do
  use Ecto.Migration

  def change do
    create table(:macros) do
      add :calories, :string
      add :carbs, :string
      add :fat, :string
      add :protein, :string
      add :logged_date, :string

      timestamps
    end
  end
end
