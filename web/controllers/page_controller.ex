defimpl Poison.Encoder, for: Tuple do
    def encode(tuple, _options) do
          tuple
          |> Tuple.to_list
          |> Poison.encode!
        end
end
defmodule ExCiProxy.PageController do
  use ExCiProxy.Web, :controller

  def index(conn, status_params) do
    build_status = CncfDashboardApi.RegisterPlugin.ci_system_type_list("testproj")
          |> List.first
          |> CncfDashboardApi.RegisterPlugin.status(status_params["project"], status_params["ref"], status_params["arch"])
      

    render(conn, "index.json", build_status: build_status)
  end
  def create(_conn, %{"ci_status/build/commit_ref" => _status__params}) do
    # changeset = Projects.changeset(%Projects{}, projects_params)
  end
end
