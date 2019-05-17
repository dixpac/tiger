defmodule Tiger.Parser do
  @moduledoc "Parse HTTP request"

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %{ method: method, path: path, status: nil, body: "" }
  end
end
