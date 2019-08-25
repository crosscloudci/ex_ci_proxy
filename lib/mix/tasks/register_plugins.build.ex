defmodule Mix.Tasks.RegisterPlugins.Build do
  use Mix.Task

  @shortdoc "Build all plugins"
  def run(_) do
    ExCiProxy.RegisterPlugin.register_all_ci_systems()
  end
end
