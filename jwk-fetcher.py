#!/usr/bin/python
from urllib.request import urlopen, Request
import json
import sys
import traceback

def get_jwk_data(env):
    if (env != "test." and env != ""):
        print("invalid env value")
        sys.exit()

    endpoint = f"https://access.{env}api.bbc.com/v1/oauth/connect/jwk_uri"
    request = Request(endpoint, None, {})
    jwk_data = json.load(urlopen(request))

    if jwk_data['keys']:
        print("keys found")
        return jwk_data

def write_jwk_data(jwk_data, env):
    with open(f"priv/static/jwk_{env}.json", 'w+') as f:
        json.dump(jwk_data, f)
    print("success")

try:
    if sys.argv[1] == "test":
        env = "test."
    elif sys.argv[1] == "live":
        env = ""
    else:
        print("Invalid env specified, accepted values: 'test' or 'live'")
        sys.exit()
except IndexError:
    print("No env specified")
    sys.exit()

try:
    jwk_data = get_jwk_data(env)
except KeyError:
    print("No keys found in jwk_data file")
    sys.exit()

try:
    write_jwk_data(jwk_data, env)
except Exception as e:
    print(f"Failed to write jwk file")
    sys.exit(traceback.format_exc())
