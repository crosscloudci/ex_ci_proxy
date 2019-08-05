require IEx;
defimpl Poison.Encoder, for: Tuple do
    def encode(tuple, _options) do
          tuple
          |> Tuple.to_list
          |> Poison.encode!
        end
end
defmodule ExCiProxy.PageController do
  use ExCiProxy.Web, :controller

  def index(conn, _status_params) do

    build_status = %{"project_name" => "testproj", 
      "commit_ref" => "fjkld1jkl33", 
      "tag" => "v0.0.1", 
      "arch" => "amd64"} 
    render(conn, "index.json", build_status: build_status)
  end
  def create(_conn, %{"ci_status/build/commit_ref" => _status__params}) do
    # changeset = Projects.changeset(%Projects{}, projects_params)
  end
end
