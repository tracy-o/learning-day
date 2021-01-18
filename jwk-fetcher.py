#!/usr/bin/python
from datetime import datetime
from urllib.request import urlopen, Request
import json
import sys
import traceback

def jwk_fetch(env):
    if (env != "test." and env != ""):
        print("invalid env value")
        sys.exit()

    endpoint = f"https://access.{env}api.bbc.com/v1/oauth/connect/jwk_uri"
    request = Request(endpoint, None, {})
    return json.load(urlopen(request))

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
    jwk_data = jwk_fetch(env)
    if jwk_data['keys']:
        print("keys found")
except KeyError:
    print("No keys found in jwk_data file")
    sys.exit()

try:
    env_name = sys.argv[1]
    with open(f"priv/static/jwk_{env_name}.json", 'w+') as f:
        json.dump(jwk_data, f)
    print("success")
except Exception as e:
    print(f"Failed to write jwk file")
    sys.exit(traceback.format_exc())
