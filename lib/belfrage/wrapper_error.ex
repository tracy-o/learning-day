defmodule Belfrage.WrapperError do
  @moduledoc """
  This module helps ensure that we don't lose the data in `%Struct{}` if an
  error happens in Belfrage.

  A function or a chain of functions that modify the `%Struct{}` and that can
  result in an error (e.g. depend on something that can fail) can be passed to
  `wrap/2` which will wrap the call(s) in a `try/catch` and if an error happens
  will wrap it in an exception that will contain the `%Struct{}`.

  This means that such errors will have the current `%Struct{}` (i.e. the data
  we accumulated before the error happened) and an error handler somewhere
  higher up could use it to generate an error response using the data in the
  `%Struct{}`. This should result in more accurate error responses.
  """

  alias Belfrage.Struct

  defexception [:struct, :kind, :reason, :stack]

  def message(%{kind: kind, reason: reason, stack: stack}) do
    Exception.format_banner(kind, reason, stack)
  end

  @doc """
  Call the passed function or a list of functions and add the `%Struct{}` to
  any errors raised during those calls. Functions must accept and return a
  `%Struct{}`.
  """
  def wrap(pipeline, struct = %Struct{}) when is_list(pipeline) do
    Enum.reduce(pipeline, struct, &wrap/2)
  end

  def wrap(func, struct = %Struct{}) when is_function(func) do
    try do
      func.(struct)
    catch
      kind, reason ->
        reraise(struct, kind, reason, __STACKTRACE__)
    end
  end

  defp reraise(struct, kind, reason, stack) do
    wrapper = %__MODULE__{struct: struct, kind: kind, reason: reason, stack: stack}
    :erlang.raise(kind, wrapper, stack)
  end
end
