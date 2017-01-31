defmodule PhoenixDown.Post do
  @moduledoc """
  Converts Genserver posts response into easily to manage structs
  """
  @type t :: %__MODULE__{
    key: String.t,
    title: String.t,
    html: String.t,
    posted_at: Calendar.DateTime.t,
    author: String.t,
    tags: List.t,
    friendly_url: String.t
  }

  defstruct [
    key: nil,
    title: nil,
    html: nil,
    posted_at: nil,
    author: nil,
    tags: [],
    friendly_url: nil
  ]

  @spec build(List.t) :: list(t)
  @doc """
  """
  def build(posts) when is_list(posts), do: wrap_each(posts)

  @spec build({String.t, String.t, String.t, pos_integer, String.t, map}) :: t
  @doc """
  """
  def build(nil), do: %__MODULE__{}
  def build({key, title, html, unix_time, author, meta_data}) do
    {meta_title, meta_author, tags} = parse_meta_data(meta_data)

    %__MODULE__{
      key: key,
      title: meta_title || title,
      html: html,
      posted_at: unix_time |> Calendar.DateTime.Parse.unix! |> Calendar.Strftime.strftime!("%a, %d %b %Y %H:%M:%S"),
      author: meta_author || author,
      tags: tags,
      friendly_url: create_friendly_url(key, unix_time)
    }
  end

  defp wrap_each(elements) do
    elements |> Enum.map(&(__MODULE__.build(&1)))
  end
  
  defp parse_meta_data(meta_data) do
    {
      meta_data["meta"]["title"],
      meta_data["meta"]["author"],
      String.split(meta_data["meta"]["tags"] || "", ",")
    }
  end
  
  def create_friendly_url(post_key, unix_time) do
    frienly_date = unix_time |> Calendar.DateTime.Parse.unix! |> Calendar.Strftime.strftime!("/%Y/%m/%d")
    friendly_key = String.replace(post_key, "_", "-")
    "#{frienly_date}/#{friendly_key}" 
  end
end
