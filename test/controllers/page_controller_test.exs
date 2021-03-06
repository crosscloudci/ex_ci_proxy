defmodule ExCiProxy.PageControllerTest do
  use ExCiProxy.ConnCase

  @valid_attrs %{project: "testproj", ref: "193689e8a01e", arch: "amd64", interface: "cli"  }
  @invalid_project_attrs %{project: "invalidname", ref: "834f6f81e394", arch: "amd64", interface: "cli"  }
  @ci_system_misconfigured %{project: "prometheus", ref: "834f6f81e394", arch: "amd64", interface: "cli"  }
  @missing_commit %{project: "testproj", ref: "fjdkafdjkaljdfkla", arch: "amd64", interface: "cli"  }
  @failed_commit %{project: "testproj", ref: "04e2b44c508", arch: "amd64", interface: "cli"  }
  @linkerd2 %{project: "linkerd2", ref: "368d16f23", arch: "amd64", interface: "cli"  }

  # test "lists all entries on index", %{conn: conn} do
  #   ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
  #   ExCiProxy.RegisterPlugin.register_all_ci_systems()
  #   conn = get conn, page_path(conn, :index), @valid_attrs
  #   _page = json_response(conn, 200)
  #   assert  %{ "build_url" => "https://travis-ci.org/crosscloudci/testproj/builds/572521581 ",
  #                   "status" => "success"
  #     } = json_response(conn, 200)["build_status"]
  # end

  test "linkerd2 should pass", %{conn: conn} do
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
    conn = get conn, page_path(conn, :index), @linkerd2
    _page = json_response(conn, 200)
    assert  %{ "build_url" => "https://travis-ci.org/linkerd/linkerd2/builds/578036893 ",
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

  test "missing commit", %{conn: conn} do
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
    conn = get conn, page_path(conn, :index), @missing_commit
    %{"error" => error, "error_code" => error_code} = json_response(conn, 422)
    assert  error_code == 1
  end

  test "failed commit", %{conn: conn} do
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
    conn = get conn, page_path(conn, :index), @failed_commit
    assert  %{"status" => "failed", "build_url" => "https://circleci.com/gh/crosscloudci/testproj/9"} == json_response(conn, 422)["build_status"]
  end

end
