defmodule ExCiProxy.PageControllerTest do
  use ExCiProxy.ConnCase

  @valid_attrs %{project: "crosscloudci/testproj", ref: "834f6f81e394", arch: "amd64", interface: "cli"  }
  test "lists all entries on index", %{conn: conn} do
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
    conn = get conn, page_path(conn, :index), @valid_attrs
    _page = json_response(conn, 200)
    assert  %{ "build_url" => "https://travis-ci.org/crosscloudci/testproj/builds/572521581 ",
                    "status" => "success"
      } = json_response(conn, 200)["build_status"]
  end
end
