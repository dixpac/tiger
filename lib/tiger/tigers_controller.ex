defmodule Tiger.TigersController do

  import Tiger.View, only: [render: 3]

  alias Tiger.Animals
  alias Tiger.Tiger


  def index(conv) do
    tigers = Animals.list_tigers() |> Enum.sort(&Tiger.sort_by_name/2)

    render(conv, "index", tigers: tigers)
  end

  def show(conv, %{"id" => id}) do
    tiger = Animals.find_tiger(id)

    render(conv, "show", tiger: tiger)
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201, body: "Created a #{type} tiger named #{name}" }
  end
end
