defmodule Routes.Specs.SportData do
  def specification do
    %{
      specs: %{
        platform: "Fabl",
        response_pipeline: ["CacheDirective", "ClassicAppCacheControl", "ResponseHeaderGuardian", "PreCacheCompression", "Etag"],
        etag: true,
        examples: ["/fd/topic-mapping?product=sport&followable=true&alias=false", "/fd/topic-mapping?product=sport&route=/sport&edition=domestic", "/fd/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios", "/fd/sport-app-page?page=https%3A%2F%2Fwww.bbc.co.uk%2Fsport&v=11&platform=ios&edition=domestic", "/fd/sport-app-notification-data", "/fd/sport-app-menu?edition=domestic&platform=ios&env=live", "/fd/sport-app-images", "/fd/sport-app-followables?env=live&edition=domestic", "/fd/sport-app-allsport?env=live&edition=domestic"]
      }
    }
  end
end
