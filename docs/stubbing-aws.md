# Stubbing out our AWS library.

## Using OriginSimulator (https://github.com/bbc/origin_simulator)
We may wish to stub out our AWS library with OriginSimulator on to test the effect the library is having on our system, with OriginSimulator we are able to replicate situations where AWS may return a variety of responses. 

1. Add some config to overrite the host, scheme and port:

        config :ex_aws, :lambda,
            host: "test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com/",
            scheme: "http://",
            port: 7080


2. Remove "DevelopmentRequests" from the pipeline in the platform/route spec which uses AWS:
        --- a/lib/routes/platforms/webcore.ex
        +++ b/lib/routes/platforms/webcore.ex
        @@ -19,6 +19,6 @@ defmodule Routes.Platforms.Webcore do
        end
        
        defp pipeline(_production_env) do
        -    pipeline("live") ++ ["DevelopmentRequests"]
        +    pipeline("live")
        end

3. Setup OriginSimulator to return JSON (Must have body, headers, statusCode):

        {
        "body": "{\"body\":\"SOME WEBCORE CONTENT\", \"isBase64Encoded\":false, \"statusCode\":200, \"headers\":{\"content-length\":30}}",
        "stages": [
            {
                "at": 0,
                "latency": "120ms",
                "status": 200
            }
        ]
        }

4. A branch with all the changes can be found here: https://github.com/bbc/belfrage/tree/stub-aws-with-origin-sim 
