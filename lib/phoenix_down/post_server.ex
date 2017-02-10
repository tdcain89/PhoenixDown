defmodule PhoenixDown.PostServer do
  use GenServer

  @post_table :post_table

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, [], [name: __MODULE__] ++ opts)
  end

  def init(_) do
    :ets.new @post_table, [:named_table, :ordered_set, :protected, read_concurrency: true]

    {:ok, all_posts()}
  end

  def handle_call({:get}, _from, v) do
    {:reply, v, v}
  end

  def get do
    __MODULE__
    |> GenServer.call({:get})
    |> PhoenixDown.Post.build
  end

  def single_post(key_match) do
    @post_table
    |> :ets.lookup(key_match)
    |> List.first
    |> PhoenixDown.Post.build
  end

  defp all_posts do
    read_directory()
    |> parse_list
    |> sorty
    |> reverse
  end

  defp get_post_html(file) do
    {:ok, str} = File.read("#{markdown_directory()}/#{file}")
    case String.split(str, "<end_meta>") do
      [meta, remaining_str] -> {YamlElixir.read_from_string(meta), Earmark.as_html!(remaining_str)}
      [remaining_str]       -> {%{}, Earmark.as_html!(remaining_str)}
      _                     -> {%{}, nil}
    end
  end

  defp get_post_date(file) do
    {:ok, stats} = File.stat("#{markdown_directory()}/#{file}", time: :posix)
    stats.mtime
  end

  defp read_directory do
    case File.ls("#{markdown_directory()}") do
      {:ok, list} -> list
      {:error, :enoent} -> raise "Markdown Directory not found. Please check your configuration files."
    end
  end

  defp parse_list(list) do
    Enum.each list, fn(p) ->
      {meta_data, html} = get_post_html(p)

      file_name = Regex.replace(~r/(.md)$/, p, "")
      [title_key|meta] = String.split(file_name, ".")
      author = meta |> List.first |> titleize

      :ets.insert @post_table, { title_key, title_key |> titleize, html, get_post_date(p), author, meta_data}
    end

    :ets.tab2list(@post_table)
  end

  defp titleize(t) do
    ~r/_/
    |> Regex.replace(t, " ")
    |> String.split(" ")
    |> Enum.map(&(String.capitalize(&1)))
    |> Enum.join(" ")
  end

  defp sorty(list) do
    List.keysort(list, 3)
  end

  # Reverse a list, put these somewhere else?
  defp foldLeft([], acc, _f), do: acc
  defp foldLeft([h | t], acc, f), do: foldLeft(t, f.(h, acc), f)
  defp reverse(l), do: foldLeft(l, [], fn (x, acc) -> [x | acc] end)

  defp markdown_directory do
    Application.get_env(:phoenix_down, :markdown_directory)
  end
end
