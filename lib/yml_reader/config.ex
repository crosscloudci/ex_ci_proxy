require IEx;
require Logger;
defmodule ExCiProxy.YmlReader.Config do

	def get do
    path = Path.join(File.cwd!(), "ci_plugins.yml")
		{:ok, %{"plugins" => yml}} = YamlElixir.read_from_file(path)
    yml
  end

  def get_repo(service) do
    repo = get() |>
    Enum.find([], fn(x) -> 
      if x["name"] == service do 
        x
      end 
    end)
    if is_nil(repo) do
      :not_found 
    else
      repo["repo"]
    end
  end

  def get_ref(service) do
    repo = get() |>
    Enum.find([], fn(x) -> 
      if x["name"] == service do
        x
      end
    end)
    if is_nil(repo) do
      :not_found 
    else
      repo["ref"]
    end
  end

  def get_plugin_ci_system_list do
    list = get() |>
    Enum.reduce([], fn(x, acc) -> 
      [x["name"] | acc]
    end)
    if is_nil(list) do
      :not_found 
    else
      list 
    end
  end
end
