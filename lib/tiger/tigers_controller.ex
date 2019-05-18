defmodule Tiger.TigersController do

  alias Tiger.Animals

  def index(conv) do
    records =
      Animals.list_tigers
      |> Enum.sort(fn(t1, t2) -> t1.name <= t2.name end)
      |> Enum.map(fn(t) -> "<li>#{t.name} - #{t.type}</li>" end)
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
