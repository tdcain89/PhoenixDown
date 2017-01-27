defmodule PhoenixDown.PostTest do
  use ExUnit.Case

  alias PhoenixDown.Post

  test """
  build/1 returns defaults when nil is passed
  """ do
    post = Post.build(nil)
    assert is_nil(post.title)
  end

  test """
  build/1 returns a list of structs given a list of tuples
  """ do
    posts = [
      {"post", "Post", "Test test test", nil, "James"},
      {"post_2", "Post 2", "Testing", nil, "Mindy"},
    ]
    post_structs = Post.build(posts)
    assert Enum.count(post_structs) == 2
  end
end
