defmodule Callumapi.PageControllerTest do
  use Callumapi.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert conn.resp_body =~ "Health"
  end
end
