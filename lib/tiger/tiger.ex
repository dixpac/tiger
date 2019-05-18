defmodule Tiger.Tiger do
  defstruct id: nil, name: "", type: ""

  def sort_by_name(t1, t2) do
    t1.name <= t2.name
  end
end
