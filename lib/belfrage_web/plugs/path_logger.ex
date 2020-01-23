defmodule BelfrageWeb.Plugs.PathLogger do

  def init(opts), do: opts

  def call(conn, _opts) do
    # get the path out of the connection
    # add that path to log.metadata(path: 'a/path/here'), or at least add it to stump first
    # test by changing the logging level and output in the config/dev
  end

end
