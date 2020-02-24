defmodule Fixtures.Lambda do
  @kb 1024

  def lambda_resp(size_kb \\ 1) do
    body =
      :crypto.strong_rand_bytes(size_kb * @kb)
      |> binary_part(0, size_kb * @kb)

    %{
      "headers" => %{},
      "statusCode" => 200,
      "body" => body
    }
  end

  def gzip_lambda_resp(size_kb \\ 1) do
    body =
      :crypto.strong_rand_bytes(size_kb * @kb)
      |> :zlib.gzip()
      |> binary_part(0, size_kb * @kb)

    %{
      "headers" => %{"content-encoding" => "gzip"},
      "statusCode" => 200,
      "body" => body
    }
  end

  def base64_lambda_resp(size_kb \\ 1) do
    body =
      :crypto.strong_rand_bytes(size_kb * @kb)
      |> Base.encode64()
      |> binary_part(0, size_kb * @kb)

    %{
      "headers" => %{},
      "isBase64Encoded" => true,
      "statusCode" => 200,
      "body" => body
    }
  end

  def gzip_base64_lambda_resp(size_kb \\ 1) do
    body =
      :crypto.strong_rand_bytes(size_kb * @kb)
      |> :zlib.gzip()
      |> Base.encode64()
      |> binary_part(0, size_kb * @kb)

    %{
      "headers" => %{},
      "isBase64Encoded" => true,
      "statusCode" => 200,
      "body" => body
    }
  end

  def body_size(%{"body" => body}), do: byte_size(body)
end
