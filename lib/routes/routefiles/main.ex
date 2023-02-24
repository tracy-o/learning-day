#
# How to add a route:
# https://github.com/bbc/belfrage/wiki/Routing-in-Belfrage#how-to-add-a-route
# What types of route matcher you can  use:
# https://github.com/bbc/belfrage/wiki/Types-of-Route-Matchers-in-Belfrage
#
# How to validate a route:
# lib/belfrage_web/validators.ex

import BelfrageWeb.Routefile

defroutefile "Main" do
  redirect "/news/0", to: "/news", status: 302
  redirect "/news/2/hi", to: "/news", status: 302
  redirect "/news/mobile", to: "/news", status: 302
  redirect "/news/popular/read", to: "/news", status: 302

  redirect "/news/help", to: "/news", status: 302
  redirect "/news/also_in_the_news", to: "/news", status: 302
  redirect "/news/cop26-alerts", to: "/news/help-58765412", status: 302
  redirect "/news/wales-election-2021-alerts", to: "/news/help-56680930", status: 302
  redirect "/news/scotland-election-2021-alerts", to: "/news/help-56680931", status: 302
  redirect "/news/nie22-alerts", to: "/news/help-60495859", status: 302

  redirect "/news/magazine", to: "/news/stories", status: 302

  redirect "/news/10318089", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302
  redirect "/news/av/10318089", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302
  redirect "/news/av/10318089/bbc-news-channel", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302
  redirect "/news/video_and_audio/headlines/10318089/bbc-news-channel", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302

  redirect "/news/video_and_audio/international", to: "/news/av/10462520", status: 302
  redirect "/news/video_and_audio/video", to: "/news/av/10318236", status: 302
  redirect "/news/video_and_audio/features/:section_and_asset/:asset_id", to: "/news/av/:section_and_asset", status: 302
  redirect "/news/world-middle-east-27796850", to: "/programmes/w13xtvn3", status: 301

  redirect "/news/world-radio-and-tv-12759931", to: "/aboutthebbc/whatwedo/worldservice", status: 301

  redirect "/cymrufyw/etholiad", to: "/cymrufyw/gwleidyddiaeth", status: 302
  redirect "/cymrufyw/etholiad/2021", to: "/cymrufyw/gwleidyddiaeth", status: 302
  redirect "/news/election", to: "/news/politics", status: 302
  redirect "/news/election/2021", to: "/news/politics", status: 302

  redirect "https://www.bbc.com/ukraine", to: "https://www.bbc.com/ukrainian", status: 302
  redirect "https://www.bbc.co.uk/ukraine", to: "/news/world-60525350", status: 302
  redirect "https://www.test.bbc.com/ukraine", to: "https://www.test.bbc.com/ukrainian", status: 302
  redirect "https://www.test.bbc.co.uk/ukraine", to: "/news/world-60525350", status: 302

  # News - Indian Sports Woman of The Year
  redirect "/news/iswoty", to: "/news/resources/idt-c01e87cf-898c-4ec6-86ea-5ef77f9e58a0", status: 302

  # Home Page
  redirect "/ni", to: "/northernireland", status: 302

  handle "/", using: "HomePage", platform: "Webcore", examples: ["/"]
  handle "/scotland", using: "ScotlandHomePage", platform: "Webcore", examples: ["/scotland"]
  handle "/homepage/test", using: "TestHomePage", platform: "Webcore", only_on: "test", examples: ["/homepage/test"]
  handle "/homepage/automation", using: "AutomationHomePage", platform: "Webcore", only_on: "test", examples: ["/homepage/automation"]
  handle "/northernireland", using: "NorthernIrelandHomePage", platform: "Webcore", examples: ["/northernireland"]
  handle "/wales", using: "WalesHomePage", platform: "Webcore", examples: ["/wales"]
  handle "/cymru", using: "CymruHomePage", platform: "Webcore", examples: ["/cymru"]
  handle "/alba", using: "AlbaHomePage", platform: "Webcore", examples: ["/alba"]

  handle "/newstipo", using: "NewsTipoHomePage", platform: "Webcore", only_on: "test", examples: ["/newstipo"]

  handle "/homepage/news/preview", using: "NewsHomePagePreview", platform: "Webcore", only_on: "test", examples: ["/homepage/news/preview"]
  handle "/homepage/news/test", using: "TestNewsHomePage", platform: "Webcore", only_on: "test", examples: ["/homepage/news/test"]
  handle "/homepage/index-examples", using: "IndexExamplesHomePage", platform: "Webcore", only_on: "test", examples: ["/homepage/index-examples"]

  handle "/homepage/preview", using: "HomePagePreview", platform: "Webcore", examples: ["/homepage/preview"]
  handle "/homepage/preview/scotland", using: "HomePagePreviewScotland", platform: "Webcore", examples: ["/homepage/preview/scotland"]
  handle "/homepage/preview/wales", using: "HomePagePreviewWales", platform: "Webcore", examples: ["/homepage/preview/wales"]
  handle "/homepage/preview/northernireland", using: "HomePagePreviewNorthernIreland", platform: "Webcore", examples: []
  handle "/homepage/preview/cymru", using: "HomePagePreviewCymru", platform: "Webcore", examples: ["/homepage/preview/cymru"]
  handle "/homepage/preview/alba", using: "HomePagePreviewAlba", platform: "Webcore", examples: ["/homepage/preview/alba"]
  handle "/homepage/newsround/preview", using: "NewsroundHomePagePreview", platform: "Webcore", examples: ["/homepage/newsround/preview"]

  handle "/homepage/personalised", using: "HomePagePersonalised", platform: "Webcore", examples: ["/homepage/personalised"]
  handle "/homepage/segmented", using: "HomePageSegmented", platform: "Webcore", examples: ["/homepage/segmented"]

  handle "/sportproto", using: "SportHomePage", platform: "Webcore", only_on: "test", examples: ["/sportproto"]
  handle "/sporttipo", using: "SportTipo", platform: "Webcore", examples: ["/sporttipo"]

  handle "/homepage/sport/preview", using: "SportHomePagePreview", platform: "Webcore", examples: ["/homepage/sport/preview"]
  handle "/homepage/sport/test", using: "TestSportHomePage", platform: "Webcore", only_on: "test", examples: ["/homepage/sport/test"]

  # data endpoints

  handle "/fd/p/mytopics-page", using: "MyTopicsPage", platform: "Fabl", examples: []
  handle "/fd/p/mytopics-follows", using: "MyTopicsFollows", platform: "Fabl", examples: []
  handle "/fd/p/preview/:name", using: "PersonalisedFablData", platform: "Fabl", only_on: "test", examples: [] do
    return_404 if: [
      !is_valid_length?(name, 3..40),
      !matches?(name, ~r/^[a-z0-9-]+$/)
    ]
  end
  handle "/fd/preview/abl", using: "AblData", platform: "Fabl", examples: []
  handle "/fd/preview/spike-abl-core", using: "AblData", platform: "Fabl", examples: []
  handle "/fd/preview/:name", using: "FablData", platform: "Fabl", examples: ["/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios"] do
    return_404 if: [
      !is_valid_length?(name, 3..40),
      !matches?(name, ~r/^[a-z0-9-]+$/)
    ]
  end
  handle "/fd/abl", using: "AblData", platform: "Fabl", examples: ["/fd/abl?clientName=Hindi&clientVersion=pre-4&page=india-63495511&release=public-alpha&service=hindi&type=asset"]
  handle "/fd/p/:name", using: "PersonalisedFablData", platform: "Fabl", only_on: "test", examples: [] do
    return_404 if: [
      !is_valid_length?(name, 3..40),
      !matches?(name, ~r/^[a-z0-9-]+$/)
    ]
  end
  handle "/fd/sport-app-allsport", using: "SportData", platform: "Fabl", examples: ["/fd/sport-app-allsport?env=live&edition=domestic"]
  handle "/fd/sport-app-followables", using: "SportData", platform: "Fabl", examples: ["/fd/sport-app-followables?env=live&edition=domestic"]
  handle "/fd/sport-app-images", using: "SportData", platform: "Fabl", examples: ["/fd/sport-app-images"]
  handle "/fd/sport-app-menu", using: "SportData", platform: "Fabl", examples: ["/fd/sport-app-menu?edition=domestic&platform=ios&env=live"]
  handle "/fd/sport-app-notification-data", using: "SportData", platform: "Fabl", examples: ["/fd/sport-app-notification-data"]
  handle "/fd/sport-app-page", using: "SportData", platform: "Fabl", examples: ["/fd/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=9&platform=ios", "/fd/sport-app-page?page=https%3A%2F%2Fwww.bbc.co.uk%2Fsport&v=11&platform=ios&edition=domestic"]
  handle "/fd/topic-mapping", using: "SportData", platform: "Fabl", examples: ["/fd/topic-mapping?product=sport&followable=true&alias=false", "/fd/topic-mapping?product=sport&route=/sport&edition=domestic"]

  handle "/fd/:name", using: "FablData", platform: "Fabl", examples: [] do
    return_404 if: [
      !is_valid_length?(name, 3..40),
      !matches?(name, ~r/^[a-z0-9-]+$/)
    ]
  end

  handle "/wc-data/container/:name", using: "ContainerData", platform: "Webcore", examples: ["/wc-data/container/consent-banner"]
  handle "/wc-data/p/container/onward-journeys", using: "PersonalisedContainerData", platform: "Webcore", examples: []
  handle "/wc-data/p/container/simple-promo-collection", using: "PersonalisedContainerData", platform: "Webcore", examples: []
  handle "/wc-data/p/container/test-client-side-personalised", using: "PersonalisedContainerData", platform: "Webcore", only_on: "test", examples: []
  handle "/wc-data/p/container/:name", using: "ContainerData", platform: "Webcore", examples: ["/wc-data/p/container/consent-banner"]
  handle "/wc-data/page-composition", using: "PageComposition", platform: "Webcore", examples: ["/wc-data/page-composition?path=/search&params=%7B%7D"]

  # Search

  handle "/search", using: "Search", platform: "Webcore", examples: ["/search"]
  handle "/chwilio", using: "WelshSearch", platform: "Webcore", examples: ["/chwilio"]
  handle "/cbeebies/search", using: "Search", platform: "Webcore", examples: ["/cbeebies/search"]
  handle "/cbbc/search", using: "Search", platform: "Webcore", examples: ["/cbbc/search"]
  handle "/bitesize/search", using: "Search", platform: "Webcore", examples: ["/bitesize/search"]
  handle "/sounds/search", using: "Search", platform: "Webcore", examples: ["/sounds/search"]

  # News

  redirect "/news/articles", to: "/news", status: 302

  ## News - Mobile Redirect
  redirect "/news/mobile/*any", to: "/news", status: 301

  handle "/news", using: "NewsHomePage", platform: "MozartNews", examples: ["/news"]

  handle "/news/breaking-news/audience", using: "BreakingNews", platform: "MozartNews", examples: [] do
    return_404 if: true
  end

  handle "/news/breaking-news/audience/:audience", using: "BreakingNews", platform: "MozartNews", examples: ["/news/breaking-news/audience/domestic", "/news/breaking-news/audience/us", "/news/breaking-news/audience/international", "/news/breaking-news/audience/asia"] do
    return_404 if: [
      !String.match?(audience, ~r/^(domestic|us|international|asia)$/)
    ]
  end

  handle "/news/election/2023/:polity/results", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2023/england/results"]  do
    return_404 if: [
                 !String.match?(polity, ~r/^(england|northern-ireland)$/)
               ]
  end

  handle "/news/election/2023/:polity/councils", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2023/england/councils", "/news/election/2023/northern-ireland/councils"] do
    return_404 if: [
      !String.match?(polity, ~r/^(england|northern-ireland)$/)
    ]
  end

  handle "/news/election/2023/:polity/councils/:gss_id", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2023/england/councils/E09000016"] do
    return_404 if: [
      !String.match?(polity, ~r/^(england|northern-ireland)$/),
      !String.match?(gss_id, ~r/^[A-Z][0-9]{8}$/)
    ]
  end

  handle "/news/election/2022/us/results", using: "NewsElectionResults", platform: "Webcore", examples: ["/news/election/2022/us/results"]

  handle "/news/election/2022/us/states/:state_id", using: "NewsElectionResults", platform: "Webcore", examples: ["/news/election/2022/us/states/al"] do
    return_404 if: [
      !String.match?(state_id, ~r/^[a-z]{2}$/)
    ]
  end

  handle "/news/election/2022/usa/midterms-test", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2022/usa/midterms-test"]

  handle "/news/election/2021/:polity/results", using: "NewsElection2021", platform: "Webcore", examples: ["/news/election/2021/england/results", "/news/election/2021/scotland/results", "/news/election/2021/wales/results"] do
    return_404 if: [
                 !String.match?(polity, ~r/^(england|scotland|wales)$/)
               ]
  end

  handle "/news/election/2021/:polity/:division_name", using: "NewsElection2021", platform: "Webcore", examples: ["/news/election/2021/england/councils", "/news/election/2021/scotland/constituencies", "/news/election/2021/wales/constituencies"] do
    return_404 if: [
      !String.match?(polity, ~r/^(england|scotland|wales)$/),
      !String.match?(division_name, ~r/^(councils|constituencies)$/),
    ]
  end

  handle "/news/election/2021/england/:division_name/:division_id", using: "NewsElection2021", platform: "Webcore", examples: ["/news/election/2021/england/councils/E06000023"] do
    return_404 if: [
      !String.match?(division_name, ~r/^(councils|mayors)$/),
      !String.match?(division_id, ~r/^[E][0-9]{8}$/),
    ]
  end

  handle "/news/election/2021/:polity/:division_name/:division_id", using: "NewsElection2021", platform: "Webcore", examples: ["/news/election/2021/scotland/constituencies/S16000084", "/news/election/2021/scotland/regions/S17000014", "/news/election/2021/wales/constituencies/W09000001", "/news/election/2021/wales/regions/W10000006"] do
    return_404 if: [
      !String.match?(polity, ~r/^(scotland|wales)$/),
      !String.match?(division_name, ~r/^(regions|constituencies)$/),
      !String.match?(division_id, ~r/^[SW][0-9]{8}$/)
    ]
  end

  handle "/news/election/2017/northern-ireland/results", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2017/northern-ireland/results"]

  handle "/news/election/2022/:polity/results", using: "NewsElectionResults", platform: "Webcore", examples: ["/news/election/2022/england/results", "/news/election/2022/scotland/results", "/news/election/2022/wales/results", "/news/election/2022/northern-ireland/results"] do
    return_404 if: [
                 !String.match?(polity, ~r/^(england|scotland|wales|northern-ireland)$/)
               ]
  end

  handle "/news/election/2017/northern-ireland/constituencies", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2017/northern-ireland/constituencies"]

  handle "/news/election/2022/:polity/:division_name", using: "NewsElectionResults", platform: "Webcore", examples: ["/news/election/2022/northern-ireland/constituencies", "/news/election/2022/england/councils", "/news/election/2022/scotland/councils", "/news/election/2022/wales/councils"] do
    return_404 if: [
       !String.match?(polity, ~r/^(england|scotland|wales|northern-ireland)$/),
       !String.match?(division_name, ~r/^(constituencies|councils)$/)
    ]
  end

  handle "/news/election/2017/northern-ireland/constituencies/:division_id", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2017/northern-ireland/constituencies/N06000001"] do
    return_404 if: [
                 !String.match?(division_id, ~r/^[N][0-9]{8}$/)
               ]
  end

  handle "/news/election/2022/:polity/:division_name/:division_id", using: "NewsElectionResults", platform: "Webcore", examples: ["/news/election/2022/northern-ireland/constituencies/N06000001", "/news/election/2022/wales/councils/W06000001"] do

    return_404 if: [
                 !String.match?(polity, ~r/^(northern-ireland|england|wales|scotland)$/),
                 !String.match?(division_name, ~r/^(constituencies|councils|mayors)$/),
                 !String.match?(division_id, ~r/^[NSWE][0-9]{8}$/)
               ]
  end

  handle "/news/election/2019/uk/results", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2019/uk/results"]

  handle "/news/election/2019/uk/constituencies", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2019/uk/constituencies"]

  handle "/news/election/2019/uk/constituencies/:division_id", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2019/uk/constituencies/E92000001", "/news/election/2019/uk/constituencies/S83000001", "/news/election/2019/uk/constituencies/W76000005", "/news/election/2019/uk/constituencies/N12000001"] do
    return_404 if: [
      !String.match?(division_id, ~r/^[NSWE][0-9]{8}$/)
    ]
  end

  handle "/news/election/2019/uk/regions/:division_id", using: "NewsElectionResults", platform: "Webcore", only_on: "test", examples: ["/news/election/2019/uk/regions/E92000001", "/news/election/2019/uk/regions/W92000004", "/news/election/2019/uk/regions/S92000003", "/news/election/2019/uk/regions/N92000002"] do
    return_404 if: [
      !String.match?(division_id, ~r/^(E92000001|W92000004|S92000003|N92000002)$/)
    ]
  end

  handle "/news/election/2015", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2015"]
  handle "/news/election/2015/england", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2015/england"]
  handle "/news/election/2015/northern_ireland", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2015/northern_ireland"]
  handle "/news/election/2015/wales", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2015/wales"]
  handle "/news/election/2015/scotland", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2015/scotland"]
  handle "/news/election/2016", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2016"]
  handle "/news/election/2016/london", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2016/london"]
  handle "/news/election/2016/northern_ireland", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2016/northern_ireland"]
  handle "/news/election/2016/scotland", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2016/scotland"]
  handle "/news/election/2016/wales", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2016/wales"]
  handle "/news/election/2017", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/2017"]
  handle "/news/election/ni2017", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/ni2017"]
  handle "/news/election/us2016", using: "NewsWebcoreIndex", platform: "Webcore", examples: ["/news/election/us2016"]

  handle "/news/election/*any", using: "NewsElection", platform: "MozartNews", examples: ["/news/election/2019"]

  # News Live - Both Morph and WebCore Traffic
  handle "/news/live/:asset_id", using: "NewsLive", platform: "MozartNews", examples: ["/news/live/uk-55930940"] do
    # example "/news/live/c1v596ken6vt" is causing smoke tests to fail.
    return_404 if: [
      !String.match?(asset_id, ~r/^(([0-9]{5,9}|[a-z0-9\-_]+-[0-9]{5,9})|(c[a-z0-9]{10,}t))$/), # CPS & TIPO IDs
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-4][0-9]|50|[1-9])\z/), # TIPO - if has pageID validate it
    ]
  end

  # News Live - Morph Traffic with Page ID
  handle "/news/live/:asset_id/page/:page_number", using: "NewsLive", platform: "MozartNews", examples: ["/news/live/uk-55930940/page/2"] do
    return_404 if: [
      !String.match?(asset_id, ~r/^([0-9]{5,9}|[a-z0-9\-_]+-[0-9]{5,9})$/),
      !String.match?(page_number, ~r/\A[1-9][0-9]{0,2}\z/)
    ]
  end

  # News Live - .app route webcore traffic to platform discriminator
  handle "/news/live/:asset_id.app", using: "NewsLive", platform: "MozartNews", only_on: "test", examples: ["/news/live/c1v596ken6vt.app", "/news/live/c1v596ken6vt.app?page=1"] do
    return_404 if: [
      !String.match?(asset_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}t$/), # TIPO IDs
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-4][0-9]|50|[1-9])\z/), # TIPO - if has pageID validate it
    ]
  end

  # Local News
  handle "/news/localnews", using: "NewsLocalNews", platform: "MozartNews", examples: ["/news/localnews"]
  handle "/news/localnews/faqs", using: "NewsLocalNews", platform: "MozartNews", examples: ["/news/localnews/faqs"]
  handle "/news/localnews/locations", using: "NewsLocalNews", platform: "MozartNews", examples: ["/news/localnews/locations"]
  # this route goes to mozart and 500s on live, may be we should remove it?
  handle "/news/localnews/locations/sitemap.xml", using: "NewsLocalNews", platform: "MozartNews", examples: ["/news/localnews/locations/sitemap.xml"]
  handle "/news/localnews/:location_id_and_name/*_radius", using: "NewsLocalNewsRedirect", platform: "MozartNews", examples: [{"/news/localnews/2643743-london/0", 302}]

  # News Topics
  redirect "/news/topics/c1vw6q14rzqt/*any", to: "/news/world-60525350", status: 302
  redirect "/news/topics/crr7mlg0d21t/*any", to: "/news/world-60525350", status: 302
  redirect "/news/topics/cmj34zmwm1zt/*any", to: "/news/science-environment-56837908", status: 302
  redirect "/news/topics/cwlw3xz0lvvt/*any", to: "/news/politics/uk_leaves_the_eu", status: 302
  redirect "/news/topics/ck7edpjq0d5t/*any", to: "/news/topics/cvp28kxz49xt", status: 301
  redirect "/news/topics/cp7r8vgl2rgt/*any", to: "/news/reality_check", status: 302
  redirect "/news/topics/c779dqxlxv2t/*any", to: "/news/world-48623037", status: 302
  redirect "/news/topics/cg5rv39y9mmt/*any", to: "/news/business-38507481", status: 302
  redirect "/news/topics/c8nq32jw8mwt/*any", to: "/news/topics/czpqp1pq5q5t", status: 301
  redirect "/news/topics/cd39m6424jwt/*any", to: "/news/world/asia/china", status: 302
  redirect "/news/topics/cny6mpy4mj9t/*any", to: "/news/world/asia/india", status: 302
  redirect "/news/topics/czv6rjvdy9gt/*any", to: "/news/world/australia", status: 302
  redirect "/news/topics/cp7r8vgl24lt/*any", to: "/news/world-middle-east-48433977", status: 302
  redirect "/news/topics/c5m8rrkp46dt/*any", to: "/news/election/us2020", status: 302
  redirect "/news/topics/cyz0z8w0ydwt/*any", to: "/news/coronavirus", status: 302

  # News Correspondents
  redirect "/news/correspondents/allegrastratton", to: "/news/topics/cl16knzkz9yt", status: 301, ttl: 3600
  redirect "/news/correspondents/amolrajan", to: "/news/topics/cl16knz07e2t", status: 301, ttl: 3600
  redirect "/news/correspondents/andrewharding", to: "/news/topics/c8qx38n5jzlt", status: 301, ttl: 3600
  redirect "/news/correspondents/andrewneil", to: "/news/topics/c5yd7pzx95qt", status: 301, ttl: 3600
  redirect "/news/correspondents/andrewnorth", to: "/news/topics/c8qx38n5vy0t", status: 301, ttl: 3600
  redirect "/news/correspondents/anthonyzurcher", to: "/news/topics/cvrkv4x14jkt", status: 301, ttl: 3600
  redirect "/news/correspondents/arifansari", to: "/news/topics/cyzpjd57213t", status: 301, ttl: 3600
  redirect "/news/correspondents/betsanpowys", to: "/news/topics/cqypkzl5xvrt", status: 301, ttl: 3600
  redirect "/news/correspondents/branwenjeffreys", to: "/news/topics/c5yd7pzx3yyt", status: 301, ttl: 3600
  redirect "/news/correspondents/briantaylor", to: "/news/topics/c2e418dqpkkt", status: 301, ttl: 3600
  redirect "/news/correspondents/chriscook", to: "/news/topics/c5yd7pzxne0t", status: 301, ttl: 3600
  redirect "/news/correspondents/chrisjackson", to: "/news/topics/c63d8496d2nt", status: 301, ttl: 3600
  redirect "/news/correspondents/chrismason", to: "/news/topics/cddv4gjql21t", status: 301, ttl: 3600
  redirect "/news/correspondents/damiangrammaticas", to: "/news/topics/cr3pkx7v1d1t", status: 301, ttl: 3600
  redirect "/news/correspondents/dannyshaw", to: "/news/topics/cd61kenlzv7t", status: 301, ttl: 3600
  redirect "/news/correspondents/davidcornock", to: "/news/topics/c1l7jeydv1jt", status: 301, ttl: 3600
  redirect "/news/correspondents/davidgregorykumar", to: "/news/topics/c01e2673yydt", status: 301, ttl: 3600
  redirect "/news/correspondents/davidshukman", to: "/news/topics/c5yd7pzxek8t", status: 301, ttl: 3600
  redirect "/news/correspondents/deborahmcgurran", to: "/news/topics/c63d8496r06t", status: 301, ttl: 3600
  redirect "/news/correspondents/dominiccasciani", to: "/news/topics/cezlkpje5zkt", status: 301, ttl: 3600
  redirect "/news/correspondents/douglasfraser", to: "/news/topics/c63d8496ky9t", status: 301, ttl: 3600
  redirect "/news/correspondents/duncanweldon", to: "/news/topics/ckj6kvxqrppt", status: 301, ttl: 3600
  redirect "/news/correspondents/emilymaitlis", to: "/news/topics/cr3pkx7vy68t", status: 301, ttl: 3600
  redirect "/news/correspondents/faisalislam", to: "/news/topics/c909dyjvdk2t", status: 301, ttl: 3600
  redirect "/news/correspondents/ferguswalsh", to: "/news/topics/c8xk6e03epdt", status: 301, ttl: 3600
  redirect "/news/correspondents/gavinhewitt", to: "/news/topics/c5yd7pzxxrpt", status: 301, ttl: 3600
  redirect "/news/correspondents/gordoncorera", to: "/news/topics/cyzpjd57zpxt", status: 301, ttl: 3600
  redirect "/news/correspondents/helenthomas", to: "/news/topics/c48de9xr454t", status: 301, ttl: 3600
  redirect "/news/correspondents/hughpym", to: "/news/topics/cezlkpjenj7t", status: 301, ttl: 3600
  redirect "/news/correspondents/jamesgallagher", to: "/news/topics/ck899zee5x2t", status: 301, ttl: 3600
  redirect "/news/correspondents/jameslandale", to: "/news/topics/c63d84969y6t", status: 301, ttl: 3600
  redirect "/news/correspondents/jawadiqbal", to: "/news/topics/c1l7jeylnv1t", status: 301, ttl: 3600
  redirect "/news/correspondents/johnhess", to: "/news/topics/cvrkv4xr93pt", status: 301, ttl: 3600
  redirect "/news/correspondents/johnsimpson", to: "/news/topics/cj26k502xxzt", status: 301, ttl: 3600
  redirect "/news/correspondents/jondonnison", to: "/news/topics/c48de9x8yrpt", status: 301, ttl: 3600
  redirect "/news/correspondents/jonsopel", to: "/news/topics/cl16knz1d2lt", status: 301, ttl: 3600
  redirect "/news/correspondents/jonathanamos", to: "/news/topics/cj26k502561t", status: 301, ttl: 3600
  redirect "/news/correspondents/jonathanmarcus", to: "/news/topics/cne6kq5e00pt", status: 301, ttl: 3600
  redirect "/news/correspondents/jonnydymond", to: "/news/topics/cezlkpjzdjzt", status: 301, ttl: 3600
  redirect "/news/correspondents/justinrowlatt", to: "/news/topics/cn5e8npr2l3t", status: 301, ttl: 3600
  redirect "/news/correspondents/kamalahmed", to: "/news/topics/czpd19nplk7t", status: 301, ttl: 3600
  redirect "/news/correspondents/karishmavaswani", to: "/news/topics/c8qx38nq177t", status: 301, ttl: 3600
  redirect "/news/correspondents/kattykay", to: "/news/topics/c8qx38nqx4qt", status: 301, ttl: 3600
  redirect "/news/correspondents/katyaadler", to: "/news/topics/cne6kq5evr5t", status: 301, ttl: 3600
  redirect "/news/correspondents/laurakuenssberg", to: "/news/topics/cvrkv4xr81qt", status: 301, ttl: 3600
  redirect "/news/correspondents/lysedoucet", to: "/news/topics/c2e418d0zxqt", status: 301, ttl: 3600
  redirect "/news/correspondents/markdarcy", to: "/news/topics/cezlkpjzx2jt", status: 301, ttl: 3600
  redirect "/news/correspondents/markdevenport", to: "/news/topics/c7d9y05d1lnt", status: 301, ttl: 3600
  redirect "/news/correspondents/markeaston", to: "/news/topics/c63d84937ejt", status: 301, ttl: 3600
  redirect "/news/correspondents/markmardell", to: "/news/topics/c37dl8076jxt", status: 301, ttl: 3600
  redirect "/news/correspondents/martinrosenbaum", to: "/news/topics/cx6p27961e1t", status: 301, ttl: 3600
  redirect "/news/correspondents/markurban", to: "/news/topics/c1l7jeylzr3t", status: 301, ttl: 3600
  redirect "/news/correspondents/martynoates", to: "/news/topics/c5yd7pzy8d8t", status: 301, ttl: 3600
  redirect "/news/correspondents/mattmcgrath", to: "/news/topics/cyzpjd5z4d3t", status: 301, ttl: 3600
  redirect "/news/correspondents/michaelcrick", to: "/news/topics/c7d9y05dy70t", status: 301, ttl: 3600
  redirect "/news/correspondents/nicholaswatt", to: "/news/topics/cr3pkx73kv3t", status: 301, ttl: 3600
  redirect "/news/correspondents/nickbryant", to: "/news/topics/c63d84936vyt", status: 301, ttl: 3600
  redirect "/news/correspondents/nickrobinson", to: "/news/topics/cvrkv4xrr7kt", status: 301, ttl: 3600
  redirect "/news/correspondents/nickservini", to: "/news/topics/c909dyj052rt", status: 301, ttl: 3600
  redirect "/news/correspondents/nicktriggle", to: "/news/topics/cne6kq5e5r0t", status: 301, ttl: 3600
  redirect "/news/correspondents/nikkifox", to: "/news/topics/cmwjjp141ydt", status: 301, ttl: 3600
  redirect "/news/correspondents/patrickburns", to: "/news/topics/cj26k50er7xt", status: 301, ttl: 3600
  redirect "/news/correspondents/paulbarltrop", to: "/news/topics/cp86kdjq015t", status: 301, ttl: 3600
  redirect "/news/correspondents/peterhenley", to: "/news/topics/cezlkpjn4v7t", status: 301, ttl: 3600
  redirect "/news/correspondents/peterhunt", to: "/news/topics/c01e267d41jt", status: 301, ttl: 3600
  redirect "/news/correspondents/philcoomes", to: "/news/topics/cne6kq53z8dt", status: 301, ttl: 3600
  redirect "/news/correspondents/richardmoss", to: "/news/topics/c909dyj5y94t", status: 301, ttl: 3600
  redirect "/news/correspondents/robertpeston", to: "/news/topics/cne6kq5300nt", status: 301, ttl: 3600
  redirect "/news/correspondents/rorycellanjones", to: "/news/topics/c01e267dpvrt", status: 301, ttl: 3600
  redirect "/news/correspondents/sarahsmith", to: "/news/topics/cezlkpjn5x5t", status: 301, ttl: 3600
  redirect "/news/correspondents/seancoughlan", to: "/news/topics/cx6p2795jvqt", status: 301, ttl: 3600
  redirect "/news/correspondents/simonjack", to: "/news/topics/cl16knz857vt", status: 301, ttl: 3600
  redirect "/news/correspondents/soutikbiswas", to: "/news/topics/c8qx38n91kkt", status: 301, ttl: 3600
  redirect "/news/correspondents/timiredale", to: "/news/topics/cp86kdjq6p0t", status: 301, ttl: 3600
  redirect "/news/correspondents/tomedwards", to: "/news/topics/ckj6kvx762pt", status: 301, ttl: 3600
  redirect "/news/correspondents/tomfeilden", to: "/news/topics/c8qx38n9el2t", status: 301, ttl: 3600
  redirect "/news/correspondents/tonyroe", to: "/news/topics/cj26k50e9pet", status: 301, ttl: 3600
  redirect "/news/correspondents/vaughanroderick", to: "/news/topics/ckj6kvx7pdyt", status: 301, ttl: 3600
  redirect "/news/correspondents/willgompertz", to: "/news/topics/cvrkv4xp7ret", status: 301, ttl: 3600
  redirect "/news/correspondents/wyredavies", to: "/news/topics/cqypkzl0n79t", status: 301, ttl: 3600

  # News Blogs
  redirect "/news/blogs/trending", to: "/news/topics/cme72mv58q4t", status: 301, ttl: 3600
  redirect "/news/blogs/the_papers", to: "/news/topics/cpml2v678pxt", status: 301, ttl: 3600

  handle "/news/topics/:id/:slug", using: "NewsTopics", platform: "Webcore", examples: ["/news/topics/cwjzj55q2p3t/gold", {"/news/topics/23ef11cb-a0eb-4cee-824a-098c6782ad4e/gold", 301}] do
    return_404 if: [
      !(is_tipo_id?(id) or is_guid?(id)),
      !String.match?(slug, ~r/^([a-z0-9-]+)$/),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50)
    ]
  end

  handle "/news/topics/:id", using: "NewsTopics", platform: "Webcore", examples: ["/news/topics/cljev4jz3pjt", {"/news/topics/23ef11cb-a0eb-4cee-824a-098c6782ad4e", 301}] do
    return_404 if: [
      !(is_tipo_id?(id) or is_guid?(id)),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50)
    ]
  end

  redirect "/news/amp/:id", to: "/news/:id.amp", status: 301
  redirect "/news/amp/:topic/:id", to: "/news/:topic/:id.amp", status: 301

  handle "/news/av/:asset_id/embed", using: "NewsVideosEmbed", platform: "MozartNews", examples: [{"/news/av/world-us-canada-50294316/embed", 302}]
  handle "/news/av/:asset_id/:slug/embed", using: "NewsVideosEmbed", platform: "MozartNews", examples: [{"/news/av/business-49843970/i-built-my-software-empire-from-a-stoke-council-house/embed", 302}]
  handle "/news/av/embed/:vpid/:asset_id", using: "NewsVideosEmbed", platform: "MozartNews", examples: [{"/news/av/embed/p07pd78q/49843970", 302}]
  handle "/news/:asset_id/embed", using: "NewsVideosEmbed", platform: "MozartNews", examples: [{"/news/health-54088206/embed", 302}, {"/news/uk-politics-54003483/embed?amp=1", 302}]
  handle "/news/:asset_id/embed/:pid", using: "NewsVideosEmbed", platform: "MozartNews", examples: [{"/news/health-54088206/embed/p08m8yx4", 302}, {"/news/health-54088206/embed/p08m8yx4?amp=1", 302}]

  redirect "/news/av/:asset_id/:slug", to: "/news/av/:asset_id", status: 302

  handle "/news/av/:id", using: "NewsVideos", platform: "Webcore", examples: ["/news/av/48404351", "/news/av/uk-51729702", "/news/av/uk-england-hampshire-50266218", "/news/av/entertainment+arts-10646650"] do
      return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/news/video_and_audio/:index/:id/:slug", using: "NewsVideoAndAudio", platform: "Webcore", examples: [{"/news/video_and_audio/must_see/54327412/scientists-create-a-microscopic-robot-that-walks", 301}] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/news/video_and_audio/*any", using: "NewsVideoAndAudio", platform: "Webcore", examples: [] do
    return_404 if: true
  end

  redirect "/news/videos", to: "/news", status: 301

  handle "/news/videos/:optimo_id", using: "NewsVideos", platform: "Webcore", examples: [] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  # Trial news assets setup for initial MVT test experiment
  handle "/news/articles/cn3zl2drk0ko", using: "NewsArticleMvt", platform: "Webcore", examples: ["/news/articles/cn3zl2drk0ko"]
  handle "/news/articles/cyxjrk98x59o", using: "NewsArticleMvt", platform: "Webcore", examples: ["/news/articles/cyxjrk98x59o"]
  handle "/news/articles/ce5108j80gpo", using: "NewsArticleMvt", platform: "Webcore", examples: ["/news/articles/ce5108j80gpo"]
  handle "/news/articles/ce4xrgggdvgo", using: "NewsArticleMvt", platform: "Webcore", examples: ["/news/articles/ce4xrgggdvgo"]

  handle "/news/articles/:optimo_id.amp", using: "NewsAmp", platform: "MozartSimorgh", examples: []
  handle "/news/articles/:optimo_id.json", using: "NewsAmp", platform: "MozartSimorgh", examples: []

  handle "/news/articles/:optimo_id", using: "NewsStorytellingPage", platform: "Webcore", examples: ["/news/articles/c5ll353v7y9o", "/news/articles/c8xxl4l3dzeo"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  # News indexes
  handle "/news/access-to-news", using: "NewsIndex", platform: "MozartNews", examples: ["/news/access-to-news"]
  handle "/news/business", using: "NewsIndex", platform: "MozartNews", examples: ["/news/business"]
  handle "/news/components", using: "NewsComponents", platform: "MozartNews", examples: []
  handle "/news/coronavirus", using: "NewsIndex", platform: "MozartNews", examples: ["/news/coronavirus"]
  handle "/news/disability", using: "NewsIndex", platform: "MozartNews", examples: ["/news/disability"]
  handle "/news/education", using: "NewsIndex", platform: "MozartNews", examples: ["/news/education"]
  handle "/news/england", using: "NewsIndex", platform: "MozartNews", examples: ["/news/england"]
  handle "/news/entertainment_and_arts", using: "NewsIndex", platform: "MozartNews", examples: ["/news/entertainment_and_arts"]
  handle "/news/explainers", using: "NewsIndex", platform: "MozartNews", examples: ["/news/explainers"]
  handle "/news/front_page", using: "NewsIndex", platform: "MozartNews", examples: ["/news/front_page"]
  handle "/news/front-page-service-worker.js", using: "NewsIndex", platform: "MozartNews", examples: ["/news/front-page-service-worker.js"]
  handle "/news/have_your_say", using: "NewsIndex", platform: "MozartNews", examples: ["/news/have_your_say"]
  handle "/news/health", using: "NewsIndex", platform: "MozartNews", examples: ["/news/health"]
  handle "/news/in_pictures", using: "NewsIndex", platform: "MozartNews", examples: ["/news/in_pictures"]
  handle "/news/newsbeat", using: "NewsIndex", platform: "MozartNews", examples: ["/news/newsbeat"]
  handle "/news/northern_ireland", using: "NewsIndex", platform: "MozartNews", examples: ["/news/northern_ireland"]
  handle "/news/paradisepapers", using: "NewsIndex", platform: "MozartNews", examples: ["/news/paradisepapers"]
  handle "/news/politics", using: "NewsIndex", platform: "MozartNews", examples: ["/news/politics"]
  handle "/news/reality_check", using: "NewsIndex", platform: "MozartNews", examples: ["/news/reality_check"]
  handle "/news/science_and_environment", using: "NewsIndex", platform: "MozartNews", examples: ["/news/science_and_environment"]
  handle "/news/scotland", using: "NewsIndex", platform: "MozartNews", examples: ["/news/scotland"]
  handle "/news/stories", using: "NewsIndex", platform: "MozartNews", examples: ["/news/stories"]
  handle "/news/technology", using: "NewsIndex", platform: "MozartNews", examples: ["/news/technology"]
  handle "/news/the_reporters", using: "NewsIndex", platform: "MozartNews", examples: ["/news/the_reporters"]
  handle "/news/uk", using: "NewsIndex", platform: "MozartNews", examples: ["/news/uk"]
  handle "/news/wales", using: "NewsIndex", platform: "MozartNews", examples: ["/news/wales"]
  handle "/news/world", using: "NewsIndex", platform: "MozartNews", examples: ["/news/world"]
  handle "/news/world_radio_and_tv", using: "NewsIndex", platform: "MozartNews", examples: ["/news/world_radio_and_tv"]

  # News feature indexes (FIX assets)

  redirect "/news/business-22449886", to: "/news/topics/cem601g08pkt", status: 301
  redirect "/news/business-41188875", to: "/news/topics/cx6npx2zrk3t", status: 301
  redirect "/news/business-46985441", to: "/news/topics/cyq54q01grmt", status: 301
  redirect "/news/business-22434141", to: "/news/topics/czpqp1pq5q5t", status: 301
  redirect "/news/business-46985442", to: "/news/topics/cgdwpywgeegt", status: 301
  redirect "/news/uk-northern-ireland-55401938", to: "/news/topics/cxlvkzzjq1wt", status: 301
  redirect "/news/business-12686570", to: "/news/topics/c89l21e4068t", status: 301
  redirect "/news/uk-northern-ireland-38323577", to: "/news/topics/c77jz3mdmgzt", status: 301
  redirect "/news/world-43160365", to: "/news/topics/czpqp1q456vt", status: 301
  redirect "/news/business-40863265", to: "/news/topics/cxn4z4nmzelt", status: 301
  redirect "/news/technology-22774341", to: "/news/topics/c008ql15vdxt", status: 301
  redirect "/news/uk-55220521", to: "/news/topics/c8nq32jwn4rt", status: 301
  redirect "/news/uk-56837907", to: "/news/topics/cq23pdgvr7rt", status: 301
  redirect "/news/uk-politics-48448557", to: "/news/topics/cvp28kxz49xt", status: 301
  redirect "/news/uk-20782891", to: "/news/topics/c8m8v3p0yygt", status: 301

  handle "/news/business-11428889", using: "NewsBusiness", platform: "MozartNews", examples: ["/news/business-11428889"]
  handle "/news/business-15521824", using: "NewsBusiness", platform: "MozartNews", examples: ["/news/business-15521824"]
  handle "/news/business-33712313", using: "NewsBusiness", platform: "MozartNews", examples: ["/news/business-33712313"]
  handle "/news/business-38507481", using: "NewsBusiness", platform: "MozartNews", examples: ["/news/business-38507481"]
  handle "/news/business-45489065", using: "NewsBusiness", platform: "MozartNews", examples: ["/news/business-45489065"]
  handle "/news/education-46131593", using: "NewsEducation", platform: "MozartNews", examples: ["/news/education-46131593"]
  handle "/news/uk-england-47486169", using: "NewsUk", platform: "MozartNews", examples: ["/news/uk-england-47486169"]
  handle "/news/science-environment-56837908", using: "NewsScienceAndTechnology", platform: "MozartNews", examples: ["/news/science-environment-56837908"]
  handle "/news/world-48623037", using: "NewsWorld", platform: "MozartNews", examples: ["/news/world-48623037"]
  handle "/news/world-middle-east-48433977", using: "NewsWorld", platform: "MozartNews", examples: ["/news/world-middle-east-48433977"]
  handle "/news/world-us-canada-15949569", using: "NewsWorld", platform: "MozartNews", examples: ["/news/world-us-canada-15949569"]

  # News archive assets
  handle "/news/10284448/ticker.sjson", using: "NewsArchive", platform: "MozartNews", examples: ["/news/10284448/ticker.sjson"]
  handle "/news/1/*any", using: "NewsArchive", platform: "MozartNews", examples: ["/news/1/shared/spl/hi/uk_politics/03/the_cabinet/html/chancellor_exchequer.stm"]
  handle "/news/2/*any", using: "NewsArchive", platform: "MozartNews", examples: ["/news/2/text_only.stm"]
  handle "/news/sport1/*any", using: "NewsArchive", platform: "MozartNews", examples: ["/news/sport1/hi/football/teams/n/newcastle_united/4405841.stm"]
  handle "/news/bigscreen/*any", using: "NewsArchive", platform: "MozartNews", examples: ["/news/bigscreen/top_stories/iptvfeed.sjson"]

  # News RSS feeds
  handle "/news/rss.xml", using: "NewsRss", platform: "Karanga", examples: ["/news/rss.xml"]
  handle "/news/:id/rss.xml", using: "NewsRss", platform: "Karanga", examples: ["/news/uk/rss.xml"]

  handle "/news/topics/:id/rss.xml", using: "NewsTopicRss", platform: "Fabl", examples: ["/news/topics/cgmxjppkwl7t/rss.xml"] do
    return_404 if: !is_tipo_id?(id)
  end

  # News section matchers
  handle "/news/ampstories/*any", using: "News", platform: "MozartNews", examples: []
  handle "/news/av-embeds/*any", using: "News", platform: "MozartNews", examples: ["/news/av-embeds/58869966/vpid/p07r2y68"]
  handle "/news/business/*any", using: "NewsBusiness", platform: "MozartNews", examples: ["/news/business/companies"]
  handle "/news/england/*any", using: "NewsUk", platform: "MozartNews", examples: ["/news/england/regions"]
  handle "/news/extra/*any", using: "News", platform: "MozartNews", examples: ["/news/extra/3O3eptdEYR/after-the-wall-fell"]
  handle "/news/events/*any", using: "NewsUk", platform: "MozartNews", examples: ["/news/events/scotland-decides/results"]
  handle "/news/iptv/*any", using: "News", platform: "MozartNews", examples: ["/news/iptv/scotland/iptvfeed.sjson"]
  handle "/news/local_news_slice/*any", using: "NewsUk", platform: "MozartNews", examples: ["/news/local_news_slice/%252Fnews%252Fengland%252Flondon"]
  handle "/news/northern_ireland/*any", using: "NewsUk", platform: "MozartNews", examples: ["/news/northern_ireland/northern_ireland_politics"]
  handle "/news/politics/*any", using: "NewsUk", platform: "MozartNews", examples: ["/news/politics/eu_referendum/results"]
  handle "/news/resources/*any", using: "News", platform: "MozartNews", examples: ["/news/resources/idt-d6338d9f-8789-4bc2-b6d7-3691c0e7d138"]
  handle "/news/rss/*any", using: "NewsRssSection", platform: "MozartNews", examples: ["/news/rss/newsonline_uk_edition/front_page/rss.xml"]
  handle "/news/science-environment/*any", using: "NewsScienceAndTechnology", platform: "MozartNews", examples: ["/news/science-environment/18552512"]
  handle "/news/scotland/*any", using: "NewsUk", platform: "MozartNews", examples: ["/news/scotland/glasgow_and_west"]
  handle "/news/slides/*any", using: "News", platform: "MozartNews", examples: []
  handle "/news/special/*any", using: "News", platform: "MozartNews", examples: ["/news/special/2015/newsspec_10857/bbc_news_logo.png"]
  handle "/news/technology/*any", using: "NewsScienceAndTechnology", platform: "MozartNews", examples: ["/news/technology/31153361"]
  handle "/news/wales/*any", using: "NewsUk", platform: "MozartNews", examples: ["/news/wales/south_east_wales"]
  handle "/news/world/*any", using: "NewsWorld", platform: "MozartNews", examples: ["/news/world/europe"]
  handle "/news/world_radio_and_tv/*any", using: "NewsWorld", platform: "MozartNews", examples: []

  # 404 matchers
  handle "/news/favicon.ico", using: "News", platform: "MozartNews", examples: [] do
    return_404 if: true
  end

  handle "/news/av/favicon.ico", using: "News", platform: "MozartNews", examples: [] do
    return_404 if: true
  end

  handle "/news/:id.amp", using: "NewsAmp", platform: "MozartSimorgh", examples: ["/news/business-58847275.amp"]
  handle "/news/:id.json", using: "NewsAmp", platform: "MozartSimorgh", examples: ["/news/business-58847275.json"]

  handle "/news/:id", using: "NewsArticlePage", platform: "Webcore", examples: ["/news/uk-politics-49336144", "/news/world-asia-china-51787936", "/news/technology-51960865", "/news/uk-england-derbyshire-18291916", "/news/entertainment+arts-10636043"]

  # TODO issue with routes such as /news/education-46131593 being matched to the /news/:id matcher
  handle "/news/*any", using: "News", platform: "MozartNews", examples: [{"/news/contact-us/editorial", 302}]

  # Cymrufyw

  redirect "/newyddion/*any", to: "/cymrufyw/*any", status: 302
  redirect "/democratiaethfyw", to: "/cymrufyw/gwleidyddiaeth", status: 302
  redirect "/cymrufyw/amp/:id", to: "/cymrufyw/:id.amp", status: 301
  redirect "/cymrufyw/amp/:topic/:id", to: "/cymrufyw/:topic/:id.amp", status: 301

  redirect "/cymrufyw/correspondents/vaughanroderick", to: "/news/topics/ckj6kvx7pdyt", status: 302

  handle "/cymrufyw/cylchgrawn", using: "Cymrufyw", platform: "MozartNews", examples: ["/cymrufyw/cylchgrawn"]

  handle "/cymrufyw/etholiad/:year/cymru/canlyniadau", using: "CymrufywEtholiadCanlyniadau", platform: "Webcore", examples: ["/cymrufyw/etholiad/2022/cymru/canlyniadau", "/cymrufyw/etholiad/2021/cymru/canlyniadau"] do
    return_404 if: [
      !String.match?(year, ~r/^(2021|2022)$/)
    ]
  end

  handle "/cymrufyw/etholiad/2021/cymru/etholaethau", using: "CymrufywEtholiad2021", platform: "Webcore", examples: ["/cymrufyw/etholiad/2021/cymru/etholaethau"]

  handle "/cymrufyw/etholiad/2021/cymru/:division_name/:division_id", using: "CymrufywEtholiad2021", platform: "Webcore", examples: ["/cymrufyw/etholiad/2021/cymru/etholaethau/W09000001", "/cymrufyw/etholiad/2021/cymru/rhanbarthau/W10000006"] do
    return_404 if: [
      !String.match?(division_name, ~r/^(rhanbarthau|etholaethau)$/),
      !String.match?(division_id, ~r/^W[0-9]{8}$/)
    ]
  end

  handle "/cymrufyw/etholiad/2022/cymru/cynghorau", using: "CymrufywEtholiadCanlyniadau", platform: "Webcore", examples: ["/cymrufyw/etholiad/2022/cymru/cynghorau"]

  handle "/cymrufyw/etholiad/2022/cymru/cynghorau/:division_id", using: "CymrufywEtholiadCanlyniadau", platform: "Webcore", examples: [] do
    return_404 if: [
                 !String.match?(division_id, ~r/^[W][0-9]{8}$/)
               ]
  end

  handle "/cymrufyw/etholiad/2019/du/etholaethau/:division_id", using: "CymrufywEtholiadCanlyniadau", platform: "Webcore", only_on: "test", examples: ["/cymrufyw/etholiad/2019/du/etholaethau/W09000001"] do
    return_404 if: [
      !String.match?(division_id, ~r/^W[0-9]{8}$/)
    ]
  end

  handle "/cymrufyw/etholiad/2019/du/rhanbarthau/W92000004", using: "CymrufywEtholiadCanlyniadau", platform: "Webcore", only_on: "test", examples: ["/cymrufyw/etholiad/2019/du/rhanbarthau/W92000004"]

  handle "/cymrufyw/gwleidyddiaeth", using: "Cymrufyw", platform: "MozartNews", examples: ["/cymrufyw/gwleidyddiaeth"]
  handle "/cymrufyw/gogledd-orllewin", using: "Cymrufyw", platform: "MozartNews", examples: ["/cymrufyw/gogledd-orllewin"]
  handle "/cymrufyw/gogledd-ddwyrain", using: "Cymrufyw", platform: "MozartNews", examples: ["/cymrufyw/gogledd-ddwyrain"]
  handle "/cymrufyw/canolbarth", using: "Cymrufyw", platform: "MozartNews", examples: ["/cymrufyw/canolbarth"]
  handle "/cymrufyw/de-orllewin", using: "Cymrufyw", platform: "MozartNews", examples: ["/cymrufyw/de-orllewin"]
  handle "/cymrufyw/de-ddwyrain", using: "Cymrufyw", platform: "MozartNews", examples: ["/cymrufyw/de-ddwyrain"]
  handle "/cymrufyw/eisteddfod", using: "Cymrufyw", platform: "MozartNews", examples: ["/cymrufyw/eisteddfod"]
  handle "/cymrufyw/components", using: "Cymrufyw", platform: "MozartNews", examples: []
  handle "/cymrufyw/hafan", using: "Cymrufyw", platform: "MozartNews", examples: [{"/cymrufyw/hafan", 301}]

  redirect "/cymrufyw/fideo", to: "/cymrufyw", status: 301

  handle "/cymrufyw/:id", using: "CymrufywArticlePage", platform: "Webcore", examples: ["/cymrufyw/52998018", "/cymrufyw/52995676", "/cymrufyw/etholiad-2017-39407507"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  handle "/cymrufyw/saf/:id", using: "CymrufywVideos", platform: "Webcore", examples: ["/cymrufyw/saf/53073086"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/cymrufyw/fideo/:optimo_id", using: "CymrufywVideos", platform: "Webcore", examples: [] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/cymrufyw/erthyglau/:optimo_id", using: "CymrufywStorytellingPage", platform: "Webcore", only_on: "test", examples: [] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/cymrufyw/*any", using: "Cymrufyw", platform: "MozartNews", examples: ["/cymrufyw"]

  # Naidheachdan

  handle "/naidheachdan", using: "NaidheachdanHomePage", platform: "MozartNews", examples: ["/naidheachdan"]
  handle "/naidheachdan/dachaigh", using: "Naidheachdan", platform: "MozartNews", examples: [{"/naidheachdan/dachaigh", 301}]
  handle "/naidheachdan/components", using: "Naidheachdan", platform: "MozartNews", examples: []
  redirect "/naidheachdan/amp/:id", to: "/naidheachdan/:id.amp", status: 301
  redirect "/naidheachdan/amp/:topic/:id", to: "/naidheachdan/:topic/:id.amp", status: 301

  redirect "/naidheachdan/bhidio", to: "/naidheachdan", status: 301

  handle "/naidheachdan/:id", using: "NaidheachdanArticlePage", platform: "Webcore", examples: ["/naidheachdan/52992845", "/naidheachdan/52990788", "/naidheachdan/52991029"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  handle "/naidheachdan/sgeulachdan/:optimo_id", using: "NaidheachdanStorytellingPage", platform: "Webcore", only_on: "test", examples: [] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/naidheachdan/fbh/:id", using: "NaidheachdanVideos", platform: "Webcore", examples: ["/naidheachdan/fbh/53159144"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/naidheachdan/bhidio/:optimo_id", using: "NaidheachdanVideos", platform: "Webcore", examples: [] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/naidheachdan/*any", using: "Naidheachdan", platform: "MozartNews", examples: []

  handle "/pres-test/personalisation", using: "PresTestPersonalised", platform: "Webcore", only_on: "test", examples: ["/pres-test/personalisation"]
  handle "/pres-test/personalisation/*any", using: "PresTestPersonalised", platform: "Webcore", only_on: "test", examples: ["/pres-test/personalisation/follow-suggestions"]
  handle "/pres-test/*any", using: "PresTest", platform: "Webcore", only_on: "test", examples: ["/pres-test/greeting-loader"]

  handle "/devx-test/personalisation", using: "DevXPersonalisation", platform: "Webcore", only_on: "test", examples: ["/devx-test/personalisation"]

  # Container API
  handle "/container/envelope/editorial-text/*any", using: "ContainerEnvelopeEditorialText", platform: "Webcore", examples: ["/container/envelope/editorial-text/heading/Belfrage%20Test/headingLevel/2", "/container/envelope/editorial-text/heading/Belfrage%20Test/headingLevel/2?static=true&mode=testData"]
  handle "/container/envelope/election-banner/*any", using: "ContainerEnvelopeElectionBanner", platform: "Webcore", examples: ["/container/envelope/election-banner/logoOnly/true", "/container/envelope/election-banner/assetUri/%2Fnews/hasFetcher/true?static=true&mode=testData"]
  handle "/container/envelope/error/*any", using: "ContainerEnvelopeError", platform: "Webcore", examples: ["/container/envelope/error/brandPalette/weatherLightV2/fontPalette/sansSimple/linkText/BBC%20Weather/linkUrl/%2Fweather/status/500?static=true"]
  handle "/container/envelope/navigation-links/*any", using: "ContainerEnvelopeNavigationLinks", platform: "Webcore", examples: ["/container/envelope/navigation-links/brandPalette/weatherLightV2/corePalette/lightV2/country/gb/fontPalette/sansSimple/hasFetcher/true/language/en/service/weather?static=true"]
  handle "/container/envelope/page-link/*any", using: "ContainerEnvelopePageLink", platform: "Webcore", examples: ["/container/envelope/page-link/linkHref/%23belfrage/linkLabel/Belfrage%20Test"]
  handle "/container/envelope/scoreboard/*any", using: "ContainerEnvelopeScoreboard", platform: "Webcore", examples: ["/container/envelope/scoreboard/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true", "/container/envelope/scoreboard/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true?static=true&mode=testData"]
  handle "/container/envelope/simple-promo-collection/*any", using: "ContainerEnvelopeSimplePromoCollection", platform: "Webcore", examples: ["/container/envelope/simple-promo-collection/brandPalette/weatherLightV2/corePalette/lightV2/enablePromoDescriptions/true/fontPalette/sansSimple/hasFetcher/true/home/weather/isUk/true/title/Features/urn/urn:bbc:cps:curie:asset:b5c5324a-aa36-e059-e040-850a02846523/withContainedPromos/false?static=true"]
  handle "/container/envelope/turnout/*any", using: "ContainerEnvelopeTurnout", platform: "Webcore", examples: ["/container/envelope/turnout/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true", "/container/envelope/turnout/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true?static=true&mode=testData"]
  handle "/container/envelope/winner-flash/*any", using: "ContainerEnvelopeWinnerFlash", platform: "Webcore", examples: ["/container/envelope/winner-flash/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true", "/container/envelope/winner-flash/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true?static=true&mode=testData"]
  handle "/container/envelope/test-:name/*any", using: "ContainerEnvelopeTestContainers", platform: "Webcore", only_on: "test", examples: ["/container/envelope/test-message/message/hello"]
  handle "/container/envelope/*any", using: "ContainerEnvelope", platform: "Webcore", examples: ["/container/envelope/global-footer/hasFetcher/true"]

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
  redirect "/arabic/middleeast/2013/11/131114_shia_ashura_rituals", to: "/arabic/middleeast-62442578", status: 301
  redirect "/persian/institutional-43952617", to: "/persian/access-to-news", status: 301
  redirect "/persian/institutional/2011/04/000001_bbcpersian_proxy", to: "/persian/access-to-news", status: 301
  redirect "/persian/institutional/2011/04/000001_feeds", to: "/persian/articles/c849y3lk2yko", status: 301
  redirect "/serbian/cyr/extra/ebxujaequt/rat-silovanje-bosna", to: "/serbian/lat/extra/ebxujaequt/rat-silovanje-bosna", status: 301

  ## World Service - Topic Redirects
  redirect "/japanese/video-55128146", to: "/japanese/topics/c132079wln0t", status: 301
  redirect "/pidgin/sport", to: "/pidgin/topics/cjgn7gv77vrt", status: 301

  # World Service - Indian Sports Woman of The Year
  redirect "/gujarati/iswoty", to: "/gujarati/resources/idt-c01e87cf-898c-4ec6-86ea-5ef77f9e58a0", status: 302
  redirect "/hindi/iswoty", to: "/hindi/resources/idt-c01e87cf-898c-4ec6-86ea-5ef77f9e58a0", status: 302
  redirect "/marathi/iswoty", to: "/marathi/resources/idt-c01e87cf-898c-4ec6-86ea-5ef77f9e58a0", status: 302
  redirect "/punjabi/iswoty", to: "/punjabi/resources/idt-c01e87cf-898c-4ec6-86ea-5ef77f9e58a0", status: 302
  redirect "/tamil/iswoty", to: "/tamil/resources/idt-c01e87cf-898c-4ec6-86ea-5ef77f9e58a0", status: 302
  redirect "/telugu/iswoty", to: "/telugu/resources/idt-c01e87cf-898c-4ec6-86ea-5ef77f9e58a0", status: 302

  ## World Service - Simorgh and ARES
  ##    Kaleidoscope Redirects: /<service>/mobile/image/*any
  ##    Mobile Redirects: /<service>/mobile/*any
  handle "/afaanoromoo.amp", using: "WorldServiceAfaanoromoo", platform: "MozartSimorgh", examples: ["/afaanoromoo.amp"]
  handle "/afaanoromoo.json", using: "WorldServiceAfaanoromoo", platform: "MozartSimorgh", examples: ["/afaanoromoo.json"]
  handle "/afaanoromoo/manifest.json", using: "WorldServiceAfaanoromooAssets", platform: "Simorgh", examples: ["/afaanoromoo/manifest.json"]
  handle "/afaanoromoo/sw.js", using: "WorldServiceAfaanoromooAssets", platform: "Simorgh", examples: ["/afaanoromoo/sw.js"]
  handle "/afaanoromoo/rss.xml", using: "WorldServiceAfaanoromooHomePageRss", platform: "Karanga", examples: ["/afaanoromoo/rss.xml"]

  handle "/afaanoromoo/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/afaanoromoo/topics/c7zp5z9n3x5t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/afaanoromoo/topics/:id", using: "WorldServiceAfaanoromooTopicPage", platform: "Simorgh", examples: ["/afaanoromoo/topics/c7zp5z9n3x5t"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/afaanoromoo/topics/:id/rss.xml", using: "WorldServiceAfaanoromooTopicRss", platform: "Fabl", examples: ["/afaanoromoo/topics/c7zp5z9n3x5t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)$/)
  end

  handle "/afaanoromoo/articles/:id", using: "WorldServiceAfaanoromooArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/afaanoromoo/articles/:id.amp", using: "WorldServiceAfaanoromooArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/afaanoromoo/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/afaanoromoo/send/u39697902"]
  handle "/afaanoromoo/*any", using: "WorldServiceAfaanoromoo", platform: "MozartSimorgh", examples: ["/afaanoromoo"]

  redirect "/afrique/mobile/*any", to: "/afrique", status: 301

  handle "/afrique.amp", using: "WorldServiceAfrique", platform: "MozartSimorgh", examples: ["/afrique.amp"]
  handle "/afrique.json", using: "WorldServiceAfrique", platform: "MozartSimorgh", examples: ["/afrique.json"]
  handle "/afrique/manifest.json", using: "WorldServiceAfriqueAssets", platform: "Simorgh", examples: ["/afrique/manifest.json"]
  handle "/afrique/sw.js", using: "WorldServiceAfriqueAssets", platform: "Simorgh", examples: ["/afrique/sw.js"]
  handle "/afrique/rss.xml", using: "WorldServiceAfriqueHomePageRss", platform: "Karanga", examples: ["/afrique/rss.xml"]

  handle "/afrique/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/afrique/topics/c9ny75kpxlkt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/afrique/topics/:id", using: "WorldServiceAfriqueTopicPage", platform: "Simorgh", examples: ["/afrique/topics/c9ny75kpxlkt", "/afrique/topics/c9ny75kpxlkt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/afrique/topics/:id/rss.xml", using: "WorldServiceAfriqueTopicRss", platform: "Fabl", examples: ["/afrique/topics/c9ny75kpxlkt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/afrique/articles/:id", using: "WorldServiceAfriqueArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/afrique/articles/:id.amp", using: "WorldServiceAfriqueArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/afrique/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/afrique/send/u39697902"]
  handle "/afrique/*any", using: "WorldServiceAfrique", platform: "MozartSimorgh", examples: ["/afrique"]

  handle "/amharic.amp", using: "WorldServiceAmharic", platform: "MozartSimorgh", examples: ["/amharic.amp"]
  handle "/amharic.json", using: "WorldServiceAmharic", platform: "MozartSimorgh", examples: ["/amharic.json"]
  handle "/amharic/manifest.json", using: "WorldServiceAmharicAssets", platform: "Simorgh", examples: ["/amharic/manifest.json"]
  handle "/amharic/sw.js", using: "WorldServiceAmharicAssets", platform: "Simorgh", examples: ["/amharic/sw.js"]
  handle "/amharic/rss.xml", using: "WorldServiceAmharicHomePageRss", platform: "Karanga", examples: ["/amharic/rss.xml"]

  handle "/amharic/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/amharic/topics/c06gq8wdrjyt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/amharic/topics/:id", using: "WorldServiceAmharicTopicPage", platform: "Simorgh", examples: ["/amharic/topics/c06gq8wdrjyt", "/amharic/topics/c06gq8wdrjyt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/amharic/topics/:id/rss.xml", using: "WorldServiceAmharicTopicRss", platform: "Fabl", examples: ["/amharic/topics/c06gq8wdrjyt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/amharic/articles/:id", using: "WorldServiceAmharicArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/amharic/articles/:id.amp", using: "WorldServiceAmharicArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/amharic/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/amharic/send/u39697902"]
  handle "/amharic/*any", using: "WorldServiceAmharic", platform: "MozartSimorgh", examples: ["/amharic"]

  redirect "/arabic/mobile/*any", to: "/arabic", status: 301
  redirect "/arabic/institutional/2011/01/000000_tv_schedule", to: "/arabic/tv-and-radio-58432380", status: 301
  redirect "/arabic/institutional/2011/01/000000_frequencies_radio", to: "/arabic/tv-and-radio-57895092", status: 301
  redirect "/arabic/investigations", to: "/arabic/tv-and-radio-42414864", status: 301

  handle "/arabic.amp", using: "WorldServiceArabic", platform: "MozartSimorgh", examples: ["/arabic.amp"]
  handle "/arabic.json", using: "WorldServiceArabic", platform: "MozartSimorgh", examples: ["/arabic.json"]
  handle "/arabic/manifest.json", using: "WorldServiceArabicAssets", platform: "Simorgh", examples: ["/arabic/manifest.json"]
  handle "/arabic/sw.js", using: "WorldServiceArabicAssets", platform: "Simorgh", examples: ["/arabic/sw.js"]
  handle "/arabic/rss.xml", using: "WorldServiceArabicHomePageRss", platform: "Karanga", examples: ["/arabic/rss.xml"]

  handle "/arabic/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/arabic/topics/c340qj374j6t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/arabic/topics/:id", using: "WorldServiceArabicTopicPage", platform: "Simorgh", examples: ["/arabic/topics/c340qj374j6t", "/arabic/topics/c340qj374j6t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/arabic/topics/:id/rss.xml", using: "WorldServiceArabicTopicRss", platform: "Fabl", examples: ["/arabic/topics/c340qj374j6t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/arabic/articles/:id", using: "WorldServiceArabicArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/arabic/articles/:id.amp", using: "WorldServiceArabicArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/arabic/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/arabic/send/u39697902"]
  handle "/arabic/*any", using: "WorldServiceArabic", platform: "MozartSimorgh", examples: ["/arabic"]

  redirect "/azeri/mobile/*any", to: "/azeri", status: 301

  handle "/azeri.amp", using: "WorldServiceAzeri", platform: "MozartSimorgh", examples: ["/azeri.amp"]
  handle "/azeri.json", using: "WorldServiceAzeri", platform: "MozartSimorgh", examples: ["/azeri.json"]
  handle "/azeri/manifest.json", using: "WorldServiceAzeriAssets", platform: "Simorgh", examples: ["/azeri/manifest.json"]
  handle "/azeri/sw.js", using: "WorldServiceAzeriAssets", platform: "Simorgh", examples: ["/azeri/sw.js"]
  handle "/azeri/rss.xml", using: "WorldServiceAzeriHomePageRss", platform: "Karanga", examples: ["/azeri/rss.xml"]

  handle "/azeri/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/azeri/topics/c1gdq32g3ddt/page/1", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/azeri/topics/:id", using: "WorldServiceAzeriTopicPage", platform: "Simorgh", examples: ["/azeri/topics/c1gdq32g3ddt", "/azeri/topics/c1gdq32g3ddt?page=1"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/azeri/topics/:id/rss.xml", using: "WorldServiceAzeriTopicRss", platform: "Fabl", examples: ["/azeri/topics/c1gdq32g3ddt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/azeri/articles/:id", using: "WorldServiceAzeriArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/azeri/articles/:id.amp", using: "WorldServiceAzeriArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/azeri/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/azeri/send/u39697902"]
  handle "/azeri/*any", using: "WorldServiceAzeri", platform: "MozartSimorgh", examples: ["/azeri"]

  redirect "/bengali/mobile/image/*any", to: "/bengali/*any", status: 302
  redirect "/bengali/mobile/*any", to: "/bengali", status: 301

  handle "/bengali.amp", using: "WorldServiceBengali", platform: "MozartSimorgh", examples: ["/bengali.amp"]
  handle "/bengali.json", using: "WorldServiceBengali", platform: "MozartSimorgh", examples: ["/bengali.json"]
  handle "/bengali/manifest.json", using: "WorldServiceBengaliAssets", platform: "Simorgh", examples: ["/bengali/manifest.json"]
  handle "/bengali/sw.js", using: "WorldServiceBengaliAssets", platform: "Simorgh", examples: ["/bengali/sw.js"]
  handle "/bengali/rss.xml", using: "WorldServiceBengaliHomePageRss", platform: "Karanga", examples: ["/bengali/rss.xml"]

  handle "/bengali/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/bengali/topics/c2dwq2nd40xt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/bengali/topics/:id", using: "WorldServiceBengaliTopicPage", platform: "Simorgh", examples: ["/bengali/topics/c2dwq2nd40xt", "/bengali/topics/c2dwq2nd40xt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/bengali/topics/:id/rss.xml", using: "WorldServiceBengaliTopicRss", platform: "Fabl", examples: ["/bengali/topics/c2dwq2nd40xt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/bengali/articles/:id", using: "WorldServiceBengaliArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/bengali/articles/:id.amp", using: "WorldServiceBengaliArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/bengali/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/bengali/send/u39697902"]
  handle "/bengali/*any", using: "WorldServiceBengali", platform: "MozartSimorgh", examples: ["/bengali"]

  redirect "/burmese/mobile/image/*any", to: "/burmese/*any", status: 302
  redirect "/burmese/mobile/*any", to: "/burmese", status: 301

  handle "/burmese.amp", using: "WorldServiceBurmese", platform: "MozartSimorgh", examples: ["/burmese.amp"]
  handle "/burmese.json", using: "WorldServiceBurmese", platform: "MozartSimorgh", examples: ["/burmese.json"]
  handle "/burmese/manifest.json", using: "WorldServiceBurmeseAssets", platform: "Simorgh", examples: ["/burmese/manifest.json"]
  handle "/burmese/sw.js", using: "WorldServiceBurmeseAssets", platform: "Simorgh", examples: ["/burmese/sw.js"]
  handle "/burmese/rss.xml", using: "WorldServiceBurmeseHomePageRss", platform: "Karanga", examples: ["/burmese/rss.xml"]

  handle "/burmese/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/burmese/topics/c404v08p1wxt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/burmese/topics/:id", using: "WorldServiceBurmeseTopicPage", platform: "Simorgh", examples: ["/burmese/topics/c404v08p1wxt", "/burmese/topics/c404v08p1wxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/burmese/topics/:id/rss.xml", using: "WorldServiceBurmeseTopicRss", platform: "Fabl", examples: ["/burmese/topics/c404v08p1wxt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/burmese/articles/:id", using: "WorldServiceBurmeseArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/burmese/articles/:id.amp", using: "WorldServiceBurmeseArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/burmese/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/burmese/send/u39697902"]
  handle "/burmese/*any", using: "WorldServiceBurmese", platform: "MozartSimorgh", examples: ["/burmese"]

  redirect "/gahuza/mobile/*any", to: "/gahuza", status: 301

  handle "/gahuza.amp", using: "WorldServiceGahuza", platform: "MozartSimorgh", examples: ["/gahuza.amp"]
  handle "/gahuza.json", using: "WorldServiceGahuza", platform: "MozartSimorgh", examples: ["/gahuza.json"]
  handle "/gahuza/manifest.json", using: "WorldServiceGahuzaAssets", platform: "Simorgh", examples: ["/gahuza/manifest.json"]
  handle "/gahuza/sw.js", using: "WorldServiceGahuzaAssets", platform: "Simorgh", examples: ["/gahuza/sw.js"]
  handle "/gahuza/rss.xml", using: "WorldServiceGahuzaHomePageRss", platform: "Karanga", examples: ["/gahuza/rss.xml"]

  handle "/gahuza/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/gahuza/topics/c7zp5z0yd0xt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/gahuza/topics/:id", using: "WorldServiceGahuzaTopicPage", platform: "Simorgh", examples: ["/gahuza/topics/c7zp5z0yd0xt", "/gahuza/topics/c7zp5z0yd0xt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/gahuza/topics/:id/rss.xml", using: "WorldServiceGahuzaTopicRss", platform: "Fabl", examples: ["/gahuza/topics/c7zp5z0yd0xt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/gahuza/articles/:id", using: "WorldServiceGahuzaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/gahuza/articles/:id.amp", using: "WorldServiceGahuzaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/gahuza/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/gahuza/send/u39697902"]
  handle "/gahuza/*any", using: "WorldServiceGahuza", platform: "MozartSimorgh", examples: ["/gahuza"]
  handle "/gujarati.amp", using: "WorldServiceGujarati", platform: "MozartSimorgh", examples: ["/gujarati.amp"]
  handle "/gujarati.json", using: "WorldServiceGujarati", platform: "MozartSimorgh", examples: ["/gujarati.json"]
  handle "/gujarati/manifest.json", using: "WorldServiceGujaratiAssets", platform: "Simorgh", examples: ["/gujarati/manifest.json"]
  handle "/gujarati/sw.js", using: "WorldServiceGujaratiAssets", platform: "Simorgh", examples: ["/gujarati/sw.js"]
  handle "/gujarati/rss.xml", using: "WorldServiceGujaratiHomePageRss", platform: "Karanga", examples: ["/gujarati/rss.xml"]

  handle "/gujarati/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/gujarati/topics/c2dwqj95d30t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/gujarati/topics/:id", using: "WorldServiceGujaratiTopicPage", platform: "Simorgh", examples: ["/gujarati/topics/c2dwqj95d30t", "/gujarati/topics/c2dwqj95d30t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/gujarati/topics/:id/rss.xml", using: "WorldServiceGujaratiTopicRss", platform: "Fabl", examples: ["/gujarati/topics/c2dwqj95d30t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/gujarati/articles/:id", using: "WorldServiceGujaratiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/gujarati/articles/:id.amp", using: "WorldServiceGujaratiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/gujarati/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/gujarati/send/u39697902"]
  handle "/gujarati/*any", using: "WorldServiceGujarati", platform: "MozartSimorgh", examples: ["/gujarati"]

  redirect "/hausa/mobile/*any", to: "/hausa", status: 301

  handle "/hausa.amp", using: "WorldServiceHausa", platform: "MozartSimorgh", examples: ["/hausa.amp"]
  handle "/hausa.json", using: "WorldServiceHausa", platform: "MozartSimorgh", examples: ["/hausa.json"]
  handle "/hausa/manifest.json", using: "WorldServiceHausaAssets", platform: "Simorgh", examples: ["/hausa/manifest.json"]
  handle "/hausa/sw.js", using: "WorldServiceHausaAssets", platform: "Simorgh", examples: ["/hausa/sw.js"]
  handle "/hausa/rss.xml", using: "WorldServiceHausaHomePageRss", platform: "Karanga", examples: ["/hausa/rss.xml"]

  handle "/hausa/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/hausa/topics/c5qvpxkx1j7t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/hausa/topics/:id", using: "WorldServiceHausaTopicPage", platform: "Simorgh", examples: ["/hausa/topics/c5qvpxkx1j7t", "/hausa/topics/c5qvpxkx1j7t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/hausa/topics/:id/rss.xml", using: "WorldServiceHausaTopicRss", platform: "Fabl", examples: ["/hausa/topics/c5qvpxkx1j7t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/hausa/articles/:id", using: "WorldServiceHausaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/hausa/articles/:id.amp", using: "WorldServiceHausaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/hausa/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/hausa/send/u39697902"]
  handle "/hausa/*any", using: "WorldServiceHausa", platform: "MozartSimorgh", examples: ["/hausa"]

  redirect "/hindi/mobile/image/*any", to: "/hindi/*any", status: 302
  redirect "/hindi/mobile/*any", to: "/hindi", status: 301

  handle "/hindi.amp", using: "WorldServiceHindi", platform: "MozartSimorgh", examples: ["/hindi.amp"]
  handle "/hindi.json", using: "WorldServiceHindi", platform: "MozartSimorgh", examples: ["/hindi.json"]
  handle "/hindi/manifest.json", using: "WorldServiceHindiAssets", platform: "Simorgh", examples: ["/hindi/manifest.json"]
  handle "/hindi/sw.js", using: "WorldServiceHindiAssets", platform: "Simorgh", examples: ["/hindi/sw.js"]
  handle "/hindi/rss.xml", using: "WorldServiceHindiHomePageRss", platform: "Karanga", examples: ["/hindi/rss.xml"]

  handle "/hindi/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/hindi/topics/c6vzy709wvxt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/hindi/topics/:id", using: "WorldServiceHindiTopicPage", platform: "Simorgh", examples: ["/hindi/topics/c6vzy709wvxt", "/hindi/topics/c6vzy709wvxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/hindi/topics/:id/rss.xml", using: "WorldServiceHindiTopicRss", platform: "Fabl", examples: ["/hindi/topics/c6vzy709wvxt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/hindi/articles/:id", using: "WorldServiceHindiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/hindi/articles/:id.amp", using: "WorldServiceHindiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/hindi/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/hindi/send/u39697902"]
  handle "/hindi/*any", using: "WorldServiceHindi", platform: "MozartSimorgh", examples: ["/hindi"]
  handle "/igbo.amp", using: "WorldServiceIgbo", platform: "MozartSimorgh", examples: ["/igbo.amp"]
  handle "/igbo.json", using: "WorldServiceIgbo", platform: "MozartSimorgh", examples: ["/igbo.json"]
  handle "/igbo/manifest.json", using: "WorldServiceIgboAssets", platform: "Simorgh", examples: ["/igbo/manifest.json"]
  handle "/igbo/sw.js", using: "WorldServiceIgboAssets", platform: "Simorgh", examples: ["/igbo/sw.js"]
  handle "/igbo/rss.xml", using: "WorldServiceIgboHomePageRss", platform: "Karanga", examples: ["/igbo/rss.xml"]

  handle "/igbo/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/igbo/topics/c340qr24xggt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end


  handle "/igbo/topics/:id", using: "WorldServiceIgboTopicPage", platform: "Simorgh", examples: ["/igbo/topics/c340qr24xggt", "/igbo/topics/c340qr24xggt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/igbo/topics/:id/rss.xml", using: "WorldServiceIgboTopicRss", platform: "Fabl", examples: ["/igbo/topics/c340qr24xggt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/igbo/articles/:id", using: "WorldServiceIgboArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/igbo/articles/:id.amp", using: "WorldServiceIgboArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/igbo/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/igbo/send/u39697902"]
  handle "/igbo/*any", using: "WorldServiceIgbo", platform: "MozartSimorgh", examples: ["/igbo"]

  redirect "/indonesia/mobile/*any", to: "/indonesia", status: 301

  handle "/indonesia.amp", using: "WorldServiceIndonesia", platform: "MozartSimorgh", examples: ["/indonesia.amp"]
  handle "/indonesia.json", using: "WorldServiceIndonesia", platform: "MozartSimorgh", examples: ["/indonesia.json"]
  handle "/indonesia/manifest.json", using: "WorldServiceIndonesiaAssets", platform: "Simorgh", examples: ["/indonesia/manifest.json"]
  handle "/indonesia/sw.js", using: "WorldServiceIndonesiaAssets", platform: "Simorgh", examples: ["/indonesia/sw.js"]
  handle "/indonesia/rss.xml", using: "WorldServiceIndonesiaHomePageRss", platform: "Karanga", examples: ["/indonesia/rss.xml"]

  handle "/indonesia/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/indonesia/topics/c340qrk1znxt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/indonesia/topics/:id", using: "WorldServiceIndonesiaTopicPage", platform: "Simorgh", examples: ["/indonesia/topics/c340qrk1znxt", "/indonesia/topics/c340qrk1znxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/indonesia/topics/:id/rss.xml", using: "WorldServiceIndonesiaTopicRss", platform: "Fabl", examples: ["/indonesia/topics/c340qrk1znxt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/indonesia/articles/:id", using: "WorldServiceIndonesiaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/indonesia/articles/:id.amp", using: "WorldServiceIndonesiaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/indonesia/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/indonesia/send/u39697902"]
  handle "/indonesia/*any", using: "WorldServiceIndonesia", platform: "MozartSimorgh", examples: ["/indonesia"]
  handle "/japanese.amp", using: "WorldServiceJapanese", platform: "MozartSimorgh", examples: ["/japanese.amp"]
  handle "/japanese.json", using: "WorldServiceJapanese", platform: "MozartSimorgh", examples: ["/japanese.json"]
  handle "/japanese/manifest.json", using: "WorldServiceJapaneseAssets", platform: "Simorgh", examples: ["/japanese/manifest.json"]
  handle "/japanese/sw.js", using: "WorldServiceJapaneseAssets", platform: "Simorgh", examples: ["/japanese/sw.js"]
  handle "/japanese/rss.xml", using: "WorldServiceJapaneseHomePageRss", platform: "Karanga", examples: ["/japanese/rss.xml"]

  handle "/japanese/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/japanese/topics/c340qrn7pp0t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/japanese/topics/:id", using: "WorldServiceJapaneseTopicPage", platform: "Simorgh", examples: ["/japanese/topics/c340qrn7pp0t", "/japanese/topics/c340qrn7pp0t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/japanese/topics/:id/rss.xml", using: "WorldServiceJapaneseTopicRss", platform: "Fabl", examples: ["/japanese/topics/c340qrn7pp0t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/japanese/articles/:id", using: "WorldServiceJapaneseArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/japanese/articles/:id.amp", using: "WorldServiceJapaneseArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/japanese/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/japanese/send/u39697902"]
  handle "/japanese/*any", using: "WorldServiceJapanese", platform: "MozartSimorgh", examples: ["/japanese"]
  handle "/korean.amp", using: "WorldServiceKorean", platform: "MozartSimorgh", examples: ["/korean.amp"]
  handle "/korean.json", using: "WorldServiceKorean", platform: "MozartSimorgh", examples: ["/korean.json"]
  handle "/korean/manifest.json", using: "WorldServiceKoreanAssets", platform: "Simorgh", examples: ["/korean/manifest.json"]
  handle "/korean/sw.js", using: "WorldServiceKoreanAssets", platform: "Simorgh", examples: ["/korean/sw.js"]
  handle "/korean/rss.xml", using: "WorldServiceKoreanHomePageRss", platform: "Karanga", examples: ["/korean/rss.xml"]

  handle "/korean/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/korean/topics/c17q6yp3jx4t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/korean/topics/:id", using: "WorldServiceKoreanTopicPage", platform: "Simorgh", examples: ["/korean/topics/c17q6yp3jx4t", "/korean/topics/c17q6yp3jx4t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/korean/topics/:id/rss.xml", using: "WorldServiceKoreanTopicRss", platform: "Fabl", examples: ["/korean/topics/c17q6yp3jx4t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/korean/articles/:id", using: "WorldServiceKoreanArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/korean/articles/:id.amp", using: "WorldServiceKoreanArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/korean/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/korean/send/u39697902"]
  handle "/korean/*any", using: "WorldServiceKorean", platform: "MozartSimorgh", examples: ["/korean"]

  redirect "/kyrgyz/mobile/*any", to: "/kyrgyz", status: 301

  handle "/kyrgyz.amp", using: "WorldServiceKyrgyz", platform: "MozartSimorgh", examples: ["/kyrgyz.amp"]
  handle "/kyrgyz.json", using: "WorldServiceKyrgyz", platform: "MozartSimorgh", examples: ["/kyrgyz.json"]
  handle "/kyrgyz/manifest.json", using: "WorldServiceKyrgyzAssets", platform: "Simorgh", examples: ["/kyrgyz/manifest.json"]
  handle "/kyrgyz/sw.js", using: "WorldServiceKyrgyzAssets", platform: "Simorgh", examples: ["/kyrgyz/sw.js"]
  handle "/kyrgyz/rss.xml", using: "WorldServiceKyrgyzHomePageRss", platform: "Karanga", examples: ["/kyrgyz/rss.xml"]

  handle "/kyrgyz/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/kyrgyz/topics/c0109l9xrpnt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/kyrgyz/topics/:id", using: "WorldServiceKyrgyzTopicPage", platform: "Simorgh", examples: ["/kyrgyz/topics/c0109l9xrpnt", "/kyrgyz/topics/c0109l9xrpnt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/kyrgyz/topics/:id/rss.xml", using: "WorldServiceKyrgyzTopicRss", platform: "Fabl", examples: ["/kyrgyz/topics/c0109l9xrpnt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/kyrgyz/articles/:id", using: "WorldServiceKyrgyzArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/kyrgyz/articles/:id.amp", using: "WorldServiceKyrgyzArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/kyrgyz/new_live/:id", using: "WorldServiceKyrgyzLivePage", platform: "Simorgh", only_on: "test", examples: [] do
    return_404 if: [
      !matches?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !integer_in_range?(conn.query_params["page"] || "1", 1..999)
    ]
  end

  handle "/kyrgyz/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/kyrgyz/send/u39697902"]
  handle "/kyrgyz/*any", using: "WorldServiceKyrgyz", platform: "MozartSimorgh", examples: ["/kyrgyz"]

  handle "/marathi.amp", using: "WorldServiceMarathi", platform: "MozartSimorgh", examples: ["/marathi.amp"]
  handle "/marathi.json", using: "WorldServiceMarathi", platform: "MozartSimorgh", examples: ["/marathi.json"]
  handle "/marathi/manifest.json", using: "WorldServiceMarathiAssets", platform: "Simorgh", examples: ["/marathi/manifest.json"]
  handle "/marathi/sw.js", using: "WorldServiceMarathiAssets", platform: "Simorgh", examples: ["/marathi/sw.js"]
  handle "/marathi/rss.xml", using: "WorldServiceMarathiHomePageRss", platform: "Karanga", examples: ["/marathi/rss.xml"]

  handle "/marathi/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/marathi/topics/c2dwqjwqqqjt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/marathi/topics/:id", using: "WorldServiceMarathiTopicPage", platform: "Simorgh", examples: ["/marathi/topics/c2dwqjwqqqjt", "/marathi/topics/c2dwqjwqqqjt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/marathi/topics/:id/rss.xml", using: "WorldServiceMarathiTopicRss", platform: "Fabl", examples: ["/marathi/topics/c2dwqjwqqqjt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/marathi/articles/:id", using: "WorldServiceMarathiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/marathi/articles/:id.amp", using: "WorldServiceMarathiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/marathi/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/marathi/send/u39697902"]
  handle "/marathi/*any", using: "WorldServiceMarathi", platform: "MozartSimorgh", examples: ["/marathi"]

  ## World Service - Olympic Redirects
  redirect "/mundo/deportes-57748229", to: "/mundo/deportes-57970068", status: 301

  ## World Service - Topcat to CPS Redirects
  redirect "/mundo/noticias/2014/08/140801_israel_palestinos_conflicto_preguntas_basicas_jp", to: "/mundo/noticias-internacional-44125537", status: 301
  redirect "/mundo/noticias/2015/10/151014_israel_palestina_preguntas_basicas_actualizacion_aw", to: "/mundo/noticias-internacional-44125537", status: 301

  redirect "/mundo/mobile/*any", to: "/mundo", status: 301
  redirect "/mundo/movil/*any", to: "/mundo", status: 301

  handle "/mundo/mvt/*any", using: "WorldServiceMvtPoc", platform: "MozartSimorgh", only_on: "test", examples: ["/mundo/mvt/testing"]

  handle "/mundo.amp", using: "WorldServiceMundo", platform: "MozartSimorgh", examples: ["/mundo.amp"]
  handle "/mundo.json", using: "WorldServiceMundo", platform: "MozartSimorgh", examples: ["/mundo.json"]
  handle "/mundo/manifest.json", using: "WorldServiceMundoAssets", platform: "Simorgh", examples: ["/mundo/manifest.json"]
  handle "/mundo/sw.js", using: "WorldServiceMundoAssets", platform: "Simorgh", examples: ["/mundo/sw.js"]
  handle "/mundo/rss.xml", using: "WorldServiceMundoHomePageRss", platform: "Karanga", examples: ["/mundo/rss.xml"]

  handle "/mundo/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/mundo/topics/cdr5613yzwqt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/mundo/topics/:id", using: "WorldServiceMundoTopicPage", platform: "Simorgh", examples: ["/mundo/topics/cdr5613yzwqt", "/mundo/topics/cdr5613yzwqt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/mundo/topics/:id/rss.xml", using: "WorldServiceMundoTopicRss", platform: "Fabl", examples: ["/mundo/topics/cdr5613yzwqt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/mundo/articles/:id", using: "WorldServiceMundoArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/mundo/articles/:id.amp", using: "WorldServiceMundoArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/mundo/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/mundo/send/u39697902"]
  handle "/mundo/*any", using: "WorldServiceMundo", platform: "MozartSimorgh", examples: ["/mundo"]

  redirect "/nepali/mobile/image/*any", to: "/nepali/*any", status: 302
  redirect "/nepali/mobile/*any", to: "/nepali", status: 301

  handle "/nepali.amp", using: "WorldServiceNepali", platform: "MozartSimorgh", examples: ["/nepali.amp"]
  handle "/nepali.json", using: "WorldServiceNepali", platform: "MozartSimorgh", examples: ["/nepali.json"]
  handle "/nepali/manifest.json", using: "WorldServiceNepaliAssets", platform: "Simorgh", examples: ["/nepali/manifest.json"]
  handle "/nepali/sw.js", using: "WorldServiceNepaliAssets", platform: "Simorgh", examples: ["/nepali/sw.js"]
  handle "/nepali/rss.xml", using: "WorldServiceNepaliHomePageRss", platform: "Karanga", examples: ["/nepali/rss.xml"]

  handle "/nepali/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/nepali/topics/c340q4p5136t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/nepali/topics/:id", using: "WorldServiceNepaliTopicPage", platform: "Simorgh", examples: ["/nepali/topics/c340q4p5136t", "/nepali/topics/c340q4p5136t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/nepali/topics/:id/rss.xml", using: "WorldServiceNepaliTopicRss", platform: "Fabl", examples: ["/nepali/topics/c340q4p5136t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/nepali/articles/:id", using: "WorldServiceNepaliArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/nepali/articles/:id.amp", using: "WorldServiceNepaliArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/nepali/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/nepali/send/u39697902"]
  handle "/nepali/*any", using: "WorldServiceNepali", platform: "MozartSimorgh", examples: ["/nepali"]

  redirect "/pashto/mobile/image/*any", to: "/pashto/*any", status: 302
  redirect "/pashto/mobile/*any", to: "/pashto", status: 301

  handle "/pashto.amp", using: "WorldServicePashto", platform: "MozartSimorgh", examples: ["/pashto.amp"]
  handle "/pashto.json", using: "WorldServicePashto", platform: "MozartSimorgh", examples: ["/pashto.json"]
  handle "/pashto/manifest.json", using: "WorldServicePashtoAssets", platform: "Simorgh", examples: ["/pashto/manifest.json"]
  handle "/pashto/sw.js", using: "WorldServicePashtoAssets", platform: "Simorgh", examples: ["/pashto/sw.js"]
  handle "/pashto/rss.xml", using: "WorldServicePashtoHomePageRss", platform: "Karanga", examples: ["/pashto/rss.xml"]

  handle "/pashto/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/pashto/topics/c8y94yr7y9rt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/pashto/topics/:id", using: "WorldServicePashtoTopicPage", platform: "Simorgh", examples: ["/pashto/topics/c8y94yr7y9rt", "/pashto/topics/c8y94yr7y9rt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/pashto/topics/:id/rss.xml", using: "WorldServicePashtoTopicRss", platform: "Fabl", examples: ["/pashto/topics/c8y94yr7y9rt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/pashto/articles/:id", using: "WorldServicePashtoArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/pashto/articles/:id.amp", using: "WorldServicePashtoArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/pashto/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/pashto/send/u39697902"]
  handle "/pashto/*any", using: "WorldServicePashto", platform: "MozartSimorgh", examples: ["/pashto"]

  redirect "/persian/mobile/image/*any", to: "/persian/*any", status: 302
  redirect "/persian/mobile/*any", to: "/persian", status: 301

  handle "/persian.amp", using: "WorldServicePersian", platform: "MozartSimorgh", examples: ["/persian.amp"]
  handle "/persian.json", using: "WorldServicePersian", platform: "MozartSimorgh", examples: ["/persian.json"]
  handle "/persian/manifest.json", using: "WorldServicePersianAssets", platform: "Simorgh", examples: ["/persian/manifest.json"]
  handle "/persian/sw.js", using: "WorldServicePersianAssets", platform: "Simorgh", examples: ["/persian/sw.js"]
  handle "/persian/rss.xml", using: "WorldServicePersianHomePageRss", platform: "Karanga", examples: ["/persian/rss.xml"]

  handle "/persian/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/persian/topics/cnq68798yw0t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/persian/topics/:id", using: "WorldServicePersianTopicPage", platform: "Simorgh", examples: ["/persian/topics/cnq68798yw0t", "/persian/topics/cnq68798yw0t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/persian/topics/:id/rss.xml", using: "WorldServicePersianTopicRss", platform: "Fabl", examples: ["/persian/topics/cnq68798yw0t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/persian/articles/:id", using: "WorldServicePersianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/persian/articles/:id.amp", using: "WorldServicePersianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/persian/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/persian/send/u39697902"]
  handle "/persian/*any", using: "WorldServicePersian", platform: "MozartSimorgh", examples: ["/persian"]
  handle "/pidgin.amp", using: "WorldServicePidgin", platform: "MozartSimorgh", examples: ["/pidgin.amp"]
  handle "/pidgin.json", using: "WorldServicePidgin", platform: "MozartSimorgh", examples: ["/pidgin.json"]
  handle "/pidgin/manifest.json", using: "WorldServicePidginAssets", platform: "Simorgh", examples: ["/pidgin/manifest.json"]
  handle "/pidgin/sw.js", using: "WorldServicePidginAssets", platform: "Simorgh", examples: ["/pidgin/sw.js"]
  handle "/pidgin/rss.xml", using: "WorldServicePidginHomePageRss", platform: "Karanga", examples: ["/pidgin/rss.xml"]

  handle "/pidgin/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/pidgin/topics/c95y35941vrt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/pidgin/topics/:id", using: "WorldServicePidginTopicPage", platform: "Simorgh", examples: ["/pidgin/topics/c95y35941vrt", "/pidgin/topics/c95y35941vrt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/pidgin/topics/:id/rss.xml", using: "WorldServicePidginTopicRss", platform: "Fabl", examples: ["/pidgin/topics/c95y35941vrt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/pidgin/articles/:id", using: "WorldServicePidginArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/pidgin/articles/:id.amp", using: "WorldServicePidginArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/pidgin/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/pidgin/send/u39697902"]
  handle "/pidgin/*any", using: "WorldServicePidgin", platform: "MozartSimorgh", examples: ["/pidgin"]

  redirect "/portuguese/mobile/*any", to: "/portuguese", status: 301
  redirect "/portuguese/celular/*any", to: "/portuguese", status: 301

  handle "/portuguese.amp", using: "WorldServicePortuguese", platform: "MozartSimorgh", examples: ["/portuguese.amp"]
  handle "/portuguese.json", using: "WorldServicePortuguese", platform: "MozartSimorgh", examples: ["/portuguese.json"]
  handle "/portuguese/manifest.json", using: "WorldServicePortugueseAssets", platform: "Simorgh", examples: ["/portuguese/manifest.json"]
  handle "/portuguese/sw.js", using: "WorldServicePortugueseAssets", platform: "Simorgh", examples: ["/portuguese/sw.js"]
  handle "/portuguese/rss.xml", using: "WorldServicePortugueseHomePageRss", platform: "Karanga", examples: ["/portuguese/rss.xml"]

  handle "/portuguese/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/portuguese/topics/c1gdqg5dr8nt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/portuguese/topics/:id", using: "WorldServicePortugueseTopicPage", platform: "Simorgh", examples: ["/portuguese/topics/c1gdqg5dr8nt", "/portuguese/topics/c1gdqg5dr8nt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/portuguese/topics/:id/rss.xml", using: "WorldServicePortugueseTopicRss", platform: "Fabl", examples: ["/portuguese/topics/c1gdqg5dr8nt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/portuguese/articles/:id", using: "WorldServicePortugueseArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/portuguese/articles/:id.amp", using: "WorldServicePortugueseArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/portuguese/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/portuguese/send/u39697902"]
  handle "/portuguese/*any", using: "WorldServicePortuguese", platform: "MozartSimorgh", examples: ["/portuguese"]
  handle "/punjabi.amp", using: "WorldServicePunjabi", platform: "MozartSimorgh", examples: ["/punjabi.amp"]
  handle "/punjabi.json", using: "WorldServicePunjabi", platform: "MozartSimorgh", examples: ["/punjabi.json"]
  handle "/punjabi/manifest.json", using: "WorldServicePunjabiAssets", platform: "Simorgh", examples: ["/punjabi/manifest.json"]
  handle "/punjabi/sw.js", using: "WorldServicePunjabiAssets", platform: "Simorgh", examples: ["/punjabi/sw.js"]
  handle "/punjabi/rss.xml", using: "WorldServicePunjabiHomePageRss", platform: "Karanga", examples: ["/punjabi/rss.xml"]

  handle "/punjabi/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/punjabi/topics/c0w258dd62mt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/punjabi/topics/:id", using: "WorldServicePunjabiTopicPage", platform: "Simorgh", examples: ["/punjabi/topics/c0w258dd62mt", "/punjabi/topics/c0w258dd62mt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/punjabi/topics/:id/rss.xml", using: "WorldServicePunjabiTopicRss", platform: "Fabl", examples: ["/punjabi/topics/c0w258dd62mt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/punjabi/articles/:id", using: "WorldServicePunjabiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/punjabi/articles/:id.amp", using: "WorldServicePunjabiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/punjabi/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/punjabi/send/u39697902"]
  handle "/punjabi/*any", using: "WorldServicePunjabi", platform: "MozartSimorgh", examples: ["/punjabi"]

  ## World Service - Russian Partners Redirects
  redirect "/russian/international/2011/02/000000_g_partners", to: "/russian/institutional-43463215", status: 301

  ## World Service - Russian Newsletter Redirects
  redirect "/russian/institutional/2012/09/000000_newsletter", to: "/russian/resources/idt-b34bb7dd-f094-4722-92eb-cf7aff8cc1bc", status: 301

  redirect "/russian/mobile/*any", to: "/russian", status: 301
  redirect "/russia", to: "/russian", status: 301


  handle "/russian.amp", using: "WorldServiceRussian", platform: "MozartSimorgh", examples: ["/russian.amp"]
  handle "/russian.json", using: "WorldServiceRussian", platform: "MozartSimorgh", examples: ["/russian.json"]
  handle "/russian/manifest.json", using: "WorldServiceRussianAssets", platform: "Simorgh", examples: ["/russian/manifest.json"]
  handle "/russian/sw.js", using: "WorldServiceRussianAssets", platform: "Simorgh", examples: ["/russian/sw.js"]
  handle "/russian/rss.xml", using: "WorldServiceRussianHomePageRss", platform: "Karanga", examples: ["/russian/rss.xml"]

  handle "/russian/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/russian/topics/c50nzm54vzmt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/russian/topics/:id", using: "WorldServiceRussianTopicPage", platform: "Simorgh", examples: ["/russian/topics/c50nzm54vzmt", "/russian/topics/c50nzm54vzmt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/russian/topics/:id/rss.xml", using: "WorldServiceRussianTopicRss", platform: "Fabl", examples: ["/russian/topics/c50nzm54vzmt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/russian/articles/:id", using: "WorldServiceRussianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/russian/articles/:id.amp", using: "WorldServiceRussianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/russian/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/russian/send/u39697902"]
  handle "/russian/*any", using: "WorldServiceRussian", platform: "MozartSimorgh", examples: ["/russian"]

  handle "/serbian/manifest.json", using: "WorldServiceSerbianAssets", platform: "Simorgh", examples: ["/serbian/manifest.json"]
  handle "/serbian/sw.js", using: "WorldServiceSerbianAssets", platform: "Simorgh", examples: ["/serbian/sw.js"]
  handle "/serbian/lat/rss.xml", using: "WorldServiceSerbianHomePageRss", platform: "Karanga", examples: ["/serbian/lat/rss.xml"]
  handle "/serbian/cyr/rss.xml", using: "WorldServiceSerbianHomePageRss", platform: "Karanga", examples: ["/serbian/cyr/rss.xml"]

  handle "/serbian/cyr/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/serbian/cyr/topics/cqwvxvvw9qrt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end
  handle "/serbian/lat/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/serbian/lat/topics/c5wzvzzz5vrt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/serbian/cyr/topics/:id", using: "WorldServiceSerbianTopicPage", platform: "Simorgh", examples: ["/serbian/cyr/topics/cqwvxvvw9qrt", "/serbian/cyr/topics/cqwvxvvw9qrt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end
  handle "/serbian/lat/topics/:id", using: "WorldServiceSerbianTopicPage", platform: "Simorgh", examples: ["/serbian/lat/topics/c5wzvzzz5vrt", "/serbian/lat/topics/c5wzvzzz5vrt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/serbian/cyr/topics/:id/rss.xml", using: "WorldServiceSerbianTopicRss", platform: "Fabl", examples: ["/serbian/cyr/topics/cqwvxvvw9qrt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end
  handle "/serbian/lat/topics/:id/rss.xml", using: "WorldServiceSerbianTopicRss", platform: "Fabl", examples: ["/serbian/lat/topics/c5wzvzzz5vrt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/serbian/articles/:id/cyr", using: "WorldServiceSerbianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/cyr.amp", using: "WorldServiceSerbianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/lat", using: "WorldServiceSerbianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/lat.amp", using: "WorldServiceSerbianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/serbian/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/serbian/send/u39697902"]
  handle "/serbian/*any", using: "WorldServiceSerbian", platform: "MozartSimorgh", examples: ["/serbian/lat", "/serbian/lat.json", "/serbian/lat.amp"]

  redirect "/sinhala/mobile/image/*any", to: "/sinhala/*any", status: 302
  redirect "/sinhala/mobile/*any", to: "/sinhala", status: 301

  handle "/sinhala.amp", using: "WorldServiceSinhala", platform: "MozartSimorgh", examples: ["/sinhala.amp"]
  handle "/sinhala.json", using: "WorldServiceSinhala", platform: "MozartSimorgh", examples: ["/sinhala.json"]
  handle "/sinhala/manifest.json", using: "WorldServiceSinhalaAssets", platform: "Simorgh", examples: ["/sinhala/manifest.json"]
  handle "/sinhala/sw.js", using: "WorldServiceSinhalaAssets", platform: "Simorgh", examples: ["/sinhala/sw.js"]
  handle "/sinhala/rss.xml", using: "WorldServiceSinhalaHomePageRss", platform: "Karanga", examples: ["/sinhala/rss.xml"]

  handle "/sinhala/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/sinhala/topics/c2dwqd311xyt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/sinhala/topics/:id", using: "WorldServiceSinhalaTopicPage", platform: "Simorgh", examples: ["/sinhala/topics/c2dwqd311xyt", "/sinhala/topics/c2dwqd311xyt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/sinhala/topics/:id/rss.xml", using: "WorldServiceSinhalaTopicRss", platform: "Fabl", examples: ["/sinhala/topics/c2dwqd311xyt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/sinhala/articles/:id", using: "WorldServiceSinhalaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/sinhala/articles/:id.amp", using: "WorldServiceSinhalaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/sinhala/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/sinhala/send/u39697902"]
  handle "/sinhala/*any", using: "WorldServiceSinhala", platform: "MozartSimorgh", examples: ["/sinhala"]

  redirect "/somali/mobile/*any", to: "/somali", status: 301

  handle "/somali.amp", using: "WorldServiceSomali", platform: "MozartSimorgh", examples: ["/somali.amp"]
  handle "/somali.json", using: "WorldServiceSomali", platform: "MozartSimorgh", examples: ["/somali.json"]
  handle "/somali/manifest.json", using: "WorldServiceSomaliAssets", platform: "Simorgh", examples: ["/somali/manifest.json"]
  handle "/somali/sw.js", using: "WorldServiceSomaliAssets", platform: "Simorgh", examples: ["/somali/sw.js"]
  handle "/somali/rss.xml", using: "WorldServiceSomaliHomePageRss", platform: "Karanga", examples: ["/somali/rss.xml"]

  handle "/somali/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/somali/topics/cz74k7jd8n8t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/somali/topics/:id", using: "WorldServiceSomaliTopicPage", platform: "Simorgh", examples: ["/somali/topics/cz74k7jd8n8t", "/somali/topics/cz74k7jd8n8t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/somali/topics/:id/rss.xml", using: "WorldServiceSomaliTopicRss", platform: "Fabl", examples: ["/somali/topics/cz74k7jd8n8t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/somali/articles/:id", using: "WorldServiceSomaliArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/somali/articles/:id.amp", using: "WorldServiceSomaliArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/somali/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/somali/send/u39697902"]
  handle "/somali/*any", using: "WorldServiceSomali", platform: "MozartSimorgh", examples: ["/somali"]

  redirect "/swahili/mobile/*any", to: "/swahili", status: 301

  handle "/swahili.amp", using: "WorldServiceSwahili", platform: "MozartSimorgh", examples: ["/swahili.amp"]
  handle "/swahili.json", using: "WorldServiceSwahili", platform: "MozartSimorgh", examples: ["/swahili.json"]
  handle "/swahili/manifest.json", using: "WorldServiceSwahiliAssets", platform: "Simorgh", examples: ["/swahili/manifest.json"]
  handle "/swahili/sw.js", using: "WorldServiceSwahiliAssets", platform: "Simorgh", examples: ["/swahili/sw.js"]
  handle "/swahili/rss.xml", using: "WorldServiceSwahiliHomePageRss", platform: "Karanga", examples: ["/swahili/rss.xml"]

  handle "/swahili/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/swahili/topics/c06gq663n6jt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/swahili/topics/:id", using: "WorldServiceSwahiliTopicPage", platform: "Simorgh", examples: ["/swahili/topics/c06gq663n6jt", "/swahili/topics/c06gq663n6jt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/swahili/topics/:id/rss.xml", using: "WorldServiceSwahiliTopicRss", platform: "Fabl", examples: ["/swahili/topics/c06gq663n6jt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/swahili/articles/:id", using: "WorldServiceSwahiliArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/swahili/articles/:id.amp", using: "WorldServiceSwahiliArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/swahili/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/swahili/send/u39697902"]
  handle "/swahili/*any", using: "WorldServiceSwahili", platform: "MozartSimorgh", examples: ["/swahili"]
  handle "/tajik/*any", using: "WorldServiceTajik", platform: "MozartNews", examples: ["/tajik"]

  redirect "/tamil/mobile/image/*any", to: "/tamil/*any", status: 302
  redirect "/tamil/mobile/*any", to: "/tamil", status: 301

  handle "/tamil.amp", using: "WorldServiceTamil", platform: "MozartSimorgh", examples: ["/tamil.amp"]
  handle "/tamil.json", using: "WorldServiceTamil", platform: "MozartSimorgh", examples: ["/tamil.json"]
  handle "/tamil/manifest.json", using: "WorldServiceTamilAssets", platform: "Simorgh", examples: ["/tamil/manifest.json"]
  handle "/tamil/sw.js", using: "WorldServiceTamilAssets", platform: "Simorgh", examples: ["/tamil/sw.js"]
  handle "/tamil/rss.xml", using: "WorldServiceTamilHomePageRss", platform: "Karanga", examples: ["/tamil/rss.xml"]

  handle "/tamil/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/tamil/topics/c06gq6gnzdgt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/tamil/topics/:id", using: "WorldServiceTamilTopicPage", platform: "Simorgh", examples: ["/tamil/topics/c06gq6gnzdgt", "/tamil/topics/c06gq6gnzdgt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/tamil/topics/:id/rss.xml", using: "WorldServiceTamilTopicRss", platform: "Fabl", examples: ["/tamil/topics/c06gq6gnzdgt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/tamil/articles/:id", using: "WorldServiceTamilArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/tamil/articles/:id.amp", using: "WorldServiceTamilArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/tamil/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/tamil/send/u39697902"]
  handle "/tamil/*any", using: "WorldServiceTamil", platform: "MozartSimorgh", examples: ["/tamil"]
  handle "/telugu.amp", using: "WorldServiceTelugu", platform: "MozartSimorgh", examples: ["/telugu.amp"]
  handle "/telugu.json", using: "WorldServiceTelugu", platform: "MozartSimorgh", examples: ["/telugu.json"]
  handle "/telugu/manifest.json", using: "WorldServiceTeluguAssets", platform: "Simorgh", examples: ["/telugu/manifest.json"]
  handle "/telugu/sw.js", using: "WorldServiceTeluguAssets", platform: "Simorgh", examples: ["/telugu/sw.js"]
  handle "/telugu/rss.xml", using: "WorldServiceTeluguHomePageRss", platform: "Karanga", examples: ["/telugu/rss.xml"]

  handle "/telugu/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/telugu/topics/c5qvp16w7dnt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/telugu/topics/:id", using: "WorldServiceTeluguTopicPage", platform: "Simorgh", examples: ["/telugu/topics/c5qvp16w7dnt", "/telugu/topics/c5qvp16w7dnt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/telugu/topics/:id/rss.xml", using: "WorldServiceTeluguTopicRss", platform: "Fabl", examples: ["/telugu/topics/c5qvp16w7dnt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/telugu/articles/:id", using: "WorldServiceTeluguArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/telugu/articles/:id.amp", using: "WorldServiceTeluguArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/telugu/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/telugu/send/u39697902"]
  handle "/telugu/*any", using: "WorldServiceTelugu", platform: "MozartSimorgh", examples: ["/telugu"]
  handle "/thai.amp", using: "WorldServiceThai", platform: "MozartSimorgh", examples: ["/thai.amp"]
  handle "/thai.json", using: "WorldServiceThai", platform: "MozartSimorgh", examples: ["/thai.json"]
  handle "/thai/manifest.json", using: "WorldServiceThaiAssets", platform: "Simorgh", examples: ["/thai/manifest.json"]
  handle "/thai/sw.js", using: "WorldServiceThaiAssets", platform: "Simorgh", examples: ["/thai/sw.js"]
  handle "/thai/rss.xml", using: "WorldServiceThaiHomePageRss", platform: "Karanga", examples: ["/thai/rss.xml"]

  handle "/thai/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/thai/topics/c340qx429k7t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/thai/topics/:id", using: "WorldServiceThaiTopicPage", platform: "Simorgh", examples: ["/thai/topics/c340qx429k7t", "/thai/topics/c340qx429k7t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/thai/topics/:id/rss.xml", using: "WorldServiceThaiTopicRss", platform: "Fabl", examples: ["/thai/topics/c340qx429k7t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/thai/articles/:id", using: "WorldServiceThaiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/thai/articles/:id.amp", using: "WorldServiceThaiArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/thai/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/thai/send/u39697902"]
  handle "/thai/*any", using: "WorldServiceThai", platform: "MozartSimorgh", examples: ["/thai"]
  handle "/tigrinya.amp", using: "WorldServiceTigrinya", platform: "MozartSimorgh", examples: ["/tigrinya.amp"]
  handle "/tigrinya.json", using: "WorldServiceTigrinya", platform: "MozartSimorgh", examples: ["/tigrinya.json"]
  handle "/tigrinya/manifest.json", using: "WorldServiceTigrinyaAssets", platform: "Simorgh", examples: ["/tigrinya/manifest.json"]
  handle "/tigrinya/sw.js", using: "WorldServiceTigrinyaAssets", platform: "Simorgh", examples: ["/tigrinya/sw.js"]
  handle "/tigrinya/rss.xml", using: "WorldServiceTigrinyaHomePageRss", platform: "Karanga", examples: ["/tigrinya/rss.xml"]

  handle "/tigrinya/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/tigrinya/topics/c1gdqrg28zxt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/tigrinya/topics/:id", using: "WorldServiceTigrinyaTopicPage", platform: "Simorgh", examples: ["/tigrinya/topics/c1gdqrg28zxt", "/tigrinya/topics/c1gdqrg28zxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/tigrinya/topics/:id/rss.xml", using: "WorldServiceTigrinyaTopicRss", platform: "Fabl", examples: ["/tigrinya/topics/c1gdqrg28zxt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/tigrinya/articles/:id", using: "WorldServiceTigrinyaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/tigrinya/articles/:id.amp", using: "WorldServiceTigrinyaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/tigrinya/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/tigrinya/send/u39697902"]
  handle "/tigrinya/*any", using: "WorldServiceTigrinya", platform: "MozartSimorgh", examples: ["/tigrinya"]

  redirect "/turkce/mobile/*any", to: "/turkce", status: 301
  redirect "/turkce/cep/*any", to: "/turkce", status: 301

  handle "/turkce.amp", using: "WorldServiceTurkce", platform: "MozartSimorgh", examples: ["/turkce.amp"]
  handle "/turkce.json", using: "WorldServiceTurkce", platform: "MozartSimorgh", examples: ["/turkce.json"]
  handle "/turkce/manifest.json", using: "WorldServiceTurkceAssets", platform: "Simorgh", examples: ["/turkce/manifest.json"]
  handle "/turkce/sw.js", using: "WorldServiceTurkceAssets", platform: "Simorgh", examples: ["/turkce/sw.js"]
  handle "/turkce/rss.xml", using: "WorldServiceTurkceHomePageRss", platform: "Karanga", examples: ["/turkce/rss.xml"]

  handle "/turkce/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/turkce/topics/c2dwqnwkvnqt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/turkce/topics/:id", using: "WorldServiceTurkceTopicPage", platform: "Simorgh", examples: ["/turkce/topics/c2dwqnwkvnqt", "/turkce/topics/c2dwqnwkvnqt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/turkce/topics/:id/rss.xml", using: "WorldServiceTurkceTopicRss", platform: "Fabl", examples: ["/turkce/topics/c2dwqnwkvnqt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/turkce/articles/:id", using: "WorldServiceTurkceArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/turkce/articles/:id.amp", using: "WorldServiceTurkceArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/turkce/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/turkce/send/u39697902"]
  handle "/turkce/*any", using: "WorldServiceTurkce", platform: "MozartSimorgh", examples: ["/turkce"]

  redirect "/ukchina/simp/mobile/*any", to: "/ukchina/simp", status: 301
  redirect "/ukchina/trad/mobile/*any", to: "/ukchina/trad", status: 301

  handle "/ukchina/manifest.json", using: "WorldServiceUkChinaAssets", platform: "Simorgh", examples: ["/ukchina/manifest.json"]
  handle "/ukchina/sw.js", using: "WorldServiceUkChinaAssets", platform: "Simorgh", examples: ["/ukchina/sw.js"]

  handle "/ukchina/simp/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/ukchina/simp/topics/c1nq04kp0r0t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end
  handle "/ukchina/trad/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/ukchina/trad/topics/cgqnyy07pqyt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/ukchina/simp/topics/:id", using: "WorldServiceUkchinaTopicPage", platform: "Simorgh", examples: ["/ukchina/simp/topics/c1nq04kp0r0t", "/ukchina/simp/topics/c1nq04kp0r0t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end
  handle "/ukchina/trad/topics/:id", using: "WorldServiceUkchinaTopicPage", platform: "Simorgh", examples: ["/ukchina/trad/topics/cgqnyy07pqyt", "/ukchina/trad/topics/cgqnyy07pqyt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/ukchina/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/ukchina/send/u39697902"]
  handle "/ukchina/*any", using: "WorldServiceUkChina", platform: "MozartSimorgh", examples: ["/ukchina/simp", "/ukchina/trad", "/ukchina/trad.json", "/ukchina/trad.amp"]

  redirect "/ukrainian/mobile/*any", to: "/ukrainian", status: 301

  handle "/ukrainian.amp", using: "WorldServiceUkrainian", platform: "MozartSimorgh", examples: ["/ukrainian.amp"]
  handle "/ukrainian.json", using: "WorldServiceUkrainian", platform: "MozartSimorgh", examples: ["/ukrainian.json"]
  handle "/ukrainian/manifest.json", using: "WorldServiceUkrainianAssets", platform: "Simorgh", examples: ["/ukrainian/manifest.json"]
  handle "/ukrainian/sw.js", using: "WorldServiceUkrainianAssets", platform: "Simorgh", examples: ["/ukrainian/sw.js"]
  handle "/ukrainian/rss.xml", using: "WorldServiceUkrainianHomePageRss", platform: "Karanga", examples: ["/ukrainian/rss.xml"]

  handle "/ukrainian/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/ukrainian/topics/c340qxwr67yt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/ukrainian/topics/:id", using: "WorldServiceUkrainianTopicPage", platform: "Simorgh", examples: ["/ukrainian/topics/c340qxwr67yt", "/ukrainian/topics/c340qxwr67yt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/ukrainian/topics/:id/rss.xml", using: "WorldServiceUkrainianTopicRss", platform: "Fabl", examples: ["/ukrainian/topics/c340qxwr67yt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/ukrainian/articles/:id", using: "WorldServiceUkrainianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/ukrainian/articles/:id.amp", using: "WorldServiceUkrainianArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/ukrainian/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/ukrainian/send/u39697902"]
  handle "/ukrainian/*any", using: "WorldServiceUkrainian", platform: "MozartSimorgh", examples: ["/ukrainian"]

  redirect "/urdu/mobile/image/*any", to: "/urdu/*any", status: 302
  redirect "/urdu/mobile/*any", to: "/urdu", status: 301

  handle "/urdu.amp", using: "WorldServiceUrdu", platform: "MozartSimorgh", examples: ["/urdu.amp"]
  handle "/urdu.json", using: "WorldServiceUrdu", platform: "MozartSimorgh", examples: ["/urdu.json"]
  handle "/urdu/manifest.json", using: "WorldServiceUrduAssets", platform: "Simorgh", examples: ["/urdu/manifest.json"]
  handle "/urdu/sw.js", using: "WorldServiceUrduAssets", platform: "Simorgh", examples: ["/urdu/sw.js"]
  handle "/urdu/rss.xml", using: "WorldServiceUrduHomePageRss", platform: "Karanga", examples: ["/urdu/rss.xml"]

  handle "/urdu/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/urdu/topics/c44pxlmy60mt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/urdu/topics/:id", using: "WorldServiceUrduTopicPage", platform: "Simorgh", examples: ["/urdu/topics/c44pxlmy60mt", "/urdu/topics/c44pxlmy60mt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/urdu/topics/:id/rss.xml", using: "WorldServiceUrduTopicRss", platform: "Fabl", examples: ["/urdu/topics/c44pxlmy60mt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/urdu/articles/:id", using: "WorldServiceUrduArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/urdu/articles/:id.amp", using: "WorldServiceUrduArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/urdu/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/urdu/send/u39697902"]
  handle "/urdu/*any", using: "WorldServiceUrdu", platform: "MozartSimorgh", examples: ["/urdu"]

  redirect "/uzbek/mobile/*any", to: "/uzbek", status: 301

  handle "/uzbek.amp", using: "WorldServiceUzbek", platform: "MozartSimorgh", examples: ["/uzbek.amp"]
  handle "/uzbek.json", using: "WorldServiceUzbek", platform: "MozartSimorgh", examples: ["/uzbek.json"]
  handle "/uzbek/manifest.json", using: "WorldServiceUzbekAssets", platform: "Simorgh", examples: ["/uzbek/manifest.json"]
  handle "/uzbek/sw.js", using: "WorldServiceUzbekAssets", platform: "Simorgh", examples: ["/uzbek/sw.js"]
  handle "/uzbek/rss.xml", using: "WorldServiceUzbekHomePageRss", platform: "Karanga", examples: ["/uzbek/rss.xml"]

  handle "/uzbek/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/uzbek/topics/c340q0q55jvt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/uzbek/topics/:id", using: "WorldServiceUzbekTopicPage", platform: "Simorgh", examples: ["/uzbek/topics/c340q0q55jvt", "/uzbek/topics/c340q0q55jvt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/uzbek/topics/:id/rss.xml", using: "WorldServiceUzbekTopicRss", platform: "Fabl", examples: ["/uzbek/topics/c340q0q55jvt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/uzbek/articles/:id", using: "WorldServiceUzbekArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/uzbek/articles/:id.amp", using: "WorldServiceUzbekArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/uzbek/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/uzbek/send/u39697902"]
  handle "/uzbek/*any", using: "WorldServiceUzbek", platform: "MozartSimorgh", examples: ["/uzbek"]

  redirect "/vietnamese/mobile/*any", to: "/vietnamese", status: 301

  handle "/vietnamese.amp", using: "WorldServiceVietnamese", platform: "MozartSimorgh", examples: ["/vietnamese.amp"]
  handle "/vietnamese.json", using: "WorldServiceVietnamese", platform: "MozartSimorgh", examples: ["/vietnamese.json"]
  handle "/vietnamese/manifest.json", using: "WorldServiceVietnameseAssets", platform: "Simorgh", examples: ["/vietnamese/manifest.json"]
  handle "/vietnamese/sw.js", using: "WorldServiceVietnameseAssets", platform: "Simorgh", examples: ["/vietnamese/sw.js"]
  handle "/vietnamese/rss.xml", using: "WorldServiceVietnameseHomePageRss", platform: "Karanga", examples: ["/vietnamese/rss.xml"]

  handle "/vietnamese/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/vietnamese/topics/c340q0gkg4kt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/vietnamese/topics/:id", using: "WorldServiceVietnameseTopicPage", platform: "Simorgh", examples: ["/vietnamese/topics/c340q0gkg4kt", "/vietnamese/topics/c340q0gkg4kt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/vietnamese/topics/:id/rss.xml", using: "WorldServiceVietnameseTopicRss", platform: "Fabl", examples: ["/vietnamese/topics/c340q0gkg4kt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/vietnamese/articles/:id", using: "WorldServiceVietnameseArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/vietnamese/articles/:id.amp", using: "WorldServiceVietnameseArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/vietnamese/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/vietnamese/send/u39697902"]
  handle "/vietnamese/*any", using: "WorldServiceVietnamese", platform: "MozartSimorgh", examples: ["/vietnamese"]
  handle "/yoruba.amp", using: "WorldServiceYoruba", platform: "MozartSimorgh", examples: ["/yoruba.amp"]
  handle "/yoruba.json", using: "WorldServiceYoruba", platform: "MozartSimorgh", examples: ["/yoruba.json"]
  handle "/yoruba/manifest.json", using: "WorldServiceYorubaAssets", platform: "Simorgh", examples: ["/yoruba/manifest.json"]
  handle "/yoruba/sw.js", using: "WorldServiceYorubaAssets", platform: "Simorgh", examples: ["/yoruba/sw.js"]
  handle "/yoruba/rss.xml", using: "WorldServiceYorubaHomePageRss", platform: "Karanga", examples: ["/yoruba/rss.xml"]

  handle "/yoruba/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/yoruba/topics/c12jqpnxn44t/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/yoruba/topics/:id", using: "WorldServiceYorubaTopicPage", platform: "Simorgh", examples: ["/yoruba/topics/c12jqpnxn44t", "/yoruba/topics/c12jqpnxn44t?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/yoruba/topics/:id/rss.xml", using: "WorldServiceYorubaTopicRss", platform: "Fabl", examples: ["/yoruba/topics/c12jqpnxn44t/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/yoruba/articles/:id", using: "WorldServiceYorubaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/yoruba/articles/:id.amp", using: "WorldServiceYorubaArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/yoruba/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/yoruba/send/u39697902"]
  handle "/yoruba/*any", using: "WorldServiceYoruba", platform: "MozartSimorgh", examples: ["/yoruba"]

  redirect "/zhongwen/simp/mobile/*any", to: "/zhongwen/simp", status: 301
  redirect "/zhongwen/trad/mobile/*any", to: "/zhongwen/trad", status: 301

  handle "/zhongwen/manifest.json", using: "WorldServiceZhongwenAssets", platform: "Simorgh", examples: ["/zhongwen/manifest.json"]
  handle "/zhongwen/sw.js", using: "WorldServiceZhongwenAssets", platform: "Simorgh", examples: ["/zhongwen/sw.js"]
  handle "/zhongwen/simp/rss.xml", using: "WorldServiceZhongwenHomePageRss", platform: "Karanga", examples: ["/zhongwen/simp/rss.xml"]
  handle "/zhongwen/trad/rss.xml", using: "WorldServiceZhongwenHomePageRss", platform: "Karanga", examples: ["/zhongwen/trad/rss.xml"]

  handle "/zhongwen/simp/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/zhongwen/simp/topics/c0dg90z8nqxt/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end
  handle "/zhongwen/trad/topics/:id/page/:page", using: "WorldServiceTopicsRedirect", platform: "Simorgh", examples: [{"/zhongwen/trad/topics/cpydz21p02et/page/2", 302}] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/zhongwen/simp/topics/:id", using: "WorldServiceZhongwenTopicPage", platform: "Simorgh", examples: ["/zhongwen/simp/topics/c0dg90z8nqxt", "/zhongwen/simp/topics/c0dg90z8nqxt?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end
  handle "/zhongwen/trad/topics/:id", using: "WorldServiceZhongwenTopicPage", platform: "Simorgh", examples: ["/zhongwen/trad/topics/cpydz21p02et", "/zhongwen/trad/topics/cpydz21p02et?page=2"] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-3][0-9]|40|[1-9])\z/)
    ]
  end

  handle "/zhongwen/simp/topics/:id/rss.xml", using: "WorldServiceZhongwenTopicRss", platform: "Fabl", examples: ["/zhongwen/simp/topics/c0dg90z8nqxt/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end
  handle "/zhongwen/trad/topics/:id/rss.xml", using: "WorldServiceZhongwenTopicRss", platform: "Fabl", examples: ["/zhongwen/trad/topics/cpydz21p02et/rss.xml"] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/zhongwen/articles/:id/simp", using: "WorldServiceZhongwenArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/simp.amp", using: "WorldServiceZhongwenArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/trad", using: "WorldServiceZhongwenArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/trad.amp", using: "WorldServiceZhongwenArticlePage", platform: "Simorgh", examples: [] do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/zhongwen/send/:id", using: "UploaderWorldService", platform: "MorphRouter", examples: ["/zhongwen/send/u39697902"]
  handle "/zhongwen/*any", using: "WorldServiceZhongwen", platform: "MozartSimorgh", examples: ["/zhongwen/simp", "/zhongwen/trad", "/zhongwen/trad.json", "/zhongwen/trad.amp"]

  handle "/ws/languages", using: "WsLanguages", platform: "MozartNews", examples: ["/ws/languages"]
  handle "/ws/av-embeds/*any", using: "WsAvEmbeds", platform: "MozartNews", examples: []
  handle "/ws/includes/*any", using: "WsIncludes", platform: "MozartNews", examples: ["/ws/includes/include/vjamericas/176-eclipse-lookup/mundo/app/embed"]
  handle "/worldservice/assets/images/*any", using: "WsImages", platform: "MozartSimorgh", examples: [{"/worldservice/assets/images/2012/07/12/120712163431_img_0328.jpg", 301}]

  # /programmes

  handle "/programmes/articles/:key/:slug/contact", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/articles/49FbN1s7dwnWXBmHRGK308B/5-unforgettable-moments-from-the-semi-final/contact", 301}] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/articles/:key/:slug", using: "ProgrammesArticle", platform: "Programmes", examples: ["/programmes/articles/4xJyCpMp64NcCXD0FVlhmSz/frequently-asked-questions"] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/articles/:key", using: "ProgrammesArticle", platform: "Programmes", examples: [{"/programmes/articles/4xJyCpMp64NcCXD0FVlhmSz", 301}] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/a-z/current", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/a-z/current", 301}]

  handle "/programmes/a-z/by/:search/current", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/a-z/by/b/current", 301}] do
    return_404 if: !String.match?(search, ~r/^[a-zA-Z@]$/)
  end

  handle "/programmes/a-z/by/:search/:slice.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/a-z/by/b/all.json", "/programmes/a-z/by/b/player.json"] do
    return_404 if: [
      !String.match?(search, ~r/^[a-zA-Z@]$/),
      !Enum.member?(["all", "player"], slice),
    ]
  end

  handle "/programmes/a-z/by/:search.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/a-z/by/b.json"] do
    return_404 if: !String.match?(search, ~r/^[a-zA-Z@]$/)
  end

  handle "/programmes/a-z/by/:search/:slice", using: "Programmes", platform: "Programmes", examples: ["/programmes/a-z/by/b/all", "/programmes/a-z/by/b/player"] do
    return_404 if: [
      !String.match?(search, ~r/^[a-zA-Z@]$/),
      !Enum.member?(["all", "player"], slice),
    ]
  end

  handle "/programmes/a-z/by/:search", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/a-z/by/b", 301}] do
    return_404 if: !String.match?(search, ~r/^[a-zA-Z@]$/)
  end

  handle "/programmes/a-z/:slice.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/a-z/player.json", "/programmes/a-z/all.json"] do
    return_404 if: !Enum.member?(["all", "player"], slice)
  end

  handle "/programmes/a-z.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/a-z.json"]

  handle "/programmes/a-z", using: "Programmes", platform: "Programmes", examples: ["/programmes/a-z"]

  handle "/programmes/formats/:category/:slice", using: "Programmes", platform: "Programmes", examples: ["/programmes/formats/animation/all", "/programmes/formats/animation/player"] do
    return_404 if: !Enum.member?(["all", "player"], slice)
  end

  handle "/programmes/formats/:category", using: "Programmes", platform: "Programmes", examples: ["/programmes/formats/animation"]

  handle "/programmes/formats", using: "Programmes", platform: "Programmes", examples: ["/programmes/formats"]

  handle "/programmes/genres", using: "Programmes", platform: "Programmes", examples: ["/programmes/genres"]

  handle "/programmes/genres/*any", using: "Programmes", platform: "Programmes", examples: ["/programmes/genres/childrens", "/programmes/genres/comedy/sitcoms", "/programmes/genres/childrens/all", "/programmes/genres/childrens/player", "/programmes/genres/comedy/music/player", "/programmes/genres/comedy/music/all", "/programmes/genres/factual/scienceandnature/scienceandtechnology/player", "/programmes/genres/factual/scienceandnature/scienceandtechnology"]

  handle "/programmes/profiles/:key/:slug", using: "Programmes", platform: "Programmes", examples: ["/programmes/profiles/5NGNHQKKXGsFfnkxPBzKPMW/alistair-lloyd"] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/profiles/:key", using: "Programmes", platform: "Programmes", examples: [{"/programmes/profiles/23ca89bd-f35e-4803-bb86-c300c88afb2f", 301}, {"/programmes/profiles/5NGNHQKKXGsFfnkxPBzKPMW", 301}] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/snippet/:records_ids.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/snippet/n45bj5.json"]

  handle "/programmes/topics/:topic/:slice", using: "Programmes", platform: "Programmes", examples: [{"/programmes/topics/21st-century_American_non-fiction_writers/video", 301}, {"/programmes/topics/21st-century_American_non-fiction_writers/audio", 301}, {"/programmes/topics/Documentary_films_about_HIV/AIDS", 301}]

  handle "/programmes/topics/:topic", using: "Programmes", platform: "Programmes", examples: [{"/programmes/topics/Performers_of_Sufi_music", 301}]

  handle "/programmes/topics", using: "Programmes", platform: "Programmes", examples: [{"/programmes/topics", 301}]

  handle "/programmes/:pid/articles", using: "ProgrammesArticle", platform: "Programmes", examples: ["/programmes/b006m8dq/articles"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/broadcasts/:year/:month", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/b006qsq5/broadcasts/2020/01", 302}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/broadcasts", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/w172vkw6f1ffv5f/broadcasts", 302}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/children.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/b006m8dq/children.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/clips", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b045fz8r/clips"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/contact", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b006qj9z/contact"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/credits", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/b06ss3j4/credits", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/a-z/:az", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/b006qnmr/episodes/a-z/a", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/downloads.rss", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/p02nrw8y/episodes/downloads.rss", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/downloads", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/p02nrw8y/episodes/downloads"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/guide", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b006m8dq/episodes/guide"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/guide.2013inc", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/p02zmzss/episodes/guide.2013inc"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/last.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/b006m8dq/episodes/last.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/player", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b006m8dq/episodes/player"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/upcoming.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/b04drklx/episodes/upcoming.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/:year/:month.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/b006m8dq/episodes/2020/12.json"] do
    return_404 if: [
      !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/),
      !String.match?(year, ~r/^[1-2][0-9]{3}$/),
      !String.match?(month, ~r/^0?[1-9]|1[0-2]$/)
    ]
  end

  handle "/programmes/:pid/episodes.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/b006m8dq/episodes.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes", using: "ProgrammesEntity", platform: "Programmes", examples: [{"/programmes/b006m8dq/episodes", 302}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/galleries", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b045fz8r/galleries"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/members/all", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/p001rshg/members/all", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/members", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/p001rshg/members", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/microsite", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/p001rshg/microsite", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/player", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/p097pw9q/player"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/playlist.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/b08lkyzk/playlist.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/podcasts", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/p02nrw8y/podcasts", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/profiles", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b006qpgr/profiles"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/recipes.ameninc", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b006v5y2/recipes.ameninc"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/recipes.2013inc", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b006v5y2/recipes.2013inc"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/recipes", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b006v5y2/recipes"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/schedules", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/p02str2y/schedules", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/schedules/*any", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/p02str2y/schedules/2019/03/18", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/segments.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/b01m2fyy/segments.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/segments", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/b01m2fz4/segments", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/series.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/b006m8dq/series.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/series", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/b006m8dq/series", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/topics/:topic", using: "ProgrammesEntity", platform: "Programmes", examples: [{"/programmes/b00lvdrj/topics/1091_Media_films", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/topics", using: "ProgrammesEntity", platform: "Programmes", examples: [{"/programmes/b00lvdrj/topics", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid.html", using: "ProgrammesLegacy", platform: "Programmes", examples: [{"/programmes/b006m8dq.html", 301}] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid.json", using: "ProgrammesData", platform: "Programmes", examples: ["/programmes/b006m8dq.json"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/:imagepid", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/p028d9jw/p028d8nr"] do
    return_404 if: [
      !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/),
      !String.match?(imagepid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
    ]
  end

  handle "/programmes/:pid", using: "ProgrammesEntity", platform: "Programmes", examples: ["/programmes/b006m8dq"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes", using: "ProgrammesHomePage", platform: "Programmes", examples: ["/programmes"]

  # /programmes catch all
  handle "/programmes/*any", using: "Programmes", platform: "Programmes", examples: []

  # /schedules

  handle "/schedules/network/:network/on-now", using: "Schedules", platform: "Programmes", examples: [{"/schedules/network/bbcone/on-now", 302}] do
    return_404 if: !String.match?(network, ~r/^[a-zA-Z0-9]{2,35}$/)
  end

  handle "/schedules/network/:network", using: "Schedules", platform: "Programmes", examples: [{"/schedules/network/radioscotland", 301}] do
    return_404 if: !String.match?(network, ~r/^[a-zA-Z0-9]{2,35}$/)
  end

  handle "/schedules/:pid/*any", using: "Schedules", platform: "Programmes", examples: ["/schedules/p00fzl6v/2021/06/28", "/schedules/p05pkt1d/2020/w02", "/schedules/p05pkt1d/2020/01", {"/schedules/p05pkt1d/yesterday", 302}, "/schedules/p05pkt1d/2021"] do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/schedules", using: "Schedules", platform: "Programmes", examples: ["/schedules"]

  # /schedules catch all
  handle "/schedules/*any", using: "Schedules", platform: "Programmes", examples: []

  # Uploader

  handle "/send/:id", using: "Uploader", platform: "Webcore", examples: ["/send/u39697902"]

  # topics

  handle "/topics", using: "TopicPage", platform: "Webcore", examples: ["/topics"]

  handle "/topics/:id", using: "TopicPage", platform: "Webcore", examples: ["/topics/c583y7zk042t"] do
    return_404 if: [
      !is_tipo_id?(id),
      !integer_in_range?(conn.query_params["page"] || "1", 1..42)
    ]
  end

  handle "/topics/:id/rss.xml", using: "TopicRss", platform: "Fabl", examples: [] do
    # example "/topics/c57jjx4233xt/rss.xml" need "feeds.api.bbci.co.uk" as host
    return_404 if: !is_tipo_id?(id)
  end

  ## Live WebCore
  handle "/live/:asset_id", using: "Live", platform: "Webcore", only_on: "test", examples: ["/live/c1v596ken6vt", "/live/c1v596ken6vt?page=6"] do
    return_404 if: [
      !String.match?(asset_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}t$/), # TIPO IDs
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-4][0-9]|50|[1-9])\z/)
    ]
  end

  ## Live WebCore - .app route
  handle "/live/:asset_id.app", using: "Live",  platform: "Webcore", only_on: "test", examples: ["/live/cvpx5wr4nv8t.app", "/live/cvpx5wr4nv8t.app?page=6"] do
    return_404 if: [
      !String.match?(asset_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}t$/), # TIPO IDs
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-4][0-9]|50|[1-9])\z/)
    ]
  end

  # Weather
  redirect "/weather/0/*any", to: "/weather/*any", status: 301

  handle "/weather", using: "WeatherHomePage", platform: "MozartWeather", examples: ["/weather"]

  handle "/weather/search", using: "WeatherSearch", platform: "MozartWeather", examples: ["/weather/search?s=london"] do
    return_404 if: [
        !is_valid_length?(conn.query_params["s"] || "", 0..100),
        !integer_in_range?(conn.query_params["page"] || "1", 1..999)
      ]
  end

  handle "/weather/outlook", using: "Weather", platform: "MozartWeather", examples: ["/weather/outlook"]

  handle "/weather/map", using: "Weather", platform: "MozartWeather", examples: ["/weather/map"]

  redirect "/weather/warnings", to: "/weather/warnings/weather", status: 302
  handle "/weather/warnings/weather", using: "WeatherWarnings", platform: "MozartWeather", examples: ["/weather/warnings/weather"]
  handle "/weather/warnings/floods", using: "WeatherWarnings", platform: "MozartWeather", examples: ["/weather/warnings/floods"]

  redirect "/weather/coast_and_sea", to: "/weather/coast-and-sea", status: 301
  redirect "/weather/coast_and_sea/shipping_forecast", to: "/weather/coast-and-sea/shipping-forecast", status: 301
  handle "/weather/coast-and-sea/tide-tables", using: "WeatherCoastAndSea", platform: "MozartWeather", examples: ["/weather/coast-and-sea/tide-tables"]
  handle "/weather/coast-and-sea/tide-tables/:region_id", using: "WeatherCoastAndSea", platform: "MozartWeather", examples: ["/weather/coast-and-sea/tide-tables/1"] do
    return_404 if: !integer_in_range?(region_id, 1..12)
  end
  handle "/weather/coast-and-sea/tide-tables/:region_id/:tide_location_id", using: "WeatherCoastAndSea", platform: "MozartWeather", examples: ["/weather/coast-and-sea/tide-tables/1/111a"] do
    return_404 if: [
        !matches?(tide_location_id, ~r/^\d{1,4}[a-f]?$/),
        !integer_in_range?(region_id, 1..12)
      ]
  end
  handle "/weather/coast_and_sea/inshore_waters/:id", using: "WeatherCoastAndSea", platform: "MozartWeather", examples: []
  handle "/weather/coast-and-sea/*any", using: "WeatherCoastAndSea", platform: "MozartWeather", examples: ["/weather/coast-and-sea", "/weather/coast-and-sea/inshore-waters"]

  handle "/weather/error/:status", using: "Weather", platform: "MozartWeather", examples: ["/weather/error/404", "/weather/error/500"] do
    return_404 if: !integer_in_range?(status, [404, 500])
  end

  handle "/weather/language/:language", using: "WeatherLanguage", platform: "MozartWeather", examples: [{"/weather/language/en", 301}] do
    return_404(
      if: [
        !starts_with?(conn.query_params["redirect_location"] || "/weather", "/"),
        !is_language?(language)
      ]
    )
  end

  handle "/weather/about/:cps_id", using: "WeatherCps", platform: "MozartWeather", examples: [] do
    return_404 if: !integer_in_range?(cps_id, 1..999_999_999_999)
  end
  handle "/weather/features/:cps_id", using: "WeatherCps", platform: "MozartWeather", examples: [] do
    return_404 if: !integer_in_range?(cps_id, 1..999_999_999_999)
  end
  handle "/weather/feeds/:cps_id", using: "WeatherCps", platform: "MozartWeather", examples: [] do
    return_404 if: !integer_in_range?(cps_id, 1..999_999_999_999)
  end
  handle "/weather/forecast-video/:cps_id", using: "WeatherCps", platform: "MozartWeather", examples: [] do
    return_404 if: !integer_in_range?(cps_id, 1..999_999_999_999)
  end

  redirect "/weather/about", to: "/weather", status: 302
  redirect "/weather/features", to: "/weather", status: 302
  redirect "/weather/feeds", to: "/weather", status: 302
  redirect "/weather/forecast-video", to: "/weather", status: 302

  handle "/weather/av/:asset_id", using: "WeatherVideos", platform: "Webcore", examples: ["/weather/av/64475513"]

  handle "/weather/:location_id", using: "WeatherLocation", platform: "MozartWeather", examples: ["/weather/2650225"] do
    return_404 if: !matches?(location_id, ~r/^([a-z0-9]{1,50})$/)
  end
  handle "/weather/:location_id/:day", using: "WeatherLocation", platform: "MozartWeather", examples: ["/weather/2650225/today"] do
    return_404 if: [
      !matches?(location_id, ~r/^([a-z0-9]{1,50})$/),
      !matches?(day, ~r/^(none|today|tomorrow|day([1][0-3]|[0-9]))$/)
    ]
  end

  # WebCore Hub
  redirect "/webcore/*any", to: "https://hub.webcore.tools.bbc.co.uk/webcore/*any", status: 302

  # News Beat

  redirect "/newsbeat/:asset_id", to: "/news/newsbeat-:asset_id", status: 301
  redirect "/newsbeat/articles/:asset_id", to: "/news/newsbeat-:asset_id", status: 301
  redirect "/newsbeat/article/:asset_id/:slug", to: "/news/newsbeat-:asset_id", status: 301
  redirect "/newsbeat", to: "/news/newsbeat", status: 301

  # BBC Optimo Articles
  redirect "/articles", to: "/", status: 302

  handle "/articles/:optimo_id", using: "StorytellingPage", platform: "Webcore", examples: ["/articles/c1vy1zrejnno"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  # Catch all

  # example test route: "/comments/embed/news/world-europe-23348005"
  handle "/comments/embed/*any", using: "CommentsEmbed", platform: "MozartWeather", examples: []

  handle "/web/shell", using: "WebShell", platform: "Webcore", examples: ["/web/shell"]

  handle "/my/session", using: "MySession", platform: "OriginSimulator", only_on: "test", examples: []

  handle "/scotland/articles/*any", using: "ScotlandArticles", platform: "MozartNews", examples: []
  # TODO this may not be an actual required route
  handle "/scotland/*any", using: "Scotland", platform: "MozartNews", examples: []

  handle "/archive/articles/*any", using: "ArchiveArticles", platform: "MozartNews", examples: ["/archive/articles/sw.js"]
  # TODO this may not be an actual required route e.g. archive/collections-transport-and-travel/zhb9f4j showing as Morph Router
  handle "/archive/*any", using: "Archive", platform: "MozartNews", examples: []

  # Newsround
  redirect "/newsround/amp/:id", to: "/newsround/:id.amp", status: 301
  handle "/newsround/:id.amp", using: "NewsroundAmp", platform: "MozartNews", examples: ["/newsround/61545299.amp"]
  handle "/newsround/:id.json", using: "NewsroundAmp", platform: "MozartNews", examples: ["/newsround/61545299.json"]
  handle "/newsround/articles/manifest.json", using: "NewsroundAmp", platform: "MozartNews", examples: ["/newsround/articles/manifest.json"]

  handle "/newsround/news/watch_newsround", using: "NewsroundVideoPage", platform: "Webcore", examples: ["/newsround/news/watch_newsround"]
  handle "/newsround/news/newsroundbsl", using: "NewsroundVideoPage", platform: "Webcore", examples: ["/newsround/news/newsroundbsl"]

  redirect "/newsround/news", to: "/newsround", status: 301
  redirect "/newsround/news/*_any", to: "/newsround", status: 301

  redirect "/newsround/rss.xml", to: "http://feeds.bbci.co.uk/newsround/rss.xml", status: 301
  redirect "/newsround/rss.xml/*_any", to: "http://feeds.bbci.co.uk/newsround/rss.xml", status: 301
  redirect "/newsround/home", to: "/newsround", status: 301
  redirect "/newsround/animals", to: "/newsround", status: 301
  redirect "/newsround/animals/*_any", to: "/newsround", status: 301
  redirect "/newsround/entertainment", to: "/newsround", status: 301
  redirect "/newsround/entertainment/*_any", to: "/newsround", status: 301
  redirect "/newsround/front_page", to: "/newsround", status: 301
  redirect "/newsround/front_page/*_any", to: "/newsround", status: 301
  redirect "/newsround/sport", to: "/newsround", status: 301
  redirect "/newsround/sport/*_any", to: "/newsround", status: 301
  redirect "/newsround/video_and_audio", to: "/newsround", status: 301
  redirect "/newsround/video_and_audio/*_any", to: "/newsround", status: 301
  redirect "/newsround/mentalhealth", to: "/newsround/44074706", status: 301
  redirect "/newsround/mentalhealth/*_any", to: "/newsround/44074706", status: 301
  redirect "/newsround/beta/*_any", to: "/newsround", status: 301

  handle "/newsround/av/:id", using: "NewsroundVideoPage", platform: "Webcore", examples: ["/newsround/av/43245617"]
  handle "/newsround/:id", using: "NewsroundArticlePage", platform: "Webcore", only_on: "test", examples: ["/newsround/61545299"]
  handle "/newsround", using: "NewsroundHomePage", platform: "Webcore", examples: ["/newsround"]
  handle "/newsround/*any", using: "NewsroundLegacy", platform: "MorphRouter", only_on: "live", examples: ["/newsround/61545299"]

  handle "/schoolreport/*any", using: "Schoolreport", platform: "MozartNews", examples: [{"/schoolreport", 301}, {"/schoolreport/home", 301}]

  handle "/wide/*any", using: "Wide", platform: "MozartNews", examples: []

  handle "/archivist/*any", using: "Archivist", platform: "MozartNews", examples: []

  # TODO /proms/extra
  handle "/proms/*any", using: "Proms", platform: "MozartNews", examples: []

  handle "/music", using: "Music", platform: "MozartNews", examples: []

  # Bitesize
  redirect "/bitesize/guides/:id", to: "/bitesize/guides/:id/revision/1", status: 301
  redirect "/bitesize/guides/:id/revision", to: "/bitesize/guides/:id/revision/1", status: 301

  redirect "/bitesize/preview/guides/:id", to: "/bitesize/preview/guides/:id/revision/1", status: 301
  redirect "/bitesize/preview/guides/:id/revision", to: "/bitesize/preview/guides/:id/revision/1", status: 301

  handle "/bitesize/preview/secondary", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/secondary"]

  handle "/bitesize/subjects", using: "Bitesize", platform: "Webcore", examples: ["/bitesize/subjects"]
  handle "/bitesize/subjects/:id", using: "BitesizeSubjects", platform: "MorphRouter", examples: ["/bitesize/subjects/z8tnvcw", "/bitesize/subjects/zbhy4wx"]
  handle "/bitesize/subjects/:id/year/:year_id", using: "BitesizeSubjects", platform: "MorphRouter", examples: ["/bitesize/subjects/zjxhfg8/year/zjpqqp3"]

  handle "/bitesize/preview/subjects/:id", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/subjects/z8tnvcw", "/bitesize/preview/subjects/zbhy4wx"]
  handle "/bitesize/preview/subjects/:id/year/:year_id", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/subjects/zjxhfg8/year/zjpqqp3"]

  handle "/bitesize/courses/:id", using: "BitesizeTransition", platform: "Webcore", only_on: "test", examples: ["/bitesize/courses/zdcg3j6"]

  handle "/bitesize/articles/:id", using: "BitesizeArticles", platform: "MorphRouter", examples: ["/bitesize/articles/zjykkmn"]
  handle "/bitesize/topics/:topic_id/articles/:id", using: "BitesizeArticles", platform: "MorphRouter", examples: ["/bitesize/topics/zmhxjhv/articles/zwdtrwx"]

  handle "/bitesize/preview/articles/:id", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/articles/zj8yydm"]
  handle "/bitesize/preview/articles/:id/:game_version", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/articles/zj8yydm/latest"]
  handle "/bitesize/preview/topics/:topic_id/articles/:id", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/topics/zmhxjhv/articles/zwdtrwx"]


  handle "/bitesize/levels/:id", using: "BitesizeLevels", platform: "MorphRouter", examples: ["/bitesize/levels/zr48q6f"]
  handle "/bitesize/levels/:id/year/:year_id", using: "BitesizeLevels", platform: "MorphRouter", examples: ["/bitesize/levels/z3g4d2p/year/zmyxxyc"]

  handle "/bitesize/preview/levels/:id", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/levels/zgckjxs"]
  handle "/bitesize/preview/levels/:id/year/:year_id", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/levels/zbr9wmn/year/zmyxxyc"]

  handle "/bitesize/guides/:id/revision/:page", using: "BitesizeGuides", platform: "MorphRouter", examples: ["/bitesize/guides/zw3bfcw/revision/1"]
  handle "/bitesize/guides/:id/test", using: "BitesizeGuides", platform: "MorphRouter", examples: ["/bitesize/guides/zw7xfcw/test"]
  handle "/bitesize/guides/:id/audio", using: "BitesizeGuides", platform: "MorphRouter", examples: ["/bitesize/guides/zwsffg8/audio"]
  handle "/bitesize/guides/:id/video", using: "BitesizeGuides", platform: "MorphRouter", examples: ["/bitesize/guides/zcvy6yc/video"]

  handle "/bitesize/preview/guides/:id/revision/:page", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/guides/zw3bfcw/revision/1"]
  handle "/bitesize/preview/guides/:id/test", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/guides/zw7xfcw/test"]
  handle "/bitesize/preview/guides/:id/audio", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/guides/zwsffg8/audio"]
  handle "/bitesize/preview/guides/:id/video", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/guides/zcvy6yc/video"]

  handle "/bitesize/topics/:id", using: "BitesizeTopics", platform: "BitesizeTopicsPlatformSelector", examples: ["/bitesize/topics/z82hsbk"]
  handle "/bitesize/topics/:id/year/:year_id", using: "BitesizeTopics", platform: "BitesizeTopicsPlatformSelector", examples: ["/bitesize/topics/zwv39j6/year/zjpqqp3"]

  handle "/bitesize/preview/topics/:id", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/topics/z82hsbk"]
  handle "/bitesize/preview/topics/:id/year/:year_id", using: "Bitesize", platform: "Webcore", only_on: "test", examples: ["/bitesize/preview/topics/zwv39j6/year/zjpqqp3"]
  handle "/bitesize/guides/:id/test.hybrid", using: "BitesizeLegacy", platform: "MorphRouter", examples: ["/bitesize/guides/zcvy6yc/test.hybrid"]
  handle "/bitesize/groups/:id", using: "BitesizeTipoTopic", platform: "Webcore", only_on: "test", examples: ["/bitesize/groups/cz4wkv77g55t"]

  handle "/bitesize/*any", using: "BitesizeLegacy", platform: "MorphRouter", examples: ["/bitesize/levels"]


  # Games
  handle "/games/*any", using: "Games", platform: "Webcore", examples: ["/games/embed/genie-starter-pack"]


  # Classic Apps

  handle "/content/trending/events", using: "ClassicApp", platform: "ClassicApps", examples: [] do
    return_404 if: true
  end
  handle "/content/cps/news/front_page", using: "ClassicAppNewsFrontpage", platform: "ClassicApps", examples: ["/content/cps/news/front_page"]
  handle "/content/cps/news/live/*any", using: "ClassicAppNewsLive", platform: "ClassicApps", examples: ["/content/cps/news/live/world-africa-47639452"]
  handle "/content/cps/news/av/*any", using: "ClassicAppNewsAv", platform: "ClassicApps", examples: []
  handle "/content/cps/news/articles/*any", using: "ClassicAppNewsArticles", platform: "ClassicApps", examples: []
  handle "/content/cps/news/video_and_audio/*any", using: "ClassicAppNewsAudioVideo", platform: "ClassicApps", examples: ["/content/cps/news/video_and_audio/ten_to_watch", "/content/cps/news/video_and_audio/top_stories"]
  handle "/content/cps/news/*any", using: "ClassicAppNewsCps", platform: "ClassicApps", examples: ["/content/cps/news/uk-england-london-59333481"]

  handle "/content/cps/sport/front-page", using: "ClassicAppSportFrontpage", platform: "ClassicApps", examples: ["/content/cps/sport/front-page"]
  handle "/content/cps/sport/live/*any", using: "ClassicAppSportLive", platform: "ClassicApps", examples: ["/content/cps/sport/live/football/59369278", "/content/cps/sport/live/formula1/58748830"]
  handle "/content/cps/sport/football/*any", using: "ClassicAppSportFootball", platform: "ClassicApps", examples: ["/content/cps/sport/football/59372826", "/content/cps/sport/football/58643317"]
  handle "/content/cps/sport/av/football/*any", using: "ClassicAppSportFootballAv", platform: "ClassicApps", examples: ["/content/cps/sport/av/football/59346509"]
  handle "/content/cps/sport/*any", using: "ClassicAppSportCps", platform: "ClassicApps", examples: ["/content/cps/sport/rugby-union/59369204", "/content/cps/sport/tennis/59328440"]

  handle "/content/cps/newsround/*any", using: "ClassicAppNewsround", platform: "ClassicApps", examples: ["/content/cps/newsround/45274517"]
  handle "/content/cps/naidheachdan/*any", using: "ClassicAppNaidheachdan", platform: "ClassicApps", examples: ["/content/cps/naidheachdan/59371990", "/content/cps/naidheachdan/front_page", "/content/cps/naidheachdan/dachaigh"]
  handle "/content/cps/mundo/*any", using: "ClassicAppMundo", platform: "ClassicApps", examples: ["/content/cps/mundo/vert-cap-59223070?createdBy=mundo&language=es", "/content/cps/mundo/noticias-59340165?createdBy=mundo&language=es"]
  handle "/content/cps/arabic/*any", using: "ClassicAppArabic", platform: "ClassicApps", examples: ["/content/cps/arabic/live/53833263?createdBy=arabic&language=ar", "/content/cps/arabic/art-and-culture-59307957?createdBy=arabic&language=ar"]
  handle "/content/cps/russian/*any", using: "ClassicAppRussianCps", platform: "ClassicApps", examples: ["/content/cps/russian/front_page?createdBy=russian&language=ru", "/content/cps/russian/news?createdBy=russian&language=ru", "/content/cps/russian/features-58536209?createdBy=russian&language=ru"]
  handle "/content/cps/hindi/*any", using: "ClassicAppHindi", platform: "ClassicApps", examples: ["/content/cps/hindi/india?createdBy=hindi&language=hi", "/content/cps/hindi/india-59277161?createdBy=hindi&language=hi"]
  handle "/content/cps/learning_english/*any", using: "ClassicAppLearningEnglish", platform: "ClassicApps", examples: ["/content/cps/learning_english/home", "/content/cps/learning_english/6-minute-english-59142810"]
  handle "/content/cps/:product/*any", using: "ClassicAppProducts", platform: "ClassicApps", examples: []
  handle "/content/cps/*any", using: "ClassicAppCps", platform: "ClassicApps", examples: []

  handle "/content/ldp/:guid", using: "ClassicAppFablLdp", platform: "Fabl", examples: ["/content/ldp/de648736-7268-454c-a7b1-dbff416f2865"]
  handle "/content/most_popular/*any", using: "ClassicAppMostPopular", platform: "ClassicApps", examples: ["/content/most_popular/news"]
  handle "/content/ww/*any", using: "ClassicAppWw", platform: "ClassicApps", examples: []
  handle "/content/news/*any", using: "ClassicAppNews", platform: "ClassicApps", examples: []
  handle "/content/sport/*any", using: "ClassicAppSport", platform: "ClassicApps", examples: []
  handle "/content/russian/*any", using: "ClassicAppRussian", platform: "ClassicApps", examples: []
  handle "/content/:hash", using: "ClassicAppId", platform: "ClassicApps", examples: []
  handle "/content/:service/*any", using: "ClassicAppService", platform: "ClassicApps", examples: []
  handle "/content/*any", using: "ClassicApp", platform: "ClassicApps", examples: []
  handle "/static/*any", using: "ClassicAppStaticContent", platform: "ClassicApps", examples: ["/static/LE/android/1.5.0/config.json", "/static/MUNDO/ios/5.19.0/layouts.zip"]
  handle "/flagpoles/*any", using: "ClassicAppFlagpole", platform: "ClassicApps", examples: ["/flagpoles/ads"]


  # Platform Health Observability endpoints for response time monitoring of Webcore platform
  handle "/_health/public_content", using: "PhoPublicContent", platform: "Webcore", examples: ["/_health/public_content"]
  handle "/_health/private_content", using: "PhoPrivateContent", platform: "Webcore", examples: ["/_health/private_content"]

  # handle "/news/business-:id", using: ["NewsStories", "NewsSFV", "MozartNews"], examples: ["/"]
  # handle "/news/business-:id", using: ["NewsBusiness", "MozartNews"], examples: ["/"]

  handle "/full-stack-test/a/*any", using: "FullStackTestA", platform: "Webcore", only_on: "test", examples: []
  handle "/full-stack-test/b/*any", using: "FullStackTestB", platform: "Webcore", only_on: "test", examples: []
  redirect "/full-stack-test/*any", to: "/full-stack-test/a/*any", status: 302

  handle "/echo", using: "EchoSpec", platform: "Webcore", only_on: "test", examples: ["/echo"]

  handle_proxy_pass "/*any", using: "ProxyPass", platform: "OriginSimulator", only_on: "test", examples: ["/foo/bar"]

  no_match()
end
