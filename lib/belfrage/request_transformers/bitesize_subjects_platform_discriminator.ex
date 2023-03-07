defmodule Belfrage.RequestTransformers.BitesizeSubjectsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform and Origin for a subset of Bitesize Subjects IDs that need to be served by Webcore.
  """
  use Belfrage.Behaviours.Transformer

  @webcore_test_ids [
    "zxtnvcw",
    "zmpfb9q",
    "zphybqt",
    "zhtf3j6",
    "z7mtsbk",
    "zvsc96f",
    "z8yrwmn",
    "zjcdxnb",
    "znwqtfr",
    "zmj2n39",
    "zdmtsbk",
    "zft3d2p",
    "zf48q6f",
    "zg9jtfr",
    "z3vrwmn",
    "zykw2hv",
    "zxtbng8",
    "zk6pyrd",
    "zb3cjxs",
    "zt3rkqt",
    "zhbc87h",
    "zkpv9j6",
    "zgb4q6f",
    "zc7xpv4",
    "zgj2tfr",
    "zqnygk7",
    "z2f3cdm",
    "z426n39",
    "zcrk2hv",
    "z4c8mp3",
    "zv6sr82",
    "z7svr82",
    "zm6wfg8",
    "z94dxnb",
    "zf9d7ty",
    "z3cr9j6",
    "zrdv3k7",
    "z8hscj6",
    "zsykb82",
    "z8mfsk7",
    "z37qtfr",
    "z8rdtfr",
    "zkxhfg8",
    "z6vg9j6",
    "zwpfb9q",
    "zrqmhyc",
    "z9frq6f",
    "zs48q6f",
    "zydqpbk",
    "z9xhfg8",
    "zvcjpv4",
    "z4bt4wx",
    "z76ngk7",
    "zdgk2hv",
    "zdhs34j",
    "zxyb4wx",
    "z7f3cdm",
    "zqxpb9q",
    "zmyb4wx",
    "zdcwhyc",
    "z7nygk7",
    "z2tsr82",
    "z33d7ty",
    "z9mtsbk",
    "zrg97ty",
    "zr3t4wx",
    "z4ygxnb",
    "zx2vw6f",
    "zy9d7ty",
    "zjpfb9q",
    "z8tnvcw",
    "z2svr82",
    "zjnygk7",
    "zkmngk7",
    "zmf3cdm",
    "zxpy4wx",
    "zwbkxnb",
    "zdsb87h",
    "z76sr82",
    "z72mn39",
    "zbhy4wx",
    "zfhbwmn",
    "zx394xs",
    "z2mxsbk",
    "zmx6fg8",
    "zmhfcdm",
    "zdmtsbk",
    "zhs3kqt",
    "zst3d2p",
    "z2w7pv4",
    "z3tfcdm",
    "zwr8mp3",
    "z4crr2p",
    "zdj2tfr",
    "zq26n39",
    "zpdj6sg",
    "zkfgd2p",
    "zmv4cmn",
    "zd8kkty",
    "zypgcmn",
    "zwd88hv",
    "zmdq92p",
    "zv7dr2p",
    "zhhwt39",
    "znnqpg8",
    "zbghbdm",
    "z4ngr2p",
    "zrghbdm",
    "zgh2qfr",
    "zjwbd6f",
    "zyjkbqt",
    "z7kwcqt",
    "zdm3nrd",
    "z88vf82",
    "zmxqkmn",
    "zbrscqt",
    "zv3jmfr",
    "zhbfd6f",
    "zfw9bdm",
    "zksyb82",
    "z4hmwty",
    "zd4png8",
    "zv7dcqt",
    "zsbxqfr",
    "z39n6g8",
    "z6sjkty",
    "zjjfp4j",
    "zpv2wnb",
    "zxsvr82",
    "z39d7ty",
    "zhy7dp3",
    "zw9wy4j",
    "zwxhfg8",
    "zsbc87h",
    "zfhbr2p",
    "z7tnvcw",
    "zst3g7h",
    "zmbff4j",
    "zr99cqt",
    "zvryt39",
    "z7mbcmn",
    "zqsv7p3",
    "z7syg2p",
    "zbhv8xs",
    "z338jsg",
    "zrnbwty",
    "znqtbdm"
  ]

  @webcore_live_ids [
    "zxtnvcw",
    "zmpfb9q",
    "zphybqt",
    "zhtf3j6",
    "z7mtsbk",
    "zvsc96f",
    "z8yrwmn",
    "zjcdxnb",
    "znwqtfr",
    "zmj2n39",
    "zft3d2p",
    "zf48q6f",
    "zg9jtfr",
    "z3vrwmn",
    "zykw2hv",
    "zxtbng8",
    "zk6pyrd",
    "zb3cjxs",
    "zt3rkqt",
    "zhbc87h",
    "zkpv9j6",
    "zgb4q6f",
    "zc7xpv4",
    "zgj2tfr",
    "zqnygk7",
    "z2f3cdm",
    "z426n39",
    "zcrk2hv",
    "z4c8mp3",
    "zv6sr82",
    "z7svr82",
    "zm6wfg8",
    "z94dxnb",
    "zf9d7ty",
    "z3cr9j6",
    "zrdv3k7",
    "z8hscj6",
    "zsykb82",
    "z8mfsk7",
    "z37qtfr",
    "z8rdtfr",
    "zkxhfg8",
    "z6vg9j6",
    "zwpfb9q",
    "zrqmhyc",
    "z9frq6f",
    "zs48q6f",
    "zydqpbk",
    "z9xhfg8",
    "zvcjpv4",
    "z4bt4wx",
    "z76ngk7",
    "zdgk2hv",
    "zdhs34j",
    "zxyb4wx",
    "z7f3cdm",
    "zqxpb9q",
    "zmyb4wx",
    "zdcwhyc",
    "z7nygk7",
    "z2tsr82",
    "z33d7ty",
    "z9mtsbk",
    "zrg97ty",
    "zr3t4wx",
    "z4ygxnb",
    "zx2vw6f",
    "zy9d7ty",
    "zjpfb9q",
    "z8tnvcw",
    "z2svr82",
    "zjnygk7",
    "zkmngk7",
    "zmf3cdm",
    "zxpy4wx",
    "zwbkxnb",
    "zdsb87h",
    "z76sr82",
    "z72mn39",
    "zbhy4wx",
    "zfhbwmn",
    "zx394xs",
    "z2mxsbk",
    "zmx6fg8",
    "zmhfcdm",
    "zdmtsbk",
    "zhs3kqt",
    "zst3d2p",
    "z2w7pv4",
    "z3tfcdm",
    "zwr8mp3",
    "z4crr2p",
    "zdj2tfr",
    "zq26n39",
    "zpdj6sg",
    "zkfgd2p",
    "zmv4cmn",
    "zd8kkty",
    "zypgcmn",
    "zwd88hv",
    "zmdq92p",
    "zv7dr2p",
    "zhhwt39",
    "znnqpg8",
    "zbghbdm",
    "z4ngr2p",
    "zrghbdm",
    "zgh2qfr",
    "zjwbd6f",
    "zyjkbqt",
    "z7kwcqt",
    "zdm3nrd",
    "z88vf82",
    "zmxqkmn",
    "zbrscqt",
    "zv3jmfr",
    "zhbfd6f",
    "zfw9bdm",
    "zksyb82",
    "z4hmwty",
    "zd4png8",
    "zv7dcqt",
    "zsbxqfr",
    "z39n6g8",
    "z6sjkty",
    "zjjfp4j",
    "zpv2wnb",
    "zxsvr82",
    "z39d7ty",
    "zhy7dp3",
    "zw9wy4j",
    "zwxhfg8",
    "zsbc87h",
    "zfhbr2p",
    "z7tnvcw",
    "zst3g7h",
    "zmbff4j",
    "zr99cqt",
    "zvryt39",
    "z7mbcmn",
    "zqsv7p3",
    "z7syg2p",
    "zbhv8xs",
    "z338jsg",
    "zrnbwty",
    "znqtbdm"
  ]

  @impl Transformer
  def call(envelope = %Envelope{request: %Envelope.Request{path_params: %{"id" => id}}}) do
    {:ok, maybe_update_origin(id, envelope)}
  end

  def call(envelope), do: {:ok, envelope}

  defp is_webcore_id(id) do
    application_env = Application.get_env(:belfrage, :production_environment)

    if application_env === "live" do
      id in @webcore_live_ids
    else
      id in @webcore_test_ids
    end
  end

  defp maybe_update_origin(id, envelope) do
    if is_webcore_id(id) do
      Envelope.add(envelope, :private, %{
        platform: "Webcore",
        origin: Application.get_env(:belfrage, :pwa_lambda_function)
      })
    else
      envelope
    end
  end
end
