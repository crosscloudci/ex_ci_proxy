require IEx;
# require Logger;
defmodule CncfDashboardApi.YmlReader.ConfigTest do
  use ExUnit.Case

  test "get" do 
    yml = CncfDashboardApi.YmlReader.Config.get()
    assert yml |> is_list()
    assert Enum.find_value(yml, fn(x) -> x["name"] == "travis-ci" end)
  end

  test "get_repo" do 
    repo = CncfDashboardApi.YmlReader.Config.get_repo("travis-ci")
    assert repo == "http://github.com/crosscloudci/ci_plugin_travis_go"
  end
end
