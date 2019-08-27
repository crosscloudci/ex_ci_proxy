defmodule ExCiProxy.PageControllerTest do
  use ExCiProxy.ConnCase

  @valid_attrs %{project: "testproj", ref: "834f6f81e394", arch: "amd64", interface: "cli"  }
  @invalid_project_attrs %{project: "invalidname", ref: "834f6f81e394", arch: "amd64", interface: "cli"  }
  @ci_system_misconfigured %{project: "prometheus", ref: "834f6f81e394", arch: "amd64", interface: "cli"  }

  test "lists all entries on index", %{conn: conn} do
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
    conn = get conn, page_path(conn, :index), @valid_attrs
    _page = json_response(conn, 200)
    assert  %{ "build_url" => "https://travis-ci.org/crosscloudci/testproj/builds/572521581 ",
                    "status" => "success"
      } = json_response(conn, 200)["build_status"]
  end

  test "invalid project", %{conn: conn} do
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
    conn = get conn, page_path(conn, :index), @invalid_project_attrs
    assert  %{"error" => "Invalid project name for global configuration yml file"} == json_response(conn, 422)
  end

  test "ci system misconfigured", %{conn: conn} do
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
    conn = get conn, page_path(conn, :index), @ci_system_misconfigured
    assert  %{"error" => "ci_system misconfigured"} == json_response(conn, 422)
  end

end
