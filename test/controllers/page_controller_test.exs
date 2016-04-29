defmodule PhoenixDown.PageControllerTest do
  use PhoenixDown.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Phoenix Down"
  end
end
