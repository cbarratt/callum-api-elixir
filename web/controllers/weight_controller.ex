defmodule Callumapi.WeightController do
  use Callumapi.Web, :controller

  alias Callumapi.Repo
  alias Callumapi.Weight

  def index(conn, _params) do
    weighins = Repo.all(
      from w in Weight,
        select: w,
        order_by: [desc: w.id]
    )

    json(conn, WeightSerializer.to_map(weighins))
  end
end
