require IEx;
# require Logger;
defmodule CncfDashboardApi.RegisterPluginTest do
  use ExUnit.Case

  #tag timeout: 320_000
  test "register" do 
    CncfDashboardApi.RegisterPlugin.register("travis-ci")
    assert File.exists?("ci_plugins/travis-ci")
  end

  test "ci_system_type_list" do 
    ans = CncfDashboardApi.RegisterPlugin.ci_system_type_list()
    assert ans == ["travis-ci", "travis"] 
  end
  
  test "ci_system_type_list per project" do 
    ans = CncfDashboardApi.RegisterPlugin.ci_system_type_list("testproj")
    assert ans == ["travis-ci"] 
  end

  test "get_list_then_register" do 
    ans = CncfDashboardApi.RegisterPlugin.register_all_ci_systems()
    assert ans == [:ok, :not_built] 
  end

  test "status" do 
    ans = CncfDashboardApi.RegisterPlugin.ci_system_type_list("testproj")
          |> List.first
          |> CncfDashboardApi.RegisterPlugin.status("crosscloudci/testproj", "834f6f81e3946c4fa", "amd86")
    assert ans == %{"status" => "success",
      "build_url" => "https://travis-ci.org/crosscloudci/testproj/builds/572521581 ", 
      "project_name" => "testproj", 
        "commit_ref" => "fjkld1jkl33", 
        "tag" => "v0.0.1", 
        "arch" => "amd64"} 
  end

  test "ci_parse" do 
    ans = CncfDashboardApi.RegisterPlugin.ci_parse("status  \t build_url\nsuccess\thttps://travis-ci.org/crosscloudci/testproj/builds/572521581\n")
    assert ans == %{"status" => "success",
      "build_url" => "https://travis-ci.org/crosscloudci/testproj/builds/572521581"} 
  end
end