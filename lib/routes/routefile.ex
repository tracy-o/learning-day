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

  handle "/afrique", using: "WorldServiceAfrique", examples: ["/afrique"]
  handle "/afrique/*_any", using: "WorldServiceAfrique", examples: ["/afrique/example-123"]

  handle "/afaanoromoo", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo"]
  handle "/afaanoromoo/*_any", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo/oduu-51797939"]

  handle "/amharic", using: "WorldServiceAmharic", examples: ["/amharic"]
  handle "/amharic/*_any", using: "WorldServiceAmharic", examples: ["/amharic/news-51797888"]

  handle "/arabic", using: "WorldServiceArabic", examples: ["/arabic"]
  handle "/arabic/*_any", using: "WorldServiceArabic", examples: ["/arabic/example-123"]

  handle "/azeri", using: "WorldServiceAzeri", examples: ["/azeri"]
  handle "/azeri/*_any", using: "WorldServiceAzeri", examples: ["/azeri/magazine-51736698"]

  handle "/bengali", using: "WorldServiceBengali", examples: ["/bengali"]
  handle "/bengali/*_any", using: "WorldServiceBengali", examples: ["/bengali/example-123"]

  handle "/burmese", using: "WorldServiceBurmese", examples: ["/burmese"]
  handle "/burmese/*_any", using: "WorldServiceBurmese", examples: ["/burmese/example-123"]

  handle "/cymrufyw", using: "WorldServiceCymrufyw", examples: ["/cymrufyw"]
  handle "/cymrufyw/*_any", using: "WorldServiceCymrufyw", examples: ["/cymrufyw/example-123"]

  handle "/gahuza", using: "WorldServiceGahuza", examples: ["/gahuza"]
  handle "/gahuza/*_any", using: "WorldServiceGahuza", examples: ["/gahuza/example-123"]

  handle "/gujarati", using: "WorldServiceGujarati", examples: ["/gujarati"]
  handle "/gujarati/*_any", using: "WorldServiceGujarati", examples: ["/gujarati/example-123"]

  handle "/hausa", using: "WorldServiceHausa", examples: ["/hausa"]
  handle "/hausa/*_any", using: "WorldServiceHausa", examples: ["/hausa/example-123"]

  handle "/hindi", using: "WorldServiceHindi", examples: ["/hindi"]
  handle "/hindi/*_any", using: "WorldServiceHindi", examples: ["/hindi/example-123"]

  handle "/igbo", using: "WorldServiceIgbo", examples: ["/igbo"]
  handle "/igbo/*_any", using: "WorldServiceIgbo", examples: ["/igbo/afirika-51708561"]

  handle "/indonesia", using: "WorldServiceIndonesia", examples: ["/indonesia"]
  handle "/indonesia/*_any", using: "WorldServiceIndonesia", examples: ["/indonesia/example-123"]

  handle "/japanese", using: "WorldServiceJapanese", examples: ["/japanese"]
  handle "/japanese/*_any", using: "WorldServiceJapanese", examples: ["/japanese/51748582"]

  handle "/korean", using: "WorldServiceKorean", examples: ["/korean"]
  handle "/korean/*_any", using: "WorldServiceKorean", examples: ["/korean/example-123"]

  handle "/kyrgyz", using: "WorldServiceKyrgyz", examples: ["/kyrgyz"]
  handle "/kyrgyz/*_any", using: "WorldServiceKyrgyz", examples: ["/kyrgyz/51748492"]

  handle "/marathi", using: "WorldServiceMarathi", examples: ["/marathi"]
  handle "/marathi/*_any", using: "WorldServiceMarathi", examples: ["/marathi/example-123"]

  handle "/mundo", using: "WorldServiceMundo", examples: ["/mundo"]
  handle "/mundo/*_any", using: "WorldServiceMundo", examples: ["/mundo/noticias-51503412", "/mundo/components"]

  handle "/naidheachdan", using: "WorldServiceNaidheachdan", examples: ["/naidheachdan"]
  handle "/naidheachdan/*_any", using: "WorldServiceNaidheachdan", examples: ["/naidheachdan/example-123"]

  handle "/persian", using: "WorldServicePersian", examples: ["/persian"]
  handle "/persian/*_any", using: "WorldServicePersian", examples: ["/persian/example-123"]

  handle "/portuguese", using: "WorldServicePortuguese", examples: ["/portuguese"]
  handle "/portuguese/*_any", using: "WorldServicePortuguese", examples: ["/portuguese/example-123"]

  handle "/nepali", using: "WorldServiceNepali", examples: ["/nepali"]
  handle "/nepali/*_any", using: "WorldServiceNepali", examples: ["/nepali/example-123"]

  handle "/pashto", using: "WorldServicePashto", examples: ["/pashto"]
  handle "/pashto/*_any", using: "WorldServicePashto", examples: ["/pashto/example-123"]

  handle "/pidgin", using: "WorldServicePidgin", examples: ["/pidgin"]
  handle "/pidgin/*_any", using: "WorldServicePidgin", examples: ["/pidgin/tori-51717056"]

  handle "/punjabi", using: "WorldServicePunjabi", examples: ["/punjabi"]
  handle "/punjabi/*_any", using: "WorldServicePunjabi", examples: ["/punjabi/india-51743542"]

  handle "/russian", using: "WorldServiceRussian", examples: ["/russian"]
  handle "/russian/*_any", using: "WorldServiceRussian", examples: ["/russian/example-123"]

  handle "/sinhala", using: "WorldServiceSinhala", examples: ["/sinhala"]
  handle "/sinhala/*_any", using: "WorldServiceSinhala", examples: ["/sinhala/example-123"]

  handle "/somali", using: "WorldServiceSomali", examples: ["/somali"]
  handle "/somali/*_any", using: "WorldServiceSomali", examples: ["/somali/example-123"]

  handle "/swahili", using: "WorldServiceSwahili", examples: ["/swahili"]
  handle "/swahili/*_any", using: "WorldServiceSwahili", examples: ["/swahili/example-123"]

  handle "/tajik", using: "WorldServiceTajik", examples: ["/tajik"]
  handle "/tajik/*_any", using: "WorldServiceTajik", examples: ["/tajik/components", "/tajik/news/2015/03/150331_l16_bbc-tajik_closure"]

  handle "/tamil", using: "WorldServiceTamil", examples: ["/tamil"]
  handle "/tamil/*_any", using: "WorldServiceTamil", examples: ["/tamil/example-123"]

  handle "/telugu", using: "WorldServiceTelugu", examples: ["/telugu"]
  handle "/telugu/*_any", using: "WorldServiceTelugu", examples: ["/telugu/example-123"]

  handle "/thai", using: "WorldServiceThai", examples: ["/thai"]
  handle "/thai/*_any", using: "WorldServiceThai", examples: ["/thai/thailand-51706739"]

  handle "/tigrinya", using: "WorldServiceTigrinya", examples: ["/tigrinya"]
  handle "/tigrinya/*_any", using: "WorldServiceTigrinya", examples: ["/tigrinya/news-51799994"]

  handle "/turkce", using: "WorldServiceTurkce", examples: ["/turkce"]
  handle "/turkce/*_any", using: "WorldServiceTurkce", examples: ["/turkce/example-123"]

  handle "/ukrainian", using: "WorldServiceUkrainian", examples: ["/ukrainian"]
  handle "/ukrainian/*_any", using: "WorldServiceUkrainian", examples: ["/ukrainian/example-123"]

  handle "/urdu", using: "WorldServiceUrdu", examples: ["/urdu"]
  handle "/urdu/*_any", using: "WorldServiceUrdu", examples: ["/urdu/example-123"]

  handle "/uzbek", using: "WorldServiceUzbek", examples: ["/uzbek"]
  handle "/uzbek/*_any", using: "WorldServiceUzbek", examples: ["/uzbek/example-123"]

  handle "/vietnamese", using: "WorldServiceVietnamese", examples: ["/vietnamese"]
  handle "/vietnamese/*_any", using: "WorldServiceVietnamese", examples: ["/vietnamese/example-123"]

  handle "/yoruba", using: "WorldServiceYoruba", examples: ["/yoruba"]
  handle "/yoruba/*_any", using: "WorldServiceYoruba", examples: ["/yoruba/awon-iroyin-miran-51716954"]

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
