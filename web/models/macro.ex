defmodule Callum.Macro do
  use Ecto.Schema

  import Ecto.Changeset

  schema "macros" do
    field :calories
    field :carbs
    field :fat
    field :protein
    field :logged_date

    timestamps
  end

  def changeset(macro, params \\ :empty) do
    macro
    |> cast(params, [:calories, :carbs, :fat, :protein, :logged_date])
  end
end
