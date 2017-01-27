defmodule PhoenixDown.PostServerTest do
  use ExUnit.Case
  doctest PhoenixDown

  alias PhoenixDown.PostServer

  setup_all do
    {:ok, _pid} = PostServer.start_link
    :ok
  end

  test """
  get/0 grabs existing markdown files and reads them into %PhoenixDown.Post{} structs
  """ do
    posts = PostServer.get
    [first_post|_] = posts
    assert Enum.count(posts) == 1
    assert first_post.html =~ "Test Markdown file"
    refute is_nil(first_post.posted_at)
    refute is_nil(first_post.title)
    refute is_nil(first_post.key)
  end

  @tag :skip
  test """
  get/0 raises an error if the configured directory is incorrect
  """ do
    Application.put_env(:phoenix_down, :markdown_directory, "bad")
    assert_raise RuntimeError, "Markdown Directory not found. Please check your configuration files.", fn ->
      PostServer.get
    end
  end

  test """
  single_post/1 returns a single %PhoenixDown.Post{} struct given an existing `id`
  """ do
    posts = PostServer.get
    [first_post|_] = posts

    found_post = PostServer.single_post(first_post.key)
    refute is_nil(found_post.title)
  end
end
