defmodule Tiger.Handler do

  @moduledoc "Handles HTTP requests"

  alias Tiger.Conv
  alias Tiger.TigersController

  @pages_path Path.expand("pages", File.cwd!)

  import Tiger.Plugins, only: [ log: 1, track: 1 ]
  import Tiger.Parser
  import Tiger.FileHandler

  @doc "Transforms request into the response."
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{ method: "GET", path: "/tigers" } = conv) do
    TigersController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/tigers/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    TigersController.show(conv, params)
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ method: "POST", path: "/animals" } = conv) do
    TigersController.create(conv, conv.params)
  end

  def route(%Conv{ path: path } = conv) do
    %{ conv | status: 404, body: "No #{path} here" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{String.length(conv.body)}\r
    \r
    #{conv.body}
    """
  end
end
