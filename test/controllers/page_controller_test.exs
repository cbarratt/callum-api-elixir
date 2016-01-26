defmodule Callumapi.PageControllerTest do
  use Callumapi.ConnCase

  import Callumapi.Factory

  test "Get the homepage" do
    macro = create(:macro)
    weighin = create(:weighin)

    conn = get conn(), "/"

    assert html_response(conn, 200) =~ macro.calories
    assert html_response(conn, 200) =~ weighin.weight
  end
end
