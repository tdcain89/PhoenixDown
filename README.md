# PhoenixDown
A lightweight blog engine powered by Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `phoenix_down` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:phoenix_down, "~> 0.1.0"}]
end
```

### Using in a Phoenix Application
Start the `PhoenixDown.PostServer` on application start:
```
defmodule TestBlog do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(TestBlog.Endpoint, []),
      worker(PhoenixDown.PostServer, []),
    ]

    opts = [strategy: :one_for_one, name: TestBlog.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TestBlog.Endpoint.config_change(changed, removed)
    :ok
  end
end
```

### Configure the directory that will house all of your markdown blog posts.
```
config :phoenix_down,
  markdown_directory: "web/static/markdown"
```

### Use in controller
Use `PhoenixDown.PostServer.get` to fetch all the markdown posts in the directory
you specified in the config.

#### Example Controller:
```
defmodule TestBlog.PageController do
  use TestBlog.Web, :controller

  def index(conn, _params) do
    render conn, "index.html", posts: posts()
  end

  defp posts do
    PhoenixDown.PostServer.get
  end
end
```

### Grabbing a single post by key
Posts are stored in ETS and are accessible by key

```
def detail(conn, %{"p" => post_key} = params) do
  post = PhoenixDown.PostServer.single_post(post_key)
  render conn, "detail.html", post: post
end
```

## Pending Features:
- [ ] Archive directory
- [ ] Truncated article text for use on indexes
- [ ] Support for authors/other potential meta data?
