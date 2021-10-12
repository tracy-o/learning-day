# Webcore contract

Example of lambda invocation payload:
```
{
  headers: {
    country: "gb",
    language: "en-GB",
    "accept-encoding": "gzip",
    is_uk: true,
    host: "www.bbc.co.uk"
  },
  body: "",
  httpMethod: "GET",
  path: "/news/an-article-id",
  queryStringParameters: {"search": "Why are bourbons better than custard creams?"},
  pathParameters: {"id": "an-article-id"}
}
```

[Original contract](https://paper.dropbox.com/doc/Ingress-Presentation-Contract-v1--A9LxuEonJaJnak9SFd759TrfAg-ylbyP5nJs5VHmhN9iDXTd)

The contract is based upon the [API Gateway -> Lambda contract](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-lambda-authorizer.html)
