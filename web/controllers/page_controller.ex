defmodule Callumapi.PageController do
  use Callumapi.Web, :controller

  alias Callumapi.Repo
  alias Callumapi.Weight
  alias Callumapi.Macro

  def index(conn, _params) do
    weighin_query = from w in Weight,
      order_by: [desc: w.withings_id]

    macro_query = from m in Macro,
      order_by: [desc: m.id]

    latest_weighin = from weighin in Weight,
      order_by: [desc: weighin.withings_id],
      limit: 1

    weight_data = Repo.all(weighin_query)
    macro_data = Repo.all(macro_query)
    last_weight = Repo.all(latest_weighin)

    render conn, weighins: weight_data, macros: macro_data, last_weighin: last_weight
  end
end
