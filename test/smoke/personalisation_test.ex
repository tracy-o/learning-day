defmodule Belfrage.PersonalisationSmokeTest do
  use ExUnit.Case, async: true

  @moduletag :smoke_test
  @moduletag :personalisation

  @auth_endpoints %{
    test: %{
      signin: "https://account.test.bbc.com/signin",
      session: "https://session.test.bbc.co.uk/session"
    },
    live: %{
      signin: "https://account.bbc.com/signin",
      session: "https://session.bbc.co.uk/session"
    }
  }

  @credentials %{
    # From
    # https://paper.dropbox.com/doc/BBC-Accounts-for-testing-personalisation--BTksKvP9C4IT11n3KojpG~mKAg-CXRQCeFkndxB0oeNOTxkg
    test: %{
      username: "dpgwebcorepersonalisedtest1@bbc.co.uk",
      password: "PersonalisedTest1"
    },
    # From
    # https://paper.dropbox.com/doc/BBC-Homepage-Accounts-for-live-personalisation--BTk9c5PRt8FNipM0GFZEORZBAg-mo2SME90tt6NnC8oOYeFO
    live: %{
      username: "homepersonalisationlive1@bbc.co.uk",
      password: "homepagelive1"
    }
  }

  setup do
    start_httpc(:test)
    :ok
  end

  environments = (System.get_env("SMOKE_ENV") || ~w(test live)) |> List.wrap() |> Enum.map(&String.to_atom/1)

  for prod_env <- environments do
    describe "on #{prod_env}" do
      @describetag spec: "HomePage"
      @describetag platform: "Webcore"

      test "authentication redirect" do
        prod_env = unquote(prod_env)
        response = make_request(endpoint(prod_env) <> "/", headers: %{"x-id-oidc-signedin" => 1})
        assert response.status == 302
        assert response.headers["location"] =~ @auth_endpoints[prod_env][:session]
      end

      test "personalised request to homepage" do
        prod_env = unquote(prod_env)
        token = get_access_token(prod_env)

        response =
          make_request(endpoint(prod_env) <> "/",
            headers: %{"x-id-oidc-signedin" => 1, "Cookie" => "ckns_atkn=#{token};"}
          )

        assert response.status == 200
        assert response.headers["cache-control"] =~ "private"
      end

      test "non-personalised request to homepage" do
        response = make_request(endpoint(unquote(prod_env)) <> "/", headers: %{"x-id-oidc-signedin" => 0})
        assert response.status == 200
        assert response.headers["cache-control"] =~ "public"
      end
    end
  end

  # This function makes a request while maintaining cookies and optionally
  # follows redirects.
  #
  # It uses `:httpc`, which has the following quirks that require all the faff
  # that this function takes care of:
  #
  # * `:httpc` expects all strings to be charlists, so it converts Elixir
  # strings to/from charlists.
  # * `:httpc` adds a `Content-length: 0` header to all GET requests by
  # default, which AWS ELB in front of Account endpoints doesn't like and
  # returns a 400. The only way to disable that is to set the `headers_as_is`
  # option, which requires all default headers (like `Host` and `Cookie`) to be
  # set manually.
  # * Because headers have to be set manually for every request, we can't use
  # the `autoredirect` feature of `:httpc` and have to follow redirects
  # manually.
  # * `:httpc` stores cookies from the response in its internal cookies DB only
  # if the host specified in the cookie matches the requested host. This isn't
  # true for Account cookies, so we strip the host from them and store them in
  # the cookies DB manually.
  defp make_request(url, opts) do
    profile = Keyword.get(opts, :profile, :test)

    host = url |> URI.parse() |> Map.fetch!(:host)

    request_headers =
      opts
      |> Keyword.get(:headers, [])
      |> Enum.map(fn {key, value} -> {to_charlist(key), to_charlist(value)} end)
      |> List.insert_at(0, {'Host', to_charlist(host)})
      |> List.insert_at(-1, :httpc.cookie_header(to_charlist(url), profile))

    method = Keyword.get(opts, :method, :get)

    request =
      if method == :get do
        {to_charlist(url), request_headers}
      else
        body = Keyword.get(opts, :body, "")
        request_headers = request_headers ++ [{'Content-Length', body |> String.length() |> to_charlist()}]
        content_type = opts |> Keyword.get(:headers, []) |> Map.get("Content-Type", "application/x-www-form-urlencoded")
        {to_charlist(url), request_headers, to_charlist(content_type), to_charlist(body)}
      end

    {:ok, {{_protocol, status_code, _status_name}, response_headers, _body}} =
      :httpc.request(method, request, [{:autoredirect, false}], [{:headers_as_is, true}], profile)

    response_headers
    |> Enum.filter(fn {key, _value} -> key == 'set-cookie' end)
    |> Enum.map(fn {key, value} ->
      {key, value |> to_string() |> String.replace(~r/domain=[^;]+;/i, "") |> to_charlist()}
    end)
    |> :httpc.store_cookies(to_charlist(url), profile)

    response_headers =
      response_headers
      |> Enum.map(fn {key, value} -> {to_string(key), to_string(value)} end)
      |> Enum.reduce(%{}, fn {key, value}, result ->
        case result[key] do
          nil ->
            Map.put(result, key, value)

          [_] = values ->
            Map.put(result, key, values ++ [value])

          existing_value ->
            Map.put(result, key, [existing_value, value])
        end
      end)

    if opts[:follow_redirect] && status_code in [301, 302] do
      make_request(response_headers["location"] |> to_string(), Keyword.take(opts, ~w(follow_redirect profile)a))
    else
      %{url: url, status: status_code, headers: response_headers}
    end
  end

  defp start_httpc(profile) do
    {:ok, _pid} = :inets.start(:httpc, [{:profile, profile}])

    on_exit(fn ->
      :inets.stop(:httpc, profile)
    end)
  end

  defp endpoint(prod_env) do
    host =
      :belfrage
      |> Application.get_env(:smoke)
      |> Keyword.fetch!(prod_env)
      |> Map.fetch!("bruce-belfrage")

    "https://" <> host
  end

  defp get_access_token(prod_env) do
    start_httpc(:auth)
    :httpc.set_options([{:cookies, :enabled}], :auth)

    sign_in(prod_env)
    generate_token(prod_env)
  end

  defp sign_in(prod_env) do
    sign_in_page =
      @auth_endpoints
      |> Map.fetch!(prod_env)
      |> Map.fetch!(:signin)
      |> make_request(profile: :auth, follow_redirect: true)

    assert sign_in_page.status == 200

    %{username: username, password: password} = Map.fetch!(@credentials, prod_env)

    response =
      make_request(sign_in_page.url,
        method: :post,
        body: "username=#{username}&password=#{password}",
        profile: :auth,
        follow_redirect: true,
        headers: %{"Content-Type" => "application/x-www-form-urlencoded"}
      )

    assert response.status == 200
  end

  defp generate_token(prod_env) do
    response =
      @auth_endpoints
      |> Map.fetch!(prod_env)
      |> Map.fetch!(:session)
      |> make_request(profile: :auth)

    assert response.status == 302

    token_cookie =
      :auth
      |> :httpc.which_cookies()
      |> Keyword.fetch!(:session_cookies)
      |> Enum.find(&(elem(&1, 3) == 'ckns_atkn'))

    assert token_cookie, "ckns_atkn cookie has not been set during authentication"

    elem(token_cookie, 4)
  end
end
