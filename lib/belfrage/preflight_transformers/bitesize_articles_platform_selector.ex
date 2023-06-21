defmodule Belfrage.PreflightTransformers.BitesizeArticlesPlatformSelector do
  use Belfrage.Behaviours.Transformer

  @webcore_test_ids [
    "zm8fhbk",
    "zjykkmn",
    "zj8yydm",
    "zwdtrwx",
    "z6x992p",
    "zgd682p",
    "z43njhv",
    "z4k8bdm",
    "z4mp2sg",
    "z6mj47h",
    "z7b9scw",
    "z7vcpg8",
    "z7yrhbk",
    "zbd2cqt",
    "zbfknrd",
    "zbjymfr",
    "zbq6kmn",
    "zbr7rj6",
    "zd3jrj6",
    "zdbtqp3",
    "zdxnjhv",
    "zh8cy9q",
    "zhb9382",
    "zhqbxyc",
    "zhrhjhv",
    "zjqbnrd",
    "zjqnjhv",
    "zjw9382",
    "zkb747h",
    "zkkr7nb",
    "zkvwgwx",
    "zmgkf4j",
    "zmyrf4j",
    "znhf7nb",
    "znkqgwx",
    "znn3pg8",
    "znncpg8",
    "znprhbk",
    "zntwcqt",
    "znvwgwx",
    "zr2yt39",
    "zr6sqp3"
  ]

  @webcore_live_ids [
    "zj8yydm",
    "z6x992p",
    "zgd682p",
    "z43njhv",
    "z4k8bdm",
    "z4mp2sg",
    "z6mj47h",
    "z7b9scw",
    "z7vcpg8",
    "z7yrhbk",
    "zbd2cqt",
    "zbfknrd",
    "zbjymfr",
    "zbq6kmn",
    "zbr7rj6",
    "zd3jrj6",
    "zdbtqp3",
    "zdxnjhv",
    "zh8cy9q",
    "zhb9382",
    "zhqbxyc",
    "zhrhjhv",
    "zjqbnrd",
    "zjqnjhv",
    "zjw9382",
    "zkb747h",
    "zkkr7nb",
    "zkvwgwx",
    "zmgkf4j",
    "zmyrf4j",
    "znhf7nb",
    "znkqgwx",
    "znn3pg8",
    "znncpg8",
    "znprhbk",
    "zntwcqt",
    "znvwgwx",
    "zr2yt39",
    "zr6sqp3"
  ]

  @impl Transformer
  def call(envelope = %Envelope{request: request}) do
    {:ok, Envelope.add(envelope, :private, %{platform: get_platform(request)})}
  end

  defp webcore_live_id?(id) do
    id in @webcore_live_ids
  end

  defp webcore_test_id?(id) do
    id in @webcore_test_ids
  end

  defp production_environment() do
    Application.get_env(:belfrage, :production_environment)
  end

  defp get_platform(%Envelope.Request{path_params: %{"id" => id}}) do
    cond do
      production_environment() == "live" and webcore_live_id?(id) ->
        "Webcore"

      production_environment() == "test" and webcore_test_id?(id) ->
        "Webcore"

      true ->
        "MorphRouter"
    end
  end

  defp get_platform(_request) do
    "MorphRouter"
  end
end
