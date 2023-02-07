defmodule Belfrage.Utils.Current do
  @delegate Application.compile_env(:belfrage, :date_time)

  def date_time do
    @delegate.date_time()
  end
end
