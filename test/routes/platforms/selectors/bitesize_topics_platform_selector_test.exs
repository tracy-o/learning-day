defmodule Routes.Platforms.Selectors.BitesizeTopicsPlatformSelectorTest do
  use ExUnit.Case
  alias Belfrage.Behaviours.Selector
  alias Belfrage.Envelope.Request

  import Test.Support.Helper, only: [set_environment: 1]

  @selector "BitesizeTopicsPlatformSelector"

  describe "requests with id and year_id path parameter keys" do
    test "if the id is a test webcore id, the year_id is valid and the production environment is test Webcore is returned" do
      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "z82hsbk", "year_id" => "zncsscw"}
             }) == {:ok, "Webcore"}
    end

    test "if the id is a live webcore id, the year_id is valid and the production environment is live Webcore is returned" do
      set_environment("live")

      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "zhtcvk7", "year_id" => "zncsscw"}
             }) == {:ok, "Webcore"}
    end

    test "if the id is a not a test webcore id, the year_id is valid and the production environment is test MorphRouter is returned" do
      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "some_id", "year_id" => "zncsscw"}
             }) == {:ok, "MorphRouter"}
    end

    test "if the id is a test webcore id, the year_id is not valid and the production environment is test MorphRouter is returned" do
      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "z82hsbk", "year_id" => "some_year_id"}
             }) == {:ok, "MorphRouter"}
    end

    test "if the id is a test webcore id, the year_id is valid and the production environment is live MorphRouter is returned" do
      set_environment("live")

      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "z82hsbk", "year_id" => "zncsscw"}
             }) == {:ok, "MorphRouter"}
    end

    test "if the id is not a live webcore id, the year_id is valid and the production environment is live MorphRouter is returned" do
      set_environment("live")

      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "some_id", "year_id" => "zncsscw"}
             }) == {:ok, "MorphRouter"}
    end

    test "if the id is a live webcore id, the year_id is invalid and the production environment is live MorphRouter is returned" do
      set_environment("live")

      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "zhtcvk7", "year_id" => "some_year_id"}
             }) == {:ok, "MorphRouter"}
    end

    test "if the id is a live webcore id, the year_id is valid and the production environment is test Webcore is returned as all the live ids are a subset of the test ids" do
      set_environment("test")

      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "zhtcvk7", "year_id" => "zncsscw"}
             }) == {:ok, "Webcore"}
    end
  end

  describe "requests with an id paramater key" do
    test "if the id is a test webcore id and the production environment is test Webcore is returned" do
      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "z82hsbk"}
             }) == {:ok, "Webcore"}
    end

    test "if the id is a live webcore id and the production environment is live Webcore is returned" do
      set_environment("live")

      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "zhtcvk7"}
             }) == {:ok, "Webcore"}
    end

    test "if the id is a not a test webcore id and the production environment is test MorphRouter is returned" do
      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "some_id"}
             }) == {:ok, "MorphRouter"}
    end

    test "if the id is a test webcore id and the production environment is live MorphRouter is returned" do
      set_environment("live")

      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "z82hsbk"}
             }) == {:ok, "MorphRouter"}
    end

    test "if the id is not a live webcore id and the production environment is live MorphRouter is returned" do
      set_environment("live")

      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "some_id"}
             }) == {:ok, "MorphRouter"}
    end

    test "if the id is a live webcore id and the production environment is test MorphRouter is returned as all the live ids are a subset of the test ids" do
      set_environment("test")

      assert Selector.call(@selector, :platform, %Request{
               path_params: %{"id" => "zhtcvk7"}
             }) == {:ok, "Webcore"}
    end
  end
end
