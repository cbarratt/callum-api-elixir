defmodule Callum.Factory do
  use ExMachina.Ecto, repo: Callum.Repo

  alias Callum.{Weight, Macro}

  def factory(:weighin) do
    %Weight{
      withings_id: 1,
      weight: "69.2",
      bodyfat_mass: "11.802",
      bodyfat_percentage: "17.092",
      lean_mass: "57.248",
      taken_at: "2015-02-27 07:29:30"
    }
  end

  def factory(:macro) do
    %Macro{
      calories: "2789",
      carbs: "300",
      fat: "67",
      protein: "140",
      logged_date: "2015-01-15"
    }
  end
end
