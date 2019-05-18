defmodule HandlerTest do
  use ExUnit.Case

  import Tiger.Handler, only: [handle: 1]

  test "GET /tigers" do
    request = """
    GET /tigers HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 126\r
    \r
    <h3>Tigers</h3>

    <ul>
      <li>Andy - Siberian</li>
      <li>Carl - Bengal</li>
      <li>Franz - Siberian</li>
    </ul>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /unknown" do
    request = """
    GET /unknown HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 404 Not Found\r
    Content-Type: text/html\r
    Content-Length: 16\r
    \r
    No /unknown here
    """
  end

  test "GET /tigers/1" do
    request = """
    GET /tigers/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 48\r
    \r
    <h3>Tiger</h3>
    <p>ID: 1</p>
    <p>Name: Franz</p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "GET /about" do
    request = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """

    response = handle(request)

    expected_response = """
    HTTP/1.1 200 OK\r
    Content-Type: text/html\r
    Content-Length: 25\r
    \r
    <p>I'm a static page</p>
    """

    assert remove_whitespace(response) == remove_whitespace(expected_response)
  end

  test "POST /animals" do
    request = """
    POST /animals HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r
    \r
    name=Mike&type=Siberian
    """

    response = handle(request)

    assert response == """
    HTTP/1.1 201 Created\r
    Content-Type: text/html\r
    Content-Length: 35\r
    \r
    Created a Siberian tiger named Mike
    """
  end

  defp remove_whitespace(text) do
    String.replace(text, ~r{\s}, "")
  end 
end

