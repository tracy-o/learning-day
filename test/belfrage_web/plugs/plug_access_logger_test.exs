defmodule Belfrage.Logger.PlugAccessLoggerTest do
  use ExUnit.Case
  use Plug.Test
  alias Belfrage.Plug.AccessLogger

  describe "call/2" do
    test "expected message is sent to the FileLoggerBackend event handler" do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({LoggerFileBackend, :handle_event, 2}, true, [:local])

      :get
      |> conn("/news")
      |> AccessLogger.call(:info)
      |> resp(200, "")
      |> send_resp()

      assert_receive {:trace, _, :call,
                      {LoggerFileBackend, :handle_event,
                       [
                         {:info, _, {Logger, "", _datetime, metadata}},
                         %{format: {Belfrage.Logger.Formatter, :access}, path: "access.log"}
                       ]}}

      assert Keyword.get(metadata, :request_path) == "/news"
      assert Keyword.get(metadata, :status) == 200
    end

    test "expected write is attempted" do
      :erlang.trace(:all, true, [:call])
      :erlang.trace_pattern({IO, :write, 2}, true, [:local])

      :get
      |> conn("/news", %{"foo" => "bar"})
      |> AccessLogger.call(:info)
      |> resp(200, "")
      |> send_resp()

      assert_receive {:trace, _, :call, {IO, :write, [_pid, [event]]}}
      assert [_, "\"GET\"", "\"/news\"", "\"foo=bar\"", "\"200\""] = String.split(event)
    end
  end
end
