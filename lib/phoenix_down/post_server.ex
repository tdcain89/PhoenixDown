defmodule PhoenixDown.PostServer do
  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__] ++ opts)
  end

  def init(_) do
    {:ok, all_posts}
  end

  def handle_call({:get}, _from, v) do
    {:reply, v, v}
  end

  def get do
    GenServer.call(__MODULE__, {:get})
  end

  def all_posts do
    read_directory
    |> parse_list
  end
  
  defp get_post(file) do
    {:ok, str} = File.read("web/static/markdown/#{file}")
    Earmark.to_html(str)
  end
  
  defp read_directory do
    {:ok, list} = File.ls("web/static/markdown")
    list
  end
  
  defp parse_list(list) do
    List.first(list) |> get_post
  end
end
