defmodule Belfrage.DialConfig do
  @dial_name_handler_mapping Application.get_env(:belfrage, :dial_handlers)

  defmacro __before_compile__(env) do
    Module.register_attribute(env.module, :dial_defaults, accumulate: true)

    Application.app_dir(:belfrage, "priv/static/dials.json")
    |> File.read!()
    |> Jason.decode!()
    |> Enum.each(fn dial ->
      dial_logic_mod = @dial_name_handler_mapping[dial["name"]]

      unless is_nil(dial_logic_mod),
        do: Module.put_attribute(env.module, :dial_defaults, {dial_logic_mod, dial["name"], dial["default-value"]})
    end)

    quote do
      def dial_config, do: @dial_defaults
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Belfrage.DialConfig

      @before_compile Belfrage.DialConfig
    end
  end
end
