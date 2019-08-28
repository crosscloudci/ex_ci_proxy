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
    case ExCiProxy.RegisterPlugin.ci_system_type_list(status_params["project"])
    |> List.first
    |> ExCiProxy.RegisterPlugin.status(status_params["project"], status_params["ref"], status_params["arch"]) do
      :invalid_project_for_global_config ->
        conn 
        |> put_status(422)
        |> json(%{error: "Invalid project name for global configuration yml file"})
      :ci_system_misconfigured ->
        conn 
        |> put_status(422)
        |> json(%{error: "ci_system misconfigured"})
      %{error: ans, error_code: error_code} ->
        conn 
        |> put_status(422)
        |> json(%{ error: ans, error_code: error_code})
      build_status ->
        render(conn, "index.json", build_status: build_status)
    end
  end

  def create(_conn, %{"ci_status/build/commit_ref" => _status__params}) do
    # changeset = Projects.changeset(%Projects{}, projects_params)
  end
end
