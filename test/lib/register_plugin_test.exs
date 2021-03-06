require IEx;
# require Logger;
defmodule ExCiProxy.RegisterPluginTest do
  use ExUnit.Case

  #tag timeout: 320_000
  test "register" do 
    ExCiProxy.RegisterPlugin.register("travis-ci")
    assert File.exists?("ci_plugins/travis-ci")
  end

  test "ci_system_type_list" do 
    ans = ExCiProxy.RegisterPlugin.ci_system_type_list()
    assert ans == ["travis-ci", "circle-ci", "travis-ci-com"] 
  end
  
  test "ci_system_type_list per project" do 
    ans = ExCiProxy.RegisterPlugin.ci_system_type_list("testproj")
    assert ans == ["circle-ci"] 
  end

  test "get_list_then_register all project's ci systems" do 
    ans = ExCiProxy.RegisterPlugin.register_all_ci_systems_from_project_config()
    assert ans |> Enum.any?(fn(x) -> x == :ok end)
  end

  test "get_list_then_register" do 
    ans = ExCiProxy.RegisterPlugin.register_all_ci_systems()
    assert ans |> Enum.any?(fn(x) -> x == :ok end)
  end

  test "get_list_then_register_all_dependencies" do 
    ans = ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    assert ans |> Enum.any?(fn(x) -> x == :ok end)
  end

  test "status" do 
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
    ans = ExCiProxy.RegisterPlugin.ci_system_type_list("testproj")
          |> List.first
          |> ExCiProxy.RegisterPlugin.status("testproj", "193689e8a01e", "amd86")
    assert ans == %{"status" => "success",
      "build_url" => "https://circleci.com/gh/crosscloudci/testproj/10"} 
  end

  test "ci_parse" do 
    ans = ExCiProxy.RegisterPlugin.ci_parse("status  \t build_url\nsuccess\thttps://travis-ci.org/crosscloudci/testproj/builds/572521581\n")
    assert ans == %{"status" => "success",
      "build_url" => "https://travis-ci.org/crosscloudci/testproj/builds/572521581"} 
  end
end
