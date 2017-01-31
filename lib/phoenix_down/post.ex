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
    tags: List.t
  }

  defstruct [
    key: nil,
    title: nil,
    html: nil,
    posted_at: nil,
    author: nil,
    tags: []
  ]

  @spec build(List.t) :: list(t)
  @doc """
  """
  def build(posts) when is_list(posts), do: wrap_each(posts)

  @spec build({String.t, String.t, String.t, Calendar.DateTime.t, String.t, map}) :: t
  @doc """
  """
  def build(nil), do: %__MODULE__{}
  def build({key, title, html, datetime, author, meta_data}) do
    {meta_title, meta_author, tags} = parse_meta_data(meta_data)

    %__MODULE__{
      key: key,
      title: meta_title || title,
      html: html,
      posted_at: datetime,
      author: meta_author || author,
      tags: tags
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
end
