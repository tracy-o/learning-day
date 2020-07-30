defmodule Fixtures.DialConfig do
  def dial_config(dial_name) do
    [
      %{
        "name" => dial_name,
        "description" => "A generic dial in a stubbed dial config",
        "default-value" => "false",
        "values" => [
          %{
            "value" => "true",
            "description" => "does something"
          },
          %{
            "value" => "false",
            "description" => "does not do something"
          }
        ]
      }
    ]
  end
end
