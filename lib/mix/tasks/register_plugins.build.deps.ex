defmodule Mix.Tasks.RegisterPlugins.Build.Deps do
  use Mix.Task

  @shortdoc "Build all plugin dependencies"
  def run(_) do
    ExCiProxy.RegisterPlugin.register_all_ci_system_dependencies()
  end
end
