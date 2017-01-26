defmodule PhoenixDown.Post do
  @moduledoc """
  Converts Genserver posts response into easily to manage structs
  """
  @type t :: %__MODULE__{
    key: String.t,
    title: String.t,
    html: String.t,
    posted_at: Calendar.DateTime.t
  }

  defstruct [
    key: nil,
    title: nil,
    html: nil,
    posted_at: nil
  ]

  @spec build(List.t) :: list(t)
  @doc """
  """
  def build(posts) when is_list(posts), do: wrap_each(posts)

  @spec build({String.t, String.t, String.t, Calendar.DateTime.t}) :: t
  @doc """
  """
  def build({key, title, html, datetime}) do
    %__MODULE__{
      key: key,
      title: title,
      html: html,
      posted_at: datetime
    }
  end

  defp wrap_each(elements) do
    elements |> Enum.map(&(__MODULE__.build(&1)))
  end
end
