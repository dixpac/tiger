defmodule Tiger.Plugins do

  @moduledoc "Plugins for transforming request"

  @doc "Log recived reques to STDOUT"
  def log(conv), do: IO.inspect conv

  @doc "Track 404 requests"
  def track(%{ status: 404, path: path } = conv) do
    IO.puts "Ooops...#{path} doesn't exist"
    conv
  end

  def track(conv), do: conv
end
