defmodule Tiger.View do

  @templates_path Path.expand("templates", File.cwd!)

  def render(conv, template, bindings \\ []) do
    content =
      @templates_path
      |> Path.join("#{template}.eex")
      |> EEx.eval_file(bindings)

    %{ conv | status: 200, body: content }
  end
end
