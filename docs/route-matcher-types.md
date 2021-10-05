** A simple route matcher
Add this to the Routefile:
#+begin_src elixir
handle "/news/business/:id", using: "MyRouteSpec", examples: ["/news/business/123456"]
#+end_src

This will match a route like ~/news/business/123456~ and generate an ~id~ param:
#+begin_src elixir
path_params: %{"id" => "123456"}
#+end_src

** I need a catch-all
You can add a glob matcher at the end of the path matcher:
#+begin_src elixir
handle "/news/russian/*any", using: "MyRouteSpec", examples: ["/news/russian/123456"]
#+end_src

This will match a route like ~/news/russian/doll/123456~ and generate an ~any~ param
#+begin_src elixir
path_params: %{"any" => ["doll", "123456"}
#+end_src

** I need to match a path containing an extension
#+begin_src elixir
handle "/sport/av/:discipline/:id.app", using: "MyRouteSpecForApps", examples: ["/sport/av/golf/123456.app"]
#+end_src

produces:
#+begin_src elixir
path_params: %{"id" => "123456", "discipline" => "golf", "format" => "app"}
#+end_src

** My route is more complicated!
Say you have a path segment ~/news/business-123456~ which - for historical reasons - includes a prefix along with the id:

#+begin_src elixir
handle "/news/business/business-:id", using: "MyRouteSpec", examples: ["/news/business-123456"]
#+end_src

#+begin_src elixir
path_params: %{"id" => "123456"}
#+end_src

But my path also has a slug! ~/news/business-123456/i-love-seo~ - easy!

#+begin_src elixir
handle "/news/business/business-:id/*rest", using: "MyRouteSpec", examples: ["/news/business-123456/foobar"]
#+end_src

produces:
#+begin_src elixir
path_params: %{"id" => "123456", "rest" => ["i-love-seo"]}
#+end_src

As you see ~rest~ is a list, this is because it's a glob - it can match anything after it:
#+begin_src elixir
/news/business-123456/i-love-seo/also/42
#+end_src

Produces:
#+begin_src elixir
path_params: %{"id" => "123456", "rest" => ["i-love-seo", "also", "42"]}
#+end_src

** I want to use a Regex!
Unfortunately *you can't*, by design.

/Note: while you can't match a route using a regex, you can use one for validation. For details on this see [[Route-Validation-in-Belfrage][Route Validation]]./

The reason for this is to avoid worst-case scenarios of sequential reads ~O(n)~ where the incoming request has to be matched against all the defined routes.
When the Routefile is compiled it builds a tree of matchers to optimize the underlying routes into a tree lookup, instead of a linear lookup that would instead match route-per-route. This means route lookups are extremely fast in Belfrage!

The same applies for glob matcher in the middle of the path like ~/news/*glob/busines/:id~. This can't work as it would make it impossible to build a tree from an inner ~*glob~ which could contain multiple path sections.

We believe that regexes can be avoided for most of the routes and can be replaced by sensible matchers. Ping us if you need support.
