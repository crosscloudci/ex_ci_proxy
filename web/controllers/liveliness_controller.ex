require Logger;
defmodule ExCiProxy.LivelinessController do
  use ExCiProxy.Web, :controller

  def index(conn, _status_params) do
    text conn, "Ok"
  end
end
