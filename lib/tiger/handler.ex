defmodule Tiger.Handler do

  @moduledoc "Handles HTTP requests"

  alias Tiger.Conv

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

  def route(%Conv{ method: "GET", path: "/siberians" } = conv) do
    %{ conv | status: 200, body: "Siberian tigers..." }
  end

  def route(%Conv{ method: "GET", path: "/bengals" } = conv) do
    %{ conv | status: 200, body: "Bengal tigers..." }
  end

  def route(%Conv{ method: "GET", path: "/bengals/" <> id } = conv) do
    %{ conv | status: 200, body: "Bengal tiger #{id}" }
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%Conv{ path: path } = conv) do
    %{ conv | status: 404, body: "No #{path} tigers" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}
    Content-Type: text/html
    Content-Lenght: #{String.length(conv.body)}

    #{conv.body}
    """
  end
end

request = """
GET /siberians HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Tiger.Handler.handle(request)
IO.puts response

request = """
GET /bengals HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Tiger.Handler.handle(request)
IO.puts response

request = """
GET /bengals/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Tiger.Handler.handle(request)
IO.puts response

request = """
GET /wolfs HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Tiger.Handler.handle(request)
IO.puts response

request = """
GET /about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""
response = Tiger.Handler.handle(request)
IO.puts response
