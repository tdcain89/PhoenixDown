defmodule PhoenixDown.PageController do
  use PhoenixDown.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", markdown: get_post
  end
  
  
  defp get_post do
    {:ok, str} = File.read("web/static/markdown/test.md")
    Earmark.to_html(str)
  end
  
  defp read_directory do
    ls("web/static/markdown")
  end
end
