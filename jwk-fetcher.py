#!/usr/bin/python
from urllib.request import urlopen, Request
import json
import sys
import traceback

def get_jwk_data(endpoint):
    try:
        request = Request(endpoint, None, {})
        jwk_data = json.load(urlopen(request))

        if jwk_data['keys']:
            return jwk_data
    except KeyError:
        print("No keys found in jwk_data file")
        sys.exit()

def write_jwk_data(jwk_data, env):
    try:
        with open(f"priv/static/jwk_{env}.json", 'w+') as f:
            json.dump(jwk_data, f)

    except Exception as e:
        print(f"Failed to write jwk file")
        sys.exit(traceback.format_exc())

def get_jwk_for_env(env):
    if env == "test":
        endpoint_env = "test."
    elif env == "live":
        endpoint_env = ""
    else:
        print("Invalid env specified, accepted values: 'test' or 'live'")
        sys.exit()

    jwk_data = get_jwk_data(f"https://access.{endpoint_env}api.bbc.com/v1/oauth/connect/jwk_uri")
    write_jwk_data(jwk_data, env)

    print(f"JWK data written for {env}")

try:
    args = sys.argv[1].split(",")

    for env in args:
        get_jwk_for_env(env)

    print("success")
except IndexError:
    print("No env specified")
    sys.exit()
