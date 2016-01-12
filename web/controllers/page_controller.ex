defmodule Callumapi.PageController do
  use Callumapi.Web, :controller

  alias Callumapi.{Repo, Weight, Macro}

  def index(conn, _params) do
    weights = Repo.all from w in Weight, order_by: [desc: w.withings_id], limit: 8
    macros = Repo.all from m in Macro, order_by: [desc: m.id], limit: 8

    last_weight = weights |> List.first
    todays_calories = macros |> List.first

    render conn, weighins: weights, macros: macros, last_weighin: last_weight, current_intake: todays_calories
  end
end
