defmodule Belfrage.PreflightTransformers.BitesizeGuidesPlatformSelector do
  use Belfrage.Behaviours.Transformer

  @webcore_test_ids [
    "zw3bfcw",
    "zwsffg8",
    "zcvy6yc",
    "zw7xfcw",
    "z9ppv4j",
    "z8ssbk7",
    "z9vvcwx",
    "z8bb9qt",
    "zt44wxs",
    "zyjjxsg",
    "zp44wxs",
    "ztrr82p",
    "z3qq6fr",
    "zskkqty",
    "zcttfrd",
    "zgxxnbk",
    "z8334j6",
    "zwyyrdm",
    "z3hhycw",
    "zgnn39q",
    "z377tyc",
    "zywwmnb",
    "zqccdmn",
    "zwggk7h",
    "z299j6f",
    "zx887hv",
    "z8nn39q",
    "z9hhycw",
    "z2334j6",
    "zwssbk7",
    "zpqq6fr",
    "ztwwmnb",
    "zs22hv4",
    "zyxxnbk",
    "z2bb9qt",
    "zqvvcwx",
    "zp99j6f",
    "zs887hv",
    "zc66sg8",
    "zgmmp39",
    "z8ppv4j",
    "z9ttfrd",
    "zg22hv4",
    "zcxxnbk",
    "z2c34j6",
    "z2gyrdm",
    "z32wmnb",
    "z8fhycw",
    "zghmp39",
    "zpd4wxs",
    "zqrvcwx",
    "zwkcdmn",
    "zyntfrd",
    "z3fpv4j",
    "z8cb9qt",
    "zxj87hv",
    "z9cb9qt",
    "zc4gk7h",
    "zsp6sg8",
    "zxtxnbk",
    "zchxnbk",
    "zckcdmn",
    "ztntfrd",
    "zx4gk7h",
    "zgfpv4j",
    "zp2jxsg",
    "zsmq6fr",
    "zwcb9qt",
    "z9yn39q",
    "zs7wmnb",
    "zsj87hv",
    "zwr34j6",
    "zyx7tyc"
  ]

  @webcore_live_ids [
    "z9ppv4j",
    "z8ssbk7",
    "z9vvcwx",
    "z8bb9qt",
    "zt44wxs",
    "zyjjxsg",
    "zp44wxs",
    "ztrr82p",
    "z3qq6fr",
    "zskkqty",
    "zcttfrd",
    "zgxxnbk",
    "z8334j6",
    "zwyyrdm",
    "z3hhycw",
    "zgnn39q",
    "z377tyc",
    "zywwmnb",
    "zqccdmn",
    "zwggk7h",
    "z299j6f",
    "zx887hv",
    "z8nn39q",
    "z9hhycw",
    "z2334j6",
    "zwssbk7",
    "zpqq6fr",
    "ztwwmnb",
    "zs22hv4",
    "zyxxnbk",
    "z2bb9qt",
    "zqvvcwx",
    "zp99j6f",
    "zs887hv",
    "zc66sg8",
    "zgmmp39",
    "z8ppv4j",
    "z9ttfrd",
    "zg22hv4",
    "zcxxnbk",
    "z2c34j6",
    "z2gyrdm",
    "z32wmnb",
    "z8fhycw",
    "zghmp39",
    "zpd4wxs",
    "zqrvcwx",
    "zwkcdmn",
    "zyntfrd",
    "z3fpv4j",
    "z8cb9qt",
    "zxj87hv",
    "z9cb9qt",
    "zc4gk7h",
    "zsp6sg8",
    "zxtxnbk",
    "zchxnbk",
    "zckcdmn",
    "ztntfrd",
    "zx4gk7h",
    "zgfpv4j",
    "zp2jxsg",
    "zsmq6fr",
    "zwcb9qt",
    "z9yn39q",
    "zs7wmnb",
    "zsj87hv",
    "zwr34j6",
    "zyx7tyc"
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
