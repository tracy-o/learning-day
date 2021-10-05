If you wish to add validation for a route then you can do so by using the route matcher example below. This can be useful in cases where downstream services need to be protected from potentially invalid routes and also to improve the performance of the platform.

### Validating the id length

To check that an `id` is a specific length we can use `String.length()`. The following is a route matcher that matches any url of the form `/sport/videos/:id` but returns a 404 when the video id is not exactly 8 chars

```elixir
  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"] do
    return_404 if: String.length(id) != 8
  end
```

### Validating the id format

We can use more complex matchers by using `String.match()`. This accepts a regex which can be very powerful. Note that whilst we don't allow regexes in the matchers themselves it is possible to use them in the validation.

The following is a matcher which returns a 404 if the route id does not start with an alphanumeric string with a dash and then exactly 8 numbers.

Note: the eagle eyes of you will spot the question mark in the function here. This means we expect a boolean return value.

```elixir
  handle "/news/av/:id", using: "NewsVideos", examples: ["/news/av/48404351", "/news/av/uk-51729702", "/news/av/uk-england-hampshire-50266218"] do
      return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9]+-)*[0-9]{8}$/)
  end
```