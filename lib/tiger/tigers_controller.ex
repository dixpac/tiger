defmodule Tiger.TigersController do

  alias Tiger.Animals
  alias Tiger.Tiger

  @templates_path Path.expand("templates", File.cwd!)

  defp render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join("#{template}.eex")
      |> EEx.eval_file(bindings)

    %{ conv | status: 200, body: content }
  end

  def index(conv) do
    tigers = Animals.list_tigers() |> Enum.sort(&Tiger.sort_by_name/2)

    render(conv, "index", tigers: tigers)
  end

  def show(conv, %{"id" => id}) do
    tiger = Animals.find_tiger(id)

    render(conv, "show", tiger: tiger)
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201, body: "Created a #{type} animal named: #{name}" }
  end
end
