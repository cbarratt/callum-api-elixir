defmodule Callumapi.PageView do
  use Callumapi.Web, :view

  def to_lbs(weight) do
    Float.ceil(elem(Float.parse(weight), 0) * 2.20462, 2)
  end

  def calories(intake) do
    if intake do
      intake.calories
    else
      "0"
    end
  end
end
