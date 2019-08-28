defmodule ExCiProxy.LivelinessControllerTest do
  use ExCiProxy.ConnCase

  test "liveliness probe", %{conn: conn} do
    conn = get conn, "/"
    assert text_response(conn, 200) =~ "Ok"
  end
end
