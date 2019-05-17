defmodule Tiger.Parser do

  @moduledoc "Parse HTTP request"

  alias Tiger.Conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")

    %Conv{ method: method, path: path, status: nil, body: "" }
  end
end
