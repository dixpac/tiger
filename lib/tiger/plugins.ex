defmodule Tiger.Plugins do

  @moduledoc "Plugins for transforming request"

  alias Tiger.Conv

  @doc "Log recived reques to STDOUT"
  def log(%Conv{} = conv), do: IO.inspect conv

  @doc "Track 404 requests"
  def track(%Conv{ status: 404, path: path } = conv) do
    IO.puts "Ooops...#{path} doesn't exist"
    conv
  end

  def track(%Conv{} = conv), do: conv
end
