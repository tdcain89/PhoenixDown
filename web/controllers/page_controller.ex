defmodule PhoenixDown.PageController do
  use PhoenixDown.Web, :controller

  def index(conn, _params) do
    #raise read_directory
    render conn, "index.html", posts: posts 
  end
  
  def detail(conn, %{"p" => post_key}) do
    {keymaster, title, html, date} = PhoenixDown.PostServer.single_post(post_key)
    render conn, "detail.html", title: title, html: html, date: date
  end
  
  defp posts do
    PhoenixDown.PostServer.get
  end
end
