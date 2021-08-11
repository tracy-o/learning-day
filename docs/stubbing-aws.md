# Stubbing out our AWS library.

## Using OriginSimulator (https://github.com/bbc/origin_simulator)
We may wish to stub out our AWS library with OriginSimulator on to test the effect the library is having on our system, with OriginSimulator we are able to replicate situations where AWS may return a variety of responses. 

1. Add some config to overwrite the host, scheme and port:

        config :ex_aws, :lambda,
            host: "test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com/",
            scheme: "http://",
            port: 7080


2. Remove "DevelopmentRequests" from the pipeline in the platform/route spec which uses AWS:

        #/lib/routes/platforms/webcore.ex
        defmodule Routes.Platforms.Webcore do
            ...
            
            defp pipeline(_production_env) do
            --  pipeline("live") ++ ["DevelopmentRequests"]
            ++  pipeline("live")
            end
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
        
    or a gzipped version:

        {
        "body": "{\"body\":\"SOME GZIPPED WEBCORE CONTENT\", \"isBase64Encoded\":true, \"statusCode\":200, \"headers\":{\"content-length\":30, \"content-encoding\":\"gzip"\}}",
        "stages": [
            {
                "at": 0,
                "latency": "120ms",
                "status": 200
            }
        ]
        }


4. A branch with all the changes can be found here: https://github.com/bbc/belfrage/tree/stub-aws-with-origin-sim 
