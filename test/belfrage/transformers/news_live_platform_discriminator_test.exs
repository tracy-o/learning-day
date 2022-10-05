defmodule Belfrage.Transformers.NewsLivePlatformDiscriminatorTest do
  import Test.Support.Helper, only: [set_environment: 1]
  use ExUnit.Case

  alias Belfrage.Transformers.NewsLivePlatformDiscriminator
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Private}

  describe "NEWS - when with TIPO URL on TEST should show webcore" do
    setup do
      set_environment("test")

      struct = %Struct{
        request: %Request{
          path: "/news/live/c1v596ken6vt"
        },
        private: %Private{
          origin: Application.get_env(:belfrage, :mozart_news_endpoint),
          platform: MozartNews
        }
      }

      %{
        struct: struct
      }
    end

    test "origin and platform gets changed to webcore", %{struct: struct} do
      assert NewsLivePlatformDiscriminator.call([], struct) ==
               {:ok,
                Struct.add(struct, :private, %{
                  platform: Webcore,
                  origin: Application.get_env(:belfrage, :pwa_lambda_function)
                })}
    end
  end

  describe "NEWS - TIPO URL on LIVE should show MozartNews 'not found' page" do
    setup do
      set_environment("live")

      struct = %Struct{
        request: %Request{
          path: "/news/live/c1v596ken6vt"
        },
        private: %Private{
          origin: Application.get_env(:belfrage, :mozart_news_endpoint),
          platform: MozartNews
        }
      }

      %{
        struct: struct
      }
    end

    test "origin and platform remains as MozartNews", %{struct: struct} do
      assert NewsLivePlatformDiscriminator.call([], struct) ==
               {:ok,
                Struct.add(struct, :private, %{
                  platform: MozartNews,
                  production_environment: "live"
                })}
    end
  end

  describe "NEWS - when with CPS URL and discipline provided show MozartNews on live" do
    setup do
      set_environment("live")

      struct = %Struct{
        request: %Request{
          path: "/news/live/uk-55930940"
        },
        private: %Private{
          origin: Application.get_env(:belfrage, :mozart_news_endpoint),
          platform: MozartNews
        }
      }

      %{
        struct: struct
      }
    end

    test "origin and platform is MozartNews", %{struct: struct} do
      assert NewsLivePlatformDiscriminator.call([], struct) ==
               {:ok,
                Struct.add(struct, :private, %{
                  platform: MozartNews,
                  production_environment: "live"
                })}
    end
  end
end
