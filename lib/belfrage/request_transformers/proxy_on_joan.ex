defmodule Belfrage.RequestTransformers.ProxyOnJoan do
  use Belfrage.Behaviours.Transformer

  @moduledoc """
    Previously all `/news/*` traffic articles that weren't specifically sent to
    Bruce from the GTM (e.g. `/news/articles`, `/news/live` etc), were sent to
    Mozart. Mozart would try to handle this traffic, but if it couldn't and it
    thought belfrage could it would send it to Bruce which would then try to
    service the request.

    We have now introduced a new Belfrage stack called Joan which will sit
    infront of Mozart. It will take `/news/*` traffic and proxy it to Mozart.

    We have to make Joans behaviour differ so that all of its traffic is sen
    directly to Mozart. Otherwise we could end up with a situation where Joan
    Belfrage acts exactly like Bruce belfrage and tried to forward a request to
    Pres rather than giving to Mozart.
  """

  @impl Transformer
  def call(envelope) do
    if stack_id() == "joan" do
      {
        :ok,
        Envelope.add(envelope, :private, %{
          platform: "MozartNews",
          origin: Application.get_env(:belfrage, :mozart_news_endpoint)
        })
      }
    else
      {:ok, envelope}
    end
  end

  defp stack_id() do
    Application.get_env(:belfrage, :stack_id)
  end
end
