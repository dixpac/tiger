defmodule Tiger.Animals do
  alias Tiger.Tiger

  def list_tigers do
    [
      %Tiger{id: 1, name: "Franz", type: "Siberian"},
      %Tiger{id: 1, name: "Carl", type: "Bengal"},
      %Tiger{id: 1, name: "Andy", type: "Siberian"}
    ]
  end

  def find_tiger(id) when is_integer(id) do
    Enum.find(list_tigers(), fn(t) -> t.id == id end)
  end

  def find_tiger(id) when is_binary(id) do
    id |> String.to_integer(id) |> find_tiger
  end
end
