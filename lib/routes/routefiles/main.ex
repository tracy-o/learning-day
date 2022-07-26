#
# How to add a route:
# https://github.com/bbc/belfrage/wiki/Routing-in-Belfrage#how-to-add-a-route
# What types of route matcher you can  use:
# https://github.com/bbc/belfrage/wiki/Types-of-Route-Matchers-in-Belfrage
#

import BelfrageWeb.Routefile

defroutefile "Main" do
  # Vanity URLs

  redirect("http://www.bbcafaanoromoo.com/*any", to: "https://www.bbc.com/afaanoromoo/*any", status: 302)
  redirect("http://www.bbcafrique.com/*any", to: "https://www.bbc.com/afrique/*any", status: 302)
  redirect("http://m.bbcafrique.com/*any", to: "https://www.bbc.com/afrique/*any", status: 302)
  redirect("http://bbcafrique.com/*any", to: "https://www.bbc.com/afrique/*any", status: 302)
  redirect("http://www.bbcamharic.com/*any", to: "https://www.bbc.com/amharic/*any", status: 302)
  redirect("http://bbcamharic.com/*any", to: "https://www.bbc.com/amharic/*any", status: 302)
  redirect("http://www.bbcarabic.com/*any", to: "https://www.bbc.com/arabic/*any", status: 302)
  redirect("http://m.bbcarabic.com/*any", to: "https://www.bbc.com/arabic/*any", status: 302)
  redirect("http://bbcarabic.com/*any", to: "https://www.bbc.com/arabic/*any", status: 302)
  redirect("http://www.bbcazeri.com/*any", to: "https://www.bbc.com/azeri/*any", status: 302)
  redirect("http://m.bbcazeri.com/*any", to: "https://www.bbc.com/azeri/*any", status: 302)
  redirect("http://bbcazeri.com/*any", to: "https://www.bbc.com/azeri/*any", status: 302)
  redirect("http://www.bbcbengali.com/*any", to: "https://www.bbc.com/bengali/*any", status: 302)
  redirect("http://m.bbcbengali.com/*any", to: "https://www.bbc.com/bengali/*any", status: 302)
  redirect("http://bbcbengali.com/*any", to: "https://www.bbc.com/bengali/*any", status: 302)
  redirect("http://www.bbcburmese.com/*any", to: "https://www.bbc.com/burmese/*any", status: 302)
  redirect("http://m.bbcburmese.com/*any", to: "https://www.bbc.com/burmese/*any", status: 302)
  redirect("http://bbcburmese.com/*any", to: "https://www.bbc.com/burmese/*any", status: 302)
  redirect("http://www.bbcgahuza.com/*any", to: "https://www.bbc.com/gahuza/*any", status: 302)
  redirect("http://m.bbcgahuza.com/*any", to: "https://www.bbc.com/gahuza/*any", status: 302)
  redirect("http://bbcgahuza.com/*any", to: "https://www.bbc.com/gahuza/*any", status: 302)
  redirect("http://www.bbcgujarati.com/*any", to: "https://www.bbc.com/gujarati/*any", status: 302)
  redirect("http://m.bbcgujarati.com/*any", to: "https://www.bbc.com/gujarati/*any", status: 302)
  redirect("http://bbcgujarati.com/*any", to: "https://www.bbc.com/gujarati/*any", status: 302)
  redirect("http://www.bbchausa.com/*any", to: "https://www.bbc.com/hausa/*any", status: 302)
  redirect("http://m.bbchausa.com/*any", to: "https://www.bbc.com/hausa/*any", status: 302)
  redirect("http://bbchausa.com/*any", to: "https://www.bbc.com/hausa/*any", status: 302)
  redirect("http://www.bbchindi.com/*any", to: "https://www.bbc.com/hindi/*any", status: 302)
  redirect("http://m.bbchindi.com/*any", to: "https://www.bbc.com/hindi/*any", status: 302)
  redirect("http://bbchindi.com/*any", to: "https://www.bbc.com/hindi/*any", status: 302)
  redirect("http://www.bbcigbo.com/*any", to: "https://www.bbc.com/igbo/*any", status: 302)
  redirect("http://bbcigbo.com/*any", to: "https://www.bbc.com/igbo/*any", status: 302)
  redirect("http://www.bbcindonesia.com/*any", to: "https://www.bbc.com/indonesia/*any", status: 302)
  redirect("http://bbcindonesia.com/*any", to: "https://www.bbc.com/indonesia/*any", status: 302)
  redirect("http://www.bbckorean.com/*any", to: "https://www.bbc.com/korean/*any", status: 302)
  redirect("http://bbckorean.com/*any", to: "https://www.bbc.com/korean/*any", status: 302)
  redirect("http://www.bbckyrgyz.com/*any", to: "https://www.bbc.com/kyrgyz/*any", status: 302)
  redirect("http://m.bbckyrgyz.com/*any", to: "https://www.bbc.com/kyrgyz/*any", status: 302)
  redirect("http://bbckyrgyz.com/*any", to: "https://www.bbc.com/kyrgyz/*any", status: 302)
  redirect("http://www.bbcmarathi.com/*any", to: "https://www.bbc.com/marathi/*any", status: 302)
  redirect("http://bbcmarathi.com/*any", to: "https://www.bbc.com/marathi/*any", status: 302)
  redirect("http://www.bbcmundo.com/*any", to: "https://www.bbc.com/mundo/*any", status: 302)
  redirect("http://m.bbcmundo.com/*any", to: "https://www.bbc.com/mundo/*any", status: 302)
  redirect("http://bbcmundo.com/*any", to: "https://www.bbc.com/mundo/*any", status: 302)
  redirect("http://www.bbcnepali.com/*any", to: "https://www.bbc.com/nepali/*any", status: 302)
  redirect("http://m.bbcnepali.com/*any", to: "https://www.bbc.com/nepali/*any", status: 302)
  redirect("http://bbcnepali.com/*any", to: "https://www.bbc.com/nepali/*any", status: 302)
  redirect("http://www.bbcpashto.com/*any", to: "https://www.bbc.com/pashto/*any", status: 302)
  redirect("http://m.bbcpashto.com/*any", to: "https://www.bbc.com/pashto/*any", status: 302)
  redirect("http://bbcpashto.com/*any", to: "https://www.bbc.com/pashto/*any", status: 302)
  redirect("http://www.bbcpersian.com/*any", to: "https://www.bbc.com/persian/*any", status: 302)
  redirect("http://m.bbcpersian.com/*any", to: "https://www.bbc.com/persian/*any", status: 302)
  redirect("http://bbcpersian.com/*any", to: "https://www.bbc.com/persian/*any", status: 302)
  redirect("http://www.bbcpidgin.com/*any", to: "https://www.bbc.com/pidgin/*any", status: 302)
  redirect("http://bbcpidgin.com/*any", to: "https://www.bbc.com/pidgin/*any", status: 302)
  redirect("http://www.bbcportuguese.com/*any", to: "https://www.bbc.com/portuguese/*any", status: 302)
  redirect("http://m.bbcportuguese.com/*any", to: "https://www.bbc.com/portuguese/*any", status: 302)
  redirect("http://bbcportuguese.com/*any", to: "https://www.bbc.com/portuguese/*any", status: 302)
  redirect("http://www.bbcbrasil.com/*any", to: "https://www.bbc.com/portuguese/*any", status: 302)
  redirect("http://m.bbcbrasil.com/*any", to: "https://www.bbc.com/portuguese/*any", status: 302)
  redirect("http://bbcbrasil.com/*any", to: "https://www.bbc.com/portuguese/*any", status: 302)
  redirect("http://www.bbcpunjabi.com/*any", to: "https://www.bbc.com/punjabi/*any", status: 302)
  redirect("http://bbcpunjabi.com/*any", to: "https://www.bbc.com/punjabi/*any", status: 302)
  # redirect("http://www.bbcrussian.com/*any", to: "https://www.bbc.com/russian/*any", status: 302)
  # redirect("http://m.bbcrussian.com/*any", to: "https://www.bbc.com/russian/*any", status: 302)
  # redirect("http://bbcrussian.com/*any", to: "https://www.bbc.com/russian/*any", status: 302)
  redirect("http://www.bbcsinhala.com/*any", to: "https://www.bbc.com/sinhala/*any", status: 302)
  redirect("http://m.bbcsinhala.com/*any", to: "https://www.bbc.com/sinhala/*any", status: 302)
  redirect("http://bbcsinhala.com/*any", to: "https://www.bbc.com/sinhala/*any", status: 302)
  redirect("http://www.bbcserbian.com/*any", to: "https://www.bbc.com/serbian/*any", status: 302)
  redirect("http://bbcserbian.com/*any", to: "https://www.bbc.com/serbian/*any", status: 302)
  redirect("http://www.bbcsomali.com/*any", to: "https://www.bbc.com/somali/*any", status: 302)
  redirect("http://m.bbcsomali.com/*any", to: "https://www.bbc.com/somali/*any", status: 302)
  redirect("http://bbcsomali.com/*any", to: "https://www.bbc.com/somali/*any", status: 302)
  redirect("http://www.bbcswahili.com/*any", to: "https://www.bbc.com/swahili/*any", status: 302)
  redirect("http://m.bbcswahili.com/*any", to: "https://www.bbc.com/swahili/*any", status: 302)
  redirect("http://bbcswahili.com/*any", to: "https://www.bbc.com/swahili/*any", status: 302)
  redirect("http://www.bbctajik.com/*any", to: "https://www.bbc.com/tajik/*any", status: 302)
  redirect("http://bbctajik.com/*any", to: "https://www.bbc.com/tajik/*any", status: 302)
  redirect("http://www.bbctamil.com/*any", to: "https://www.bbc.com/tamil/*any", status: 302)
  redirect("http://m.bbctamil.com/*any", to: "https://www.bbc.com/tamil/*any", status: 302)
  redirect("http://bbctamil.com/*any", to: "https://www.bbc.com/tamil/*any", status: 302)
  redirect("http://www.bbctelugu.com/*any", to: "https://www.bbc.com/telugu/*any", status: 302)
  redirect("http://bbctelugu.com/*any", to: "https://www.bbc.com/telugu/*any", status: 302)
  redirect("http://www.bbcthai.com/*any", to: "https://www.bbc.com/thai/*any", status: 302)
  redirect("http://m.bbcthai.com/*any", to: "https://www.bbc.com/thai/*any", status: 302)
  redirect("http://bbcthai.com/*any", to: "https://www.bbc.com/thai/*any", status: 302)
  redirect("http://www.bbctigrinya.com/*any", to: "https://www.bbc.com/tigrinya/*any", status: 302)
  redirect("http://bbctigrinya.com/*any", to: "https://www.bbc.com/tigrinya/*any", status: 302)
  redirect("http://www.bbcturkce.com/*any", to: "https://www.bbc.com/turkce/*any", status: 302)
  redirect("http://m.bbcturkce.com/*any", to: "https://www.bbc.com/turkce/*any", status: 302)
  redirect("http://bbcturkce.com/*any", to: "https://www.bbc.com/turkce/*any", status: 302)
  redirect("http://www.bbcukchina.com/*any", to: "https://www.bbc.com/ukchina/*any", status: 302)
  redirect("http://m.bbcukchina.com/*any", to: "https://www.bbc.com/ukchina/*any", status: 302)
  redirect("http://bbcukchina.com/*any", to: "https://www.bbc.com/ukchina/*any", status: 302)
  redirect("http://www.bbcukrainian.com/*any", to: "https://www.bbc.com/ukrainian/*any", status: 302)
  redirect("http://m.bbcukrainian.com/*any", to: "https://www.bbc.com/ukrainian/*any", status: 302)
  redirect("http://bbcukrainian.com/*any", to: "https://www.bbc.com/ukrainian/*any", status: 302)
  redirect("http://www.bbcurdu.com/*any", to: "https://www.bbc.com/urdu/*any", status: 302)
  redirect("http://m.bbcurdu.com/*any", to: "https://www.bbc.com/urdu/*any", status: 302)
  redirect("http://bbcurdu.com/*any", to: "https://www.bbc.com/urdu/*any", status: 302)
  redirect("http://www.bbcuzbek.com/*any", to: "https://www.bbc.com/uzbek/*any", status: 302)
  redirect("http://m.bbcuzbek.com/*any", to: "https://www.bbc.com/uzbek/*any", status: 302)
  redirect("http://bbcuzbek.com/*any", to: "https://www.bbc.com/uzbek/*any", status: 302)
  redirect("http://www.bbcvietnamese.com/*any", to: "https://www.bbc.com/vietnamese/*any", status: 302)
  redirect("http://m.bbcvietnamese.com/*any", to: "https://www.bbc.com/vietnamese/*any", status: 302)
  redirect("http://bbcvietnamese.com/*any", to: "https://www.bbc.com/vietnamese/*any", status: 302)
  redirect("http://www.bbcyoruba.com/*any", to: "https://www.bbc.com/yoruba/*any", status: 302)
  redirect("http://bbcyoruba.com/*any", to: "https://www.bbc.com/yoruba/*any", status: 302)
  redirect("http://www.bbczhongwen.com/*any", to: "https://www.bbc.com/zhongwen/*any", status: 302)
  redirect("http://m.bbczhongwen.com/*any", to: "https://www.bbc.com/zhongwen/*any", status: 302)
  redirect("http://bbczhongwen.com/*any", to: "https://www.bbc.com/zhongwen/*any", status: 302)
  redirect("http://www.bbcasiapacific.com/*any", to: "https://www.bbc.com/news/world/asia/*any", status: 302)
  redirect("http://m.bbcasiapacific.com/*any", to: "https://www.bbc.com/news/world/asia/*any", status: 302)
  redirect("http://bbcasiapacific.com/*any", to: "https://www.bbc.com/news/world/asia/*any", status: 302)
  redirect("http://www.bbcsouthasia.com/*any", to: "https://www.bbc.com/news/world/asia/*any", status: 302)
  redirect("http://m.bbcsouthasia.com/*any", to: "https://www.bbc.com/news/world/asia/*any", status: 302)
  redirect("http://bbcsouthasia.com/*any", to: "https://www.bbc.com/news/world/asia/*any", status: 302)

  redirect("/news/0", to: "/news", status: 302)
  redirect("/news/2/hi", to: "/news", status: 302)
  redirect("/news/mobile", to: "/news", status: 302)
  redirect("/news/popular/read", to: "/news", status: 302)

  redirect("/news/help", to: "/news", status: 302)
  redirect("/news/also_in_the_news", to: "/news", status: 302)
  redirect("/news/cop26-alerts", to: "/news/help-58765412", status: 302)
  redirect("/news/wales-election-2021-alerts", to: "/news/help-56680930", status: 302)
  redirect("/news/scotland-election-2021-alerts", to: "/news/help-56680931", status: 302)
  redirect("/news/nie22-alerts", to: "/news/help-60495859", status: 302)

  redirect("/news/magazine", to: "/news/stories", status: 302)

  redirect("/news/10318089", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302)
  redirect("/news/av/10318089", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302)
  redirect("/news/av/10318089/bbc-news-channel", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302)
  redirect("/news/video_and_audio/headlines/10318089/bbc-news-channel", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302)

  redirect("/news/video_and_audio/international", to: "/news/av/10462520", status: 302)
  redirect("/news/video_and_audio/video", to: "/news/av/10318236", status: 302)
  redirect("/news/video_and_audio/features/:section_and_asset/:asset_id", to: "/news/av/:section_and_asset", status: 302)
  redirect "/news/world-middle-east-27796850", to: "/programmes/w13xtvn3", status: 301

  redirect("/cymrufyw/etholiad", to: "/cymrufyw/gwleidyddiaeth", status: 302)
  redirect("/cymrufyw/etholiad/2021", to: "/cymrufyw/gwleidyddiaeth", status: 302)
  redirect("/cymrufyw/etholiad/2021/cymru", to: "/cymrufyw/pynciau/cvd627zw9rjt/etholiad-senedd-cymru-2021", status: 302)
  redirect("/cymrufyw/etholiad/2021/cymru/canlyniadau", to: "/cymrufyw/pynciau/cvd627zw9rjt/etholiad-senedd-cymru-2021", status: 302)
  redirect("/news/election", to: "/news/politics", status: 302)
  redirect("/news/election/2021", to: "/news/politics", status: 302)
  redirect("/news/election/2021/scotland", to: "/news/topics/c37d28xdn99t/scottish-parliament-election-2021", status: 302)
  redirect("/news/election/2021/wales", to: "/news/topics/cqwn14k92zwt/welsh-parliament-election-2021", status: 302)
  redirect("/news/election/2021/england", to: "/news/topics/c481drqqzv7t/england-local-elections-2021", status: 302)
  redirect("/news/election/2021/scotland/results", to: "/news/topics/c37d28xdn99t/scottish-parliament-election-2021", status: 302)
  redirect("/news/election/2021/wales/results", to: "/news/topics/cqwn14k92zwt/welsh-parliament-election-2021", status: 302)
  redirect("/news/election/2021/england/results", to: "/news/topics/c481drqqzv7t/england-local-elections-2021", status: 302)
  redirect("/news/election/2021/london", to: "/news/topics/c27kz1m3j9mt/london-elections-2021", status: 302)

  redirect("https://www.bbc.com/ukraine", to: "https://www.bbc.com/ukrainian", status: 302)
  redirect("https://www.bbc.co.uk/ukraine", to: "/news/world-60525350", status: 302)
  redirect("https://www.test.bbc.com/ukraine", to: "https://www.test.bbc.com/ukrainian", status: 302)
  redirect("https://www.test.bbc.co.uk/ukraine", to: "/news/world-60525350", status: 302)

  # Home Page

  redirect "/ni", to: "/northernireland", status: 302

  handle "/", using: "HomePage", examples: ["/"]
  handle "/scotland", using: "ScotlandHomePage", examples: ["/scotland"]
  handle "/homepage/test", using: "TestHomePage", only_on: "test", examples: ["/homepage/test"]
  handle "/homepage/automation", using: "AutomationHomePage", only_on: "test", examples: ["/homepage/automation"]
  handle "/northernireland", using: "NorthernIrelandHomePage", examples: ["/northernireland"]
  handle "/wales", using: "WalesHomePage", examples: ["/wales"]
  handle "/cymru", using: "CymruHomePage", examples: ["/cymru"]
  handle "/alba", using: "AlbaHomePage", examples: ["/alba"]

  handle "/newstipo", using: "NewsTipoHomePage", only_on: "test", examples: ["/newstipo"]

  handle "/homepage/preview", using: "HomePagePreview", only_on: "test", examples: ["/homepage/preview"]
  handle "/homepage/preview/scotland", using: "HomePagePreviewScotland", only_on: "test", examples: ["/homepage/preview/scotland"]
  handle "/homepage/preview/wales", using: "HomePagePreviewWales", only_on: "test", examples: ["/homepage/preview/wales"]
  handle "/homepage/preview/northernireland", using: "HomePagePreviewNorthernIreland", only_on: "test", examples: ["/homepage/preview/northernireland"]
  handle "/homepage/preview/cymru", using: "HomePagePreviewCymru", only_on: "test", examples: ["/homepage/preview/cymru"]
  handle "/homepage/preview/alba", using: "HomePagePreviewAlba", only_on: "test", examples: ["/homepage/preview/alba"]

  handle "/homepage/personalised", using: "HomePagePersonalised", examples: ["/homepage/personalised"]
  handle "/homepage/segmented", using: "HomePageSegmented", examples: ["/homepage/segmented"]

  handle "/sportproto", using: "SportHomePage", only_on: "test", examples: ["/sportproto"]
  handle "/sporttipo", using: "SportTipo", examples: ["/sporttipo"]

  handle "/homepage/sport/preview", using: "SportHomePagePreview", only_on: "test", examples: ["/homepage/sport/preview"]
  handle "/homepage/sport/test", using: "TestSportHomePage", only_on: "test", examples: ["/homepage/sport/test"]

  # data endpoints

  handle "/fd/p/mytopics-page", using: "MyTopicsPage", examples: []
  handle "/fd/p/mytopics-follows", using: "MyTopicsFollows", examples: []
  handle "/fd/p/preview/:name", using: "PersonalisedFablData", only_on: "test", examples: []
  handle "/fd/preview/:name", using: "FablData", examples: ["/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"]
  handle "/fd/p/:name", using: "PersonalisedFablData", only_on: "test", examples: []

  handle "/fd/sport-app-allsport", using: "SportData", examples: ["/fd/sport-app-allsport?env=live&edition=domestic"]
  handle "/fd/sport-app-followables", using: "SportData", examples: ["/fd/sport-app-followables?env=live&edition=domestic"]
  handle "/fd/sport-app-images", using: "SportData", examples: ["/fd/sport-app-images"]
  handle "/fd/sport-app-menu", using: "SportData", examples: ["/fd/sport-app-menu?edition=domestic&platform=ios&env=live"]
  handle "/fd/sport-app-notification-data", using: "SportData", examples: ["/fd/sport-app-notification-data"]
  handle "/fd/sport-app-page", using: "SportData", examples: ["/fd/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios", "/fd/sport-app-page?page=https%3A%2F%2Fwww.bbc.co.uk%2Fsport&v=11&platform=ios&edition=domestic"]
  handle "/fd/topic-mapping", using: "SportData", examples: ["/fd/topic-mapping?product=sport&followable=true&alias=false", "/fd/topic-mapping?product=sport&route=/sport&edition=domestic"]

  handle "/fd/:name", using: "FablData", examples: []

  handle "/wc-data/container/:name", using: "ContainerData", examples: ["/wc-data/container/consent-banner"]
  handle "/wc-data/p/container/onward-journeys", using: "PersonalisedContainerData", examples: []
  handle "/wc-data/p/container/simple-promo-collection", using: "PersonalisedContainerData", examples: []
  handle "/wc-data/p/container/test-client-side-personalised", using: "PersonalisedContainerData", only_on: "test", examples: []
  handle "/wc-data/p/container/:name", using: "ContainerData", examples: ["/wc-data/p/container/consent-banner"]
  handle "/wc-data/page-composition", using: "PageComposition", examples: ["/wc-data/page-composition?path=/search&params=%7B%7D"]

  # Search

  handle "/search", using: "Search", examples: ["/search"]
  handle "/chwilio", using: "WelshSearch", examples: ["/chwilio"]
  handle "/cbeebies/search", using: "Search", examples: ["/cbeebies/search"]
  handle "/cbbc/search", using: "Search", examples: ["/cbbc/search"]
  handle "/bitesize/search", using: "Search", examples: ["/bitesize/search"]
  handle "/sounds/search", using: "Search", examples: ["/sounds/search"]
  handle "/pres-test/new-chwilio", using: "WelshNewSearch", only_on: "test", examples: ["/pres-test/new-chwilio"]

  # News

  redirect "/news/articles", to: "/news", status: 302

  ## News - Mobile Redirect
  redirect "/news/mobile/*any", to: "/news", status: 301

  handle "/news", using: "NewsHomePage", examples: ["/news"]

  handle "/news/breaking-news/audience", using: "BreakingNews", examples: [] do
    return_404 if: true
  end

  handle "/news/breaking-news/audience/:audience", using: "BreakingNews", examples: ["/news/breaking-news/audience/domestic", "/news/breaking-news/audience/us", "/news/breaking-news/audience/international", "/news/breaking-news/audience/asia"] do
    return_404 if: [
      !String.match?(audience, ~r/^(domestic|us|international|asia)$/)
    ]
  end

  handle "/news/election/2022/usa/midterms-test", using: "NewsElectionResults", only_on: "test", examples: ["/news/election/2022/usa/midterms-test"]

  handle "/news/election/2021/:polity/:division_name", using: "NewsElection2021", examples: ["/news/election/2021/england/councils", "/news/election/2021/scotland/constituencies", "/news/election/2021/wales/constituencies"] do
    return_404 if: [
      !String.match?(polity, ~r/^(england|scotland|wales)$/),
      !String.match?(division_name, ~r/^(councils|constituencies)$/),
    ]
  end

  handle "/news/election/2021/england/:division_name/:division_id", using: "NewsElection2021", examples: ["/news/election/2021/england/councils/E06000023", "/news/election/2021/england/mayors/E47000001"] do
    return_404 if: [
      !String.match?(division_name, ~r/^(councils|mayors)$/),
      !String.match?(division_id, ~r/^[E][0-9]{8}$/),
      String.match?(division_id, ~r/E12000007/)
    ]
  end

  handle "/news/election/2021/:polity/:division_name/:division_id", using: "NewsElection2021", examples: ["/news/election/2021/scotland/constituencies/S16000084", "/news/election/2021/scotland/regions/S17000014", "/news/election/2021/wales/constituencies/W09000001", "/news/election/2021/wales/regions/W10000006"] do
    return_404 if: [
      !String.match?(polity, ~r/^(scotland|wales)$/),
      !String.match?(division_name, ~r/^(regions|constituencies)$/),
      !String.match?(division_id, ~r/^[SW][0-9]{8}$/)
    ]
  end

  handle "/news/election/2017/northern-ireland/results", using: "NewsElectionResults", only_on: "test", examples: ["/news/election/2017/northern-ireland/results"]

  handle "/news/election/2022/:polity/results", using: "NewsElectionResults", examples: ["/news/election/2022/england/results", "/news/election/2022/scotland/results", "/news/election/2022/wales/results", "/news/election/2022/northern-ireland/results"] do
    return_404 if: [
                 !String.match?(polity, ~r/^(england|scotland|wales|northern-ireland)$/)
               ]
  end

  handle "/news/election/2017/northern-ireland/constituencies", using: "NewsElectionResults", only_on: "test", examples: ["/news/election/2017/northern-ireland/constituencies"]

  handle "/news/election/2022/:polity/:division_name", using: "NewsElectionResults", examples: ["/news/election/2022/northern-ireland/constituencies", "/news/election/2022/england/councils", "/news/election/2022/scotland/councils", "/news/election/2022/wales/councils"] do
    return_404 if: [
       !String.match?(polity, ~r/^(england|scotland|wales|northern-ireland)$/),
       !String.match?(division_name, ~r/^(constituencies|councils)$/)
    ]
  end

  handle "/news/election/2017/northern-ireland/constituencies/:division_id", using: "NewsElectionResults", only_on: "test", examples: ["/news/election/2017/northern-ireland/constituencies/N06000001"] do
    return_404 if: [
                 !String.match?(division_id, ~r/^[N][0-9]{8}$/)
               ]
  end

  handle "/news/election/2022/:polity/:division_name/:division_id", using: "NewsElectionResults", examples: ["/news/election/2022/northern-ireland/constituencies/N06000001", "/news/election/2022/england/councils/E06000001", "/news/election/2022/wales/councils/W06000001", "/news/election/2022/scotland/councils/S06000001", "/news/election/2022/england/mayors/E06000001"] do
    return_404 if: [
                 !String.match?(polity, ~r/^(northern-ireland|england|wales|scotland)$/),
                 !String.match?(division_name, ~r/^(constituencies|councils|mayors)$/),
                 !String.match?(division_id, ~r/^[NSWE][0-9]{8}$/)
               ]
  end

  handle "/news/election/2019/uk/results", using: "NewsElectionResults", only_on: "test", examples: ["/news/election/2019/uk/results"]

  handle "/news/election/2019/uk/constituencies", using: "NewsElectionResults", only_on: "test", examples: ["/news/election/2019/uk/constituencies"]

  handle "/news/election/2019/uk/constituencies/:division_id", using: "NewsElectionResults", only_on: "test", examples: ["/news/election/2019/uk/constituencies/E92000001", "/news/election/2019/uk/constituencies/S83000001", "/news/election/2019/uk/constituencies/W76000005", "/news/election/2019/uk/constituencies/N12000001"] do
    return_404 if: [
      !String.match?(division_id, ~r/^[NSWE][0-9]{8}$/)
    ]
  end

  handle "/news/election/2019/uk/regions/:division_id", using: "NewsElectionResults", only_on: "test", examples: ["/news/election/2019/uk/regions/E92000001", "/news/election/2019/uk/regions/W92000004", "/news/election/2019/uk/regions/S92000003", "/news/election/2019/uk/regions/N92000002"] do
    return_404 if: [
      !String.match?(division_id, ~r/^(E92000001|W92000004|S92000003|N92000002)$/)
    ]
  end

  handle "/news/election/*any", using: "NewsElection", examples: ["/news/election/2019"]

  handle "/news/live/:asset_id", using: "NewsLive", examples: ["/news/live/uk-55930940"] do
    return_404 if: !String.match?(asset_id, ~r/^([0-9]{5,9}|[a-z0-9\-_]+-[0-9]{5,9})$/)
  end

  handle "/news/live/:asset_id/page/:page_number", using: "NewsLive", examples: ["/news/live/uk-55930940/page/2"] do
    return_404 if: [
      !String.match?(asset_id, ~r/^([0-9]{5,9}|[a-z0-9\-_]+-[0-9]{5,9})$/),
      !String.match?(page_number, ~r/\A[1-9][0-9]{0,2}\z/)
    ]
  end

  # Local News
  handle "/news/localnews", using: "NewsLocalNews", examples: ["/news/localnews"]
  handle "/news/localnews/faqs", using: "NewsLocalNews", examples: ["/news/localnews/faqs"]
  handle "/news/localnews/locations", using: "NewsLocalNews", examples: ["/news/localnews/locations"]
  handle "/news/localnews/locations/sitemap.xml", using: "NewsLocalNews", examples: ["/news/localnews/locations/sitemap.xml"]
  handle "/news/localnews/:location_id_and_name/*_radius", using: "NewsLocalNewsRedirect", examples: ["/news/localnews/2643743-london/0"]

  # News Topics
  redirect "/news/topics/c1vw6q14rzqt/*any", to: "/news/world-60525350", status: 302
  redirect "/news/topics/crr7mlg0d21t/*any", to: "/news/world-60525350", status: 302
  redirect "/news/topics/cmj34zmwm1zt/*any", to: "/news/science-environment-56837908", status: 302
  redirect "/news/topics/cxlvkzzjq1wt/*any", to: "/news/uk-northern-ireland-55401938", status: 302
  redirect "/news/topics/cwlw3xz0lvvt/*any", to: "/news/politics/uk_leaves_the_eu", status: 302
  redirect "/news/topics/ck7edpjq0d5t/*any", to: "/news/uk-politics-48448557", status: 302
  redirect "/news/topics/cp7r8vgl2rgt/*any", to: "/news/reality_check", status: 302
  redirect "/news/topics/c779dqxlxv2t/*any", to: "/news/world-48623037", status: 302
  redirect "/news/topics/c77jz3mdmgzt/*any", to: "/news/uk-northern-ireland-38323577", status: 302
  redirect "/news/topics/cg5rv39y9mmt/*any", to: "/news/business-38507481", status: 302
  redirect "/news/topics/c8nq32jw8mwt/*any", to: "/news/business-22434141", status: 302
  redirect "/news/topics/cd39m6424jwt/*any", to: "/news/world/asia/china", status: 302
  redirect "/news/topics/cny6mpy4mj9t/*any", to: "/news/world/asia/india", status: 302
  redirect "/news/topics/czv6rjvdy9gt/*any", to: "/news/world/australia", status: 302
  redirect "/news/topics/cp7r8vgl24lt/*any", to: "/news/world-middle-east-48433977", status: 302
  redirect "/news/topics/c5m8rrkp46dt/*any", to: "/news/election/us2020", status: 302
  redirect "/news/topics/cyz0z8w0ydwt/*any", to: "/news/coronavirus", status: 302

  handle "/news/topics/:id/:slug", using: "NewsTopics", examples: [] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(slug, ~r/^([a-z0-9-]+)$/)
    ]
  end

  handle "/news/topics/:id", using: "NewsTopics", examples: [] do
    return_404 if: !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/)
  end

  redirect "/news/amp/:id", to: "/news/:id.amp", status: 301
  redirect "/news/amp/:topic/:id", to: "/news/:topic/:id.amp", status: 301

  handle "/news/av/:asset_id/embed", using: "NewsVideosEmbed", examples: [{"/news/av/world-us-canada-50294316/embed", 302}]
  handle "/news/av/:asset_id/:slug/embed", using: "NewsVideosEmbed", examples: [{"/news/av/business-49843970/i-built-my-software-empire-from-a-stoke-council-house/embed", 302}]
  handle "/news/av/embed/:vpid/:asset_id", using: "NewsVideosEmbed", examples: [{"/news/av/embed/p07pd78q/49843970", 302}]
  handle "/news/:asset_id/embed", using: "NewsVideosEmbed", examples: [{"/news/health-54088206/embed", 302}, {"/news/uk-politics-54003483/embed?amp=1", 302}]
  handle "/news/:asset_id/embed/:pid", using: "NewsVideosEmbed", examples: [{"/news/health-54088206/embed/p08m8yx4", 302}, {"/news/health-54088206/embed/p08m8yx4?amp=1", 302}]

  redirect("/news/av/:asset_id/:slug", to: "/news/av/:asset_id", status: 302)

  handle "/news/av/:id", using: "NewsVideos", examples: ["/news/av/48404351", "/news/av/uk-51729702", "/news/av/uk-england-hampshire-50266218", "/news/av/entertainment+arts-10646650"] do
      return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/news/video_and_audio/:index/:id/:slug", using: "NewsVideoAndAudio", examples: [{"/news/video_and_audio/must_see/54327412/scientists-create-a-microscopic-robot-that-walks", 301}] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/news/video_and_audio/*_any", using: "NewsVideoAndAudio", examples: [] do
    return_404 if: true
  end

  handle "/news/videos/:optimo_id", using: "NewsVideos", only_on: "test", examples: ["/news/videos/cemgppexd28o?mode=testData"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/news/articles/:optimo_id.amp", using: "NewsAmp", examples: []
  handle "/news/articles/:optimo_id.json", using: "NewsAmp", examples: []

  handle "/news/articles/:optimo_id", using: "StorytellingPage", examples: ["/news/articles/c5ll353v7y9o", "/news/articles/c8xxl4l3dzeo"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  # News indexes
  handle "/news/access-to-news", using: "NewsIndex", examples: ["/news/access-to-news"]
  handle "/news/business", using: "NewsIndex", examples: ["/news/business"]
  handle "/news/components", using: "NewsComponents", examples: ["/news/components"]
  handle "/news/coronavirus", using: "NewsIndex", examples: ["/news/coronavirus"]
  handle "/news/disability", using: "NewsIndex", examples: ["/news/disability"]
  handle "/news/education", using: "NewsIndex", examples: ["/news/education"]
  handle "/news/england", using: "NewsIndex", examples: ["/news/england"]
  handle "/news/entertainment_and_arts", using: "NewsIndex", examples: ["/news/entertainment_and_arts"]
  handle "/news/explainers", using: "NewsIndex", examples: ["/news/explainers"]
  handle "/news/front_page", using: "NewsIndex", examples: ["/news/front_page"]
  handle "/news/front-page-service-worker.js", using: "NewsIndex", examples: ["/news/front-page-service-worker.js"]
  handle "/news/have_your_say", using: "NewsIndex", examples: ["/news/have_your_say"]
  handle "/news/health", using: "NewsIndex", examples: ["/news/health"]
  handle "/news/in_pictures", using: "NewsIndex", examples: ["/news/in_pictures"]
  handle "/news/newsbeat", using: "NewsIndex", examples: ["/news/newsbeat"]
  handle "/news/northern_ireland", using: "NewsIndex", examples: ["/news/northern_ireland"]
  handle "/news/paradisepapers", using: "NewsIndex", examples: ["/news/paradisepapers"]
  handle "/news/politics", using: "NewsIndex", examples: ["/news/politics"]
  handle "/news/reality_check", using: "NewsIndex", examples: ["/news/reality_check"]
  handle "/news/science_and_environment", using: "NewsIndex", examples: ["/news/science_and_environment"]
  handle "/news/scotland", using: "NewsIndex", examples: ["/news/scotland"]
  handle "/news/stories", using: "NewsIndex", examples: ["/news/stories"]
  handle "/news/technology", using: "NewsIndex", examples: ["/news/technology"]
  handle "/news/the_reporters", using: "NewsIndex", examples: ["/news/the_reporters"]
  handle "/news/uk", using: "NewsIndex", examples: ["/news/uk"]
  handle "/news/wales", using: "NewsIndex", examples: ["/news/wales"]
  handle "/news/world", using: "NewsIndex", examples: ["/news/world"]
  handle "/news/world_radio_and_tv", using: "NewsIndex", examples: ["/news/world_radio_and_tv"]

  # News feature indexes (FIX assets)
  handle "/news/business-11428889", using: "NewsBusiness", examples: ["/news/business-11428889"]
  handle "/news/business-12686570", using: "NewsBusiness", examples: ["/news/business-12686570"]
  handle "/news/business-15521824", using: "NewsBusiness", examples: ["/news/business-15521824"]
  handle "/news/business-22434141", using: "NewsBusiness", examples: ["/news/business-22434141"]
  handle "/news/business-22449886", using: "NewsBusiness", examples: ["/news/business-22449886"]
  handle "/news/business-33712313", using: "NewsBusiness", examples: ["/news/business-33712313"]
  handle "/news/business-38507481", using: "NewsBusiness", examples: ["/news/business-38507481"]
  handle "/news/business-41188875", using: "NewsBusiness", examples: ["/news/business-41188875"]
  handle "/news/business-45489065", using: "NewsBusiness", examples: ["/news/business-45489065"]
  handle "/news/business-46985441", using: "NewsBusiness", examples: ["/news/business-46985441"]
  handle "/news/business-46985442", using: "NewsBusiness", examples: ["/news/business-46985442"]
  handle "/news/education-46131593", using: "NewsEducation", examples: ["/news/education-46131593"]
  handle "/news/uk-england-47486169", using: "NewsUk", examples: ["/news/uk-england-47486169"]
  handle "/news/science-environment-56837908", using: "NewsScienceAndTechnology", examples: ["/news/science-environment-56837908"]
  handle "/news/technology-22774341", using: "NewsScienceAndTechnology", examples: ["/news/technology-22774341"]
  handle "/news/uk-55220521", using: "NewsUk", examples: ["/news/uk-55220521"]
  handle "/news/uk-northern-ireland-38323577", using: "NewsUk", examples: ["/news/uk-northern-ireland-38323577"]
  handle "/news/uk-northern-ireland-55401938", using: "NewsUk", examples: ["/news/uk-northern-ireland-55401938"]
  handle "/news/uk-politics-48448557", using: "NewsUk", examples: ["/news/uk-politics-48448557"]
  handle "/news/world-43160365", using: "NewsWorld", examples: ["/news/world-43160365"]
  handle "/news/world-48623037", using: "NewsWorld", examples: ["/news/world-48623037"]
  handle "/news/world-middle-east-48433977", using: "NewsWorld", examples: ["/news/world-middle-east-48433977"]
  handle "/news/world-us-canada-15949569", using: "NewsWorld", examples: ["/news/world-us-canada-15949569"]

  # News archive assets
  handle "/news/10284448/ticker.sjson", using: "NewsArchive", examples: ["/news/10284448/ticker.sjson"]
  handle "/news/1/*_any", using: "NewsArchive", examples: ["/news/1/shared/spl/hi/uk_politics/03/the_cabinet/html/chancellor_exchequer.stm"]
  handle "/news/2/*_any", using: "NewsArchive", examples: ["/news/2/text_only.stm"]
  handle "/news/sport1/*_any", using: "NewsArchive", examples: ["/news/sport1/hi/football/teams/n/newcastle_united/4405841.stm"]
  handle "/news/bigscreen/*_any", using: "NewsArchive", examples: ["/news/bigscreen/top_stories/iptvfeed.sjson"]

  # News section matchers
  handle "/news/ampstories/*_any", using: "News", examples: ["/news/ampstories/moonmess/index.html"]
  handle "/news/av-embeds/*_any", using: "News", examples: ["/news/av-embeds/58869966/vpid/p07r2y68"]
  handle "/news/blogs/*_any", using: "News", examples: ["/news/blogs/the_papers"]
  handle "/news/business/*_any", using: "NewsBusiness", examples: ["/news/business/companies"]
  handle "/news/correspondents/*_any", using: "NewsUk", examples: ["/news/correspondents/philcoomes"]
  handle "/news/england/*_any", using: "NewsUk", examples: ["/news/england/regions"]
  handle "/news/extra/*_any", using: "News", examples: ["/news/extra/3O3eptdEYR/after-the-wall-fell"]
  handle "/news/events/*_any", using: "NewsUk", examples: ["/news/events/scotland-decides/results"]
  handle "/news/iptv/*_any", using: "News", examples: ["/news/iptv/scotland/iptvfeed.sjson"]
  handle "/news/local_news_slice/*_any", using: "NewsUk", examples: ["/news/local_news_slice/%252Fnews%252Fengland%252Flondon"]
  handle "/news/northern_ireland/*_any", using: "NewsUk", examples: ["/news/northern_ireland/northern_ireland_politics"]
  handle "/news/politics/*_any", using: "NewsUk", examples: ["/news/politics/eu_referendum/results"]
  handle "/news/resources/*_any", using: "News", examples: ["/news/resources/idt-d6338d9f-8789-4bc2-b6d7-3691c0e7d138"]
  handle "/news/rss/*_any", using: "NewsRss", examples: ["/news/rss/newsonline_uk_edition/front_page/rss.xml"]
  handle "/news/science-environment/*_any", using: "NewsScienceAndTechnology", examples: ["/news/science-environment/18552512"]
  handle "/news/scotland/*_any", using: "NewsUk", examples: ["/news/scotland/glasgow_and_west"]
  handle "/news/slides/*_any", using: "News", examples: ["/news/slides/dress/3/yes-you-can-go-to-the-ball"]
  handle "/news/special/*_any", using: "News", examples: ["/news/special/2015/newsspec_10857/bbc_news_logo.png"]
  handle "/news/technology/*_any", using: "NewsScienceAndTechnology", examples: ["/news/technology/31153361"]
  handle "/news/wales/*_any", using: "NewsUk", examples: ["/news/wales/south_east_wales"]
  handle "/news/world/*_any", using: "NewsWorld", examples: ["/news/world/europe"]
  handle "/news/world_radio_and_tv/*_any", using: "NewsWorld", examples: ["/news/world_radio_and_tv/apple-touch-icon-precomposed.png"]

  # 404 matchers
  handle "/news/favicon.ico", using: "News", examples: [] do
    return_404 if: true
  end

  handle "/news/av/favicon.ico", using: "News", examples: [] do
    return_404 if: true
  end

  handle "/news/:id.amp", using: "NewsAmp", examples: ["/news/business-58847275.amp"]
  handle "/news/:id.json", using: "NewsAmp", examples: ["/news/business-58847275.json"]

  handle "/news/rss.xml", using: "NewsRss", examples: ["/news/rss.xml"]
  handle "/news/:id/rss.xml", using: "NewsRss", examples: ["/news/uk/rss.xml"]

  handle "/news/:id", using: "NewsArticlePage", examples: ["/news/uk-politics-49336144", "/news/world-asia-china-51787936", "/news/technology-51960865", "/news/uk-england-derbyshire-18291916", "/news/entertainment+arts-10636043"]

  # TODO issue with routes such as /news/education-46131593 being matched to the /news/:id matcher
  handle "/news/*_any", using: "News", examples: [{"/news/contact-us/editorial", 302}]

  # Cymrufyw

  redirect "/newyddion/*any", to: "/cymrufyw/*any", status: 302
  redirect "/democratiaethfyw", to: "/cymrufyw/gwleidyddiaeth", status: 302
  redirect "/cymrufyw/amp/:id", to: "/cymrufyw/:id.amp", status: 301
  redirect "/cymrufyw/amp/:topic/:id", to: "/cymrufyw/:topic/:id.amp", status: 301

  redirect "/cymrufyw/correspondents/vaughanroderick", to: "/news/topics/ckj6kvx7pdyt", status: 302

  handle "/cymrufyw/cylchgrawn", using: "Cymrufyw", examples: ["/cymrufyw/cylchgrawn"]

  handle "/cymrufyw/etholiad/2021/cymru/etholaethau", using: "CymrufywEtholiad2021", examples: ["/cymrufyw/etholiad/2021/cymru/etholaethau"]

  handle "/cymrufyw/etholiad/2021/cymru/:division_name/:division_id", using: "CymrufywEtholiad2021", examples: ["/cymrufyw/etholiad/2021/cymru/etholaethau/W09000001", "/cymrufyw/etholiad/2021/cymru/rhanbarthau/W10000006"] do
    return_404 if: [
      !String.match?(division_name, ~r/^(rhanbarthau|etholaethau)$/),
      !String.match?(division_id, ~r/^W[0-9]{8}$/)
    ]
  end

  handle "/cymrufyw/etholiad/2022/cymru/canlyniadau", using: "CymrufywEtholiadCanlyniadau", examples: ["/cymrufyw/etholiad/2022/cymru/canlyniadau"]

  handle "/cymrufyw/etholiad/2022/cymru/cynghorau", using: "CymrufywEtholiadCanlyniadau", examples: ["/cymrufyw/etholiad/2022/cymru/cynghorau"]

  handle "/cymrufyw/etholiad/2022/cymru/cynghorau/:division_id", using: "CymrufywEtholiadCanlyniadau", examples: ["/cymrufyw/etholiad/2022/cymru/cynghorau/W10000006"] do
    return_404 if: [
                 !String.match?(division_id, ~r/^[W][0-9]{8}$/)
               ]
  end

  handle "/cymrufyw/etholiad/2019/du/etholaethau/:division_id", using: "CymrufywEtholiadCanlyniadau", only_on: "test", examples: ["/cymrufyw/etholiad/2019/du/etholaethau/W09000001"] do
    return_404 if: [
      !String.match?(division_id, ~r/^W[0-9]{8}$/)
    ]
  end

  handle "/cymrufyw/etholiad/2019/du/rhanbarthau/W92000004", using: "CymrufywEtholiadCanlyniadau", only_on: "test", examples: ["/cymrufyw/etholiad/2019/du/rhanbarthau/W92000004"]

  handle "/cymrufyw/gwleidyddiaeth", using: "Cymrufyw", examples: ["/cymrufyw/gwleidyddiaeth"]
  handle "/cymrufyw/gogledd-orllewin", using: "Cymrufyw", examples: ["/cymrufyw/gogledd-orllewin"]
  handle "/cymrufyw/gogledd-ddwyrain", using: "Cymrufyw", examples: ["/cymrufyw/gogledd-ddwyrain"]
  handle "/cymrufyw/canolbarth", using: "Cymrufyw", examples: ["/cymrufyw/canolbarth"]
  handle "/cymrufyw/de-orllewin", using: "Cymrufyw", examples: ["/cymrufyw/de-orllewin"]
  handle "/cymrufyw/de-ddwyrain", using: "Cymrufyw", examples: ["/cymrufyw/de-ddwyrain"]
  handle "/cymrufyw/eisteddfod", using: "Cymrufyw", examples: ["/cymrufyw/eisteddfod"]
  handle "/cymrufyw/components", using: "Cymrufyw", examples: []
  handle "/cymrufyw/hafan", using: "Cymrufyw", examples: [{"/cymrufyw/hafan", 301}]

  handle "/cymrufyw/:id", using: "CymrufywArticlePage", examples: ["/cymrufyw/52998018", "/cymrufyw/52995676", "/cymrufyw/etholiad-2017-39407507"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  handle "/cymrufyw/saf/:id", using: "CymrufywVideos", examples: ["/cymrufyw/saf/53073086"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/cymrufyw/fideo/:optimo_id", using: "CymrufywVideos", only_on: "test", examples: ["/cymrufyw/fideo/cr9zddqg9jro?mode=testData"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/cymrufyw/*_any", using: "Cymrufyw", examples: ["/cymrufyw"]

  # Naidheachdan

  handle "/naidheachdan", using: "NaidheachdanHomePage", examples: ["/naidheachdan"]
  handle "/naidheachdan/dachaigh", using: "Naidheachdan", examples: [{"/naidheachdan/dachaigh", 301}]
  handle "/naidheachdan/components", using: "Naidheachdan", examples: []
  redirect "/naidheachdan/amp/:id", to: "/naidheachdan/:id.amp", status: 301
  redirect "/naidheachdan/amp/:topic/:id", to: "/naidheachdan/:topic/:id.amp", status: 301
  handle "/naidheachdan/:id", using: "NaidheachdanArticlePage", examples: ["/naidheachdan/52992845", "/naidheachdan/52990788", "/naidheachdan/52991029"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  handle "/naidheachdan/fbh/:id", using: "NaidheachdanVideos", examples: ["/naidheachdan/fbh/53159144"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/naidheachdan/bhidio/:optimo_id", using: "NaidheachdanVideos", only_on: "test", examples: ["/naidheachdan/bhidio/cvpvqqp83g0o?mode=testData"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/naidheachdan/*_any", using: "Naidheachdan", examples: []

  handle "/pres-test/personalisation", using: "PresTestPersonalised", only_on: "test", examples: ["/pres-test/personalisation"]
  handle "/pres-test/*any", using: "PresTest", only_on: "test", examples: ["/pres-test/greeting-loader"]

  handle "/devx-test/personalisation", using: "DevXPersonalisation", only_on: "test", examples: ["/devx-test/personalisation"]

  # Container API
  handle "/container/envelope/editorial-text/*any", using: "ContainerEnvelopeEditorialText", examples: ["/container/envelope/editorial-text/heading/Belfrage%20Test/headingLevel/2", "/container/envelope/editorial-text/heading/Belfrage%20Test/headingLevel/2?static=true&mode=testData"]
  handle "/container/envelope/election-banner/*any", using: "ContainerEnvelopeElectionBanner", examples: ["/container/envelope/election-banner/logoOnly/true", "/container/envelope/election-banner/assetUri/%2Fnews/hasFetcher/true?static=true&mode=testData"]
  handle "/container/envelope/page-link/*any", using: "ContainerEnvelopePageLink", examples: ["/container/envelope/page-link/linkHref/%23belfrage/linkLabel/Belfrage%20Test"]
  handle "/container/envelope/scoreboard/*any", using: "ContainerEnvelopeScoreboard", examples: ["/container/envelope/scoreboard/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true", "/container/envelope/scoreboard/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true?static=true&mode=testData"]
  handle "/container/envelope/winner-flash/*any", using: "ContainerEnvelopeWinnerFlash", examples: ["/container/envelope/winner-flash/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true", "/container/envelope/winner-flash/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true?static=true&mode=testData"]
  handle "/container/envelope/turnout/*any", using: "ContainerEnvelopeTurnout", examples: ["/container/envelope/turnout/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true", "/container/envelope/turnout/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true?static=true&mode=testData"]
  handle "/container/envelope/test-:name/*any", using: "ContainerEnvelopeTestContainers", only_on: "test", examples: ["/container/envelope/test-message/message/hello"]
  handle "/container/envelope/*any", using: "ContainerEnvelope", examples: ["/container/envelope/global-footer/hasFetcher/true"]

  # World Service

  ## World Service - Podcast Redirects
  redirect "/arabic/climate-change", to: "/arabic/podcasts/p0c9wp0l", status: 301
  redirect "/arabic/media-45669761", to: "/arabic/podcasts/p02pc9qc", status: 301
  redirect "/arabic/xlevels", to: "/arabic/podcasts/p09w8yvk", status: 301
  redirect "/arabic/morahakaty", to: "/arabic/podcasts/p0b3xdrj", status: 301
  redirect "/burmese/media-45625858", to: "/burmese/podcasts/p02pc9lh", status: 301
  redirect "/burmese/media-45625862", to: "/burmese/podcasts/p02p9f6q", status: 301
  redirect "/gahuza/institutional-51112056", to: "/gahuza/podcasts/p07yh8hb", status: 301
  redirect "/gahuza/institutional-50169255", to: "/gahuza/podcasts/p02pcb5c", status: 301
  redirect "/gahuza/institutional-51111781", to: "/gahuza/podcasts/p07yjlmf", status: 301
  redirect "/gahuza/institutional-50948665", to: "/gahuza/podcasts/p07yhgwh", status: 301
  redirect "/gahuza/institutional-51111776", to: "/gahuza/podcasts/p07yjfjq", status: 301
  redirect "/hausa/media-54540879", to: "/hausa/podcasts/p08mlgcb", status: 301
  redirect "/hindi/media-45683508", to: "/hindi/podcasts/p0552909", status: 301
  redirect "/hindi/media-45684223", to: "/hindi/podcasts/p055260j", status: 301
  redirect "/hindi/media-45684228", to: "/hindi/podcasts/p05528hs", status: 301
  redirect "/hindi/media-45684413", to: "/hindi/podcasts/p05523zq", status: 301
  redirect "/hindi/media-52093366", to: "/hindi/podcasts/p05525mc", status: 301
  redirect "/hindi/media-55217505", to: "/hindi/podcasts/p08s9wv2", status: 301
  redirect "/indonesia/media-45640737", to: "/indonesia/podcasts/p02pc9v6", status: 301
  redirect "/kyrgyz/kyrgyzstan/2016/02/160215_war_in_afghanistan", to: "/kyrgyz/articles/cpgqrwy5zvzo", status: 301
  redirect "/nepali/media-45658289", to: "/nepali/podcasts/p02pc9w3", status: 301
  redirect "/persian/media-45683503", to: "/persian/podcasts/p05gyy09", status: 301
  redirect "/persian/media-45679210", to: "/persian/podcasts/p02pc9mc", status: 301
  redirect "/russian/media-37828473", to: "/russian/podcasts/p05607v8", status: 301
  redirect "/zhongwen/simp/institutional-38228429", to: "/zhongwen/simp/podcasts/p02pc9xp", status: 301
  redirect "/zhongwen/trad/institutional-38228429", to: "/zhongwen/trad/podcasts/p02pc9xp", status: 301

  ## World Service - "Access to News" Redirects
  redirect "/persian/institutional-43952617", to: "/persian/access-to-news", status: 301
  redirect "/persian/institutional/2011/04/000001_bbcpersian_proxy", to: "/persian/access-to-news", status: 301

  redirect "/persian/institutional/2011/04/000001_feeds", to: "/persian/articles/c849y3lk2yko", status: 301
  redirect "/serbian/cyr/extra/ebxujaequt/rat-silovanje-bosna", to: "/serbian/lat/extra/ebxujaequt/rat-silovanje-bosna", status: 301

  ## World Service - Topic Redirects
  redirect "/japanese/video-55128146", to: "/japanese/topics/c132079wln0t", status: 301
  redirect "/pidgin/sport", to: "/pidgin/topics/cjgn7gv77vrt", status: 301

  ## World Service - Simorgh and ARES
  ##    Kaleidoscope Redirects: /<service>/mobile/image/*any
  ##    Mobile Redirects: /<service>/mobile/*any
  handle "/afaanoromoo.amp", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo.amp"]
  handle "/afaanoromoo.json", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo.json"]
  handle "/afaanoromoo/manifest.json", using: "WorldServiceAfaanoromooAssets", examples: ["/afaanoromoo/manifest.json"]
  handle "/afaanoromoo/sw.js", using: "WorldServiceAfaanoromooAssets", examples: ["/afaanoromoo/sw.js"]
  handle "/afaanoromoo/topics/:id", using: "WorldServiceAfaanoromooTopicPage", examples: ["/afaanoromoo/topics/c7zp5z9n3x5t", "/afaanoromoo/topics/c7zp5z9n3x5t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/afaanoromoo/articles/:id", using: "WorldServiceAfaanoromooArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/afaanoromoo/articles/:id.amp", using: "WorldServiceAfaanoromooArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/afaanoromoo/send/:id", using: "UploaderWorldService", examples: ["/afaanoromoo/send/u39697902"]
  handle "/afaanoromoo/*_any", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo"]

  redirect "/afrique/mobile/*any", to: "/afrique", status: 301

  handle "/afrique.amp", using: "WorldServiceAfrique", examples: ["/afrique.amp"]
  handle "/afrique.json", using: "WorldServiceAfrique", examples: ["/afrique.json"]
  handle "/afrique/manifest.json", using: "WorldServiceAfriqueAssets", examples: ["/afrique/manifest.json"]
  handle "/afrique/sw.js", using: "WorldServiceAfriqueAssets", examples: ["/afrique/sw.js"]
  handle "/afrique/topics/:id", using: "WorldServiceAfriqueTopicPage", examples: ["/afrique/topics/c9ny75kpxlkt", "/afrique/topics/c9ny75kpxlkt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/afrique/articles/:id", using: "WorldServiceAfriqueArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/afrique/articles/:id.amp", using: "WorldServiceAfriqueArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/afrique/send/:id", using: "UploaderWorldService", examples: ["/afrique/send/u39697902"]
  handle "/afrique/*_any", using: "WorldServiceAfrique", examples: ["/afrique"]

  handle "/amharic.amp", using: "WorldServiceAmharic", examples: ["/amharic.amp"]
  handle "/amharic.json", using: "WorldServiceAmharic", examples: ["/amharic.json"]
  handle "/amharic/manifest.json", using: "WorldServiceAmharicAssets", examples: ["/amharic/manifest.json"]
  handle "/amharic/sw.js", using: "WorldServiceAmharicAssets", examples: ["/amharic/sw.js"]
  handle "/amharic/topics/:id", using: "WorldServiceAmharicTopicPage", examples: ["/amharic/topics/c06gq8wdrjyt", "/amharic/topics/c06gq8wdrjyt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/amharic/articles/:id", using: "WorldServiceAmharicArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/amharic/articles/:id.amp", using: "WorldServiceAmharicArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/amharic/send/:id", using: "UploaderWorldService", examples: ["/amharic/send/u39697902"]
  handle "/amharic/*_any", using: "WorldServiceAmharic", examples: ["/amharic"]

  redirect "/arabic/mobile/*any", to: "/arabic", status: 301
  redirect "/arabic/institutional/2011/01/000000_tv_schedule", to: "/arabic/tv-and-radio-58432380", status: 301
  redirect "/arabic/institutional/2011/01/000000_frequencies_radio", to: "/arabic/tv-and-radio-57895092", status: 301
  redirect "/arabic/investigations", to: "/arabic/tv-and-radio-42414864", status: 301

  handle "/arabic.amp", using: "WorldServiceArabic", examples: ["/arabic.amp"]
  handle "/arabic.json", using: "WorldServiceArabic", examples: ["/arabic.json"]
  handle "/arabic/manifest.json", using: "WorldServiceArabicAssets", examples: ["/arabic/manifest.json"]
  handle "/arabic/sw.js", using: "WorldServiceArabicAssets", examples: ["/arabic/sw.js"]
  handle "/arabic/topics/:id", using: "WorldServiceArabicTopicPage", examples: ["/arabic/topics/c340qj374j6t", "/arabic/topics/c340qj374j6t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/arabic/articles/:id", using: "WorldServiceArabicArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/arabic/articles/:id.amp", using: "WorldServiceArabicArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/arabic/send/:id", using: "UploaderWorldService", examples: ["/arabic/send/u39697902"]
  handle "/arabic/*_any", using: "WorldServiceArabic", examples: ["/arabic"]

  redirect "/azeri/mobile/*any", to: "/azeri", status: 301

  handle "/azeri.amp", using: "WorldServiceAzeri", examples: ["/azeri.amp"]
  handle "/azeri.json", using: "WorldServiceAzeri", examples: ["/azeri.json"]
  handle "/azeri/manifest.json", using: "WorldServiceAzeriAssets", examples: ["/azeri/manifest.json"]
  handle "/azeri/sw.js", using: "WorldServiceAzeriAssets", examples: ["/azeri/sw.js"]
  handle "/azeri/topics/:id", using: "WorldServiceAzeriTopicPage", examples: ["/azeri/topics/c1gdq32g3ddt", "/azeri/topics/c1gdq32g3ddt?page=1"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/azeri/articles/:id", using: "WorldServiceAzeriArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/azeri/articles/:id.amp", using: "WorldServiceAzeriArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/azeri/send/:id", using: "UploaderWorldService", examples: ["/azeri/send/u39697902"]
  handle "/azeri/*_any", using: "WorldServiceAzeri", examples: ["/azeri"]

  redirect "/bengali/mobile/image/*any", to: "/bengali/*any", status: 302
  redirect "/bengali/mobile/*any", to: "/bengali", status: 301

  handle "/bengali.amp", using: "WorldServiceBengali", examples: ["/bengali.amp"]
  handle "/bengali.json", using: "WorldServiceBengali", examples: ["/bengali.json"]
  handle "/bengali/manifest.json", using: "WorldServiceBengaliAssets", examples: ["/bengali/manifest.json"]
  handle "/bengali/sw.js", using: "WorldServiceBengaliAssets", examples: ["/bengali/sw.js"]
  handle "/bengali/topics/:id", using: "WorldServiceBengaliTopicPage", examples: ["/bengali/topics/c2dwq2nd40xt", "/bengali/topics/c2dwq2nd40xt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/bengali/articles/:id", using: "WorldServiceBengaliArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/bengali/articles/:id.amp", using: "WorldServiceBengaliArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/bengali/send/:id", using: "UploaderWorldService", examples: ["/bengali/send/u39697902"]
  handle "/bengali/*_any", using: "WorldServiceBengali", examples: ["/bengali"]

  redirect "/burmese/mobile/image/*any", to: "/burmese/*any", status: 302
  redirect "/burmese/mobile/*any", to: "/burmese", status: 301

  handle "/burmese.amp", using: "WorldServiceBurmese", examples: ["/burmese.amp"]
  handle "/burmese.json", using: "WorldServiceBurmese", examples: ["/burmese.json"]
  handle "/burmese/manifest.json", using: "WorldServiceBurmeseAssets", examples: ["/burmese/manifest.json"]
  handle "/burmese/sw.js", using: "WorldServiceBurmeseAssets", examples: ["/burmese/sw.js"]
  handle "/burmese/topics/:id", using: "WorldServiceBurmeseTopicPage", examples: ["/burmese/topics/c404v08p1wxt", "/burmese/topics/c404v08p1wxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/burmese/articles/:id", using: "WorldServiceBurmeseArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/burmese/articles/:id.amp", using: "WorldServiceBurmeseArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/burmese/send/:id", using: "UploaderWorldService", examples: ["/burmese/send/u39697902"]
  handle "/burmese/*_any", using: "WorldServiceBurmese", examples: ["/burmese"]

  redirect "/gahuza/mobile/*any", to: "/gahuza", status: 301

  handle "/gahuza.amp", using: "WorldServiceGahuza", examples: ["/gahuza.amp"]
  handle "/gahuza.json", using: "WorldServiceGahuza", examples: ["/gahuza.json"]
  handle "/gahuza/manifest.json", using: "WorldServiceGahuzaAssets", examples: ["/gahuza/manifest.json"]
  handle "/gahuza/sw.js", using: "WorldServiceGahuzaAssets", examples: ["/gahuza/sw.js"]
  handle "/gahuza/topics/:id", using: "WorldServiceGahuzaTopicPage", examples: ["/gahuza/topics/c7zp5z0yd0xt", "/gahuza/topics/c7zp5z0yd0xt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/gahuza/articles/:id", using: "WorldServiceGahuzaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/gahuza/articles/:id.amp", using: "WorldServiceGahuzaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/gahuza/send/:id", using: "UploaderWorldService", examples: ["/gahuza/send/u39697902"]
  handle "/gahuza/*_any", using: "WorldServiceGahuza", examples: ["/gahuza"]
  handle "/gujarati.amp", using: "WorldServiceGujarati", examples: ["/gujarati.amp"]
  handle "/gujarati.json", using: "WorldServiceGujarati", examples: ["/gujarati.json"]
  handle "/gujarati/manifest.json", using: "WorldServiceGujaratiAssets", examples: ["/gujarati/manifest.json"]
  handle "/gujarati/sw.js", using: "WorldServiceGujaratiAssets", examples: ["/gujarati/sw.js"]
  handle "/gujarati/topics/:id", using: "WorldServiceGujaratiTopicPage", examples: ["/gujarati/topics/c2dwqj95d30t", "/gujarati/topics/c2dwqj95d30t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/gujarati/articles/:id", using: "WorldServiceGujaratiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/gujarati/articles/:id.amp", using: "WorldServiceGujaratiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/gujarati/send/:id", using: "UploaderWorldService", examples: ["/gujarati/send/u39697902"]
  handle "/gujarati/*_any", using: "WorldServiceGujarati", examples: ["/gujarati"]

  redirect "/hausa/mobile/*any", to: "/hausa", status: 301

  handle "/hausa.amp", using: "WorldServiceHausa", examples: ["/hausa.amp"]
  handle "/hausa.json", using: "WorldServiceHausa", examples: ["/hausa.json"]
  handle "/hausa/manifest.json", using: "WorldServiceHausaAssets", examples: ["/hausa/manifest.json"]
  handle "/hausa/sw.js", using: "WorldServiceHausaAssets", examples: ["/hausa/sw.js"]
  handle "/hausa/topics/:id", using: "WorldServiceHausaTopicPage", examples: ["/hausa/topics/c5qvpxkx1j7t", "/hausa/topics/c5qvpxkx1j7t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/hausa/articles/:id", using: "WorldServiceHausaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/hausa/articles/:id.amp", using: "WorldServiceHausaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/hausa/send/:id", using: "UploaderWorldService", examples: ["/hausa/send/u39697902"]
  handle "/hausa/*_any", using: "WorldServiceHausa", examples: ["/hausa"]

  redirect "/hindi/mobile/image/*any", to: "/hindi/*any", status: 302
  redirect "/hindi/mobile/*any", to: "/hindi", status: 301

  handle "/hindi.amp", using: "WorldServiceHindi", examples: ["/hindi.amp"]
  handle "/hindi.json", using: "WorldServiceHindi", examples: ["/hindi.json"]
  handle "/hindi/manifest.json", using: "WorldServiceHindiAssets", examples: ["/hindi/manifest.json"]
  handle "/hindi/sw.js", using: "WorldServiceHindiAssets", examples: ["/hindi/sw.js"]
  handle "/hindi/topics/:id", using: "WorldServiceHindiTopicPage", examples: ["/hindi/topics/c6vzy709wvxt", "/hindi/topics/c6vzy709wvxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/hindi/articles/:id", using: "WorldServiceHindiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/hindi/articles/:id.amp", using: "WorldServiceHindiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/hindi/send/:id", using: "UploaderWorldService", examples: ["/hindi/send/u39697902"]
  handle "/hindi/*_any", using: "WorldServiceHindi", examples: ["/hindi"]
  handle "/igbo.amp", using: "WorldServiceIgbo", examples: ["/igbo.amp"]
  handle "/igbo.json", using: "WorldServiceIgbo", examples: ["/igbo.json"]
  handle "/igbo/manifest.json", using: "WorldServiceIgboAssets", examples: ["/igbo/manifest.json"]
  handle "/igbo/sw.js", using: "WorldServiceIgboAssets", examples: ["/igbo/sw.js"]
  handle "/igbo/topics/:id", using: "WorldServiceIgboTopicPage", examples: ["/igbo/topics/c340qr24xggt", "/igbo/topics/c340qr24xggt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/igbo/articles/:id", using: "WorldServiceIgboArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/igbo/articles/:id.amp", using: "WorldServiceIgboArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/igbo/send/:id", using: "UploaderWorldService", examples: ["/igbo/send/u39697902"]
  handle "/igbo/*_any", using: "WorldServiceIgbo", examples: ["/igbo"]

  redirect "/indonesia/mobile/*any", to: "/indonesia", status: 301

  handle "/indonesia.amp", using: "WorldServiceIndonesia", examples: ["/indonesia.amp"]
  handle "/indonesia.json", using: "WorldServiceIndonesia", examples: ["/indonesia.json"]
  handle "/indonesia/manifest.json", using: "WorldServiceIndonesiaAssets", examples: ["/indonesia/manifest.json"]
  handle "/indonesia/sw.js", using: "WorldServiceIndonesiaAssets", examples: ["/indonesia/sw.js"]
  handle "/indonesia/topics/:id", using: "WorldServiceIndonesiaTopicPage", examples: ["/indonesia/topics/c340qrk1znxt", "/indonesia/topics/c340qrk1znxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/indonesia/articles/:id", using: "WorldServiceIndonesiaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/indonesia/articles/:id.amp", using: "WorldServiceIndonesiaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/indonesia/send/:id", using: "UploaderWorldService", examples: ["/indonesia/send/u39697902"]
  handle "/indonesia/*_any", using: "WorldServiceIndonesia", examples: ["/indonesia"]
  handle "/japanese.amp", using: "WorldServiceJapanese", examples: ["/japanese.amp"]
  handle "/japanese.json", using: "WorldServiceJapanese", examples: ["/japanese.json"]
  handle "/japanese/manifest.json", using: "WorldServiceJapaneseAssets", examples: ["/japanese/manifest.json"]
  handle "/japanese/sw.js", using: "WorldServiceJapaneseAssets", examples: ["/japanese/sw.js"]
  handle "/japanese/topics/:id", using: "WorldServiceJapaneseTopicPage", examples: ["/japanese/topics/c340qrn7pp0t", "/japanese/topics/c340qrn7pp0t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/japanese/articles/:id", using: "WorldServiceJapaneseArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/japanese/articles/:id.amp", using: "WorldServiceJapaneseArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/japanese/send/:id", using: "UploaderWorldService", examples: ["/japanese/send/u39697902"]
  handle "/japanese/*_any", using: "WorldServiceJapanese", examples: ["/japanese"]
  handle "/korean.amp", using: "WorldServiceKorean", examples: ["/korean.amp"]
  handle "/korean.json", using: "WorldServiceKorean", examples: ["/korean.json"]
  handle "/korean/manifest.json", using: "WorldServiceKoreanAssets", examples: ["/korean/manifest.json"]
  handle "/korean/sw.js", using: "WorldServiceKoreanAssets", examples: ["/korean/sw.js"]
  handle "/korean/topics/:id", using: "WorldServiceKoreanTopicPage", examples: ["/korean/topics/c17q6yp3jx4t", "/korean/topics/c17q6yp3jx4t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/korean/articles/:id", using: "WorldServiceKoreanArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/korean/articles/:id.amp", using: "WorldServiceKoreanArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/korean/send/:id", using: "UploaderWorldService", examples: ["/korean/send/u39697902"]
  handle "/korean/*_any", using: "WorldServiceKorean", examples: ["/korean"]

  redirect "/kyrgyz/mobile/*any", to: "/kyrgyz", status: 301

  handle "/kyrgyz.amp", using: "WorldServiceKyrgyz", examples: ["/kyrgyz.amp"]
  handle "/kyrgyz.json", using: "WorldServiceKyrgyz", examples: ["/kyrgyz.json"]
  handle "/kyrgyz/manifest.json", using: "WorldServiceKyrgyzAssets", examples: ["/kyrgyz/manifest.json"]
  handle "/kyrgyz/sw.js", using: "WorldServiceKyrgyzAssets", examples: ["/kyrgyz/sw.js"]
  handle "/kyrgyz/topics/:id", using: "WorldServiceKyrgyzTopicPage", examples: ["/kyrgyz/topics/c0109l9xrpnt", "/kyrgyz/topics/c0109l9xrpnt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/kyrgyz/articles/:id", using: "WorldServiceKyrgyzArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/kyrgyz/articles/:id.amp", using: "WorldServiceKyrgyzArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/kyrgyz/send/:id", using: "UploaderWorldService", examples: ["/kyrgyz/send/u39697902"]
  handle "/kyrgyz/*_any", using: "WorldServiceKyrgyz", examples: ["/kyrgyz"]

  handle "/marathi.amp", using: "WorldServiceMarathi", examples: ["/marathi.amp"]
  handle "/marathi.json", using: "WorldServiceMarathi", examples: ["/marathi.json"]
  handle "/marathi/manifest.json", using: "WorldServiceMarathiAssets", examples: ["/marathi/manifest.json"]
  handle "/marathi/sw.js", using: "WorldServiceMarathiAssets", examples: ["/marathi/sw.js"]
  handle "/marathi/topics/:id", using: "WorldServiceMarathiTopicPage", examples: ["/marathi/topics/c2dwqjwqqqjt", "/marathi/topics/c2dwqjwqqqjt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/marathi/articles/:id", using: "WorldServiceMarathiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/marathi/articles/:id.amp", using: "WorldServiceMarathiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/marathi/send/:id", using: "UploaderWorldService", examples: ["/marathi/send/u39697902"]
  handle "/marathi/*_any", using: "WorldServiceMarathi", examples: ["/marathi"]

  ## World Service - Olympic Redirects
  redirect "/mundo/deportes-57748229", to: "/mundo/deportes-57970068", status: 301

  ## World Service - Topcat to CPS Redirects
  redirect "/mundo/noticias/2014/08/140801_israel_palestinos_conflicto_preguntas_basicas_jp", to: "/mundo/noticias-internacional-44125537", status: 301
  redirect "/mundo/noticias/2015/10/151014_israel_palestina_preguntas_basicas_actualizacion_aw", to: "/mundo/noticias-internacional-44125537", status: 301

  redirect "/mundo/mobile/*any", to: "/mundo", status: 301
  redirect "/mundo/movil/*any", to: "/mundo", status: 301

  handle "/mundo/mvt/*_any", using: "WorldServiceMvtPoc", only_on: "test", examples: ["/mundo/mvt/testing"]

  handle "/mundo.amp", using: "WorldServiceMundo", examples: ["/mundo.amp"]
  handle "/mundo.json", using: "WorldServiceMundo", examples: ["/mundo.json"]
  handle "/mundo/manifest.json", using: "WorldServiceMundoAssets", examples: ["/mundo/manifest.json"]
  handle "/mundo/sw.js", using: "WorldServiceMundoAssets", examples: ["/mundo/sw.js"]
  handle "/mundo/topics/:id", using: "WorldServiceMundoTopicPage", examples: ["/mundo/topics/cdr5613yzwqt", "/mundo/topics/cdr5613yzwqt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/mundo/articles/:id", using: "WorldServiceMundoArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/mundo/articles/:id.amp", using: "WorldServiceMundoArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/mundo/send/:id", using: "UploaderWorldService", examples: ["/mundo/send/u39697902"]
  handle "/mundo/*_any", using: "WorldServiceMundo", examples: ["/mundo"]

  redirect "/nepali/mobile/image/*any", to: "/nepali/*any", status: 302
  redirect "/nepali/mobile/*any", to: "/nepali", status: 301

  handle "/nepali.amp", using: "WorldServiceNepali", examples: ["/nepali.amp"]
  handle "/nepali.json", using: "WorldServiceNepali", examples: ["/nepali.json"]
  handle "/nepali/manifest.json", using: "WorldServiceNepaliAssets", examples: ["/nepali/manifest.json"]
  handle "/nepali/sw.js", using: "WorldServiceNepaliAssets", examples: ["/nepali/sw.js"]
  handle "/nepali/topics/:id", using: "WorldServiceNepaliTopicPage", examples: ["/nepali/topics/c340q4p5136t", "/nepali/topics/c340q4p5136t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/nepali/articles/:id", using: "WorldServiceNepaliArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/nepali/articles/:id.amp", using: "WorldServiceNepaliArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/nepali/send/:id", using: "UploaderWorldService", examples: ["/nepali/send/u39697902"]
  handle "/nepali/*_any", using: "WorldServiceNepali", examples: ["/nepali"]

  redirect "/pashto/mobile/image/*any", to: "/pashto/*any", status: 302
  redirect "/pashto/mobile/*any", to: "/pashto", status: 301

  handle "/pashto.amp", using: "WorldServicePashto", examples: ["/pashto.amp"]
  handle "/pashto.json", using: "WorldServicePashto", examples: ["/pashto.json"]
  handle "/pashto/manifest.json", using: "WorldServicePashtoAssets", examples: ["/pashto/manifest.json"]
  handle "/pashto/sw.js", using: "WorldServicePashtoAssets", examples: ["/pashto/sw.js"]
  handle "/pashto/topics/:id", using: "WorldServicePashtoTopicPage", examples: ["/pashto/topics/c8y94yr7y9rt", "/pashto/topics/c8y94yr7y9rt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/pashto/articles/:id", using: "WorldServicePashtoArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/pashto/articles/:id.amp", using: "WorldServicePashtoArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/pashto/send/:id", using: "UploaderWorldService", examples: ["/pashto/send/u39697902"]
  handle "/pashto/*_any", using: "WorldServicePashto", examples: ["/pashto"]

  redirect "/persian/mobile/image/*any", to: "/persian/*any", status: 302
  redirect "/persian/mobile/*any", to: "/persian", status: 301

  handle "/persian.amp", using: "WorldServicePersian", examples: ["/persian.amp"]
  handle "/persian.json", using: "WorldServicePersian", examples: ["/persian.json"]
  handle "/persian/manifest.json", using: "WorldServicePersianAssets", examples: ["/persian/manifest.json"]
  handle "/persian/sw.js", using: "WorldServicePersianAssets", examples: ["/persian/sw.js"]
  handle "/persian/topics/:id", using: "WorldServicePersianTopicPage", examples: ["/persian/topics/cnq68798yw0t", "/persian/topics/cnq68798yw0t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/persian/articles/:id", using: "WorldServicePersianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/persian/articles/:id.amp", using: "WorldServicePersianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/persian/send/:id", using: "UploaderWorldService", examples: ["/persian/send/u39697902"]
  handle "/persian/*_any", using: "WorldServicePersian", examples: ["/persian"]
  handle "/pidgin.amp", using: "WorldServicePidgin", examples: ["/pidgin.amp"]
  handle "/pidgin.json", using: "WorldServicePidgin", examples: ["/pidgin.json"]
  handle "/pidgin/manifest.json", using: "WorldServicePidginAssets", examples: ["/pidgin/manifest.json"]
  handle "/pidgin/sw.js", using: "WorldServicePidginAssets", examples: ["/pidgin/sw.js"]
  handle "/pidgin/topics/:id", using: "WorldServicePidginTopicPage", examples: ["/pidgin/topics/c95y35941vrt", "/pidgin/topics/c95y35941vrt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/pidgin/articles/:id", using: "WorldServicePidginArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/pidgin/articles/:id.amp", using: "WorldServicePidginArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/pidgin/send/:id", using: "UploaderWorldService", examples: ["/pidgin/send/u39697902"]
  handle "/pidgin/*_any", using: "WorldServicePidgin", examples: ["/pidgin"]

  redirect "/portuguese/mobile/*any", to: "/portuguese", status: 301
  redirect "/portuguese/celular/*any", to: "/portuguese", status: 301

  handle "/portuguese.amp", using: "WorldServicePortuguese", examples: ["/portuguese.amp"]
  handle "/portuguese.json", using: "WorldServicePortuguese", examples: ["/portuguese.json"]
  handle "/portuguese/manifest.json", using: "WorldServicePortugueseAssets", examples: ["/portuguese/manifest.json"]
  handle "/portuguese/sw.js", using: "WorldServicePortugueseAssets", examples: ["/portuguese/sw.js"]
  handle "/portuguese/topics/:id", using: "WorldServicePortugueseTopicPage", examples: ["/portuguese/topics/c1gdqg5dr8nt", "/portuguese/topics/c1gdqg5dr8nt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/portuguese/articles/:id", using: "WorldServicePortugueseArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/portuguese/articles/:id.amp", using: "WorldServicePortugueseArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/portuguese/send/:id", using: "UploaderWorldService", examples: ["/portuguese/send/u39697902"]
  handle "/portuguese/*_any", using: "WorldServicePortuguese", examples: ["/portuguese"]
  handle "/punjabi.amp", using: "WorldServicePunjabi", examples: ["/punjabi.amp"]
  handle "/punjabi.json", using: "WorldServicePunjabi", examples: ["/punjabi.json"]
  handle "/punjabi/manifest.json", using: "WorldServicePunjabiAssets", examples: ["/punjabi/manifest.json"]
  handle "/punjabi/sw.js", using: "WorldServicePunjabiAssets", examples: ["/punjabi/sw.js"]
  handle "/punjabi/topics/:id", using: "WorldServicePunjabiTopicPage", examples: ["/punjabi/topics/c0w258dd62mt", "/punjabi/topics/c0w258dd62mt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/punjabi/articles/:id", using: "WorldServicePunjabiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/punjabi/articles/:id.amp", using: "WorldServicePunjabiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/punjabi/send/:id", using: "UploaderWorldService", examples: ["/punjabi/send/u39697902"]
  handle "/punjabi/*_any", using: "WorldServicePunjabi", examples: ["/punjabi"]

  ## World Service - Russian Partners Redirects
  redirect "/russian/international/2011/02/000000_g_partners", to: "/russian/institutional-43463215", status: 301

  redirect "/russian/mobile/*any", to: "/russian", status: 301
  redirect "/russia", to: "/russian", status: 301


  handle "/russian.amp", using: "WorldServiceRussian", examples: ["/russian.amp"]
  handle "/russian.json", using: "WorldServiceRussian", examples: ["/russian.json"]
  handle "/russian/manifest.json", using: "WorldServiceRussianAssets", examples: ["/russian/manifest.json"]
  handle "/russian/sw.js", using: "WorldServiceRussianAssets", examples: ["/russian/sw.js"]
  handle "/russian/topics/:id", using: "WorldServiceRussianTopicPage", examples: ["/russian/topics/c50nzm54vzmt", "/russian/topics/c50nzm54vzmt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/russian/articles/:id", using: "WorldServiceRussianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/russian/articles/:id.amp", using: "WorldServiceRussianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/russian/send/:id", using: "UploaderWorldService", examples: ["/russian/send/u39697902"]
  handle "/russian/*_any", using: "WorldServiceRussian", examples: ["/russian"]

  handle "/serbian/manifest.json", using: "WorldServiceSerbianAssets", examples: ["/serbian/manifest.json"]
  handle "/serbian/sw.js", using: "WorldServiceSerbianAssets", examples: ["/serbian/sw.js"]
  handle "/serbian/cyr/topics/:id", using: "WorldServiceSerbianTopicPage", examples: ["/serbian/cyr/topics/cqwvxvvw9qrt", "/serbian/cyr/topics/cqwvxvvw9qrt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end
  handle "/serbian/lat/topics/:id", using: "WorldServiceSerbianTopicPage", examples: ["/serbian/lat/topics/c5wzvzzz5vrt", "/serbian/lat/topics/c5wzvzzz5vrt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/serbian/articles/:id/cyr", using: "WorldServiceSerbianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/cyr.amp", using: "WorldServiceSerbianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/lat", using: "WorldServiceSerbianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/lat.amp", using: "WorldServiceSerbianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/serbian/send/:id", using: "UploaderWorldService", examples: ["/serbian/send/u39697902"]
  handle "/serbian/*_any", using: "WorldServiceSerbian", examples: ["/serbian/lat", "/serbian/lat.json", "/serbian/lat.amp"]

  redirect "/sinhala/mobile/image/*any", to: "/sinhala/*any", status: 302
  redirect "/sinhala/mobile/*any", to: "/sinhala", status: 301

  handle "/sinhala.amp", using: "WorldServiceSinhala", examples: ["/sinhala.amp"]
  handle "/sinhala.json", using: "WorldServiceSinhala", examples: ["/sinhala.json"]
  handle "/sinhala/manifest.json", using: "WorldServiceSinhalaAssets", examples: ["/sinhala/manifest.json"]
  handle "/sinhala/sw.js", using: "WorldServiceSinhalaAssets", examples: ["/sinhala/sw.js"]
  handle "/sinhala/topics/:id", using: "WorldServiceSinhalaTopicPage", examples: ["/sinhala/topics/c2dwqd311xyt", "/sinhala/topics/c2dwqd311xyt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/sinhala/articles/:id", using: "WorldServiceSinhalaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/sinhala/articles/:id.amp", using: "WorldServiceSinhalaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/sinhala/send/:id", using: "UploaderWorldService", examples: ["/sinhala/send/u39697902"]
  handle "/sinhala/*_any", using: "WorldServiceSinhala", examples: ["/sinhala"]

  redirect "/somali/mobile/*any", to: "/somali", status: 301

  handle "/somali.amp", using: "WorldServiceSomali", examples: ["/somali.amp"]
  handle "/somali.json", using: "WorldServiceSomali", examples: ["/somali.json"]
  handle "/somali/manifest.json", using: "WorldServiceSomaliAssets", examples: ["/somali/manifest.json"]
  handle "/somali/sw.js", using: "WorldServiceSomaliAssets", examples: ["/somali/sw.js"]
  handle "/somali/topics/:id", using: "WorldServiceSomaliTopicPage", examples: ["/somali/topics/cz74k7jd8n8t", "/somali/topics/cz74k7jd8n8t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/somali/articles/:id", using: "WorldServiceSomaliArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/somali/articles/:id.amp", using: "WorldServiceSomaliArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/somali/send/:id", using: "UploaderWorldService", examples: ["/somali/send/u39697902"]
  handle "/somali/*_any", using: "WorldServiceSomali", examples: ["/somali"]

  redirect "/swahili/mobile/*any", to: "/swahili", status: 301

  handle "/swahili.amp", using: "WorldServiceSwahili", examples: ["/swahili.amp"]
  handle "/swahili.json", using: "WorldServiceSwahili", examples: ["/swahili.json"]
  handle "/swahili/manifest.json", using: "WorldServiceSwahiliAssets", examples: ["/swahili/manifest.json"]
  handle "/swahili/sw.js", using: "WorldServiceSwahiliAssets", examples: ["/swahili/sw.js"]
  handle "/swahili/topics/:id", using: "WorldServiceSwahiliTopicPage", examples: ["/swahili/topics/c06gq663n6jt", "/swahili/topics/c06gq663n6jt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/swahili/articles/:id", using: "WorldServiceSwahiliArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/swahili/articles/:id.amp", using: "WorldServiceSwahiliArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/swahili/send/:id", using: "UploaderWorldService", examples: ["/swahili/send/u39697902"]
  handle "/swahili/*_any", using: "WorldServiceSwahili", examples: ["/swahili"]
  handle "/tajik/*_any", using: "WorldServiceTajik", examples: ["/tajik"]

  redirect "/tamil/mobile/image/*any", to: "/tamil/*any", status: 302
  redirect "/tamil/mobile/*any", to: "/tamil", status: 301

  handle "/tamil.amp", using: "WorldServiceTamil", examples: ["/tamil.amp"]
  handle "/tamil.json", using: "WorldServiceTamil", examples: ["/tamil.json"]
  handle "/tamil/manifest.json", using: "WorldServiceTamilAssets", examples: ["/tamil/manifest.json"]
  handle "/tamil/sw.js", using: "WorldServiceTamilAssets", examples: ["/tamil/sw.js"]
  handle "/tamil/topics/:id", using: "WorldServiceTamilTopicPage", examples: ["/tamil/topics/c06gq6gnzdgt", "/tamil/topics/c06gq6gnzdgt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/tamil/articles/:id", using: "WorldServiceTamilArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/tamil/articles/:id.amp", using: "WorldServiceTamilArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/tamil/send/:id", using: "UploaderWorldService", examples: ["/tamil/send/u39697902"]
  handle "/tamil/*_any", using: "WorldServiceTamil", examples: ["/tamil"]
  handle "/telugu.amp", using: "WorldServiceTelugu", examples: ["/telugu.amp"]
  handle "/telugu.json", using: "WorldServiceTelugu", examples: ["/telugu.json"]
  handle "/telugu/manifest.json", using: "WorldServiceTeluguAssets", examples: ["/telugu/manifest.json"]
  handle "/telugu/sw.js", using: "WorldServiceTeluguAssets", examples: ["/telugu/sw.js"]
  handle "/telugu/topics/:id", using: "WorldServiceTeluguTopicPage", examples: ["/telugu/topics/c5qvp16w7dnt", "/telugu/topics/c5qvp16w7dnt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/telugu/articles/:id", using: "WorldServiceTeluguArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/telugu/articles/:id.amp", using: "WorldServiceTeluguArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/telugu/send/:id", using: "UploaderWorldService", examples: ["/telugu/send/u39697902"]
  handle "/telugu/*_any", using: "WorldServiceTelugu", examples: ["/telugu"]
  handle "/thai.amp", using: "WorldServiceThai", examples: ["/thai.amp"]
  handle "/thai.json", using: "WorldServiceThai", examples: ["/thai.json"]
  handle "/thai/manifest.json", using: "WorldServiceThaiAssets", examples: ["/thai/manifest.json"]
  handle "/thai/sw.js", using: "WorldServiceThaiAssets", examples: ["/thai/sw.js"]
  handle "/thai/topics/:id", using: "WorldServiceThaiTopicPage", examples: ["/thai/topics/c340qx429k7t", "/thai/topics/c340qx429k7t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/thai/articles/:id", using: "WorldServiceThaiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/thai/articles/:id.amp", using: "WorldServiceThaiArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/thai/send/:id", using: "UploaderWorldService", examples: ["/thai/send/u39697902"]
  handle "/thai/*_any", using: "WorldServiceThai", examples: ["/thai"]
  handle "/tigrinya.amp", using: "WorldServiceTigrinya", examples: ["/tigrinya.amp"]
  handle "/tigrinya.json", using: "WorldServiceTigrinya", examples: ["/tigrinya.json"]
  handle "/tigrinya/manifest.json", using: "WorldServiceTigrinyaAssets", examples: ["/tigrinya/manifest.json"]
  handle "/tigrinya/sw.js", using: "WorldServiceTigrinyaAssets", examples: ["/tigrinya/sw.js"]
  handle "/tigrinya/topics/:id", using: "WorldServiceTigrinyaTopicPage", examples: ["/tigrinya/topics/c1gdqrg28zxt", "/tigrinya/topics/c1gdqrg28zxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/tigrinya/articles/:id", using: "WorldServiceTigrinyaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/tigrinya/articles/:id.amp", using: "WorldServiceTigrinyaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/tigrinya/send/:id", using: "UploaderWorldService", examples: ["/tigrinya/send/u39697902"]
  handle "/tigrinya/*_any", using: "WorldServiceTigrinya", examples: ["/tigrinya"]

  redirect "/turkce/mobile/*any", to: "/turkce", status: 301
  redirect "/turkce/cep/*any", to: "/turkce", status: 301

  handle "/turkce.amp", using: "WorldServiceTurkce", examples: ["/turkce.amp"]
  handle "/turkce.json", using: "WorldServiceTurkce", examples: ["/turkce.json"]
  handle "/turkce/manifest.json", using: "WorldServiceTurkceAssets", examples: ["/turkce/manifest.json"]
  handle "/turkce/sw.js", using: "WorldServiceTurkceAssets", examples: ["/turkce/sw.js"]
  handle "/turkce/topics/:id", using: "WorldServiceTurkceTopicPage", examples: ["/turkce/topics/c2dwqnwkvnqt", "/turkce/topics/c2dwqnwkvnqt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/turkce/articles/:id", using: "WorldServiceTurkceArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/turkce/articles/:id.amp", using: "WorldServiceTurkceArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/turkce/send/:id", using: "UploaderWorldService", examples: ["/turkce/send/u39697902"]
  handle "/turkce/*_any", using: "WorldServiceTurkce", examples: ["/turkce"]

  redirect "/ukchina/simp/mobile/*any", to: "/ukchina/simp", status: 301
  redirect "/ukchina/trad/mobile/*any", to: "/ukchina/trad", status: 301

  handle "/ukchina/manifest.json", using: "WorldServiceUkChinaAssets", examples: ["/ukchina/manifest.json"]
  handle "/ukchina/sw.js", using: "WorldServiceUkChinaAssets", examples: ["/ukchina/sw.js"]

  handle "/ukchina/simp/topics/:id", using: "WorldServiceUkchinaTopicPage", examples: ["/ukchina/simp/topics/c1nq04kp0r0t", "/ukchina/simp/topics/c1nq04kp0r0t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end
  handle "/ukchina/trad/topics/:id", using: "WorldServiceUkchinaTopicPage", examples: ["/ukchina/trad/topics/cgqnyy07pqyt", "/ukchina/trad/topics/cgqnyy07pqyt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/ukchina/send/:id", using: "UploaderWorldService", examples: ["/ukchina/send/u39697902"]
  handle "/ukchina/*_any", using: "WorldServiceUkChina", examples: ["/ukchina/simp", "/ukchina/trad", "/ukchina/trad.json", "/ukchina/trad.amp"]

  redirect "/ukrainian/mobile/*any", to: "/ukrainian", status: 301

  handle "/ukrainian.amp", using: "WorldServiceUkrainian", examples: ["/ukrainian.amp"]
  handle "/ukrainian.json", using: "WorldServiceUkrainian", examples: ["/ukrainian.json"]
  handle "/ukrainian/manifest.json", using: "WorldServiceUkrainianAssets", examples: ["/ukrainian/manifest.json"]
  handle "/ukrainian/sw.js", using: "WorldServiceUkrainianAssets", examples: ["/ukrainian/sw.js"]
  handle "/ukrainian/topics/:id", using: "WorldServiceUkrainianTopicPage", examples: ["/ukrainian/topics/c340qxwr67yt", "/ukrainian/topics/c340qxwr67yt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/ukrainian/articles/:id", using: "WorldServiceUkrainianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/ukrainian/articles/:id.amp", using: "WorldServiceUkrainianArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/ukrainian/send/:id", using: "UploaderWorldService", examples: ["/ukrainian/send/u39697902"]
  handle "/ukrainian/*_any", using: "WorldServiceUkrainian", examples: ["/ukrainian"]

  redirect "/urdu/mobile/image/*any", to: "/urdu/*any", status: 302
  redirect "/urdu/mobile/*any", to: "/urdu", status: 301

  handle "/urdu.amp", using: "WorldServiceUrdu", examples: ["/urdu.amp"]
  handle "/urdu.json", using: "WorldServiceUrdu", examples: ["/urdu.json"]
  handle "/urdu/manifest.json", using: "WorldServiceUrduAssets", examples: ["/urdu/manifest.json"]
  handle "/urdu/sw.js", using: "WorldServiceUrduAssets", examples: ["/urdu/sw.js"]
  handle "/urdu/topics/:id", using: "WorldServiceUrduTopicPage", examples: ["/urdu/topics/c44pxlmy60mt", "/urdu/topics/c44pxlmy60mt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/urdu/articles/:id", using: "WorldServiceUrduArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/urdu/articles/:id.amp", using: "WorldServiceUrduArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/urdu/send/:id", using: "UploaderWorldService", examples: ["/urdu/send/u39697902"]
  handle "/urdu/*_any", using: "WorldServiceUrdu", examples: ["/urdu"]

  redirect "/uzbek/mobile/*any", to: "/uzbek", status: 301

  handle "/uzbek.amp", using: "WorldServiceUzbek", examples: ["/uzbek.amp"]
  handle "/uzbek.json", using: "WorldServiceUzbek", examples: ["/uzbek.json"]
  handle "/uzbek/manifest.json", using: "WorldServiceUzbekAssets", examples: ["/uzbek/manifest.json"]
  handle "/uzbek/sw.js", using: "WorldServiceUzbekAssets", examples: ["/uzbek/sw.js"]
  handle "/uzbek/topics/:id", using: "WorldServiceUzbekTopicPage", examples: ["/uzbek/topics/c340q0q55jvt", "/uzbek/topics/c340q0q55jvt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/uzbek/articles/:id", using: "WorldServiceUzbekArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/uzbek/articles/:id.amp", using: "WorldServiceUzbekArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/uzbek/send/:id", using: "UploaderWorldService", examples: ["/uzbek/send/u39697902"]
  handle "/uzbek/*_any", using: "WorldServiceUzbek", examples: ["/uzbek"]

  redirect "/vietnamese/mobile/*any", to: "/vietnamese", status: 301

  handle "/vietnamese.amp", using: "WorldServiceVietnamese", examples: ["/vietnamese.amp"]
  handle "/vietnamese.json", using: "WorldServiceVietnamese", examples: ["/vietnamese.json"]
  handle "/vietnamese/manifest.json", using: "WorldServiceVietnameseAssets", examples: ["/vietnamese/manifest.json"]
  handle "/vietnamese/sw.js", using: "WorldServiceVietnameseAssets", examples: ["/vietnamese/sw.js"]
  handle "/vietnamese/topics/:id", using: "WorldServiceVietnameseTopicPage", examples: ["/vietnamese/topics/c340q0gkg4kt", "/vietnamese/topics/c340q0gkg4kt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/vietnamese/articles/:id", using: "WorldServiceVietnameseArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/vietnamese/articles/:id.amp", using: "WorldServiceVietnameseArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/vietnamese/send/:id", using: "UploaderWorldService", examples: ["/vietnamese/send/u39697902"]
  handle "/vietnamese/*_any", using: "WorldServiceVietnamese", examples: ["/vietnamese"]
  handle "/yoruba.amp", using: "WorldServiceYoruba", examples: ["/yoruba.amp"]
  handle "/yoruba.json", using: "WorldServiceYoruba", examples: ["/yoruba.json"]
  handle "/yoruba/manifest.json", using: "WorldServiceYorubaAssets", examples: ["/yoruba/manifest.json"]
  handle "/yoruba/sw.js", using: "WorldServiceYorubaAssets", examples: ["/yoruba/sw.js"]
  handle "/yoruba/topics/:id", using: "WorldServiceYorubaTopicPage", examples: ["/yoruba/topics/c12jqpnxn44t", "/yoruba/topics/c12jqpnxn44t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/yoruba/articles/:id", using: "WorldServiceYorubaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/yoruba/articles/:id.amp", using: "WorldServiceYorubaArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/yoruba/send/:id", using: "UploaderWorldService", examples: ["/yoruba/send/u39697902"]
  handle "/yoruba/*_any", using: "WorldServiceYoruba", examples: ["/yoruba"]

  redirect "/zhongwen/simp/mobile/*any", to: "/zhongwen/simp", status: 301
  redirect "/zhongwen/trad/mobile/*any", to: "/zhongwen/trad", status: 301

  handle "/zhongwen/manifest.json", using: "WorldServiceZhongwenAssets", examples: ["/zhongwen/manifest.json"]
  handle "/zhongwen/sw.js", using: "WorldServiceZhongwenAssets", examples: ["/zhongwen/sw.js"]

  handle "/zhongwen/simp/topics/:id", using: "WorldServiceZhongwenTopicPage", examples: ["/zhongwen/simp/topics/c0dg90z8nqxt", "/zhongwen/simp/topics/c0dg90z8nqxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end
  handle "/zhongwen/trad/topics/:id", using: "WorldServiceZhongwenTopicPage", examples: ["/zhongwen/trad/topics/cpydz21p02et", "/zhongwen/trad/topics/cpydz21p02et?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/zhongwen/articles/:id/simp", using: "WorldServiceZhongwenArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/simp.amp", using: "WorldServiceZhongwenArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/trad", using: "WorldServiceZhongwenArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/trad.amp", using: "WorldServiceZhongwenArticlePage", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/zhongwen/send/:id", using: "UploaderWorldService", examples: ["/zhongwen/send/u39697902"]
  handle "/zhongwen/*_any", using: "WorldServiceZhongwen", examples: ["/zhongwen/simp", "/zhongwen/trad", "/zhongwen/trad.json", "/zhongwen/trad.amp"]

  handle "/ws/languages", using: "WsLanguages", examples: ["/ws/languages"]
  handle "/ws/av-embeds/*_any", using: "WsAvEmbeds", examples: []
  handle "/ws/includes/*_any", using: "WsIncludes", examples: ["/ws/includes/include/vjamericas/176-eclipse-lookup/mundo/app/embed"]
  handle "/worldservice/assets/images/*_any", using: "WsImages", examples: [{"/worldservice/assets/images/2012/07/12/120712163431_img_0328.jpg", 301}]

  # /programmes

  handle "/programmes/av/:id", using: "ProgrammesVideos", only_on: "test", examples: ["/programmes/av/p0992fn5", "/programmes/av/p092wf79", "/programmes/av/p091z0jn"] do
    return_404 if: !String.match?(id, ~r/^[a-z][a-z0-9]+$/)
  end

  handle "/programmes/articles/:key/:slug/contact", using: "ProgrammesLegacy", examples: [{"/programmes/articles/49FbN1s7dwnWXBmHRGK308B/5-unforgettable-moments-from-the-semi-final/contact", 301}] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/articles/:key/:slug", using: "ProgrammesArticle", examples: ["/programmes/articles/4xJyCpMp64NcCXD0FVlhmSz/frequently-asked-questions"] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/articles/:key", using: "ProgrammesArticle", examples: [{"/programmes/articles/4xJyCpMp64NcCXD0FVlhmSz", 301}] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/a-z/current", using: "ProgrammesLegacy", examples: [{"/programmes/a-z/current", 301}]

  handle "/programmes/a-z/by/:search/current", using: "ProgrammesLegacy", examples: [{"/programmes/a-z/by/b/current", 301}] do
    return_404 if: !String.match?(search, ~r/^[a-zA-Z@]$/)
  end

  handle "/programmes/a-z/by/:search/:slice.json", using: "ProgrammesData", examples: ["/programmes/a-z/by/b/all.json", "/programmes/a-z/by/b/player.json"] do
    return_404 if: [
      !String.match?(search, ~r/^[a-zA-Z@]$/),
      !Enum.member?(["all", "player"], slice),
    ]
  end

  handle "/programmes/a-z/by/:search.json", using: "ProgrammesData", examples: ["/programmes/a-z/by/b.json"] do
    return_404 if: !String.match?(search, ~r/^[a-zA-Z@]$/)
  end

  handle "/programmes/a-z/by/:search/:slice", using: "Programmes", examples: ["/programmes/a-z/by/b/all", "/programmes/a-z/by/b/player"] do
    return_404 if: [
      !String.match?(search, ~r/^[a-zA-Z@]$/),
      !Enum.member?(["all", "player"], slice),
    ]
  end

  handle "/programmes/a-z/by/:search", using: "ProgrammesLegacy", examples: [{"/programmes/a-z/by/b", 301}] do
    return_404 if: !String.match?(search, ~r/^[a-zA-Z@]$/)
  end

  handle "/programmes/a-z/:slice.json", using: "ProgrammesData", examples: ["/programmes/a-z/player.json", "/programmes/a-z/all.json"] do
    return_404 if: !Enum.member?(["all", "player"], slice)
  end

  handle "/programmes/a-z.json", using: "ProgrammesData", examples: ["/programmes/a-z.json"]

  handle "/programmes/a-z", using: "Programmes", examples: ["/programmes/a-z"]

  handle "/programmes/formats/:category/:slice", using: "Programmes", examples: ["/programmes/formats/animation/all", "/programmes/formats/animation/player"] do
    return_404 if: !Enum.member?(["all", "player"], slice)
  end

  handle "/programmes/formats/:category", using: "Programmes", examples: ["/programmes/formats/animation"]

  handle "/programmes/formats", using: "Programmes", examples: ["/programmes/formats"]

  handle "/programmes/genres", using: "Programmes", examples: ["/programmes/genres"]

  handle "/programmes/genres/*_any", using: "Programmes", examples: ["/programmes/genres/childrens", "/programmes/genres/comedy/sitcoms", "/programmes/genres/childrens/all", "/programmes/genres/childrens/player", "/programmes/genres/comedy/music/player", "/programmes/genres/comedy/music/all", "/programmes/genres/factual/scienceandnature/scienceandtechnology/player", "/programmes/genres/factual/scienceandnature/scienceandtechnology"]

  handle "/programmes/profiles/:key/:slug", using: "Programmes", examples: ["/programmes/profiles/5NGNHQKKXGsFfnkxPBzKPMW/alistair-lloyd"] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/profiles/:key", using: "Programmes", examples: [{"/programmes/profiles/23ca89bd-f35e-4803-bb86-c300c88afb2f", 301}, {"/programmes/profiles/5NGNHQKKXGsFfnkxPBzKPMW", 301}] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/snippet/:records_ids.json", using: "ProgrammesData", examples: ["/programmes/snippet/n45bj5.json"]

  handle "/programmes/topics/:topic/:slice", using: "Programmes", examples: [{"/programmes/topics/21st-century_American_non-fiction_writers/video", 301}, {"/programmes/topics/21st-century_American_non-fiction_writers/audio", 301}, {"/programmes/topics/Documentary_films_about_HIV/AIDS", 301}]

  handle "/programmes/topics/:topic", using: "Programmes", examples: [{"/programmes/topics/Performers_of_Sufi_music", 301}]

  handle "/programmes/topics", using: "Programmes", examples: [{"/programmes/topics", 301}]

  handle "/programmes/:pid/articles", using: "ProgrammesArticle", examples: ["/programmes/b006m8dq/articles"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/broadcasts/:year/:month", using: "ProgrammesLegacy", examples: [{"/programmes/b006qsq5/broadcasts/2020/01", 302}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/broadcasts", using: "ProgrammesLegacy", examples: [{"/programmes/w172vkw6f1ffv5f/broadcasts", 302}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/children.json", using: "ProgrammesData", examples: ["/programmes/b006m8dq/children.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/clips", using: "ProgrammesEntity", examples: ["/programmes/b045fz8r/clips"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/contact", using: "ProgrammesEntity", examples: ["/programmes/b006qj9z/contact"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/credits", using: "ProgrammesLegacy", examples: [{"/programmes/b06ss3j4/credits", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/a-z/:az", using: "ProgrammesLegacy", examples: [{"/programmes/b006qnmr/episodes/a-z/a", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/downloads.rss", using: "ProgrammesLegacy", examples: [{"/programmes/p02nrw8y/episodes/downloads.rss", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/downloads", using: "ProgrammesEntity", examples: ["/programmes/p02nrw8y/episodes/downloads"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/guide", using: "ProgrammesEntity", examples: ["/programmes/b006m8dq/episodes/guide"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/guide.2013inc", using: "ProgrammesEntity", examples: ["/programmes/p02zmzss/episodes/guide.2013inc"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/last.json", using: "ProgrammesData", examples: ["/programmes/b006m8dq/episodes/last.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/player", using: "ProgrammesEntity", examples: ["/programmes/b006m8dq/episodes/player"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/upcoming.json", using: "ProgrammesData", examples: ["/programmes/b04drklx/episodes/upcoming.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/:year/:month.json", using: "ProgrammesData", examples: ["/programmes/b006m8dq/episodes/2020/12.json"] do
    return_404 if: [
      !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/),
      !String.match?(year, ~r/^[1-2][0-9]{3}$/),
      !String.match?(month, ~r/^0?[1-9]|1[0-2]$/)
    ]
  end

  handle "/programmes/:pid/episodes.json", using: "ProgrammesData", examples: ["/programmes/b006m8dq/episodes.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes", using: "ProgrammesEntity", examples: [{"/programmes/b006m8dq/episodes", 302}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/galleries", using: "ProgrammesEntity", examples: ["/programmes/b045fz8r/galleries"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/members/all", using: "ProgrammesLegacy", examples: [{"/programmes/p001rshg/members/all", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/members", using: "ProgrammesLegacy", examples: [{"/programmes/p001rshg/members", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/microsite", using: "ProgrammesLegacy", examples: [{"/programmes/p001rshg/microsite", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/player", using: "ProgrammesEntity", examples: ["/programmes/p097pw9q/player"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/playlist.json", using: "ProgrammesData", examples: ["/programmes/b08lkyzk/playlist.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/podcasts", using: "ProgrammesLegacy", examples: [{"/programmes/p02nrw8y/podcasts", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/profiles", using: "ProgrammesEntity", examples: ["/programmes/b006qpgr/profiles"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/recipes.ameninc", using: "ProgrammesEntity", examples: ["/programmes/b006v5y2/recipes.ameninc"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/recipes.2013inc", using: "ProgrammesEntity", examples: ["/programmes/b006v5y2/recipes.2013inc"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/recipes", using: "ProgrammesEntity", examples: ["/programmes/b006v5y2/recipes"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/schedules", using: "ProgrammesLegacy", examples: [{"/programmes/p02str2y/schedules", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/schedules/*_any", using: "ProgrammesLegacy", examples: [{"/programmes/p02str2y/schedules/2019/03/18", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/segments.json", using: "ProgrammesData", examples: ["/programmes/b01m2fyy/segments.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/segments", using: "ProgrammesLegacy", examples: [{"/programmes/b01m2fz4/segments", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/series.json", using: "ProgrammesData", examples: ["/programmes/b006m8dq/series.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/series", using: "ProgrammesLegacy", examples: [{"/programmes/b006m8dq/series", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/topics/:topic", using: "ProgrammesEntity", examples: [{"/programmes/b00lvdrj/topics/1091_Media_films", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/topics", using: "ProgrammesEntity", examples: [{"/programmes/b00lvdrj/topics", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid.html", using: "ProgrammesLegacy", examples: [{"/programmes/b006m8dq.html", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid.json", using: "ProgrammesData", examples: ["/programmes/b006m8dq.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/:imagepid", using: "ProgrammesEntity", examples: ["/programmes/p028d9jw/p028d8nr"] do
    return_404 if: [
      !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/),
      !String.match?(imagepid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
    ]
  end

  handle "/programmes/:pid", using: "ProgrammesEntity", examples: ["/programmes/b006m8dq"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes", using: "ProgrammesHomePage", examples: ["/programmes"]

  # /programmes catch all
  handle "/programmes/*_any", using: "Programmes", examples: []

  # /schedules

  handle "/schedules/network/:network/on-now", using: "Schedules", examples: [{"/schedules/network/cbeebies/on-now", 302}] do
    return_404 if: !String.match?(network, ~r/^[a-zA-Z0-9]{2,35}$/)
  end

  handle "/schedules/network/:network", using: "Schedules", examples: [{"/schedules/network/radioscotland", 301}] do
    return_404 if: !String.match?(network, ~r/^[a-zA-Z0-9]{2,35}$/)
  end

  handle "/schedules/:pid/*_any", using: "Schedules", examples: ["/schedules/p00fzl6v/2021/06/28", "/schedules/p05pkt1d/2020/w02", "/schedules/p05pkt1d/2020/01", {"/schedules/p05pkt1d/yesterday", 302}, "/schedules/p05pkt1d/2021"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/schedules", using: "Schedules", examples: ["/schedules"]

  # /schedules catch all
  handle "/schedules/*_any", using: "Schedules", examples: []

  # Participation

  handle "/participation-test/follow", using: "ParticipationTestFollow", only_on: "test", examples: ["/participation-test/follow"]

  # Uploader

  handle "/send/:id", using: "Uploader", examples: ["/send/u39697902"]

  # topics

  handle "/topics", using: "TopicPage", examples: ["/topics"]

  handle "/topics/:id", using: "TopicPage", examples: ["/topics/c583y7zk042t"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  ## Live WebCore
  handle "/live/:asset_id", using: "Live", only_on: "test", examples: ["/live/c1v596ken6vt", "/live/c1v596ken6vt&page=6"] do
    return_404 if: [
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-4][0-9]|50|[1-9])\z/)
    ]
  end

  # Weather
  handle "/weather", using: "WeatherHomePage", examples: ["/weather"]
  handle "/weather/coast-and-sea/*_any", using: "WeatherCoastAndSea", examples: ["/weather/coast-and-sea", "/weather/coast-and-sea/inshore-waters"]
  handle "/weather/*_any", using: "Weather", examples: ["/weather/2650225"]

  # WebCore Hub
  redirect("/webcore/*any", to: "https://hub.webcore.tools.bbc.co.uk/webcore/*any", status: 302)

  # News Beat

  redirect("/newsbeat/:asset_id", to: "/news/newsbeat-:asset_id", status: 301)
  redirect("/newsbeat/articles/:asset_id", to: "/news/newsbeat-:asset_id", status: 301)
  redirect("/newsbeat/article/:asset_id/:slug", to: "/news/newsbeat-:asset_id", status: 301)
  redirect("/newsbeat", to: "/news/newsbeat", status: 301)

  # BBC Optimo Articles
  redirect "/articles", to: "/", status: 302

  handle "/articles/:optimo_id", using: "StorytellingPage", examples: ["/articles/c1vy1zrejnno"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  # Catch all

  # example test route: "/comments/embed/news/world-europe-23348005"
  handle "/comments/embed/*_any", using: "CommentsEmbed", examples: []

  handle "/web/shell", using: "WebShell", examples: ["/web/shell"]

  handle "/my/session", using: "MySession", only_on: "test", examples: []

  handle "/scotland/articles/*_any", using: "ScotlandArticles", examples: []
  # TODO this may not be an actual required route
  handle "/scotland/*_any", using: "Scotland", examples: []

  handle "/archive/articles/*_any", using: "ArchiveArticles", examples: ["/archive/articles/sw.js"]
  # TODO this may not be an actual required route e.g. archive/collections-transport-and-travel/zhb9f4j showing as Morph Router
  handle "/archive/*_any", using: "Archive", examples: []

  # newsrounds routes appear to be using morphRouter
  handle "/newsround.amp", using: "Newsround", examples: []
  handle "/newsround.json", using: "Newsround", examples: []

  redirect "/newsround/amp/:id", to: "/newsround/:id.amp", status: 301
  redirect "/newsround/amp/:topic/:id", to: "/newsround/:topic/:id.amp", status: 301

  handle "/newsround/*_any", using: "Newsround", examples: []

  handle "/schoolreport/*_any", using: "Schoolreport", examples: [{"/schoolreport", 301}, {"/schoolreport/home", 301}]

  handle "/wide/*_any", using: "Wide", examples: []

  handle "/archivist/*_any", using: "Archivist", examples: []

  # TODO /proms/extra
  handle "/proms/*_any", using: "Proms", examples: []

  handle "/music", using: "Music", examples: []

  # Bitesize
  handle "/bitesize/secondary", using: "BitesizeTransition", examples: ["/bitesize/secondary"]

  handle "/bitesize/subjects", using: "Bitesize", examples: ["/bitesize/subjects"]
  handle "/bitesize/subjects/:id", using: "BitesizeTransition", only_on: "test", examples: ["/bitesize/subjects/z8tnvcw"]
  handle "/bitesize/subjects/:id/year/:year_id", using: "BitesizeTransition", only_on: "test", examples: ["/bitesize/subjects/zjxhfg8/year/zjpqqp3"]

  handle "/bitesize/courses/:id", using: "BitesizeTransition", only_on: "test", examples: ["/bitesize/courses/zdcg3j6"]

  handle "/bitesize/articles/:id", using: "BitesizeArticles", examples: ["/bitesize/articles/zjykkmn"]

  handle "/bitesize/preview/articles/:id", using: "Bitesize", only_on: "test", examples: ["/bitesize/preview/articles/zj8yydm"]

  handle "/bitesize/levels/:id", using: "BitesizeWebcorePages", examples: ["/bitesize/levels/z98jmp3"]
  handle "/bitesize/levels/:level_id/year/:year_id", using: "BitesizeWebcorePages", examples: ["/bitesize/levels/z3g4d2p/year/zmyxxyc"]

  handle "/bitesize/guides/:id/revision/:page", using: "BitesizeGuides", examples: ["/bitesize/guides/zw3bfcw/revision/1"]
  handle "/bitesize/guides/:id/revision", using: "BitesizeGuides", examples: ["/bitesize/guides/zw3bfcw/revision"]
  handle "/bitesize/guides/:id/test", using: "BitesizeGuides", examples: ["/bitesize/guides/zw7xfcw/test"]
  handle "/bitesize/guides/:id/audio", using: "BitesizeGuides", examples: ["/bitesize/guides/zwsffg8/audio"]
  handle "/bitesize/guides/:id/video", using: "BitesizeGuides", examples: ["/bitesize/guides/zcvy6yc/video"]

  handle "/bitesize/preview/guides/:id/revision/:page", using: "Bitesize", only_on: "test", examples: ["/bitesize/preview/guides/zw3bfcw/revision/1"]
  handle "/bitesize/preview/guides/:id/revision", using: "Bitesize", only_on: "test", examples: ["/bitesize/preview/guides/zw3bfcw/revision"]
  handle "/bitesize/preview/guides/:id/test", using: "Bitesize", only_on: "test", examples: ["/bitesize/preview/guides/zw7xfcw/test"]
  handle "/bitesize/preview/guides/:id/audio", using: "Bitesize", only_on: "test", examples: ["/bitesize/preview/guides/zwsffg8/audio"]
  handle "/bitesize/preview/guides/:id/video", using: "Bitesize", only_on: "test", examples: ["/bitesize/preview/guides/zcvy6yc/video"]

  redirect "/bitesize/guides/:id", to: "/bitesize/guides/:id/revision/1", status: 301

  handle "/bitesize/topics/:id", using: "BitesizeTransition", only_on: "test", examples: ["/bitesize/topics/z82hsbk"]
  handle "/bitesize/topics/:id/year/:year_id", using: "BitesizeTransition", only_on: "test", examples: ["/bitesize/topics/zwv39j6/year/zjpqqp3"]
  handle "/bitesize/*_any", using: "BitesizeLegacy", examples: ["/bitesize/levels"]

  # Games
  handle "/games/*_any", using: "Games", examples: ["/games/embed/genie-starter-pack"]


  # Classic Apps

  handle "/content/cps/news/front_page", using: "ClassicAppNewsFrontpage", examples: ["/content/cps/news/front_page"]
  handle "/content/cps/news/live/*any", using: "ClassicAppNewsLive", examples: ["/content/cps/news/live/world-africa-47639452"]
  handle "/content/cps/news/av/*any", using: "ClassicAppNewsAv", examples: ["/content/cps/news/av/world-europe-59368718"]
  handle "/content/cps/news/articles/*any", using: "ClassicAppNewsArticles", examples: ["/content/cps/news/articles/c7pp03pz8dro"]
  handle "/content/cps/news/video_and_audio/*any", using: "ClassicAppNewsAudioVideo", examples: ["/content/cps/news/video_and_audio/ten_to_watch", "/content/cps/news/video_and_audio/top_stories"]
  handle "/content/cps/news/*any", using: "ClassicAppNewsCps", examples: ["/content/cps/news/world-europe-59368718", "/content/cps/news/uk-england-london-59333481"]

  handle "/content/cps/sport/front-page", using: "ClassicAppSportFrontpage", examples: ["/content/cps/sport/front-page"]
  handle "/content/cps/sport/live/*any", using: "ClassicAppSportLive", examples: ["/content/cps/sport/live/football/59369278", "/content/cps/sport/live/formula1/58748830"]
  handle "/content/cps/sport/football/*any", using: "ClassicAppSportFootball", examples: ["/content/cps/sport/football/59372826", "/content/cps/sport/football/58643317"]
  handle "/content/cps/sport/av/football/*any", using: "ClassicAppSportFootballAv", examples: ["/content/cps/sport/av/football/59346509"]
  handle "/content/cps/sport/*any", using: "ClassicAppSportCps", examples: ["/content/cps/sport/rugby-union/59369204", "/content/cps/sport/tennis/59328440"]

  handle "/content/cps/newsround/*any", using: "ClassicAppNewsround", examples: ["/content/cps/newsround/45274517"]
  handle "/content/cps/naidheachdan/*any", using: "ClassicAppNaidheachdan", examples: ["/content/cps/naidheachdan/59371990", "/content/cps/naidheachdan/front_page", "/content/cps/naidheachdan/dachaigh"]
  handle "/content/cps/mundo/*any", using: "ClassicAppMundo", examples: ["/content/cps/mundo/vert-cap-59223070?createdBy=mundo&language=es", "/content/cps/mundo/noticias-59340165?createdBy=mundo&language=es"]
  handle "/content/cps/arabic/*any", using: "ClassicAppArabic", examples: ["/content/cps/arabic/live?createdBy=arabic&language=ar", "/content/cps/arabic/art-and-culture-59307957?createdBy=arabic&language=ar"]
  handle "/content/cps/russian/*any", using: "ClassicAppRussianCps", examples: ["/content/cps/russian/front_page?createdBy=russian&language=ru", "/content/cps/russian/news?createdBy=russian&language=ru", "/content/cps/russian/features-58536209?createdBy=russian&language=ru"]
  handle "/content/cps/hindi/*any", using: "ClassicAppHindi", examples: ["/content/cps/hindi/india?createdBy=hindi&language=hi", "/content/cps/hindi/india-59277161?createdBy=hindi&language=hi"]
  handle "/content/cps/learning_english/*any", using: "ClassicAppLearningEnglish", examples: ["/content/cps/learning_english/home", "/content/cps/learning_english/6-minute-english-59142810"]
  handle "/content/cps/:product/*any", using: "ClassicAppProducts", examples: []
  handle "/content/cps/*any", using: "ClassicAppCps", examples: []

  handle "/content/ldp/:guid", using: "ClassicAppFablLdp", examples: ["/content/ldp/de648736-7268-454c-a7b1-dbff416f2865"]
  handle "/content/most_popular/*any", using: "ClassicAppMostPopular", examples: ["/content/most_popular/news"]
  handle "/content/ww/*any", using: "ClassicAppWw", examples: ["/content/ww/travel/module/homepage"]
  handle "/content/news/*any", using: "ClassicAppNews", examples: []
  handle "/content/sport/*any", using: "ClassicAppSport", examples: []
  handle "/content/russian/*any", using: "ClassicAppRussian", examples: ["/content/russian/video?createdBy=russian&language=ru"]
  handle "/content/:hash", using: "ClassicAppId", examples: ["/content/a2aad340841e6e878b0f7aff2ecfe8a8"]
  handle "/content/:service/*any", using: "ClassicAppService", examples: []
  handle "/content/*any", using: "ClassicApp", examples: []
  handle "/static/*any", using: "ClassicAppStaticContent", examples: ["/static/LE/android/1.5.0/config.json", "/static/MUNDO/ios/5.19.0/layouts.zip"]
  handle "/flagpoles/*any", using: "ClassicAppFlagpole", examples: ["/flagpoles/ads"]


  # Platform Health Observability endpoints for response time monitoring of Webcore platform
  handle "/_health/public_content", using: "PhoPublicContent", examples: ["/_health/public_content"]
  handle "/_health/private_content", using: "PhoPrivateContent", examples: ["/_health/private_content"]

  handle "/_private/belfrage-cascade-test", using: ["WorldServiceTajik", "WorldServiceKorean", "ProxyPass"], only_on: "test", examples: []
  handle "/_private/lambda-cascade-test", using: ["HomePage", "ProxyPass"], only_on: "test", examples: []
  # handle "/news/business-:id", using: ["NewsStories", "NewsSFV", "MozartNews"], examples: ["/"]
  # handle "/news/business-:id", using: ["NewsBusiness", "MozartNews"], examples: ["/"]

  handle "/full-stack-test/a/*_any", using: "FullStackTestA", only_on: "test", examples: []
  handle "/full-stack-test/b/*_any", using: "FullStackTestB", only_on: "test", examples: []
  redirect("/full-stack-test/*any", to: "/full-stack-test/a/*any", status: 302)

  handle "/echo", using: "EchoSpec", only_on: "test", examples: ["/echo"]

  handle_proxy_pass "/*any", using: "ProxyPass", only_on: "test", examples: ["/foo/bar"]

  no_match()
end
