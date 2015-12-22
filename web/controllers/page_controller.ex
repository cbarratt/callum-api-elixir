defmodule Callumapi.PageController do
  use Callumapi.Web, :controller
  use Timex

  alias Callumapi.Repo
  alias Callumapi.Weight
  alias Callumapi.Macro

  def index(conn, _params) do
    date = Date.now |> DateFormat.format!("%d %B %Y", :strftime)

    weighin_query = from w in Weight,
      order_by: [desc: w.withings_id],
      limit: 8

    macro_query = from m in Macro,
      order_by: [desc: m.id],
      limit: 8

    latest_weighin = from weighin in Weight,
      order_by: [desc: weighin.withings_id],
      limit: 1

    todays_calories = from m in Macro,
      order_by: [desc: m.id],
      where: like(m.logged_date, ^date),
      limit: 1

    weight_data = Repo.all(weighin_query)
    macro_data = Repo.all(macro_query)
    last_weight = Repo.all(latest_weighin) |> List.first
    todays_calories = Repo.all(todays_calories) |> List.first

    render conn, weighins: weight_data, macros: macro_data, last_weighin: last_weight, current_intake: todays_calories
  end
end
