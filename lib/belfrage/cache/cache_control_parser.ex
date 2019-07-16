defmodule Belfrage.Cache.CacheControlParser do
  alias Belfrage.Struct

  def parse(response = %Struct.Response{}) do
    # TODO: parse cache-control response header value
    response.headers["cache-control"]
  end
end
