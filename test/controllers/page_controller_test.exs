defmodule ExCiProxy.PageControllerTest do
  use ExCiProxy.ConnCase

  @valid_attrs %{project: "crosscloudci/testproj", ref: "834f6f81e394", arch: "amd64"}
  test "lists all entries on index", %{conn: conn} do
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
    conn = get conn, page_path(conn, :index), @valid_attrs
    _page = json_response(conn, 200)
    assert  %{"tag" => "v0.0.1",
      "project_name" => "testproj",
      "status" => "success",
      "commit_ref" => "fjkld1jkl33",
      "arch" => "amd64"} = json_response(conn, 200)["build_status"]
  end
end
