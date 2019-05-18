defmodule Tiger.TigersController do

  alias Tiger.Animals
  alias Tiger.Tiger

  @templates_path Path.expand("templates", File.cwd!)

  def index(conv) do
    tigers =
      Animals.list_tigers()
      |> Enum.sort(&Tiger.sort_by_name/2)

    content =
      @templates_path
      |> Path.join("index.eex")
      |> EEx.eval_file(tigers: tigers)

    %{ conv | status: 200, body: content }
  end

  def show(conv, %{"id" => id}) do
    tiger = Animals.find_tiger(id)

    content =
      @templates_path
      |> Path.join("show.eex")
      |> EEx.eval_file(tiger: tiger)

    %{ conv | status: 200, body: content }
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201, body: "Created a #{type} animal named: #{name}" }
  end
end
