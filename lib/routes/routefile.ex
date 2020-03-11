defmodule Routes.Routefile do
  use BelfrageWeb.RouteMaster
  alias Routes.Specs.TopicPage

  redirect "/example/news/0", to: "/news", status: 302
  redirect "/example/weather/0", to: "/weather", status: 301

  handle "/", using: "HomePage", examples: ["/"]
  handle "/scotland", using: "ScotlandHomePage", examples: ["/scotland"]
  handle "/homepage/test", using: "TestHomePage", only_on: "test", examples: ["/homepage/test"]
  handle "/news", using: "NewsFrontPage", examples: ["/news"]
  handle "/sport", using: "SportFrontPage", examples: ["/sport"]
  handle "/weather", using: "WeatherFrontPage", examples: ["/weather"]
  handle "/bitesize", using: "BitesizeFrontPage", examples: ["/bitesize"]
  handle "/cbeebies", using: "CBeebiesFrontPage", examples: ["/cbeebies"]
  handle "/dynasties", using: "DynastiesFrontPage", examples: ["/dynasties"]
  handle "/northernireland", using: "NorthernIrelandHomePage", examples: ["/northernireland"]
  handle "/wales", using: "WalesHomePage", examples: ["/wales"]

  handle "/fd/preview/:name", using: "FablData", examples: ["/fd/preview/example-module"]
  handle "/fd/:name", using: "FablData", examples: ["/fd/example-module"]

  handle "/wc-data/container/:name", using: "ContainerData", examples: ["/wc-data/container/promo-group"]
  handle "/wc-data/page-composition", using: "PageComposition", examples: ["/wc-data/page-composition?path=/sport"]
  handle "/hcraes", using: "Hcraes", examples: ["/hcraes"]

  handle "/news/beta/article/:id", using: "NewsArticlePage", examples: ["/news/beta/article/uk-politics-49336144"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/newsround/beta/article/:id", using: "NewsroundArticlePage", examples: ["/newsround/beta/article/49081103"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/sport/beta/article/:id", using: "SportArticlePage", examples: ["/sport/beta/article/rugby-union%2F49590345"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/search", using: "Search", examples: ["/search"]
  handle "/chwilio", using: "Search", examples: ["/chwilio"]
  handle "/cbeebies/search", using: "Search", examples: ["/cbeebies/search"]
  handle "/cbbc/search", using: "Search", examples: ["/cbbc/search"]

  handle "/news/search", using: "NewsSearch", examples: ["/news/search"]
  handle "/news/videos/:id", using: "NewsVideos", examples: ["/news/videos/50653614"] do
    return_404 if: String.length(id) != 8
  end

  handle "/sport/videos/service-worker.js", using: "SportVideos", examples: ["/sport/videos/service-worker.js"]
  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"] do
    return_404 if: String.length(id) != 8
  end

  handle "/pres-test/*any", using: "PresTest", only_on: "test", examples: ["/pres-test/greeting-loader", "/pres-test/hcraes"]

  handle "/afaanoromoo/*_any", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo", "/afaanoromoo/oduu-51797939"]
  handle "/afrique/*_any", using: "WorldServiceAfrique", examples: ["/afrique", "/afrique/example-123"]
  handle "/amharic/*_any", using: "WorldServiceAmharic", examples: ["/amharic", "/amharic/news-51797888"]
  handle "/arabic/*_any", using: "WorldServiceArabic", examples: ["/arabic", "/arabic/example-123"]
  handle "/azeri/*_any", using: "WorldServiceAzeri", examples: ["/azeri", "/azeri/magazine-51736698"]
  handle "/bengali/*_any", using: "WorldServiceBengali", examples: ["/bengali", "/bengali/example-123"]
  handle "/burmese/*_any", using: "WorldServiceBurmese", examples: ["/burmese", "/burmese/example-123"]
  handle "/cymrufyw/*_any", using: "WorldServiceCymrufyw", examples: ["/cymrufyw", "/cymrufyw/example-123"]
  handle "/gahuza/*_any", using: "WorldServiceGahuza", examples: ["/gahuza", "/gahuza/example-123"]
  handle "/gujarati/*_any", using: "WorldServiceGujarati", examples: ["/gujarati", "/gujarati/example-123"]
  handle "/hausa/*_any", using: "WorldServiceHausa", examples: ["/hausa", "/hausa/example-123"]
  handle "/hindi/*_any", using: "WorldServiceHindi", examples: ["/hindi", "/hindi/example-123"]
  handle "/igbo/*_any", using: "WorldServiceIgbo", examples: ["/igbo", "/igbo/afirika-51708561"]
  handle "/indonesia/*_any", using: "WorldServiceIndonesia", examples: ["/indonesia", "/indonesia/example-123"]
  handle "/japanese/*_any", using: "WorldServiceJapanese", examples: ["/japanese", "/japanese/51748582"]
  handle "/korean/*_any", using: "WorldServiceKorean", examples: ["/korean", "/korean/example-123"]
  handle "/kyrgyz/*_any", using: "WorldServiceKyrgyz", examples: ["/kyrgyz", "/kyrgyz/51748492"]
  handle "/marathi/*_any", using: "WorldServiceMarathi", examples: ["/marathi", "/marathi/example-123"]
  handle "/mundo/*_any", using: "WorldServiceMundo", examples: ["/mundo", "/mundo/noticias-51503412", "/mundo/components"]
  handle "/naidheachdan/*_any", using: "WorldServiceNaidheachdan", examples: ["/naidheachdan", "/naidheachdan/example-123"]
  handle "/nepali/*_any", using: "WorldServiceNepali", examples: ["/nepali", "/nepali/example-123"]
  handle "/pashto/*_any", using: "WorldServicePashto", examples: ["/pashto", "/pashto/example-123"]
  handle "/persian/*_any", using: "WorldServicePersian", examples: ["/persian", "/persian/example-123"]
  handle "/pidgin/*_any", using: "WorldServicePidgin", examples: ["/pidgin", "/pidgin/tori-51717056"]
  handle "/portuguese/*_any", using: "WorldServicePortuguese", examples: ["/portuguese", "/portuguese/example-123"]
  handle "/punjabi/*_any", using: "WorldServicePunjabi", examples: ["/punjabi", "/punjabi/india-51743542"]
  handle "/russian/*_any", using: "WorldServiceRussian", examples: ["/russian", "/russian/example-123"]
  handle "/sinhala/*_any", using: "WorldServiceSinhala", examples: ["/sinhala", "/sinhala/example-123"]
  handle "/somali/*_any", using: "WorldServiceSomali", examples: ["/somali", "/somali/example-123"]
  handle "/swahili/*_any", using: "WorldServiceSwahili", examples: ["/swahili", "/swahili/example-123"]
  handle "/tajik/*_any", using: "WorldServiceTajik", examples: ["/tajik", "/tajik/components", "/tajik/news/2015/03/150331_l16_bbc-tajik_closure"]
  handle "/tamil/*_any", using: "WorldServiceTamil", examples: ["/tamil", "/tamil/example-123"]
  handle "/telugu/*_any", using: "WorldServiceTelugu", examples: ["/telugu", "/telugu/example-123"]
  handle "/thai/*_any", using: "WorldServiceThai", examples: ["/thai", "/thai/thailand-51706739"]
  handle "/tigrinya/*_any", using: "WorldServiceTigrinya", examples: ["/tigrinya", "/tigrinya/news-51799994"]
  handle "/turkce/*_any", using: "WorldServiceTurkce", examples: ["/turkce", "/turkce/example-123"]
  handle "/ukrainian/*_any", using: "WorldServiceUkrainian", examples: ["/ukrainian", "/ukrainian/example-123"]
  handle "/urdu/*_any", using: "WorldServiceUrdu", examples: ["/urdu", "/urdu/example-123"]
  handle "/uzbek/*_any", using: "WorldServiceUzbek", examples: ["/uzbek", "/uzbek/example-123"]
  handle "/vietnamese/*_any", using: "WorldServiceVietnamese", examples: ["/vietnamese", "/vietnamese/example-123"]
  handle "/yoruba/*_any", using: "WorldServiceYoruba", examples: ["/yoruba", "/yoruba/awon-iroyin-miran-51716954"]

  handle "/topics/:id/:pageNumber", using: "TopicPage", examples: ["/topics/cmj34zmwm1zt/1"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/) or !String.match?(pageNumber , ~r/^[1-9][0-9]*$/)
  end

  handle "/topics/:id", using: "TopicPage", examples: ["/topics/cmj34zmwm1zt"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  handle "/sport/alpine-skiing.app", using: "SportPal", examples: ["/sport/alpine-skiing.app"]

  handle "/sport/topics/:id/:pageNumber", using: "TopicPage", examples: ["/sport/topics/cpzrw9qgwelt/1"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/) or !String.match?(pageNumber , ~r/^[1-9][0-9]*$/)
  end

  handle "/sport/topics/:id", using: "TopicPage", examples: ["/sport/topics/cpzrw9qgwelt"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  handle "/sport/:discipline/:pageNumber", using: "TopicPage", examples: ["/sport/snowboarding/1"] do
    return_404 if: !Enum.member?(TopicPage.sports_topics_routes, discipline) or !String.match?(pageNumber , ~r/^[1-9][0-9]*$/)
  end

  handle "/sport/:discipline", using: "TopicPage", examples: ["/sport/snowboarding"] do
    return_404 if: !Enum.member?(TopicPage.sports_topics_routes, discipline)
  end

  handle "/web/shell", using: "WebShell", examples: ["/web/shell"]

  handle "/*any", using: "ProxyPass", only_on: "test", examples: ["/foo/bar"]
end
