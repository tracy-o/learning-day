defmodule Belfrage.RequestTransformers.SessionState do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Authentication.SessionState

  @impl Transformer
  def call(envelope = %Envelope{private: %Envelope.Private{personalised_request: false}}) do
    {:ok, envelope}
  end

  @impl Transformer
  def call(envelope = %Envelope{}) do
    session_state = SessionState.build(envelope.request)
    IO.inspect(session_state)
    envelope = Envelope.add(envelope, :user_session, session_state)

    {:ok, envelope}
  end
end
