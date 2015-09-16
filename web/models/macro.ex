defmodule Callumapi.Macro do
  use Ecto.Model
  use Calecto.Model

  schema "macros" do
    field :calories
    field :carbs
    field :fat
    field :protein
    field :logged_date

    timestamps
  end
end
