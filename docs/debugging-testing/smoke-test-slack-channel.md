# Changing smoke tests report slack channel

Belfrage now supports sending smoke test failures into a slack channel of your choosing, after 2 steps.

1. Set the `slack_channel` key & value in the specs of your `routespec`, to the name of the destination channel. e.g ("help-belfrage")
2. Add the `Moz` slack app to that channel, by sending the message `@Moz` into the channel, and clicking "invite".

Now you should be setup to receive any smoke test failures, specific to that routespec!

Example of adding it to a routespec:
```

defmodule Routes.Specs.NewsSearch do
  def specs do
    %{
      platform: Webcore,
      slack_channel: "news-search"
    }
  end
end
```

Any questions/issues, don't hesitate to contact us in the slack channel `#help-belfrage`