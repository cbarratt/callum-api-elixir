defmodule WeightSerializer do
  use Remodel
  @array_root :weighins

  attributes [:id, :weight, :bodyfat_mass, :bodyfat_percentage, :lean_mass, :taken_at]
end
