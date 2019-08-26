defimpl Poison.Encoder, for: Tuple do
    def encode(tuple, _options) do
          tuple
          |> Tuple.to_list
          |> Poison.encode!
        end
end
require Logger;
defmodule ExCiProxy.PageController do
  use ExCiProxy.Web, :controller


  def show(conn, _params) do
    text conn, "Ok"
  end

  def index(conn, status_params) do
    build_status = ExCiProxy.RegisterPlugin.ci_system_type_list(status_params["project"])
          |> List.first
          |> ExCiProxy.RegisterPlugin.status(status_params["project"], status_params["ref"], status_params["arch"])
      

    render(conn, "index.json", build_status: build_status)
  end
  def create(_conn, %{"ci_status/build/commit_ref" => _status__params}) do
    # changeset = Projects.changeset(%Projects{}, projects_params)
  end
end
