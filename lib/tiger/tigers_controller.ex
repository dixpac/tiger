defmodule Tiger.TigersController do
  def index(conv) do
    %{ conv | status: 200, body: "Tigers..." }
  end

  def show(conv, %{"id" => id}) do
    %{ conv | status: 200, body: "Tiger #{id}" }
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201, body: "Created a #{type} animal named: #{name}" }
  end
end
