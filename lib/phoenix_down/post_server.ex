defmodule PhoenixDown.PostServer do
  use GenServer
  use Timex

  @post_table :post_table

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__] ++ opts)
  end

  def init(_) do
    :ets.new @post_table, [:named_table, :ordered_set,  :protected, read_concurrency: true]
    
    {:ok, all_posts}
  end

  def handle_call({:get}, _from, v) do
    {:reply, v, v}
  end

  def get do
    GenServer.call(__MODULE__, {:get})
  end
  
  def single_post(key_match) do
    List.first(:ets.lookup(@post_table, key_match))
  end

  def all_posts do
    read_directory
    |> parse_list
  end
  
  defp get_post_html(file) do
    {:ok, str} = File.read("web/static/markdown/#{file}")
    Earmark.to_html(str)
  end
  
  defp get_post_date(file) do
    {:ok, stats} = File.stat("web/static/markdown/#{file}")
    {:ok, date} = stats.ctime |> formatted_date
    date
  end
  
  defp read_directory do
    {:ok, list} = File.ls("web/static/markdown")
    list
  end
  
  defp parse_list(list) do
    Enum.each list, fn(p) ->
      title_key = Regex.replace(~r/(.md)$/, p, "")
      :ets.insert @post_table, { title_key, title_key |> titleize, get_post_html(p), get_post_date(p)}
    end
    
    :ets.tab2list(@post_table)
  end
  
  defp formatted_date(time) do
    Date.from(time) |> DateFormat.format("%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end
  
  defp titleize(t) do
    Regex.replace(~r/_/, t, " ") |> String.capitalize
  end
end
