require IEx;
require Logger;
defmodule CncfDashboardApi.RegisterPlugin do

  def register(plugin_name) do
    Logger.info fn ->
      "register plugin_name: #{inspect(plugin_name)}"
    end
    repo = CncfDashboardApi.YmlReader.Config.get_repo(plugin_name)
    Logger.info fn ->
      "register repo: #{inspect(repo)}"
    end
    if repo != :not_found do
      if File.exists?("ci_plugins/" <> plugin_name) do
        Logger.info fn ->
          "register: pulling"
        end
        File.cd("ci_plugins/" <> plugin_name)
        System.cmd("git", ["pull", "origin"])
        File.cd("../../")
      else
        Logger.info fn ->
          "register: cloning"
        end
        System.cmd("git", ["clone", repo, "ci_plugins/" <> plugin_name])
      end
      # execute build from in the plugin's direcory
      File.cd("ci_plugins/" <> plugin_name)
      System.cmd("bash", ["bin/build.sh"])
      File.cd("../../")
    else
      :not_built
    end
  end

  def ci_system_type_list do
    CncfDashboardApi.YmlReader.GitlabCi.project_list()
    |> Enum.map(fn (x) -> 
      ci_system_type_list(x["yml_name"])
    end)
    |> List.flatten()
    |> Enum.uniq
  end

  def ci_system_type_list(project) do
    CncfDashboardApi.YmlReader.GitlabCi.project_list()
    |> Enum.reduce([], fn (x, acc) -> 
      # Get rid of everything except list of systems for
      # each project
      if x["yml_name"] == project do
        if x["ci_system"] && (is_nil(x["ci_system"]) == false) do
          [x["ci_system"] | acc]
        else
          acc
        end
      else
        acc
      end
		end) 
    |> List.flatten()
    # get rid of everything but system types for each system
    |> Enum.reduce([], fn(k, acc_ci_system) ->
      [k["ci_system_type"] | acc_ci_system]
    end)
    |> Enum.uniq
  end

  def register_all_ci_systems do
    CncfDashboardApi.RegisterPlugin.ci_system_type_list()
    |> Enum.map(fn(x) ->
      CncfDashboardApi.RegisterPlugin.register(x)
    end)
  end

  def status(plugin, project, ref, _arch) do
    if plugin == "test-ci" do
      %{"project_name" => "testproj", 
        "status" => "success",
        "commit_ref" => "fjkld1jkl33", 
        "tag" => "v0.0.1", 
        "arch" => "amd64"} 
    else
      Logger.info fn ->
        "status ci_plugins/" <> plugin <> "/bin/status"
      end
      ans = File.cwd
      |> elem(1)
      |> Path.join("ci_plugins/" <> plugin <> "/bin/status")
      |> System.cmd(["status", "--project", project, "--commit", ref])
      |> elem(0)
      |> ci_parse
      %{"project_name" => "testproj", 
        "status" => ans["status"],
        "build_url" => ans["build_url"],
        "commit_ref" => "fjkld1jkl33", 
        "tag" => "v0.0.1", 
        "arch" => "amd64"} 
    end
  end

  def ci_parse(status) do
    # get header
    status_with_header = String.split(status, ["\n"])
    # second row is the status
    split_status = String.split(Enum.at(status_with_header, 1), ["\t"])
    %{ "status" => Enum.at(split_status, 0),
      "build_url" => Enum.at(split_status, 1) } 
  end

end
