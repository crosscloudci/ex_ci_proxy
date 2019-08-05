defmodule ExCiProxy.PageView do
  use ExCiProxy.Web, :view
  def render("index.json", %{build_status: build_status}) do
    %{build_status: build_status}
  end
end
