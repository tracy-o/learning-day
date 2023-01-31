defmodule Routes.Platforms.Selectors.BitesizeTopicsPlatformSelector do
  alias Belfrage.Struct.Request

  @behaviour Routes.Platforms.Selector

  @valid_year_ids [
    "zjpqqp3",
    "z7s22sg",
    "zmyxxyc",
    "z63tt39",
    "zhgppg8",
    "zncsscw"
  ]

  @webcore_test_ids [
    "z82hsbk",
    "zwv39j6",
    "zhtcvk7",
    "zgdmsbk",
    "zv9qhyc",
    "zxfrwmn",
    "zgwxfg8",
    "zcj6yrd",
    "z4qtvcw",
    "zk2pb9q",
    "zjty4wx",
    "ztv4q6f",
    "z47h34j"
  ]

  @webcore_live_ids [
    "zhtcvk7",
    "zgdmsbk",
    "zv9qhyc",
    "zxfrwmn",
    "zgwxfg8",
    "zcj6yrd",
    "z4qtvcw",
    "zk2pb9q",
    "zjty4wx",
    "ztv4q6f",
    "z47h34j"
  ]

  @impl Routes.Platforms.Selector
  def call(%Request{path_params: %{"year_id" => year_id, "id" => id}}) do
    cond do
      valid_year?(year_id) and production_environment() == "live" and webcore_live_id?(id) ->
        {:ok, "Webcore"}

      valid_year?(year_id) and production_environment() == "test" and webcore_test_id?(id) ->
        {:ok, "Webcore"}

      true ->
        {:ok, "MorphRouter"}
    end
  end

  def call(%Request{path_params: %{"id" => id}}) do
    cond do
      production_environment() == "live" and webcore_live_id?(id) ->
        {:ok, "Webcore"}

      production_environment() == "test" and webcore_test_id?(id) ->
        {:ok, "Webcore"}

      true ->
        {:ok, "MorphRouter"}
    end
  end

  def call(_request) do
    {:ok, "MorphRouter"}
  end

  defp webcore_live_id?(id) do
    id in @webcore_live_ids
  end

  defp webcore_test_id?(id) do
    id in @webcore_test_ids
  end

  defp valid_year?(id) do
    id in @valid_year_ids
  end

  defp production_environment() do
    Application.get_env(:belfrage, :production_environment)
  end
end
