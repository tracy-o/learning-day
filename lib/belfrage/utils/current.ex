defmodule Belfrage.Utils.Current do
  @delegate Application.get_env(:belfrage, :date_time)

  def date_time do
    @delegate.date_time()
  end
end
