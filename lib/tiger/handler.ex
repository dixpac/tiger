defmodule Tiger.Handler do

  @moduledoc "Handles HTTP requests"

  @pages_path Path.expand("../../pages", __DIR__)

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

  def route(%{ method: "GET", path: "/siberians" } = conv) do
    %{ conv | status: 200, body: "Siberian tigers..." }
  end

  def route(%{ method: "GET", path: "/bengals" } = conv) do
    %{ conv | status: 200, body: "Bengal tigers..." }
  end

  def route(%{ method: "GET", path: "/bengals/" <> id } = conv) do
    %{ conv | status: 200, body: "Bengal tiger #{id}" }
  end

  def route(%{ method: "GET", path: "/about" } = conv) do
    @pages_path
    |> Path.join("about.html")
    |> File.read
    |> handle_file(conv)
  end

  def route(%{ path: path } = conv) do
    %{ conv | status: 404, body: "No #{path} tigers" }
  end

  def format_response(conv) do
    """
    HTTP/1.1 #{conv.status} #{status_reason(conv.status)}
    Content-Type: text/html
    Content-Lenght: #{String.length(conv.body)}

    #{conv.body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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
