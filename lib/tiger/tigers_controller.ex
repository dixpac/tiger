defmodule Tiger.TigersController do

  alias Tiger.Animals
  alias Tiger.Tiger

  def tiger_record(tiger) do
    "<li>#{tiger.name} - #{tiger.type}</li>"
  end

  def index(conv) do
    records =
      Animals.list_tigers
      |> Enum.sort(&Tiger.sort_by_name/2)
      |> Enum.map(&tiger_record/1)
      |> Enum.join

    %{ conv | status: 200, body: "<ul>#{records}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    tiger = Animals.find_tiger(id)
    %{ conv | status: 200, body: "<h3>Tiger id #{tiger.id} - name: #{tiger.name} </h3>" }
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201, body: "Created a #{type} animal named: #{name}" }
  end
end
