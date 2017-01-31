defmodule PhoenixDown.PostServerTest do
  use ExUnit.Case
  doctest PhoenixDown

  alias PhoenixDown.PostServer

  setup_all do
    {:ok, _pid} = PostServer.start_link
    {
      :ok,
      %{
        posts: PostServer.get
      }
    }
  end

  test """
  get/0 grabs existing markdown files and reads them into %PhoenixDown.Post{} structs
  """, %{posts: posts} do
    [first_post|_] = posts
    assert Enum.count(posts) == 2
    assert first_post.html =~ "Testing test test"
    refute is_nil(first_post.posted_at)
    refute is_nil(first_post.title)
    refute is_nil(first_post.key)
    assert first_post.author == "Test Author"
  end

  test """
  single_post/1 returns a single %PhoenixDown.Post{} struct given an existing `id`
  """, %{posts: posts} do
    [first_post|_] = posts

    found_post = PostServer.single_post(first_post.key)
    refute is_nil(found_post.title)
  end

  test """
  Author can be first and last name
  """, %{posts: _posts} do
    post = PostServer.single_post("another_test")

    assert post.author == "Test Author"
    assert post.title == "Test Title"
  end
  
  test """
  MD file without meta info still parses
  """, %{posts: _posts} do
    post = PostServer.single_post("test")

    assert post.author == "Larry"
    assert post.title == "Test"
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
end
