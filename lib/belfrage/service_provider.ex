defmodule Belfrage.ServiceProvider do
  alias Belfrage.{Services, Behaviours.ServiceProvider}

  @behaviour ServiceProvider

  @impl ServiceProvider
  def service_for(origin) do
    case origin =~ ~r/^http(s)?:\/\// do
      true -> Services.HTTP
      false -> Services.Lambda
    end
  end
end
