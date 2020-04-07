defmodule Routes.Routefile do
  use BelfrageWeb.RouteMaster
  alias Routes.Specs.TopicPage

  redirect "/example/news/0", to: "/news", status: 302
  redirect "/example/weather/0", to: "/weather", status: 301

  handle "/", using: "HomePage", examples: ["/"]
  handle "/scotland", using: "ScotlandHomePage", examples: ["/scotland"]
  handle "/homepage/test", using: "TestHomePage", only_on: "test", examples: ["/homepage/test"]
  handle "/northernireland", using: "NorthernIrelandHomePage", examples: ["/northernireland"]
  handle "/wales", using: "WalesHomePage", examples: ["/wales"]

  handle "/fd/preview/:name", using: "FablData", examples: ["/fd/preview/example-module"]
  handle "/fd/:name", using: "FablData", examples: ["/fd/example-module"]

  handle "/wc-data/container/:name", using: "ContainerData", examples: ["/wc-data/container/promo-group"]
  handle "/wc-data/page-composition", using: "PageComposition", examples: ["/wc-data/page-composition?path=/sport"]
  handle "/hcraes", using: "Hcraes", examples: ["/hcraes"]

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
  handle "/sounds/search", using: "Search", examples: ["/sounds/search"]

  handle "/news/search", using: "NewsSearch", examples: ["/news/search"]
  handle "/news/videos/:id", using: "NewsVideos", examples: ["/news/videos/50653614"] do
    return_404 if: String.length(id) != 8
  end

  handle "/news/:id", using: "NewsArticlePage", examples: ["/news/uk-politics-49336144"] do
    return_404 if: !String.match?(id, ~r/[a-zA-Z0-9\/-]*$/)
  end

  handle "/sport/videos/service-worker.js", using: "SportVideos", examples: ["/sport/videos/service-worker.js"]
  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"] do
    return_404 if: String.length(id) != 8
  end

  handle "/pres-test/*any", using: "PresTest", only_on: "test", examples: ["/pres-test/greeting-loader", "/pres-test/hcraes"]

  handle "/afaanoromoo.amp", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo.amp"]
  handle "/afaanoromoo.json", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo.json"]
  handle "/afaanoromoo/*_any", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo", "/afaanoromoo/example-123", "/afaanoromoo/example-123.amp", "/afaanoromoo/example-123.json"]
  handle "/afrique.amp", using: "WorldServiceAfrique", examples: ["/afrique.amp"]
  handle "/afrique.json", using: "WorldServiceAfrique", examples: ["/afrique.json"]
  handle "/afrique/*_any", using: "WorldServiceAfrique", examples: ["/afrique", "/afrique/example-123", "/afrique/example-123.amp", "/afrique/example-123.json"]
  handle "/amharic.amp", using: "WorldServiceAmharic", examples: ["/amharic.amp"]
  handle "/amharic.json", using: "WorldServiceAmharic", examples: ["/amharic.json"]
  handle "/amharic/*_any", using: "WorldServiceAmharic", examples: ["/amharic", "/amharic/example-123", "/amharic/example-123.amp", "/amharic/example-123.json"]
  handle "/arabic.amp", using: "WorldServiceArabic", examples: ["/arabic.amp"]
  handle "/arabic.json", using: "WorldServiceArabic", examples: ["/arabic.json"]
  handle "/arabic/*_any", using: "WorldServiceArabic", examples: ["/arabic", "/arabic/example-123", "/arabic/example-123.amp", "/arabic/example-123.json"]
  handle "/azeri.amp", using: "WorldServiceAzeri", examples: ["/azeri.amp"]
  handle "/azeri.json", using: "WorldServiceAzeri", examples: ["/azeri.json"]
  handle "/azeri/*_any", using: "WorldServiceAzeri", examples: ["/azeri", "/azeri/example-123", "/azeri/example-123.amp", "/azeri/example-123.json"]
  handle "/bengali.amp", using: "WorldServiceBengali", examples: ["/bengali.amp"]
  handle "/bengali.json", using: "WorldServiceBengali", examples: ["/bengali.json"]
  handle "/bengali/*_any", using: "WorldServiceBengali", examples: ["/bengali", "/bengali/example-123", "/bengali/example-123.amp", "/bengali/example-123.json"]
  handle "/burmese.amp", using: "WorldServiceBurmese", examples: ["/burmese.amp"]
  handle "/burmese.json", using: "WorldServiceBurmese", examples: ["/burmese.json"]
  handle "/burmese/*_any", using: "WorldServiceBurmese", examples: ["/burmese", "/burmese/example-123", "/burmese/example-123.amp", "/burmese/example-123.json"]
  handle "/cymrufyw.amp", using: "WorldServiceCymrufyw", examples: ["/cymrufyw.amp"]
  handle "/cymrufyw.json", using: "WorldServiceCymrufyw", examples: ["/cymrufyw.json"]
  handle "/cymrufyw/*_any", using: "WorldServiceCymrufyw", examples: ["/cymrufyw", "/cymrufyw/example-123", "/cymrufyw/example-123.amp", "/cymrufyw/example-123.json"]
  handle "/gahuza.amp", using: "WorldServiceGahuza", examples: ["/gahuza.amp"]
  handle "/gahuza.json", using: "WorldServiceGahuza", examples: ["/gahuza.json"]
  handle "/gahuza/*_any", using: "WorldServiceGahuza", examples: ["/gahuza", "/gahuza/example-123", "/gahuza/example-123.amp", "/gahuza/example-123.json"]
  handle "/gujarati.amp", using: "WorldServiceGujarati", examples: ["/gujarati.amp"]
  handle "/gujarati.json", using: "WorldServiceGujarati", examples: ["/gujarati.json"]
  handle "/gujarati/*_any", using: "WorldServiceGujarati", examples: ["/gujarati", "/gujarati/example-123", "/gujarati/example-123.amp", "/gujarati/example-123.json"]
  handle "/hausa.amp", using: "WorldServiceHausa", examples: ["/hausa.amp"]
  handle "/hausa.json", using: "WorldServiceHausa", examples: ["/hausa.json"]
  handle "/hausa/*_any", using: "WorldServiceHausa", examples: ["/hausa", "/hausa/example-123", "/hausa/example-123.amp", "/hausa/example-123.json"]
  handle "/hindi.amp", using: "WorldServiceHindi", examples: ["/hindi.amp"]
  handle "/hindi.json", using: "WorldServiceHindi", examples: ["/hindi.json"]
  handle "/hindi/*_any", using: "WorldServiceHindi", examples: ["/hindi", "/hindi/example-123", "/hindi/example-123.amp", "/hindi/example-123.json"]
  handle "/igbo.amp", using: "WorldServiceIgbo", examples: ["/igbo.amp"]
  handle "/igbo.json", using: "WorldServiceIgbo", examples: ["/igbo.json"]
  handle "/igbo/*_any", using: "WorldServiceIgbo", examples: ["/igbo", "/igbo/example-123", "/igbo/example-123.amp", "/igbo/example-123.json"]
  handle "/indonesia.amp", using: "WorldServiceIndonesia", examples: ["/indonesia.amp"]
  handle "/indonesia.json", using: "WorldServiceIndonesia", examples: ["/indonesia.json"]
  handle "/indonesia/*_any", using: "WorldServiceIndonesia", examples: ["/indonesia", "/indonesia/example-123", "/indonesia/example-123.amp", "/indonesia/example-123.json"]
  handle "/japanese.amp", using: "WorldServiceJapanese", examples: ["/japanese.amp"]
  handle "/japanese.json", using: "WorldServiceJapanese", examples: ["/japanese.json"]
  handle "/japanese/*_any", using: "WorldServiceJapanese", examples: ["/japanese", "/japanese/example-123", "/japanese/example-123.amp", "/japanese/example-123.json"]
  handle "/korean.amp", using: "WorldServiceKorean", examples: ["/korean.amp"]
  handle "/korean.json", using: "WorldServiceKorean", examples: ["/korean.json"]
  handle "/korean/*_any", using: "WorldServiceKorean", examples: ["/korean", "/korean/example-123", "/korean/example-123.amp", "/korean/example-123.json"]
  handle "/kyrgyz.amp", using: "WorldServiceKyrgyz", examples: ["/kyrgyz.amp"]
  handle "/kyrgyz.json", using: "WorldServiceKyrgyz", examples: ["/kyrgyz.json"]
  handle "/kyrgyz/*_any", using: "WorldServiceKyrgyz", examples: ["/kyrgyz", "/kyrgyz/example-123", "/kyrgyz/example-123.amp", "/kyrgyz/example-123.json"]
  handle "/marathi.amp", using: "WorldServiceMarathi", examples: ["/marathi.amp"]
  handle "/marathi.json", using: "WorldServiceMarathi", examples: ["/marathi.json"]
  handle "/marathi/*_any", using: "WorldServiceMarathi", examples: ["/marathi", "/marathi/example-123", "/marathi/example-123.amp", "/marathi/example-123.json"]
  handle "/mundo.amp", using: "WorldServiceMundo", examples: ["/mundo.amp"]
  handle "/mundo.json", using: "WorldServiceMundo", examples: ["/mundo.json"]
  handle "/mundo/*_any", using: "WorldServiceMundo", examples: ["/mundo", "/mundo/example-123", "/mundo/example-123.amp", "/mundo/example-123.json"]
  handle "/naidheachdan.amp", using: "WorldServiceNaidheachdan", examples: ["/naidheachdan.amp"]
  handle "/naidheachdan.json", using: "WorldServiceNaidheachdan", examples: ["/naidheachdan.json"]
  handle "/naidheachdan/*_any", using: "WorldServiceNaidheachdan", examples: ["/naidheachdan", "/naidheachdan/example-123", "/naidheachdan/example-123.amp", "/naidheachdan/example-123.json"]
  handle "/newyddion.amp", using: "WorldServiceNewyddion", examples: ["/newyddion.amp"]
  handle "/newyddion.json", using: "WorldServiceNewyddion", examples: ["/newyddion.json"]
  handle "/newyddion/*_any", using: "WorldServiceNewyddion", examples: ["/newyddion", "/newyddion/example-123", "/newyddion/example-123.amp", "/newyddion/example-123.json"]
  handle "/nepali.amp", using: "WorldServiceNepali", examples: ["/nepali.amp"]
  handle "/nepali.json", using: "WorldServiceNepali", examples: ["/nepali.json"]
  handle "/nepali/*_any", using: "WorldServiceNepali", examples: ["/nepali", "/nepali/example-123", "/nepali/example-123.amp", "/nepali/example-123.json"]
  handle "/pashto.amp", using: "WorldServicePashto", examples: ["/pashto.amp"]
  handle "/pashto.json", using: "WorldServicePashto", examples: ["/pashto.json"]
  handle "/pashto/*_any", using: "WorldServicePashto", examples: ["/pashto", "/pashto/example-123", "/pashto/example-123.amp", "/pashto/example-123.json"]
  handle "/persian.amp", using: "WorldServicePersian", examples: ["/persian.amp"]
  handle "/persian.json", using: "WorldServicePersian", examples: ["/persian.json"]
  handle "/persian/*_any", using: "WorldServicePersian", examples: ["/persian", "/persian/example-123", "/persian/example-123.amp", "/persian/example-123.json"]
  handle "/pidgin.amp", using: "WorldServicePidgin", examples: ["/pidgin.amp"]
  handle "/pidgin.json", using: "WorldServicePidgin", examples: ["/pidgin.json"]
  handle "/pidgin/*_any", using: "WorldServicePidgin", examples: ["/pidgin", "/pidgin/example-123", "/pidgin/example-123.amp", "/pidgin/example-123.json"]
  handle "/portuguese.amp", using: "WorldServicePortuguese", examples: ["/portuguese.amp"]
  handle "/portuguese.json", using: "WorldServicePortuguese", examples: ["/portuguese.json"]
  handle "/portuguese/*_any", using: "WorldServicePortuguese", examples: ["/portuguese", "/portuguese/example-123", "/portuguese/example-123.amp", "/portuguese/example-123.json"]
  handle "/punjabi.amp", using: "WorldServicePunjabi", examples: ["/punjabi.amp"]
  handle "/punjabi.json", using: "WorldServicePunjabi", examples: ["/punjabi.json"]
  handle "/punjabi/*_any", using: "WorldServicePunjabi", examples: ["/punjabi", "/punjabi/example-123", "/punjabi/example-123.amp", "/punjabi/example-123.json"]
  handle "/russian.amp", using: "WorldServiceRussian", examples: ["/russian.amp"]
  handle "/russian.json", using: "WorldServiceRussian", examples: ["/russian.json"]
  handle "/russian/*_any", using: "WorldServiceRussian", examples: ["/russian", "/russian/example-123", "/russian/example-123.amp", "/russian/example-123.json"]
  handle "/sinhala.amp", using: "WorldServiceSinhala", examples: ["/sinhala.amp"]
  handle "/sinhala.json", using: "WorldServiceSinhala", examples: ["/sinhala.json"]
  handle "/sinhala/*_any", using: "WorldServiceSinhala", examples: ["/sinhala", "/sinhala/example-123", "/sinhala/example-123.amp", "/sinhala/example-123.json"]
  handle "/somali.amp", using: "WorldServiceSomali", examples: ["/somali.amp"]
  handle "/somali.json", using: "WorldServiceSomali", examples: ["/somali.json"]
  handle "/somali/*_any", using: "WorldServiceSomali", examples: ["/somali", "/somali/example-123", "/somali/example-123.amp", "/somali/example-123.json"]
  handle "/swahili.amp", using: "WorldServiceSwahili", examples: ["/swahili.amp"]
  handle "/swahili.json", using: "WorldServiceSwahili", examples: ["/swahili.json"]
  handle "/swahili/*_any", using: "WorldServiceSwahili", examples: ["/swahili", "/swahili/example-123", "/swahili/example-123.amp", "/swahili/example-123.json"]
  handle "/tajik.amp", using: "WorldServiceTajik", examples: ["/tajik.amp"]
  handle "/tajik.json", using: "WorldServiceTajik", examples: ["/tajik.json"]
  handle "/tajik/*_any", using: "WorldServiceTajik", examples: ["/tajik", "/tajik/example-123", "/tajik/example-123.amp", "/tajik/example-123.json"]
  handle "/tamil.amp", using: "WorldServiceTamil", examples: ["/tamil.amp"]
  handle "/tamil.json", using: "WorldServiceTamil", examples: ["/tamil.json"]
  handle "/tamil/*_any", using: "WorldServiceTamil", examples: ["/tamil", "/tamil/example-123", "/tamil/example-123.amp", "/tamil/example-123.json"]
  handle "/telugu.amp", using: "WorldServiceTelugu", examples: ["/telugu.amp"]
  handle "/telugu.json", using: "WorldServiceTelugu", examples: ["/telugu.json"]
  handle "/telugu/*_any", using: "WorldServiceTelugu", examples: ["/telugu", "/telugu/example-123", "/telugu/example-123.amp", "/telugu/example-123.json"]
  handle "/thai.amp", using: "WorldServiceThai", examples: ["/thai.amp"]
  handle "/thai.json", using: "WorldServiceThai", examples: ["/thai.json"]
  handle "/thai/*_any", using: "WorldServiceThai", examples: ["/thai", "/thai/example-123", "/thai/example-123.amp", "/thai/example-123.json"]
  handle "/tigrinya.amp", using: "WorldServiceTigrinya", examples: ["/tigrinya.amp"]
  handle "/tigrinya.json", using: "WorldServiceTigrinya", examples: ["/tigrinya.json"]
  handle "/tigrinya/*_any", using: "WorldServiceTigrinya", examples: ["/tigrinya", "/tigrinya/example-123", "/tigrinya/example-123.amp", "/tigrinya/example-123.json"]
  handle "/turkce.amp", using: "WorldServiceTurkce", examples: ["/turkce.amp"]
  handle "/turkce.json", using: "WorldServiceTurkce", examples: ["/turkce.json"]
  handle "/turkce/*_any", using: "WorldServiceTurkce", examples: ["/turkce", "/turkce/example-123", "/turkce/example-123.amp", "/turkce/example-123.json"]
  handle "/ukrainian.amp", using: "WorldServiceUkrainian", examples: ["/ukrainian.amp"]
  handle "/ukrainian.json", using: "WorldServiceUkrainian", examples: ["/ukrainian.json"]
  handle "/ukrainian/*_any", using: "WorldServiceUkrainian", examples: ["/ukrainian", "/ukrainian/example-123", "/ukrainian/example-123.amp", "/ukrainian/example-123.json"]
  handle "/urdu.amp", using: "WorldServiceUrdu", examples: ["/urdu.amp"]
  handle "/urdu.json", using: "WorldServiceUrdu", examples: ["/urdu.json"]
  handle "/urdu/*_any", using: "WorldServiceUrdu", examples: ["/urdu", "/urdu/example-123", "/urdu/example-123.amp", "/urdu/example-123.json"]
  handle "/uzbek.amp", using: "WorldServiceUzbek", examples: ["/uzbek.amp"]
  handle "/uzbek.json", using: "WorldServiceUzbek", examples: ["/uzbek.json"]
  handle "/uzbek/*_any", using: "WorldServiceUzbek", examples: ["/uzbek", "/uzbek/example-123", "/uzbek/example-123.amp", "/uzbek/example-123.json"]
  handle "/vietnamese.amp", using: "WorldServiceVietnamese", examples: ["/vietnamese.amp"]
  handle "/vietnamese.json", using: "WorldServiceVietnamese", examples: ["/vietnamese.json"]
  handle "/vietnamese/*_any", using: "WorldServiceVietnamese", examples: ["/vietnamese", "/vietnamese/example-123", "/vietnamese/example-123.amp", "/vietnamese/example-123.json"]
  handle "/yoruba.amp", using: "WorldServiceYoruba", examples: ["/yoruba.amp"]
  handle "/yoruba.json", using: "WorldServiceYoruba", examples: ["/yoruba.json"]
  handle "/yoruba/*_any", using: "WorldServiceYoruba", examples: ["/yoruba", "/yoruba/example-123", "/yoruba/example-123.amp", "/yoruba/example-123.json"]

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
