require IEx;
require Logger;
defmodule ExCiProxy.YmlReader.GitlabCi do
  use Retry
	def get do
		Application.ensure_all_started :inets
    retry with: exp_backoff() |> randomize |> cap(1_000) |> expiry(8_000), rescue_only: [MatchError] do  
			Logger.debug fn ->
				"Trying getcncfci http get on #{inspect(System.get_env("GITLAB_CI_YML"))}"
			end
     {:ok, resp} = :httpc.request(:get, {System.get_env("GITLAB_CI_YML") |> to_charlist, []}, [], [body_format: :binary])
     {{_, 200, 'OK'}, _headers, body} = resp
     body
    end
  end

  # Convention:
  # 1. cross-cloud ci has all the projects (listed under projects)
  # 2. cncfci.yml has project specific attributes (such as logo-url)
  #   -- lives in the {project}-configuration repo
  # 3. We need to get the url/location of the project-configuration repo in order to
  # get the project specific attributes
  # 4. Using convention we can derive the name of the project-configuration repos from a list of valid project names.
  #   -- if the project name doesn't match the name of the project repo we will fail
  #   -- see https://en.wikipedia.org/wiki/Connascence
	def getcncfci(configuration_repo) do
		Application.ensure_all_started :inets
    try do
      retry with: exp_backoff() |> randomize |> cap(1_000) |> expiry(6_000), rescue_only: [MatchError] do  
        if is_nil(configuration_repo) == false do
          Logger.debug fn ->
            "Trying getcncfci http get on #{inspect(configuration_repo)}"
          end
          {:ok, {{_, 200, 'OK'}, _headers, body}} = :httpc.request(:get, {configuration_repo |> to_charlist, []}, [], [body_format: :binary])
          body
        else
          {:error, :not_found}
        end
      end
    rescue
      _e in MatchError -> 
        Logger.error fn ->
          "failed at gitlab_ci http get on #{inspect(configuration_repo)}"
        end
        {:error, :not_found}
    end
  end

  def cloud_list do
    {:ok, yml} = ExCiProxy.YmlReader.GitlabCi.get() |> YamlElixir.read_from_string 
    yml["clouds"] 
    |> Stream.with_index 
    |> Enum.reduce([], fn ({{k, v}, _idx}, acc) -> 
      # [%{"id" => (idx + 1), 
      [%{"id" => 0, 
        "cloud_name" => k, 
        "active" => v["active"],
        "display_name" => v["display_name"],
        # "order" => (idx + 1)} | acc] 
        "order" => v["order"]} | acc] 
    end) 
	end

  def cncf_relations_list do
    {:ok, yml} = ExCiProxy.YmlReader.GitlabCi.get() |> YamlElixir.read_from_string 
    yml["cncf_relations"] 
    |> Stream.with_index 
    |> Enum.reduce([], fn ({v, idx}, acc) -> 
      [%{"order" => (idx + 1), 
        "name" => v} | acc] 
    end) 
	end

  def projects_with_yml do
		{:ok, yml} = ExCiProxy.YmlReader.GitlabCi.get() |> YamlElixir.read_from_string 
		yml["projects"] 
		|> Stream.with_index 
		|> Enum.reduce([], fn ({{k, v}, _idx}, acc) -> 
      case configuration_repo_path(v["configuration_repo"]) |> getcncfci() do
        {:error, :not_found} ->
          acc
        _ ->
          [%{"project_name" => k} | acc] 
      end
		end)
  end

  def configuration_repo_path(configuration_repo) do 
     "#{configuration_repo}/#{System.get_env("PROJECT_SEGMENT_ENV")}/cncfci.yml"
  end 

	def project_list do
    project_names = ExCiProxy.YmlReader.GitlabCi.projects_with_yml()
		{:ok, yml} = ExCiProxy.YmlReader.GitlabCi.get() |> YamlElixir.read_from_string 
		yml["projects"] 
		|> Stream.with_index 
		|> Enum.reduce([], fn ({{k, v}, _idx}, acc) -> 
      # IEx.pry()
      # global config overwrites the project config
      cncfci_yml = if Enum.find_value(project_names, fn(x) -> x["project_name"] == k end) do
          {:ok, cncfci_yml} = configuration_repo_path(v["configuration_repo"]) |> getcncfci() |> YamlElixir.read_from_string
          cncfci_yml
      end
      display_name = if v["display_name"], do: v["display_name"], else: cncfci_yml["project"]["display_name"]
      logo_url = if v["logo_url"], do: v["logo_url"], else: cncfci_yml["project"]["logo_url"]
      sub_title = if v["sub_title"], do: v["sub_title"], else: cncfci_yml["project"]["sub_title"]
      project_url = if v["project_url"], do: v["project_url"], else: cncfci_yml["project"]["project_url"]
      stable_ref = if v["stable_ref"], do: v["stable_ref"], else: cncfci_yml["project"]["stable_ref"]
      head_ref = if v["head_ref"], do: v["head_ref"], else: cncfci_yml["project"]["head_ref"]
      ci_system = if v["ci_system"], do: v["ci_system"], else: cncfci_yml["project"]["ci_system"]
			[%{"id" => 0, 
        "yml_name" => k, 
        "active" => v["active"],
        "logo_url" => logo_url,
        "display_name" => display_name,
        "sub_title" => sub_title,
        "yml_gitlab_name" => v["gitlab_name"],
        "project_url" => project_url,
        "repository_url" => v["repository_url"],
        "configuration_repo" => v["configuration_repo"],
        "timeout" => v["timeout"],
        "cncf_relation" => v["cncf_relation"],
        "stable_ref" => stable_ref,
        "head_ref" => head_ref,
        "ci_system" => ci_system,
        # "order" => (idx + 1)} | acc] 
        "order" => v["order"]} | acc] 
		end) 
	end

	def gitlab_pipeline_config do
		{:ok, yml} = ExCiProxy.YmlReader.GitlabCi.get() |> YamlElixir.read_from_string 
		yml["gitlab_pipeline"] 
		|> Stream.with_index 
		|> Enum.reduce([], fn ({{k, v}, _idx}, acc) -> 
			# [%{"id" => (idx + 1), 
			[%{"id" => 0, 
        "pipeline_name" => k, 
        "timeout" => v["timeout"],
        "status_jobs" => v["status_jobs"],
        } | acc] 
		end) 
	end

  def project_ci_system(project_name) do
    full_project_list = ExCiProxy.YmlReader.GitlabCi.project_list()

    project_list = Enum.reduce(full_project_list, [], fn (x, acc) -> 
      case x["yml_name"] do
        ^project_name -> [x | acc]
        _ -> acc 
      end 
    end)
    project_list[0]["ci_system"]
  end
end
