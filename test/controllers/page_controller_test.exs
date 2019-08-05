defmodule ExCiProxy.PageControllerTest do
  use ExCiProxy.ConnCase

  # test "GET /", %{conn: conn} do
  #   conn = get conn, "/"
  #   assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  # end
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, page_path(conn, :index)
    page = json_response(conn, 200)
    assert  %{"tag" => "v0.0.1",
      "project_name" => "testproj",
      "status" => "success",
      "commit_ref" => "fjkld1jkl33",
      "arch" => "amd64"} = json_response(conn, 200)["build_status"]
  end
end
