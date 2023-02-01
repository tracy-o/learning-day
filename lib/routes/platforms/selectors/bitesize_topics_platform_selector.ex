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
    "zghnb9q",
    "ztqtb9q",
    "zffhmfr",
    "z3p3d2p",
    "zsxs4wx",
    "zxwxvcw",
    "z939mp3",
    "z8g86sg",
    "zq4jpv4",
    "zdrdtfr",
    "zbnbwmn",
    "zcyc7ty",
    "z79qn39",
    "ztxqxg8",
    "zh676rd",
    "zpt2tcw",
    "zycmp9q",
    "znhmh4j",
    "zv96s82",
    "zspxp9q"
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
    "zghnb9q",
    "ztqtb9q",
    "zffhmfr",
    "z3p3d2p",
    "zsxs4wx",
    "zxwxvcw",
    "z939mp3",
    "z8g86sg",
    "zq4jpv4",
    "zdrdtfr",
    "zbnbwmn",
    "zcyc7ty",
    "z79qn39",
    "ztxqxg8",
    "zh676rd",
    "zpt2tcw",
    "zycmp9q",
    "znhmh4j",
    "zv96s82",
    "zspxp9q"
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
