defmodule Tiger.Parser do

  @moduledoc "Parse HTTP request"

  alias Tiger.Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\r\n\r\n")

    [request_line | header_lines] = String.split(top, "\r\n")
    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params_string)

    %Conv{
      method: method,
      path: path,
      headers: headers,
      params: params
    }
  end

  @doc """
  Parses a list of header fields into a map.

  ## Example
    iex> header_lines = ["A: 1", "B: 1"]
    iex> Tiger.Parser.parse_headers(header_lines)
    %{"A" => "1", "B" => "1"}
  """
  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, headers_so_far) ->
      [key, value] = String.split(line, ": ")
      Map.put(headers_so_far, key, value)
    end)
  end

  @doc """
  Parses param string in the form of `key1=value&key2=value` into a map with
  corresponding key and values.

  ## Examples
    iex> params_string = "name=Rocky&type=Siberian"
    iex> Tiger.Parser.parse_params("application/x-www-form-urlencoded", params_string)
    %{"name" => "Rocky", "type" => "Siberian"}
    iex> Tiger.Parser.parse_params("multipart/form-data", params_string)
    %{}
  """
  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string
    |> String.trim
    |> URI.decode_query
  end

  def parse_params(_, _), do: %{}
end
