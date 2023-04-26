defmodule Belfrage.RequestTransformers.NewsLivePlatformDiscriminatorTest do
  import Test.Support.Helper, only: [set_environment: 1]
  use ExUnit.Case

  alias Belfrage.RequestTransformers.NewsLivePlatformDiscriminator
  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Private}

  describe "NEWS - when with TIPO URL on TEST, show WebCore" do
    setup do
      set_environment("test")

      envelope = %Envelope{
        request: %Request{
          path: "/news/live/c1v596ken6vt",
          path_params: %{"asset_id" => "c1v596ken6vt"}
        },
        private: %Private{
          origin: Application.get_env(:belfrage, :mozart_news_endpoint),
          platform: MozartNews
        }
      }

      %{
        envelope: envelope
      }
    end

    test "origin and platform gets changed to webcore", %{envelope: envelope} do
      assert NewsLivePlatformDiscriminator.call(envelope) ==
               {:ok,
                Envelope.add(envelope, :private, %{
                  platform: "Webcore",
                  origin: Application.get_env(:belfrage, :pwa_lambda_function)
                }), {:replace, ["LambdaOriginAlias", "CircuitBreaker"]}}
    end
  end

  describe "NEWS - when TIPO URL on LIVE, show MozartNews" do
    setup do
      set_environment("live")

      envelope = %Envelope{
        request: %Request{
          path: "/news/live/c1v596ken6vt",
          path_params: %{"asset_id" => "c1v596ken6vt"}
        },
        private: %Private{
          origin: Application.get_env(:belfrage, :mozart_news_endpoint),
          platform: MozartNews
        }
      }

      %{
        envelope: envelope
      }
    end

    test "origin and platform remains as MozartNews", %{envelope: envelope} do
      assert NewsLivePlatformDiscriminator.call(envelope) ==
               {:ok,
                Envelope.add(envelope, :private, %{
                  platform: MozartNews,
                  production_environment: "live"
                })}
    end
  end

  describe "NEWS - when CPS URL with asset ID provided, show MozartNews on test" do
    setup do
      set_environment("test")

      envelope = %Envelope{
        request: %Request{
          path: "/news/live/uk-55930940",
          path_params: %{"asset_id" => "uk-55930940"}
        },
        private: %Private{
          origin: Application.get_env(:belfrage, :mozart_news_endpoint),
          platform: MozartNews
        }
      }

      %{
        envelope: envelope
      }
    end

    test "origin and platform is MozartNews", %{envelope: envelope} do
      assert NewsLivePlatformDiscriminator.call(envelope) ==
               {:ok,
                Envelope.add(envelope, :private, %{
                  platform: MozartNews,
                  production_environment: "live"
                })}
    end
  end

  describe "NEWS - when CPS URL with asset ID provided, show MozartNews on live" do
    setup do
      set_environment("live")

      envelope = %Envelope{
        request: %Request{
          path: "/news/live/uk-55930940",
          path_params: %{"asset_id" => "uk-55930940"}
        },
        private: %Private{
          origin: Application.get_env(:belfrage, :mozart_news_endpoint),
          platform: MozartNews
        }
      }

      %{
        envelope: envelope
      }
    end

    test "origin and platform is MozartNews", %{envelope: envelope} do
      assert NewsLivePlatformDiscriminator.call(envelope) ==
               {:ok,
                Envelope.add(envelope, :private, %{
                  platform: MozartNews,
                  production_environment: "live"
                })}
    end
  end

  describe "NEWS - when with TIPO .app URL on TEST, show WebCore" do
    setup do
      set_environment("test")

      envelope = %Envelope{
        request: %Request{
          path: "/news/live/c1v596ken6vt.app",
          path_params: %{"asset_id" => "c1v596ken6vt", "format" => "app"}
        },
        private: %Private{
          origin: Application.get_env(:belfrage, :mozart_news_endpoint),
          platform: MozartNews
        }
      }

      %{
        envelope: envelope
      }
    end

    test "origin and platform gets changed to webcore", %{envelope: envelope} do
      assert NewsLivePlatformDiscriminator.call(envelope) ==
               {:ok,
                Envelope.add(envelope, :private, %{
                  platform: "Webcore",
                  origin: Application.get_env(:belfrage, :pwa_lambda_function)
                }), {:replace, ["LambdaOriginAlias", "CircuitBreaker"]}}
    end
  end

  describe "NEWS - when TIPO .app URL on LIVE, show MozartNews" do
    setup do
      set_environment("live")

      envelope = %Envelope{
        request: %Request{
          path: "/news/live/c1v596ken6vt.app",
          path_params: %{"asset_id" => "cvpx5wr4nv8t", "format" => "app"}
        },
        private: %Private{
          origin: Application.get_env(:belfrage, :mozart_news_endpoint),
          platform: MozartNews
        }
      }

      %{
        envelope: envelope
      }
    end

    test "origin and platform remains as MozartNews", %{envelope: envelope} do
      assert NewsLivePlatformDiscriminator.call(envelope) ==
               {:ok,
                Envelope.add(envelope, :private, %{
                  platform: MozartNews,
                  production_environment: "live"
                })}
    end
  end
end
