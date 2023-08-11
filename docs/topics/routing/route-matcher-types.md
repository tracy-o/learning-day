A simple route matcher looks like this:  `handle "/news/business/:id", using: "MyRouteSpec"`
 * This will match a route like `/news/business/123456` and generate an id param: `path_params: %{"id" => "123456"}`

If you need need a catch-all, add `/*any` at the end of the path matcher: `handle "/news/russian/*any", using: "MyRouteSpec"`
* This will match a route like `/news/russian/doll/123456` and generate an any param ` path_params: %{"any" => ["doll", "123456"]}`
> Note: You should avoid using a catch-all if your route has an identifier in the same segment. For instance, if your route is similar to this: `handle "/news/business/:id", using: "MyRouteSpec"`, you shouldn't have a catch-all such as `handle "/news/business/*any", using: "MyOtherRouteSpec"` as well.

If you need to match a path containing an extension such as `.app` or `.json`, do it like so:
* `handle "/sport/av/:discipline/:id.app", using: "MyRouteSpecForApps"`
* In that case, a route like `"/sport/av/golf/123456.app"` produces `path_params: %{"id" => "123456", "discipline" => "golf", "format" => "app"} `

My route is more complicated!
If you have a path segment /news/business-123456 which - for historical reasons - includes a prefix, you can do:
* `handle "/news/business/business-:id", using: "MyRouteSpec"`
* In this case, an example like `"/news/business-123456"` would generate: `path_params: %{"id" => "123456"}`

If you also need a slug, for instance /news/business-123456/i-love-seo, do this:
* `handle "/news/business/business-:id/*rest", using: "MyRouteSpec"`
* Here, an example such as `"/news/business-123456/foobar"` produces: `path_params: %{"id" => "123456", "rest" => ["i-love-seo"]}`
> Note: rest is a list and it can match anything after it. An example like `/news/business-123456/i-love-seo/also/42` produces `path_params: %{"id" => "123456", "rest" => ["i-love-seo", "also", "42"]}`


I want to use a Regex! Unfortunately you can't, by design.
> Note: while you can't match a route using a regex, you can use one for validation. For details on this see [Route-Validation-in-Belfrage].

The reason for this is to avoid worst-case scenarios of sequential reads O(n) where the incoming request has to be matched against all the defined routes. When the Routefile is compiled it builds a tree of matchers to optimize the underlying routes into a tree lookup, instead of a linear lookup that would instead match route-per-route. This means route lookups are extremely fast in Belfrage!

The same applies for glob matcher in the middle of the path like /news/*glob/busines/:id. This can't work as it would make it impossible to build a tree from an inner *glob which could contain multiple path sections.

We believe that regexes can be avoided for most of the routes and can be replaced by sensible matchers. Ping us if you need support.
