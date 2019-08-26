require IEx;
# require Logger;
defmodule ExCiProxy.YmlReader.ConfigTest do
  use ExUnit.Case

  test "get" do 
    yml = ExCiProxy.YmlReader.Config.get()
    assert yml |> is_list()
    assert Enum.find_value(yml, fn(x) -> x["name"] == "travis-ci" end)
  end

  test "get_repo" do 
    repo = ExCiProxy.YmlReader.Config.get_repo("travis-ci")
    assert repo == "http://github.com/crosscloudci/ci_plugin_travis_go"
  end

  test "ref" do 
    ref = ExCiProxy.YmlReader.Config.get_ref("travis-ci")
    assert is_binary(ref)
  end
  test "get_plugin_ci_system_list" do 
    list = ExCiProxy.YmlReader.Config.get_plugin_ci_system_list()
    assert list == ["travis-ci"]
  end
end
