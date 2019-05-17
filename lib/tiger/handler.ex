defmodule Tiger.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method, path: path, status: nil, body: "" }
  end

  def log(conv), do: IO.inspect conv

  def route(conv) do
    route(conv, conv.method, conv.path)
  end

  def route(conv, "GET", "/siberians") do
    %{ conv | status: 200, body: "Siberian tigers..." }
  end

  def route(conv, "GET", "/bengals") do
    %{ conv | status: 200, body: "Bengal tigers..." }
  end

  def route(conv, "GET", "/bengals" <> id) do
    %{ conv | status: 200, body: "Bengal tiger #{id}" }
  end
def route(conv, _method, path) do
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
