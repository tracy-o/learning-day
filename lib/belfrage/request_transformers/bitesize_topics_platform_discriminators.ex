defmodule Belfrage.RequestTransformers.BitesizeTopicsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize topic IDs that need to be served by Webcore.
  """
  use Belfrage.Behaviours.Transformer

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
    "z47h34j",
    "zrttyrd",
    "zxccwmn",
    "zqbbkqt",
    "z2gg87h",
    "zbxxsbk",
    "zyqqtfr",
    "zmccwmn",
    "zfjj6sg",
    "z4pp34j",
    "zdyycdm",
    "znddmp3",
    "z9nnb9q",
    "z3mmn39",
    "zt99q6f",
    "zswwxnb",
    "zkssgk7",
    "zmrrd2p",
    "zchhvcw",
    "zv22pv4",
    "zj339j6",
    "zhkk7ty",
    "z644jxs",
    "z8ffr82",
    "zwvv4wx",
    "zq6g4xs",
    "zpvw7yc",
    "z2hckty",
    "zn3j2v4",
    "zjxbcmn",
    "z7tr96f",
    "ztf8jsg",
    "zxn9dp3",
    "zhydqfr",
    "zmp48hv",
    "z6skwnb",
    "zsbqm39",
    "zs3j2v4",
    "zcdpf82",
    "z34xhcw",
    "zfbqm39",
    "z4wnydm",
    "zgktn9q",
    "zvcmtrd",
    "zb96p4j",
    "zkqf3j6",
    "z9jsvwx",
    "zr8hsk7",
    "zyg7xbk",
    "zc2tqfr",
    "z9brd2p",
    "zbjmdp3",
    "zmdj6sg",
    "zr76jsg",
    "zkgcwmn",
    "zs9sydm",
    "zdr4jxs",
    "z43g87h",
    "zwrw96f",
    "z9xp2v4",
    "zgqxwnb",
    "zxwqtfr",
    "z4mh7yc",
    "zr2c96f",
    "zhbthcw",
    "z24w6sg",
    "ztp3kqt",
    "z6hv9j6",
    "zwjxfg8",
    "znsb87h",
    "zvmgvwx",
    "z7c9q6f",
    "zs7mn39",
    "z9fv4wx",
    "zm982hv",
    "z24k7ty",
    "zqr4jxs",
    "zghnb9q"
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
    "z47h34j",
    "zrttyrd",
    "zxccwmn",
    "zqbbkqt",
    "z2gg87h",
    "zbxxsbk",
    "zyqqtfr",
    "zmccwmn",
    "zfjj6sg",
    "z4pp34j",
    "zdyycdm",
    "znddmp3",
    "z9nnb9q",
    "z3mmn39",
    "zt99q6f",
    "zswwxnb",
    "zkssgk7",
    "zmrrd2p",
    "zchhvcw",
    "zv22pv4",
    "zj339j6",
    "zhkk7ty",
    "z644jxs",
    "z8ffr82",
    "zwvv4wx",
    "zq6g4xs",
    "zpvw7yc",
    "z2hckty",
    "zn3j2v4",
    "zjxbcmn",
    "z7tr96f",
    "ztf8jsg",
    "zxn9dp3",
    "zhydqfr",
    "zmp48hv",
    "z6skwnb",
    "zsbqm39",
    "zs3j2v4",
    "zcdpf82",
    "z34xhcw",
    "zfbqm39",
    "z4wnydm",
    "zgktn9q",
    "zvcmtrd",
    "zb96p4j",
    "zkqf3j6",
    "z9jsvwx",
    "zr8hsk7",
    "zyg7xbk",
    "zc2tqfr",
    "z9brd2p",
    "zbjmdp3",
    "zmdj6sg",
    "zr76jsg",
    "zkgcwmn",
    "zs9sydm",
    "zdr4jxs",
    "z43g87h",
    "zwrw96f",
    "z9xp2v4",
    "zgqxwnb",
    "zxwqtfr",
    "z4mh7yc",
    "zr2c96f",
    "zhbthcw",
    "z24w6sg",
    "ztp3kqt",
    "z6hv9j6",
    "zwjxfg8",
    "znsb87h",
    "zvmgvwx",
    "z7c9q6f",
    "zs7mn39",
    "z9fv4wx",
    "zm982hv",
    "z24k7ty",
    "zqr4jxs",
    "zghnb9q"
  ]

  @impl Transformer
  def call(struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) do
    {:ok, maybe_update_origin(id, struct)}
  end

  def call(struct = %Struct{request: %Struct.Request{path_params: %{"id" => id, "year_id" => year_id}}}) do
    if year_id in @valid_year_ids do
      {:ok, maybe_update_origin(id, struct)}
    else
      {:ok, struct}
    end
  end

  def call(struct), do: {:ok, struct}

  defp is_webcore_id(id) do
    application_env = Application.get_env(:belfrage, :production_environment)

    if application_env === "live" do
      id in @webcore_live_ids
    else
      id in @webcore_test_ids
    end
  end

  defp maybe_update_origin(id, struct) do
    if is_webcore_id(id) do
      Struct.add(struct, :private, %{
        platform: Webcore,
        origin: Application.get_env(:belfrage, :pwa_lambda_function)
      })
    else
      struct
    end
  end
end
