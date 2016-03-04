defmodule PhoenixDown.PageController do
  use PhoenixDown.Web, :controller

  def index(conn, _params) do
    #raise read_directory
    render conn, "index.html", posts: posts 
  end
  
  defp posts do
    PhoenixDown.PostServer.get
  end
end
