defmodule Belfrage.Authentication.Token do
#   {
#   "sub": "a76ea475-1f67-4b23-95a2-452a364e1aa7",
#   "cts": "OAUTH2_STATELESS_GRANT",
#   "auth_level": 2,
#   "auditTrackingId": "53a1918b-beb1-44c6-9233-29e6d6198cc6-664974",
#   "iss": "https://access.test.api.bbc.com/bbcidv5/oauth2",
#   "tokenName": "access_token",
#   "token_type": "Bearer",
#   "authGrantId": "Vgz46WyjHhgKs_91qhAWC1ZN66k",
#   "aud": "Account",
#   "nbf": 1623327835,
#   "grant_type": "authorization_code",
#   "scope": [
#     "explicit",
#     "core",
#     "implicit",
#     "pii",
#     "uid",
#     "openid"
#   ],
#   "auth_time": 1623327786,
#   "realm": "/",
#   "exp": 1623335035,
#   "iat": 1623327835,
#   "expires_in": 7200,
#   "jti": "XSmy3al-43ebzBMlaTk5AkbLSR0",
#   "userAttributes": {
#     "ageBracket": "o18",
#     "allowPersonalisation": true,
  #     "analyticsHashedId": "gJOF-9aIQ60iZIpYaEySQP0IMI2gArfUTFLk-lgEGTE"
  #   }
  # }

  def decode(nil) do
    nil
  end

  def decode(cookie) do
    Belfrage.Authentication.Validator.verify_and_validate(cookie)
  end

  def valid?(_decoded_token = nil), do: false

  def valid?({:ok, _decoded_token}) do
    true
  end

  def valid?({:error, [message: message, claim: claim, claim_val: claim_val]}) do
    Belfrage.Event.record(:log, :warn, %{
          msg: "Claim validation failed",
          message: message,
          claim_val: claim_val,
          claim: claim })

    false
  end

  def valid?({:error, :token_malformed}) do
    Belfrage.Event.record(:log, :error, "Malformed JWT")

    false
  end

  def valid?({:error, :public_key_not_found}) do
    false
  end

  def valid?({:error, :invalid_token_header}) do
    Belfrage.Event.record(:log, :error, "Invalid token header")

    false
  end

  def valid?({:error, :signature_error}) do
    false
  end

  def valid?({:error, _}) do
    Belfrage.Event.record(:log, :error, "Unexpected token error.")

    false
  end

  # FIXME
  def user_attributes do
  end
end
