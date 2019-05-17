defmodule Tiger.FileHandler do
  @moduledoc "Handles reading stataic files"

  def handle_file({:ok, content}, conv) do
    %{ conv | status: 200, body: content }
  end

  def handle_file({:error, :enoent}, conv) do
    %{ conv | status: 404, body: "File not found" }
  end

  def handle_file({:error, reason}, conv) do
    %{ conv | status: 500, body: reason}
  end
end
