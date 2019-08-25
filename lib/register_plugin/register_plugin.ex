require IEx;
require Logger;
defmodule ExCiProxy.RegisterPlugin do

  def register(plugin_name) do
    ExCiProxy.YmlReader.Config.get_repo(plugin_name)
    |> ExCiProxy.RegisterPlugin.get_plugin(plugin_name)
    |> ExCiProxy.RegisterPlugin.build(plugin_name)
    # if repo != :not_found do
    #   if File.exists?("ci_plugins/" <> plugin_name) do
    #     Logger.info fn ->
    #       "register: pulling"
    #     end
    #     File.cd("ci_plugins/" <> plugin_name)
    #     #TODO checkout ref 
    #     System.cmd("git", ["pull", "origin"])
    #     File.cd("../../")
    #   else
    #     Logger.info fn ->
    #       "register: cloning"
    #     end
    #     System.cmd("git", ["clone", "--single-branch", "--branch", 
    #       System.get_env("PROJECT_SEGMENT_ENV"), repo, "ci_plugins/" <> plugin_name])
    #     #TODO checkout ref 
    #   end
      # execute build from in the plugin's direcory
      # File.cd("ci_plugins/" <> plugin_name)
      # System.cmd("bash", ["bin/build.sh"])
      # File.cd("../../")
    # else
    #   :not_built
    # end
  end

  def register(plugin_name, :deps) do
    ExCiProxy.YmlReader.Config.get_repo(plugin_name)
    |> ExCiProxy.RegisterPlugin.get_plugin(plugin_name)
    |> ExCiProxy.RegisterPlugin.build(plugin_name, :deps)
  end


  def get_plugin(:not_found, _plugin_name) do
    :not_built
  end 

  def get_plugin(repo, plugin_name) do
    # if repo != :not_found do
    if File.exists?("ci_plugins/" <> plugin_name) do
      Logger.info fn ->
        "register: pulling"
      end
      File.cd("ci_plugins/" <> plugin_name)
      #TODO checkout ref 
      System.cmd("git", ["fetch", "--all"])
      # git reset --hard origin/master
      System.cmd("git", ["reset", "--hard", "origin/" <> System.get_env("PROJECT_SEGMENT_ENV")])
      # System.cmd("git", ["pull", "origin"])
      File.cd("../../")
    else
      Logger.info fn ->
        "register: cloning"
      end
      System.cmd("git", ["clone", "--single-branch", "--branch", 
        System.get_env("PROJECT_SEGMENT_ENV"), repo, "ci_plugins/" <> plugin_name])
      #TODO checkout ref 
    end
    repo
  end

  def build(:not_built, _plugin_name) do
    :not_built
  end

  def build(_repo, plugin_name) do
      File.cd("ci_plugins/" <> plugin_name)
      System.cmd("bash", ["bin/build.sh"])
      File.cd("../../")
  end

  def build(:not_built, _plugin_name, :deps) do
    :not_built
  end

  def build(_repo, plugin_name, :deps) do
    File.cd("ci_plugins/" <> plugin_name)
    # Don't install the dependencies on your dev
    # enviroment :/ Test using docker: see README
    if Mix.env != :test do 
      System.cmd("bash", ["bin/build-deps.sh"])
    end
    File.cd("../../")
  end

  def ci_system_type_list do
    ExCiProxy.YmlReader.GitlabCi.project_list()
    |> Enum.map(fn (x) -> 
      ci_system_type_list(x["yml_name"])
    end)
    |> List.flatten()
    |> Enum.uniq
  end

  def ci_system_type_list(project) do
    ExCiProxy.YmlReader.GitlabCi.project_list()
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
    ExCiProxy.RegisterPlugin.ci_system_type_list()
    |> Enum.map(fn(x) ->
      ExCiProxy.RegisterPlugin.register(x)
    end)
  end

  def register_all_ci_system_dependencies do
    ExCiProxy.RegisterPlugin.ci_system_type_list()
    |> Enum.map(fn(x) ->
      ExCiProxy.RegisterPlugin.register(x, :deps)
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
