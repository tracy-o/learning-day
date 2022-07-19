defmodule Benchmark.Etag do
  @moduledoc """
  Peformance comparison of using different algorithms to generate an ETag.

  ### To run this experiment
  ```
  $ mix benchmark etag
  ```
  """

  import Fixtures.Lambda

  def run(_) do
    experiment()
  end

  def setup() do
    gzip_base64_lambda_resp(100)
  end

  def experiment(_iterations \\ 1000) do
    %{"body" => lambda_response_body} = setup()

    Benchee.run(
      %{
        "SHA-1" => fn -> etag(lambda_response_body, :sha1) end,
        "SHA-512" => fn -> etag(lambda_response_body, :sha512) end,
        "MD5" => fn -> etag(lambda_response_body, :md5) end
      },
      time: 10,
      memory_time: 2
    )
  end

  defp etag(binary, algorithm) do
    case algorithm do
      :sha1 -> :crypto.hash(:sha, binary) |> Base.encode16()
      :sha512 -> :crypto.hash(:sha512, binary) |> Base.encode16()
      :md5 -> :crypto.hash(:md5, binary) |> Base.encode16()
    end
  end
end
