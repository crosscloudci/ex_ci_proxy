require IEx;
require Logger;
defmodule ExCiProxy.YmlReader.Config do

	def get do
    path = Path.join(File.cwd!(), "ci_plugins.yml")
		{:ok, %{"plugins" => yml}} = YamlElixir.read_from_file(path)
    yml
  end

  def get_repo(service) do
    repo = get |>
    Enum.reduce([], fn(x, acc) -> 
      if x["name"] == service do
          acc = x["repo"]
      end
    end)
    if is_nil(repo) do
      :not_found 
    else
      repo
    end
  end
end
