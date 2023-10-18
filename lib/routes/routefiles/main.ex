#
# How to add a route:
# docs/topics/routing/routing.md#how-to-add-a-route
# What types of route matcher you can  use:
# docs/topics/routing/route-matcher-types.md
#
# How to validate a route:
# lib/belfrage_web/validators.ex
#

import BelfrageWeb.Routefile

defroutefile "Main" do
  redirect "/news/0", to: "/news", status: 302
  redirect "/news/2/hi", to: "/news", status: 302
  redirect "/news/mobile", to: "/news", status: 302
  redirect "/news/popular/read", to: "/news", status: 302

  redirect "/news/contact-us/editorial", to: "/news/55077304", status: 302
  redirect "/news/contact-us/school-report-feedback", to: "/teach/young-reporter/what-is-bbc-young-reporter/z6ncf82", status: 301
  redirect "/news/contact-us/school-report-subscribe", to: "/send/u58606905", status: 301

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
  redirect "/news/election/2023/northern-ireland", to: "/news/election/2023/northern-ireland/results", status: 302

  redirect "https://www.bbc.com/ukraine", to: "https://www.bbc.com/ukrainian", status: 302
  redirect "https://www.bbc.co.uk/ukraine", to: "/news/world-60525350", status: 302
  redirect "https://www.test.bbc.com/ukraine", to: "https://www.test.bbc.com/ukrainian", status: 302
  redirect "https://www.test.bbc.co.uk/ukraine", to: "/news/world-60525350", status: 302

  # News - Indian Sports Woman of The Year
  redirect "/news/iswoty", to: "/news/resources/idt-c01e87cf-898c-4ec6-86ea-5ef77f9e58a0", status: 302

  # Home Page
  redirect "/ni", to: "/northernireland", status: 302

  handle "/", using: "HomePage"
  handle "/scotland", using: "ScotlandHomePage"
  handle "/homepage/test", using: "TestHomePage", only_on: "test"
  handle "/homepage/automation", using: "AutomationHomePage", only_on: "test"
  handle "/northernireland", using: "NorthernIrelandHomePage"
  handle "/wales", using: "WalesHomePage"
  handle "/cymru", using: "CymruHomePage"
  handle "/alba", using: "AlbaHomePage"

  handle "/newstipo", using: "NewsTipoHomePage", only_on: "test"

  handle "/weathertipo", using: "WeatherTipoHomePage", only_on: "test"
  handle "/homepage/weather/test", using: "TestWeatherHomePage", only_on: "test"

  handle "/homepage/news/preview", using: "NewsHomePagePreview", only_on: "test"
  handle "/homepage/news/test", using: "TestNewsHomePage", only_on: "test"
  handle "/homepage/index-examples", using: "IndexExamplesHomePage", only_on: "test"

  handle "/homepage/preview", using: "HomePagePreview"
  handle "/homepage/preview/scotland", using: "HomePagePreviewScotland"
  handle "/homepage/preview/wales", using: "HomePagePreviewWales"
  handle "/homepage/preview/northernireland", using: "HomePagePreviewNorthernIreland"
  handle "/homepage/preview/cymru", using: "HomePagePreviewCymru"
  handle "/homepage/preview/alba", using: "HomePagePreviewAlba"
  handle "/homepage/newsround/preview", using: "NewsroundHomePagePreview"

  handle "/homepage/sport/preview", using: "SportHomePagePreview"
  handle "/homepage/sport/test", using: "TestSportHomePage", only_on: "test"

  # data endpoints

  handle "/fd/p/mytopics-page", using: "MyTopicsPage"
  handle "/fd/p/mytopics-follows", using: "MyTopicsFollows"

  handle "/fd/p/preview/:name", using: "PersonalisedFablData", only_on: "test" do
    return_404 if: name not in [
      "mytopics-page",
      "mytopics-follows"
    ]
  end

  handle "/fd/preview/abl", using: "AblDataPreview"

  handle "/fd/preview/:name", using: "FablData" do
    return_404 if:
      name not in [
        "app-article-api",
        "curriculum-data",
        "game",
        "simorgh-bff",
        "topic-mapping"
      ]
      and !String.match?(name, ~r/^sport-app-[a-z0-9-]+$/)
      and !String.match?(name, ~r/^spike-app-[a-z0-9-]+$/)
  end

  handle "/fd/abl", using: "AblData"

  handle "/fd/sport-app-allsport", using: "SportData"
  handle "/fd/sport-app-followables", using: "SportData"
  handle "/fd/sport-app-images", using: "SportData"
  handle "/fd/sport-app-menu", using: "SportData"
  handle "/fd/sport-app-notification-data", using: "SportData"
  handle "/fd/sport-app-page", using: "SportData"
  handle "/fd/topic-mapping", using: "SportData"

  handle "/fd/:name", using: "FablData" do
    return_404 if: name not in [
      "app-article-api",
      "curriculum-data",
      "game",
      "simorgh-bff",
      "sport-app-remote-config"
    ]
  end

  handle "/wc-data/container/:name", using: "ContainerData"
  handle "/wc-data/p/container/onward-journeys", using: "PersonalisedContainerData"
  handle "/wc-data/p/container/simple-promo-collection", using: "PersonalisedContainerData"
  handle "/wc-data/p/container/test-client-side-personalised", using: "PersonalisedContainerData", only_on: "test"
  handle "/wc-data/p/container/:name", using: "ContainerData"
  handle "/wc-data/page-composition", using: "PageComposition"

  # Search

  handle "/search", using: "Search"
  handle "/chwilio", using: "WelshSearch"
  handle "/cbeebies/search", using: "Search"
  handle "/cbbc/search", using: "Search"
  handle "/bitesize/search", using: "Search"

  # News

  redirect "/news/articles", to: "/news", status: 302

  ## News - Mobile Redirect
  redirect "/news/mobile/*any", to: "/news", status: 301

  handle "/news", using: "NewsHomePage"

  handle "/news/breaking-news/audience", using: "BreakingNews" do
    return_404 if: true
  end

  handle "/news/breaking-news/audience/:audience", using: "BreakingNews" do
    return_404 if: [
      !String.match?(audience, ~r/^(domestic|us|international|asia)$/)
    ]
  end

  handle "/news/election/2023/northern-ireland/results", using: "NewsNiElectionResults"

  handle "/news/election/2023/:polity/results", using: "NewsElectionResults"  do
    return_404 if: [
                 !String.match?(polity, ~r/^(england)$/)
               ]
  end

  handle "/news/election/2023/:polity/councils", using: "NewsElectionResults" do
    return_404 if: [
      !String.match?(polity, ~r/^(england)$/)
    ]
  end

  handle "/news/election/2023/northern-ireland/councils/:gss_id", using: "NewsNiElectionResults" do
    return_404 if: [
      !String.match?(gss_id, ~r/^[A-Z][0-9]{8}$/)
    ]
  end

  handle "/news/election/2023/:polity/councils/:gss_id", using: "NewsElectionResults" do
    return_404 if: [
      !String.match?(polity, ~r/^(england|northern-ireland)$/),
      !String.match?(gss_id, ~r/^[A-Z][0-9]{8}$/)
    ]
  end

  handle "/news/election/2022/us/results", using: "NewsElectionResults"

  handle "/news/election/2022/us/states/:state_id", using: "NewsElectionResults" do
    return_404 if: [
      !String.match?(state_id, ~r/^[a-z]{2}$/)
    ]
  end

  handle "/news/election/2022/usa/midterms-test", using: "NewsElectionResults", only_on: "test"

  handle "/news/election/2021/:polity/results", using: "NewsElection2021" do
    return_404 if: [
                 !String.match?(polity, ~r/^(england|scotland|wales)$/)
               ]
  end

  handle "/news/election/2021/:polity/:division_name", using: "NewsElection2021" do
    return_404 if: [
      !String.match?(polity, ~r/^(england|scotland|wales)$/),
      !String.match?(division_name, ~r/^(councils|constituencies)$/),
    ]
  end

  handle "/news/election/2021/england/:division_name/:division_id", using: "NewsElection2021" do
    return_404 if: [
      !String.match?(division_name, ~r/^(councils|mayors)$/),
      !String.match?(division_id, ~r/^[E][0-9]{8}$/),
    ]
  end

  handle "/news/election/2021/:polity/:division_name/:division_id", using: "NewsElection2021" do
    return_404 if: [
      !String.match?(polity, ~r/^(scotland|wales)$/),
      !String.match?(division_name, ~r/^(regions|constituencies)$/),
      !String.match?(division_id, ~r/^[SW][0-9]{8}$/)
    ]
  end

  handle "/news/election/2017/northern-ireland/results", using: "NewsElectionResults", only_on: "test"

  handle "/news/election/2022/:polity/results", using: "NewsElectionResults" do
    return_404 if: [
                 !String.match?(polity, ~r/^(england|scotland|wales|northern-ireland)$/)
               ]
  end

  handle "/news/election/2017/northern-ireland/constituencies", using: "NewsElectionResults", only_on: "test"

  handle "/news/election/2022/:polity/:division_name", using: "NewsElectionResults" do
    return_404 if: [
       !String.match?(polity, ~r/^(england|scotland|wales|northern-ireland)$/),
       !String.match?(division_name, ~r/^(constituencies|councils)$/)
    ]
  end

  handle "/news/election/2017/northern-ireland/constituencies/:division_id", using: "NewsElectionResults", only_on: "test" do
    return_404 if: [
                 !String.match?(division_id, ~r/^[N][0-9]{8}$/)
               ]
  end

  handle "/news/election/2022/:polity/:division_name/:division_id", using: "NewsElectionResults" do

    return_404 if: [
                 !String.match?(polity, ~r/^(northern-ireland|england|wales|scotland)$/),
                 !String.match?(division_name, ~r/^(constituencies|councils|mayors)$/),
                 !String.match?(division_id, ~r/^[NSWE][0-9]{8}$/)
               ]
  end

  handle "/news/election/2019/uk/results", using: "NewsElectionResults", only_on: "test"

  handle "/news/election/2019/uk/constituencies", using: "NewsElectionResults", only_on: "test"

  handle "/news/election/2019/uk/constituencies/:division_id", using: "NewsElectionResults", only_on: "test" do
    return_404 if: [
      !String.match?(division_id, ~r/^[NSWE][0-9]{8}$/)
    ]
  end

  handle "/news/election/2019/uk/regions/:division_id", using: "NewsElectionResults", only_on: "test" do
    return_404 if: [
      !String.match?(division_id, ~r/^(E92000001|W92000004|S92000003|N92000002)$/)
    ]
  end

  redirect "/news/16630456", to: "/news/events/scotland-decides", status: 301
  redirect "/news/uk-politics-33256201", to: "/news/politics/eu_referendum", status: 301
  redirect "/news/election-2017-39946901", to: "/news/election-2019-50459517", status: 301
  redirect "/news/election/2015/live", to: "/news/live/election-2015-32753161", status: 301

  handle "/news/election/2015", using: "NewsWebcoreIndex"
  handle "/news/election/2015/england", using: "NewsWebcoreIndex"
  handle "/news/election/2015/northern_ireland", using: "NewsWebcoreIndex"
  handle "/news/election/2015/wales", using: "NewsWebcoreIndex"
  handle "/news/election/2015/scotland", using: "NewsWebcoreIndex"
  handle "/news/election/2016", using: "NewsWebcoreIndex"
  handle "/news/election/2016/london", using: "NewsWebcoreIndex"
  handle "/news/election/2016/northern_ireland", using: "NewsWebcoreIndex"
  handle "/news/election/2016/scotland", using: "NewsWebcoreIndex"
  handle "/news/election/2016/wales", using: "NewsWebcoreIndex"
  handle "/news/election/2017", using: "NewsWebcoreIndex"
  handle "/news/election/ni2017", using: "NewsWebcoreIndex"
  handle "/news/election/us2016", using: "NewsWebcoreIndex"

  handle "/news/election/*any", using: "NewsElection"

  ### News BBC Live - CPS & TIPO - No Discipline
  handle "/news/live/:asset_id", using: "NewsLive" do
    return_404 if: [
      !(is_tipo_id?(asset_id) or is_cps_id?(asset_id)),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50),
      !(is_nil(conn.query_params["post"]) or is_asset_guid?(conn.query_params["post"])),
    ]
  end

  ### News BBC Live - CPS - Page Number
  handle "/news/live/:asset_id/page/:page_number", using: "NewsLive" do
    return_404 if: [
      !is_cps_id?(asset_id),
      !integer_in_range?(page_number || "1", 1..50),
    ]
  end

  ### News BBC Live - TIPO - .app route (not available on Morph news)
  handle "/news/live/:asset_id.app", using: "NewsLive" do
    return_404 if: [
      !(is_tipo_id?(asset_id)),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50),
      !(is_nil(conn.query_params["post"]) or is_asset_guid?(conn.query_params["post"])),
    ]
  end

  # Local News
  handle "/news/localnews", using: "NewsLocalNews"
  # this route goes to mozart and 500s on live, may be we should remove it?
  handle "/news/localnews/locations/sitemap.xml", using: "NewsLocalNews"
  handle "/news/localnews/:location_id_and_name/*_radius", using: "NewsLocalNewsRedirect"

  # News Indexes
  redirect "/news/topics/c05pg0wvm83t/*any", to: "/news/wales", status: 301
  redirect "/news/topics/c05pgvdm849t/*any", to: "/news/world/europe", status: 301
  redirect "/news/topics/cwgdj57820vt/*any", to: "/news/world/africa", status: 301
  redirect "/news/topics/ck71r1x591xt/*any", to: "/news/england", status: 301
  redirect "/news/topics/c05p9vgdr6pt/*any", to: "/news/world/middle_east", status: 301
  redirect "/news/topics/cp35rmprpn5t/*any", to: "/news/world/us_and_canada", status: 301
  redirect "/news/topics/c43v1n0wl83t/*any", to: "/news/scotland", status: 301
  redirect "/news/topics/cv5j55kq5p6t/*any", to: "/news/world/europe/guernsey", status: 301
  redirect "/news/topics/c97e7xl514xt/*any", to: "/news/england/cornwall", status: 301
  redirect "/news/topics/cr1k15w1vk6t/*any", to: "/news/england/birmingham_and_black_country", status: 301
  redirect "/news/topics/cnlklx5gl9rt/*any", to: "/news/england/dorset", status: 301
  redirect "/news/topics/czpqpg9jzjkt/*any", to: "/news/england/essex", status: 301
  redirect "/news/topics/c13r3338vlpt/*any", to: "/news/england/berkshire", status: 301
  redirect "/news/topics/cnlkl1gkn5jt/*any", to: "/news/england/coventry_and_warwickshire", status: 301
  redirect "/news/topics/cwvgv34x7vxt/*any", to: "/news/england/gloucestershire", status: 301
  redirect "/news/topics/cr1k11ryy55t/*any", to: "/news/england/hampshire", status: 301
  redirect "/news/topics/czpqp47g86pt/*any", to: "/news/england/cumbria", status: 301
  redirect "/news/topics/cr1k15gr6gnt/*any", to: "/news/england/derbyshire", status: 301
  redirect "/news/topics/ckrkrnv7yqzt/*any", to: "/news/england/bristol", status: 301
  redirect "/news/topics/cq6k679g9l6t/*any", to: "/news/england/cambridgeshire", status: 301
  redirect "/news/topics/cezkzgl6858t/*any", to: "/news/england/devon", status: 301
  redirect "/news/topics/cnjn674nvdvt/*any", to: "/news/world", status: 301
  redirect "/news/topics/cwrw9n0dgp5t/*any", to: "/news/england/hereford_and_worcester", status: 301
  redirect "/news/topics/czpxgx8070wt/*any", to: "/news/uk", status: 301
  redirect "/news/topics/c7p3v5qzg01t/*any", to: "/news/england/lancashire", status: 301
  redirect "/news/topics/c8654v3gj5xt/*any", to: "/news/the_reporters", status: 301
  redirect "/news/topics/ceq8p90z9xpt/*any", to: "/news/england/manchester", status: 301
  redirect "/news/topics/c893vgw19q1t/*any", to: "/news/england/lincolnshire", status: 301
  redirect "/news/topics/c383j9k4qd8t/*any", to: "/news/england/merseyside", status: 301
  redirect "/news/topics/cezdel3r8q0t/*any", to: "/news/world/europe/isle_of_man", status: 301
  redirect "/news/topics/cjn6w9x7j9wt/*any", to: "/news/business", status: 301
  redirect "/news/topics/c4dldkkz1net/*any", to: "/news/business/global_car_industry", status: 301
  redirect "/news/topics/cvrl962gz9xt/*any", to: "/news/politics", status: 301
  redirect "/news/topics/cvrl2wn3063t/*any", to: "/news/politics/uk_leaves_the_eu", status: 301
  redirect "/news/topics/cvrl9jzx0r5t/*any", to: "/news/technology", status: 301
  redirect "/news/topics/c43v9644301t/*any", to: "/news/science_and_environment", status: 301
  redirect "/news/topics/c902n88xrgwt/*any", to: "/news/health", status: 301
  redirect "/news/topics/cwgdx0ppwnzt/*any", to: "/news/education", status: 301
  redirect "/news/topics/cvrl9j39l8pt/*any", to: "/news/entertainment_and_arts", status: 301
  redirect "/news/topics/c43v9x3zpl4t/*any", to: "/news/in_pictures", status: 301
  redirect "/news/topics/c9mn073kx8jt/*any", to: "/news/newsbeat", status: 301
  redirect "/news/topics/c58m9d3v2m4t/*any", to: "/news/disability", status: 301
  redirect "/news/topics/cyz0z8w0ydwt/*any", to: "/news/coronavirus", status: 301
  redirect "/news/topics/cp60w97z6lpt/*any", to: "/news/explainers", status: 301
  redirect "/news/topics/c0r51g8gzj4t/*any", to: "/naidheachdan", status: 301
  redirect "/news/topics/c3y3yz5y46wt/*any", to: "/cymrufyw", status: 301
  redirect "/news/topics/cd59gnpep0mt/*any", to: "/cymrufyw/gwleidyddiaeth", status: 301
  redirect "/news/topics/c89624nd36zt/*any", to: "/cymrufyw/gogledd-orllewin", status: 301
  redirect "/news/topics/c6z1jm2e958t/*any", to: "/cymrufyw/gogledd-ddwyrain", status: 301
  redirect "/news/topics/c44dg7xd5j0t/*any", to: "/cymrufyw/canolbarth", status: 301
  redirect "/news/topics/cr0p1mgq088t/*any", to: "/cymrufyw/de-orllewin", status: 301
  redirect "/news/topics/c7p2x560jqqt/*any", to: "/cymrufyw/de-ddwyrain", status: 301
  redirect "/news/topics/cmlx13g8vkvt/*any", to: "/news/world/europe/jersey", status: 301
  redirect "/news/topics/c30gv89epevt/*any", to: "/news/wales/south_east_wales", status: 301
  redirect "/news/topics/cpvn4p9gv9nt/*any", to: "/news/wales/south_west_wales", status: 301
  redirect "/news/topics/cj1g5vpnkx6t/*any", to: "/news/wales/mid_wales ", status: 301
  redirect "/news/topics/cqepv27v61dt/*any", to: "/news/wales/north_west_wales", status: 301
  redirect "/news/topics/c9mn0730k23t/*any", to: "/news/wales/north_east_wales", status: 301
  redirect "/news/topics/cq0zpjy11vyt/*any", to: "/news/england/somerset", status: 301
  redirect "/news/topics/cz43vwmy967t/*any", to: "/news/england/wiltshire", status: 301

  # News Topics
  redirect "/news/topics/c1vw6q14rzqt/*any", to: "/news/world-60525350", status: 302
  redirect "/news/topics/crr7mlg0d21t/*any", to: "/news/world-60525350", status: 302
  redirect "/news/topics/cmj34zmwm1zt/*any", to: "/news/science-environment-56837908", status: 302
  redirect "/news/topics/cwlw3xz0lvvt/*any", to: "/news/politics/uk_leaves_the_eu", status: 302
  redirect "/news/topics/ck7edpjq0d5t/*any", to: "/news/topics/cvp28kxz49xt", status: 301
  redirect "/news/topics/cp7r8vgl2rgt/*any", to: "/news/reality_check", status: 302
  redirect "/news/topics/cg5rv39y9mmt/*any", to: "/news/topics/ckrkrw3yjx1t", status: 301
  redirect "/news/topics/c8nq32jw8mwt/*any", to: "/news/topics/czpqp1pq5q5t", status: 301
  redirect "/news/topics/cd39m6424jwt/*any", to: "/news/world/asia/china", status: 302
  redirect "/news/topics/cny6mpy4mj9t/*any", to: "/news/world/asia/india", status: 302
  redirect "/news/topics/czv6rjvdy9gt/*any", to: "/news/world/australia", status: 302
  redirect "/news/topics/c5m8rrkp46dt/*any", to: "/news/election/us2020", status: 302
  redirect "/news/topics/cxqvep8kqext/*any", to: "/news/the_reporters", status: 302

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

  redirect "/news/science-environment-34320399", to: "/news/topics/cmj34zmwm1zt/climate-change", status: 301

  # News Blogs
  redirect "/news/blogs/trending", to: "/news/topics/cme72mv58q4t", status: 301, ttl: 3600
  redirect "/news/blogs/the_papers", to: "/news/topics/cpml2v678pxt", status: 301, ttl: 3600

  handle "/news/topics/:id/:slug", using: "NewsTopics" do
    return_404 if: [
      !(is_tipo_id?(id) or is_guid?(id)),
      !String.match?(slug, ~r/^([a-z0-9-]+)$/),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50)
    ]
  end

  handle "/news/topics/:id", using: "NewsTopics" do
    return_404 if: [
      !(is_tipo_id?(id) or is_guid?(id)),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50)
    ]
  end

  redirect "/news/amp/:id", to: "/news/:id.amp", status: 301
  redirect "/news/amp/:topic/:id", to: "/news/:topic/:id.amp", status: 301

  handle "/news/av/:asset_id/embed", using: "NewsVideosEmbed"
  handle "/news/av/:asset_id/:slug/embed", using: "NewsVideosEmbed"
  handle "/news/av/embed/:vpid/:asset_id", using: "NewsVideosEmbed"
  handle "/news/:asset_id/embed", using: "NewsVideosEmbed"
  handle "/news/:asset_id/embed/:pid", using: "NewsVideosEmbed"

  handle "/news/av/:id.app", using: "NewsVideosAppPage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/news/av/favicon.ico", using: "News" do
    return_404 if: true
  end

  redirect "/news/av/:asset_id/:slug", to: "/news/av/:asset_id", status: 302

  handle "/news/av/:id", using: "NewsVideos" do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/news/video_and_audio/:index/:id/:slug", using: "NewsVideoAndAudio" do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/news/video_and_audio/*any", using: "NewsVideoAndAudio" do
    return_404 if: true
  end

  redirect "/news/videos", to: "/news", status: 301

  handle "/news/videos/:optimo_id.app", using: "NewsVideosAppPage", only_on: "test" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/news/videos/:optimo_id", using: "NewsVideos" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/news/articles/:optimo_id.amp", using: "NewsAmp"

  handle "/news/articles/:optimo_id", using: "NewsStorytellingPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/news/articles/:optimo_id.app", using: "NewsStorytellingAppPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  # News indexes
  handle "/news/access-to-news", using: "NewsIndex"
  handle "/news/business", using: "NewsBusinessIndex"
  handle "/news/components", using: "NewsComponents"
  handle "/news/coronavirus", using: "NewsWebcoreIndex"
  handle "/news/disability", using: "NewsIndex"
  handle "/news/education", using: "NewsWebcoreIndex"
  handle "/news/england", using: "NewsIndex"
  handle "/news/entertainment_and_arts", using: "NewsEntertainmentAndArtsIndex"
  handle "/news/explainers", using: "NewsIndex"
  handle "/news/front_page", using: "NewsIndex"
  handle "/news/front-page-service-worker.js", using: "NewsIndex"
  handle "/news/have_your_say", using: "NewsWebcoreIndex"
  handle "/news/health", using: "NewsIndex"
  handle "/news/in_pictures", using: "NewsInPicturesIndex"
  handle "/news/newsbeat", using: "NewsIndex"
  handle "/news/northern_ireland", using: "NewsIndex"
  handle "/news/paradisepapers", using: "NewsIndex"
  handle "/news/politics", using: "NewsIndex"
  handle "/news/reality_check", using: "NewsRealityCheckIndex"
  handle "/news/science_and_environment", using: "NewsIndex"
  handle "/news/scotland", using: "NewsIndex"
  handle "/news/stories", using: "NewsWebcoreIndex"
  handle "/news/technology", using: "NewsTechnologyIndex"
  handle "/news/the_reporters", using: "NewsWebcoreIndex"
  handle "/news/uk", using: "NewsUkIndex"
  handle "/news/us-canada", using: "BBCXIndex"
  handle "/news/wales", using: "NewsIndex"
  handle "/news/war-in-ukraine", using: "BBCXIndex"
  handle "/news/world", using: "NewsWorld"
  handle "/news/world_radio_and_tv", using: "NewsIndex"
  handle "/news/england/cornwall", using: "NewsWebcoreIndex"
  handle "/news/england/devon", using: "NewsWebcoreIndex"
  handle "/news/world/europe/guernsey", using: "NewsWebcoreIndex"
  handle "/news/world/europe/jersey", using: "NewsWebcoreIndex"
  handle "/news/wales/south_east_wales", using: "NewsWebcoreIndex"
  handle "/news/wales/south_west_wales", using: "NewsWebcoreIndex"
  handle "/news/wales/mid_wales", using: "NewsWebcoreIndex"
  handle "/news/wales/north_west_wales", using: "NewsWebcoreIndex"
  handle "/news/wales/north_east_wales", using: "NewsWebcoreIndex"
  handle "/news/england/bristol", using: "NewsWebcoreIndex"
  handle "/news/england/gloucestershire", using: "NewsWebcoreIndex"
  handle "/news/england/somerset", using: "NewsWebcoreIndex"
  handle "/news/england/wiltshire", using: "NewsWebcoreIndex"

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
  redirect "/news/world-us-canada-44928743", to: "/news/topics/c163jpkepkqt", status: 301
  redirect "/news/uk-england-tees-48281832", to: "/news/topics/c2ymky7eq13t", status: 301
  redirect "/news/education-46131593", to: "/news/topics/cg41ylwv43pt", status: 301
  redirect "/news/world-middle-east-48433977", to: "/news/topics/cp7r8vgl24lt", status: 301
  redirect "/news/world-48623037", to: "/news/topics/c779dqxlxv2t", status: 301
  redirect "/news/world-24371433", to: "/news/topics/c779dqxlxv2t", status: 301
  redirect "/news/business-44813754", to: "/news/topics/clenme2345qt", status: 301
  redirect "/news/business-45489065", to: "/news/topics/c3y3yv3g7e4t", status: 301
  redirect "/news/business-15521824", to: "/news/topics/cgmlnmr3yjzt", status: 301
  redirect "/news/business-38507481", to: "/news/topics/ckrkrw3yjx1t", status: 301
  redirect "/news/business-33712313", to: "/news/topics/cj8k8ngevpgt", status: 301
  redirect "/news/business-11428889", to: "/news/topics/cw9l5jelpl1t", status: 301

  handle "/news/uk-england-47486169", using: "NewsUk"
  handle "/news/science-environment-56837908", using: "NewsScienceAndTechnology"
  handle "/news/world-us-canada-15949569", using: "News"

  # News archive assets
  handle "/news/10284448/ticker.sjson", using: "NewsArchive"
  handle "/news/1/*any", using: "NewsArchive"
  handle "/news/2/*any", using: "NewsArchive"
  handle "/news/sport1/*any", using: "NewsArchive"
  handle "/news/bigscreen/*any", using: "NewsArchive"

  redirect "/news/uk-england-52934822", to: "/news/uk-54373904", status: 301
  redirect "/news/uk/newsnightlive", to: "/programmes/b006mk25", status: 301

  redirect "/news/world-39146653", to: "/news/reality_check", status: 301

  # News RSS feeds
  handle "/news/rss.xml", using: "NewsRss"
  handle "/news/:id/rss.xml", using: "NewsRss"

  handle "/news/topics/:id/rss.xml", using: "NewsTopicRss" do
    return_404 if: !is_tipo_id?(id)
  end

  handle "/news/business/market-data", using: "NewsMarketData"

  # News section matchers
  handle "/news/ampstories/*any", using: "News"
  handle "/news/av-embeds/*any", using: "News"
  handle "/news/business/*any", using: "NewsBusiness"
  handle "/news/england/*any", using: "NewsUk"
  handle "/news/extra/*any", using: "News"
  handle "/news/events/*any", using: "NewsUk"
  handle "/news/iptv/*any", using: "News"
  handle "/news/local_news_slice/*any", using: "NewsUk"
  handle "/news/northern_ireland/*any", using: "NewsUk"
  handle "/news/politics/*any", using: "NewsUk"

  redirect "/news/health-52300114", to: "/news/resources/idt-29ceaf8c-03db-47b3-9318-0df359669f8f", status: 301
  redirect "/news/resources/idt-sh/boeing_two_deadly_crashes", to: "/news/extra/IFtb42kkNv/boeing-two-deadly-crashes", status: 301
  redirect "/news/resources/idt-sh/the_boy_in_the_photo", to: "/news/extra/WkiLgbPpdd/boy-in-the-photo", status: 301

  handle "/news/resources/*any", using: "News"

  handle "/news/rss/*any", using: "NewsRssSection"
  handle "/news/science-environment/*any", using: "NewsScienceAndTechnology"
  handle "/news/scotland/*any", using: "NewsUk"
  handle "/news/slides/*any", using: "News"
  handle "/news/special/*any", using: "News"
  handle "/news/technology/*any", using: "NewsScienceAndTechnology"
  handle "/news/wales/*any", using: "NewsUk"
  handle "/news/world/*any", using: "NewsWorld"
  handle "/news/world_radio_and_tv/*any", using: "News"

  # 404 matchers
  handle "/news/favicon.ico", using: "News" do
    return_404 if: true
  end

  handle "/news/null", using: "News" do
    return_404()
  end

  handle "/news/onward-journeys", using: "News" do
    return_404()
  end

  handle "/news/undefined", using: "News" do
    return_404()
  end

  handle "/news/feed", using: "News" do
    return_404()
  end

  handle "/news/av", using: "News" do
    return_404()
  end

  handle "/news/live", using: "News" do
    return_404()
  end

  handle "/news/topics", using: "News" do
    return_404()
  end

  handle "/news/newsbeat-entertainment", using: "News" do
    return_404()
  end

  handle "/news/newsbeat-music", using: "News" do
    return_404()
  end

  handle "/news/newsbeat-health", using: "News" do
    return_404()
  end

  handle "/news/newsbeat-technology", using: "News" do
    return_404()
  end

  handle "/news/newsbeat-the_p_word", using: "News" do
    return_404()
  end

  handle "/news/:id.amp", using: "NewsAmp"

  handle "/news/sitemap.xml", using: "News"
  handle "/news/news_sitemap.xml", using: "News"
  handle "/news/video_sitemap.xml", using: "News"

  handle "/news/:id", using: "NewsArticlePage"

  # TODO issue with routes such as /news/education-46131593 being matched to the /news/:id matcher
  handle "/news/*any", using: "NewsAny"

  # Cymrufyw

  redirect "/newyddion/*any", to: "/cymrufyw/*any", status: 302
  redirect "/democratiaethfyw", to: "/cymrufyw/gwleidyddiaeth", status: 302
  redirect "/cymrufyw/amp/:id", to: "/cymrufyw/:id.amp", status: 301
  redirect "/cymrufyw/amp/:topic/:id", to: "/cymrufyw/:topic/:id.amp", status: 301

  handle "/cymrufyw/etholiad/2015", using: "CymrufywWebcoreIndex"
  handle "/cymrufyw/etholiad/2016", using: "CymrufywWebcoreIndex"
  handle "/cymrufyw/etholiad/2017", using: "CymrufywWebcoreIndex"
  handle "/cymrufyw/etholiad/2019", using: "CymrufywWebcoreIndex"
  handle "/cymrufyw/gwleidyddiaeth/refferendwm_ue", using: "CymrufywWebcoreIndex"

  redirect "/cymrufyw/correspondents/vaughanroderick", to: "/news/topics/ckj6kvx7pdyt", status: 302

  handle "/cymrufyw/cylchgrawn", using: "Cymrufyw"

  handle "/cymrufyw/etholiad/:year/cymru/canlyniadau", using: "CymrufywEtholiadCanlyniadau" do
    return_404 if: [
      !String.match?(year, ~r/^(2021|2022)$/)
    ]
  end

  handle "/cymrufyw/etholiad/2021/cymru/etholaethau", using: "CymrufywEtholiad2021"

  handle "/cymrufyw/etholiad/2021/cymru/:division_name/:division_id", using: "CymrufywEtholiad2021" do
    return_404 if: [
      !String.match?(division_name, ~r/^(rhanbarthau|etholaethau)$/),
      !String.match?(division_id, ~r/^W[0-9]{8}$/)
    ]
  end

  handle "/cymrufyw/etholiad/2022/cymru/cynghorau", using: "CymrufywEtholiadCanlyniadau"

  handle "/cymrufyw/etholiad/2022/cymru/cynghorau/:division_id", using: "CymrufywEtholiadCanlyniadau" do
    return_404 if: [
                 !String.match?(division_id, ~r/^[W][0-9]{8}$/)
               ]
  end

  handle "/cymrufyw/etholiad/2019/cymru/etholaethau", using: "CymrufywEtholiadCanlyniadau", only_on: "test"

  handle "/cymrufyw/etholiad/2019/du/etholaethau/:division_id", using: "CymrufywEtholiadCanlyniadau", only_on: "test" do
    return_404 if: [
      !String.match?(division_id, ~r/^W[0-9]{8}$/)
    ]
  end

  handle "/cymrufyw/etholiad/2019/du/rhanbarthau/W92000004", using: "CymrufywEtholiadCanlyniadau", only_on: "test"

  handle "/cymrufyw/gwleidyddiaeth", using: "Cymrufyw"
  handle "/cymrufyw/gogledd-orllewin", using: "Cymrufyw"
  handle "/cymrufyw/gogledd-ddwyrain", using: "Cymrufyw"
  handle "/cymrufyw/canolbarth", using: "Cymrufyw"
  handle "/cymrufyw/de-orllewin", using: "Cymrufyw"
  handle "/cymrufyw/de-ddwyrain", using: "Cymrufyw"
  handle "/cymrufyw/eisteddfod", using: "Cymrufyw"
  handle "/cymrufyw/components", using: "Cymrufyw"
  handle "/cymrufyw/hafan", using: "Cymrufyw"

  redirect "/cymrufyw/fideo", to: "/cymrufyw", status: 301

  handle "/cymrufyw/:id", using: "CymrufywArticlePage" do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  handle "/cymrufyw/saf/:id.app", using: "CymrufywVideosAppPage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/cymrufyw/saf/:id", using: "CymrufywVideos" do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/cymrufyw/fideo/:optimo_id.app", using: "CymrufywVideosAppPage", only_on: "test" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/cymrufyw/fideo/:optimo_id", using: "CymrufywVideos" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/cymrufyw/erthyglau/:optimo_id.amp", using: "CymrufywAmp" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/cymrufyw/erthyglau/:optimo_id", using: "CymrufywStorytellingPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/cymrufyw/erthyglau/:optimo_id.app", using: "CymrufywStorytellingAppPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/cymrufyw/*any", using: "Cymrufyw"

  # Naidheachdan

  handle "/naidheachdan", using: "NaidheachdanHomePage"
  handle "/naidheachdan/dachaigh", using: "Naidheachdan"
  handle "/naidheachdan/components", using: "Naidheachdan"
  redirect "/naidheachdan/amp/:id", to: "/naidheachdan/:id.amp", status: 301
  redirect "/naidheachdan/amp/:topic/:id", to: "/naidheachdan/:topic/:id.amp", status: 301

  redirect "/naidheachdan/bhidio", to: "/naidheachdan", status: 301

  handle "/naidheachdan/:id", using: "NaidheachdanArticlePage" do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  handle "/naidheachdan/sgeulachdan/:optimo_id.amp", using: "NaidheachdanAmp" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/naidheachdan/sgeulachdan/:optimo_id", using: "NaidheachdanStorytellingPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/naidheachdan/sgeulachdan/:optimo_id.app", using: "NaidheachdanStorytellingAppPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/naidheachdan/fbh/:id.app", using: "NaidheachdanVideosAppPage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/naidheachdan/fbh/:id", using: "NaidheachdanVideos" do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/naidheachdan/bhidio/:optimo_id.app", using: "NaidheachdanVideosAppPage", only_on: "test" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/naidheachdan/bhidio/:optimo_id", using: "NaidheachdanVideos" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/naidheachdan/*any", using: "Naidheachdan"

  handle "/pres-test/personalisation", using: "PresTestPersonalised", only_on: "test"
  handle "/pres-test/personalisation/*any", using: "PresTestPersonalised", only_on: "test"
  handle "/pres-test/*any", using: "PresTest", only_on: "test"

  handle "/devx-test/personalisation", using: "DevXPersonalisation", only_on: "test"

  # Container API
  handle "/container/envelope/editorial-text/*any", using: "ContainerEnvelopeEditorialText"
  handle "/container/envelope/election-banner/*any", using: "ContainerEnvelopeElectionBanner"
  handle "/container/envelope/error/*any", using: "ContainerEnvelopeError"
  handle "/container/envelope/navigation-links/*any", using: "ContainerEnvelopeNavigationLinks"
  handle "/container/envelope/page-link/*any", using: "ContainerEnvelopePageLink"
  handle "/container/envelope/scoreboard/*any", using: "ContainerEnvelopeScoreboard"
  handle "/container/envelope/simple-promo-collection/*any", using: "ContainerEnvelopeSimplePromoCollection"
  handle "/container/envelope/turnout/*any", using: "ContainerEnvelopeTurnout"
  handle "/container/envelope/winner-flash/*any", using: "ContainerEnvelopeWinnerFlash"
  handle "/container/envelope/test-:name/*any", using: "ContainerEnvelopeTestContainers", only_on: "test"
  handle "/container/envelope/*any", using: "ContainerEnvelope"

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

  ## World Service - Article Redirects
  redirect "/afaanoromoo/oduu-57098175", to: "/afaanoromoo/articles/cw03re3p5lno", status: 301
  redirect "/arabic/middleeast-65449088", to: "/arabic/articles/cv2310xx8n5o", status: 301
  redirect "/bengali/news-51295547", to: "/bengali/articles/cn4876p6z2po", status: 301
  redirect "/igbo/articles/c4nrw821j28o", to: "/igbo/afirika-66648485", status: 301
  redirect "/mundo/noticias-america-latina-45714908", to: "/mundo/articles/c8745el6z5go", status: 301
  redirect "/mundo/noticias-internacional-44125537", to: "/mundo/articles/cd1dk2079rgo", status: 301
  redirect "/mundo/noticias/2015/02/150210_salud_como_ganar_peso_si_estas_muy_delgado_bd", to: "/mundo/articles/c6p7ry76ryko", status: 301
  redirect "/mundo/noticias/2016/03/160317_semana_santa_causas_sangre_heces_cancer_ac", to: "/mundo/articles/c2qd71z6y3wo", status: 301
  redirect "/mundo/noticias/2016/04/160429_salud_cancer_10_sintomas_generales_il", to: "/mundo/articles/cevzx098d1ko", status: 301
  redirect "/portuguese/articles/ckdzj02w2g1o", to: "/portuguese/articles/c4nqkqx7lgko", status: 301
  redirect "/portuguese/brasil-45229400", to: "/portuguese/articles/c3gjpmvkv5eo", status: 301
  redirect "/portuguese/brasil-45428722", to: "/portuguese/articles/cw56kkzgnq6o", status: 301
  redirect "/portuguese/brasil-57447342", to: "/portuguese/articles/ckml56krrd1o", status: 301
  redirect "/portuguese/brasil-58468215", to: "/portuguese/articles/c0j3ppkk054o", status: 301
  redirect "/portuguese/curiosidades-44304506", to: "/portuguese/articles/c51q2391gq9o", status: 301
  redirect "/portuguese/curiosidades-44444417", to: "/portuguese/articles/c9x9pz7zk82o", status: 301
  redirect "/portuguese/institutional-36202452", to: "/portuguese/articles/ce5rvednerpo", status: 301
  redirect "/portuguese/institutional-36202454", to: "/portuguese/articles/cw0w9z6p491o", status: 301
  redirect "/portuguese/institutional-36202448", to: "/portuguese/articles/cjrldj8285do", status: 301
  redirect "/portuguese/institutional-50054434", to: "/portuguese/articles/c2x5mvrdk74o", status: 301
  redirect "/portuguese/geral-44930392", to: "/portuguese/articles/cd1gmq2gzg5o", status: 301

  ## World Service - "Access to News" Redirects
  redirect "/arabic/middleeast/2013/11/131114_shia_ashura_rituals", to: "/arabic/middleeast-62442578", status: 301
  redirect "/persian/institutional-43952617", to: "/persian/access-to-news", status: 301
  redirect "/persian/institutional/2011/04/000001_bbcpersian_proxy", to: "/persian/access-to-news", status: 301
  redirect "/persian/institutional/2011/04/000001_feeds", to: "/persian/articles/c849y3lk2yko", status: 301

  ## World Service - Topic Redirects
  redirect "/afaanoromoo/topics/c44dyn08mejt", to: "/afaanoromoo", status: 301
  redirect "/amharic/topics/cg58k91re1gt", to: "/amharic", status: 301
  redirect "/azeri/topics/c1295dq496yt", to: "/azeri", status: 301
  redirect "/bengali/topics/cg81xp242zxt", to: "/bengali", status: 301
  redirect "/burmese/topics/cn6rql5k0z5t", to: "/burmese", status: 301
  redirect "/gahuza/topics/cz4vn9gy9pyt", to: "/gahuza", status: 301
  redirect "/gujarati/topics/cx0edn859g0t", to: "/gujarati", status: 301
  redirect "/igbo/topics/cp2dkn6rzj5t", to: "/igbo", status: 301
  redirect "/indonesia/topics/c89lm51033zt", to: "/indonesia", status: 301
  redirect "/hindi/india-66590093", to: "/hindi/topics/cqe17zz2k1nt", status: 301
  redirect "/japanese/video-55128146", to: "/japanese/topics/c132079wln0t", status: 301
  redirect "/kyrgyz/topics/crg7kj2e52nt", to: "/kyrgyz", status: 301
  redirect "/nepali/topics/c44d8kpmzlgt", to: "/nepali", status: 301
  redirect "/marathi/topics/crezq2dg90mt", to: "/marathi", status: 301
  redirect "/pidgin/topics/ck3yk9nz25qt", to: "/pidgin", status: 301
  redirect "/pidgin/sport", to: "/pidgin/topics/cjgn7gv77vrt", status: 301
  redirect "/portuguese/topics/c0rp0kp57p1t", to: "/portuguese", status: 301
  redirect "/punjabi/topics/c0rp0kp5ezmt", to: "/punjabi", status: 301
  redirect "/sinhala/topics/c1x6gk68neqt", to: "/sinhala", status: 301
  redirect "/somali/media-54071665", to: "/somali/topics/cn6rqlrkm0pt", status: 301
  redirect "/somali/topics/c89m6yjv965t", to: "/somali", status: 301
  redirect "/tamil/topics/c1x6gk68w9zt", to: "/tamil", status: 301
  redirect "/telugu/topics/c2w0dk010q2t", to: "/telugu", status: 301
  redirect "/thai/topics/c2w0dk01g2kt", to: "/thai", status: 301
  redirect "/tigrinya/topics/cq01ke649v0t", to: "/tigrinya", status: 301
  redirect "/turkce/topics/c3eg5kgl56zt", to: "/turkce", status: 301
  redirect "/ukrainian/55425840", to: "/ukrainian/topics/c44vmzqkzqqt", status: 301
  redirect "/ukrainian/topics/c3eg5kglplrt", to: "/ukrainian", status: 301
  redirect "/urdu/topics/c44d8kd7lgzt", to: "/urdu", status: 301
  redirect "/vietnamese/topics/c5q5105m81dt", to: "/vietnamese", status: 301
  redirect "/yoruba/topics/cvpk14mq48kt", to: "/yoruba", status: 301

  ## World Service - Homepage Redirects
  redirect "/afrique/index.html", to: "/afrique", status: 301
  redirect "/arabic/index.html", to: "/arabic", status: 301
  redirect "/azeri/index.html", to: "/azeri", status: 301
  redirect "/bengali/index.html", to: "/bengali", status: 301
  redirect "/burmese/index.html", to: "/burmese", status: 301
  redirect "/gahuza/index.html", to: "/gahuza", status: 301
  redirect "/hausa/index.html", to: "/hausa", status: 301
  redirect "/hindi/index.html", to: "/hindi", status: 301
  redirect "/indonesia/index.html", to: "/indonesia", status: 301
  redirect "/kyrgyz/index.html", to: "/kyrgyz", status: 301
  redirect "/mundo/index.html", to: "/mundo", status: 301
  redirect "/nepali/index.html", to: "/nepali", status: 301
  redirect "/pashto/index.html", to: "/pashto", status: 301
  redirect "/persian/index.html", to: "/persian", status: 301
  redirect "/persian/afghanistan/index.html", to: "/persian/afghanistan", status: 301
  redirect "/portuguese/index.html", to: "/portuguese", status: 301
  redirect "/russian/index.html", to: "/russian", status: 301
  redirect "/sinhala/index.html", to: "/sinhala", status: 301
  redirect "/somali/index.html", to: "/somali", status: 301
  redirect "/swahili/index.html", to: "/swahili", status: 301
  redirect "/tamil/index.html", to: "/tamil", status: 301
  redirect "/turkce/index.html", to: "/turkce", status: 301
  redirect "/ukrainian/index.html", to: "/ukrainian", status: 301
  redirect "/urdu/index.html", to: "/urdu", status: 301
  redirect "/uzbek/index.html", to: "/uzbek", status: 301
  redirect "/vietnamese/index.html", to: "/vietnamese", status: 301

  ## World Service - RSS Redirects
  redirect "/afaanoromoo/front_page/rss.xml", to: "/afaanoromoo/rss.xml", status: 301
  redirect "/amharic/front_page/rss.xml", to: "/amharic/rss.xml", status: 301
  redirect "/azeri/front_page/rss.xml", to: "/azeri/rss.xml", status: 301
  redirect "/bengali/front_page/rss.xml", to: "/bengali/rss.xml", status: 301
  redirect "/burmese/front_page/rss.xml", to: "/burmese/rss.xml", status: 301
  redirect "/kyrgyz/front_page/rss.xml", to: "/kyrgyz/rss.xml", status: 301
  redirect "/gahuza/front_page/rss.xml", to: "/gahuza/rss.xml", status: 301
  redirect "/gujarati/front_page/rss.xml", to: "/gujarati/rss.xml", status: 301
  redirect "/igbo/front_page/rss.xml", to: "/igbo/rss.xml", status: 301
  redirect "/indonesia/front_page/rss.xml", to: "/indonesia/rss.xml", status: 301
  redirect "/nepali/front_page/rss.xml", to: "/nepali/rss.xml", status: 301
  redirect "/marathi/front_page/rss.xml", to: "/marathi/rss.xml", status: 301
  redirect "/pidgin/front_page/rss.xml", to: "/pidgin/rss.xml", status: 301
  redirect "/portuguese/front_page/rss.xml", to: "/portuguese/rss.xml", status: 301
  redirect "/punjabi/front_page/rss.xml", to: "/punjabi/rss.xml", status: 301
  redirect "/sinhala/front_page/rss.xml", to: "/sinhala/rss.xml", status: 301
  redirect "/somali/front_page/rss.xml", to: "/somali/rss.xml", status: 301
  redirect "/tamil/front_page/rss.xml", to: "/tamil/rss.xml", status: 301
  redirect "/telugu/front_page/rss.xml", to: "/telugu/rss.xml", status: 301
  redirect "/thai/front_page/rss.xml", to: "/thai/rss.xml", status: 301
  redirect "/tigrinya/front_page/rss.xml", to: "/tigrinya/rss.xml", status: 301
  redirect "/turkce/front_page/rss.xml", to: "/turkce/rss.xml", status: 301
  redirect "/ukrainian/front_page/rss.xml", to: "/ukrainian/rss.xml", status: 301
  redirect "/urdu/front_page/rss.xml", to: "/urdu/rss.xml", status: 301
  redirect "/vietnamese/front_page/rss.xml", to: "/vietnamese/rss.xml", status: 301
  redirect "/yoruba/front_page/rss.xml", to: "/yoruba/rss.xml", status: 301


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
  handle "/afaanoromoo.amp", using: "WorldServiceAfaanoromooTipoHomePage"
  handle "/afaanoromoo/manifest.json", using: "WorldServiceAfaanoromooAssets"
  handle "/afaanoromoo/sw.js", using: "WorldServiceAfaanoromooAssets"
  handle "/afaanoromoo/rss.xml", using: "WorldServiceAfaanoromooHomePageRss"

  handle "/afaanoromoo/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/afaanoromoo/topics/:id", using: "WorldServiceAfaanoromooTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/afaanoromoo/topics/:id/rss.xml", using: "WorldServiceAfaanoromooTopicRss" do
    return_404 if: !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)$/)
  end

  handle "/afaanoromoo/:topic/rss.xml", using: "WorldServiceAfaanoromooRss"

  handle "/afaanoromoo/articles/:id", using: "WorldServiceAfaanoromooArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/afaanoromoo/articles/:id.amp", using: "WorldServiceAfaanoromooArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/afaanoromoo/articles/:id.app", using: "WorldServiceAfaanoromooAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/afaanoromoo/send/:id", using: "UploaderWorldService"
  handle "/afaanoromoo", using: "WorldServiceAfaanoromooTipoHomePage"
  handle "/afaanoromoo/*any", using: "WorldServiceAfaanoromoo"

  redirect "/afrique/mobile/*any", to: "/afrique", status: 301

  handle "/afrique.amp", using: "WorldServiceAfrique"
  handle "/afrique.json", using: "WorldServiceAfrique"
  handle "/afrique/manifest.json", using: "WorldServiceAfriqueAssets"
  handle "/afrique/sw.js", using: "WorldServiceAfriqueAssets"
  handle "/afrique/rss.xml", using: "WorldServiceAfriqueHomePageRss"

  handle "/afrique/tipohome.amp", using: "WorldServiceAfriqueTipoHomePage", only_on: "test"

  handle "/afrique/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/afrique/topics/:id", using: "WorldServiceAfriqueTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/afrique/topics/:id/rss.xml", using: "WorldServiceAfriqueTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/afrique/:topic/rss.xml", using: "WorldServiceAfriqueRss"
  handle "/afrique/:topic/:subtopic/rss.xml", using: "WorldServiceAfriqueRss"

  handle "/afrique/articles/:id", using: "WorldServiceAfriqueArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/afrique/articles/:id.amp", using: "WorldServiceAfriqueArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/afrique/articles/:id.app", using: "WorldServiceAfriqueAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/afrique/send/:id", using: "UploaderWorldService"
  handle "/afrique", using: "WorldServiceAfriqueTipoHomePage", only_on: "test"
  handle "/afrique/*any", using: "WorldServiceAfrique"

  handle "/amharic.amp", using: "WorldServiceAmharicTipoHomePage"
  handle "/amharic/manifest.json", using: "WorldServiceAmharicAssets"
  handle "/amharic/sw.js", using: "WorldServiceAmharicAssets"
  handle "/amharic/rss.xml", using: "WorldServiceAmharicHomePageRss"

  handle "/amharic/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/amharic/topics/:id", using: "WorldServiceAmharicTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/amharic/topics/:id/rss.xml", using: "WorldServiceAmharicTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/amharic/:topic/rss.xml", using: "WorldServiceAmharicRss"

  handle "/amharic/articles/:id", using: "WorldServiceAmharicArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/amharic/articles/:id.amp", using: "WorldServiceAmharicArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/amharic/articles/:id.app", using: "WorldServiceAmharicAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/amharic/send/:id", using: "UploaderWorldService"
  handle "/amharic", using: "WorldServiceAmharicTipoHomePage"
  handle "/amharic/*any", using: "WorldServiceAmharic"

  redirect "/arabic/mobile/*any", to: "/arabic", status: 301
  redirect "/arabic/institutional/2011/01/000000_tv_schedule", to: "/arabic/tv-and-radio-58432380", status: 301
  redirect "/arabic/institutional/2011/01/000000_frequencies_radio", to: "/arabic/tv-and-radio-57895092", status: 301
  redirect "/arabic/investigations", to: "/arabic/tv-and-radio-42414864", status: 301

  handle "/arabic.amp", using: "WorldServiceArabic"
  handle "/arabic.json", using: "WorldServiceArabic"
  handle "/arabic/manifest.json", using: "WorldServiceArabicAssets"
  handle "/arabic/sw.js", using: "WorldServiceArabicAssets"
  handle "/arabic/rss.xml", using: "WorldServiceArabicHomePageRss"

  handle "/arabic/tipohome.amp", using: "WorldServiceArabicTipoHomePage", only_on: "test"

  handle "/arabic/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/arabic/topics/:id", using: "WorldServiceArabicTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/arabic/topics/:id/rss.xml", using: "WorldServiceArabicTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/arabic/:topic/rss.xml", using: "WorldServiceArabicRss"
  handle "/arabic/:topic/:subtopic/rss.xml", using: "WorldServiceArabicRss"

  handle "/arabic/articles/:id", using: "WorldServiceArabicArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/arabic/articles/:id.amp", using: "WorldServiceArabicArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/arabic/articles/:id.app", using: "WorldServiceArabicAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/arabic/send/:id", using: "UploaderWorldService"
  handle "/arabic", using: "WorldServiceArabicTipoHomePage", only_on: "test"
  handle "/arabic/*any", using: "WorldServiceArabic"

  redirect "/azeri/mobile/*any", to: "/azeri", status: 301

  handle "/azeri.amp", using: "WorldServiceAzeriTipoHomePage"
  handle "/azeri/manifest.json", using: "WorldServiceAzeriAssets"
  handle "/azeri/sw.js", using: "WorldServiceAzeriAssets"
  handle "/azeri/rss.xml", using: "WorldServiceAzeriHomePageRss"

  handle "/azeri/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/azeri/topics/:id", using: "WorldServiceAzeriTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/azeri/topics/:id/rss.xml", using: "WorldServiceAzeriTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/azeri/:topic/rss.xml", using: "WorldServiceAzeriRss"
  handle "/azeri/:topic/:subtopic/rss.xml", using: "WorldServiceAzeriRss"

  handle "/azeri/articles/:id", using: "WorldServiceAzeriArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/azeri/articles/:id.amp", using: "WorldServiceAzeriArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/azeri/articles/:id.app", using: "WorldServiceAzeriAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/azeri/send/:id", using: "UploaderWorldService"
  handle "/azeri", using: "WorldServiceAzeriTipoHomePage"
  handle "/azeri/*any", using: "WorldServiceAzeri"

  redirect "/bengali/mobile/image/*any", to: "/bengali/*any", status: 302
  redirect "/bengali/mobile/*any", to: "/bengali", status: 301

  handle "/bengali.amp", using: "WorldServiceBengaliTipoHomePage"
  handle "/bengali/manifest.json", using: "WorldServiceBengaliAssets"
  handle "/bengali/sw.js", using: "WorldServiceBengaliAssets"
  handle "/bengali/rss.xml", using: "WorldServiceBengaliHomePageRss"

  handle "/bengali/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/bengali/topics/:id", using: "WorldServiceBengaliTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/bengali/topics/:id/rss.xml", using: "WorldServiceBengaliTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/bengali/:topic/rss.xml", using: "WorldServiceBengaliRss"
  handle "/bengali/:topic/:subtopic/rss.xml", using: "WorldServiceBengaliRss"

  handle "/bengali/articles/:id", using: "WorldServiceBengaliArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/bengali/articles/:id.amp", using: "WorldServiceBengaliArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/bengali/articles/:id.app", using: "WorldServiceBengaliAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/bengali/send/:id", using: "UploaderWorldService"
  handle "/bengali", using: "WorldServiceBengaliTipoHomePage"
  handle "/bengali/*any", using: "WorldServiceBengali"

  redirect "/burmese/mobile/image/*any", to: "/burmese/*any", status: 302
  redirect "/burmese/mobile/*any", to: "/burmese", status: 301

  handle "/burmese.amp", using: "WorldServiceBurmeseTipoHomePage"
  handle "/burmese/manifest.json", using: "WorldServiceBurmeseAssets"
  handle "/burmese/sw.js", using: "WorldServiceBurmeseAssets"
  handle "/burmese/rss.xml", using: "WorldServiceBurmeseHomePageRss"

  handle "/burmese/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/burmese/topics/:id", using: "WorldServiceBurmeseTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/burmese/topics/:id/rss.xml", using: "WorldServiceBurmeseTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/burmese/:topic/rss.xml", using: "WorldServiceBurmeseRss"
  handle "/burmese/:topic/:subtopic/rss.xml", using: "WorldServiceBurmeseRss"

  handle "/burmese/articles/:id", using: "WorldServiceBurmeseArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/burmese/articles/:id.amp", using: "WorldServiceBurmeseArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/burmese/articles/:id.app", using: "WorldServiceBurmeseAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/burmese/live/:id", using: "WorldServiceBurmeseLivePage", only_on: "test" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_live_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/burmese/send/:id", using: "UploaderWorldService"
  handle "/burmese", using: "WorldServiceBurmeseTipoHomePage"
  handle "/burmese/*any", using: "WorldServiceBurmese"

  redirect "/gahuza/mobile/*any", to: "/gahuza", status: 301

  handle "/gahuza.amp", using: "WorldServiceGahuzaTipoHomePage"
  handle "/gahuza/manifest.json", using: "WorldServiceGahuzaAssets"
  handle "/gahuza/sw.js", using: "WorldServiceGahuzaAssets"
  handle "/gahuza/rss.xml", using: "WorldServiceGahuzaHomePageRss"

  handle "/gahuza/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/gahuza/topics/:id", using: "WorldServiceGahuzaTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/gahuza/topics/:id/rss.xml", using: "WorldServiceGahuzaTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/gahuza/:topic/rss.xml", using: "WorldServiceGahuzaRss"
  handle "/gahuza/:topic/:subtopic/rss.xml", using: "WorldServiceGahuzaRss"

  handle "/gahuza/articles/:id", using: "WorldServiceGahuzaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/gahuza/articles/:id.amp", using: "WorldServiceGahuzaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/gahuza/articles/:id.app", using: "WorldServiceGahuzaAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/gahuza/send/:id", using: "UploaderWorldService"
  handle "/gahuza", using: "WorldServiceGahuzaTipoHomePage"
  handle "/gahuza/*any", using: "WorldServiceGahuza"

  handle "/gujarati.amp", using: "WorldServiceGujaratiTipoHomePage"
  handle "/gujarati/manifest.json", using: "WorldServiceGujaratiAssets"
  handle "/gujarati/sw.js", using: "WorldServiceGujaratiAssets"
  handle "/gujarati/rss.xml", using: "WorldServiceGujaratiHomePageRss"

  handle "/gujarati/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/gujarati/topics/:id", using: "WorldServiceGujaratiTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/gujarati/topics/:id/rss.xml", using: "WorldServiceGujaratiTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/gujarati/:topic/rss.xml", using: "WorldServiceGujaratiRss"

  handle "/gujarati/articles/:id", using: "WorldServiceGujaratiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/gujarati/articles/:id.amp", using: "WorldServiceGujaratiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/gujarati/articles/:id.app", using: "WorldServiceGujaratiAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/gujarati/send/:id", using: "UploaderWorldService"
  handle "/gujarati", using: "WorldServiceGujaratiTipoHomePage"
  handle "/gujarati/*any", using: "WorldServiceGujarati"

  redirect "/hausa/mobile/*any", to: "/hausa", status: 301

  handle "/hausa.amp", using: "WorldServiceHausa"
  handle "/hausa.json", using: "WorldServiceHausa"
  handle "/hausa/manifest.json", using: "WorldServiceHausaAssets"
  handle "/hausa/sw.js", using: "WorldServiceHausaAssets"
  handle "/hausa/rss.xml", using: "WorldServiceHausaHomePageRss"

  handle "/hausa/tipohome.amp", using: "WorldServiceHausaTipoHomePage", only_on: "test"

  handle "/hausa/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/hausa/topics/:id", using: "WorldServiceHausaTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/hausa/topics/:id/rss.xml", using: "WorldServiceHausaTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/hausa/:topic/rss.xml", using: "WorldServiceHausaRss"
  handle "/hausa/:topic/:subtopic/rss.xml", using: "WorldServiceHausaRss"

  handle "/hausa/articles/:id", using: "WorldServiceHausaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/hausa/articles/:id.amp", using: "WorldServiceHausaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/hausa/articles/:id.app", using: "WorldServiceHausaAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/hausa/send/:id", using: "UploaderWorldService"
  handle "/hausa", using: "WorldServiceHausaTipoHomePage", only_on: "test"
  handle "/hausa/*any", using: "WorldServiceHausa"

  redirect "/hindi/mobile/image/*any", to: "/hindi/*any", status: 302
  redirect "/hindi/mobile/*any", to: "/hindi", status: 301

  handle "/hindi.amp", using: "WorldServiceHindi"
  handle "/hindi.json", using: "WorldServiceHindi"
  handle "/hindi/manifest.json", using: "WorldServiceHindiAssets"
  handle "/hindi/sw.js", using: "WorldServiceHindiAssets"
  handle "/hindi/rss.xml", using: "WorldServiceHindiHomePageRss"

  handle "/hindi/tipohome.amp", using: "WorldServiceHindiTipoHomePage", only_on: "test"

  handle "/hindi/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/hindi/topics/:id", using: "WorldServiceHindiTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/hindi/topics/:id/rss.xml", using: "WorldServiceHindiTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/hindi/:topic/rss.xml", using: "WorldServiceHindiRss"
  handle "/hindi/:topic/:subtopic/rss.xml", using: "WorldServiceHindiRss"

  handle "/hindi/articles/:id", using: "WorldServiceHindiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/hindi/articles/:id.amp", using: "WorldServiceHindiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/hindi/articles/:id.app", using: "WorldServiceHindiAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/hindi/send/:id", using: "UploaderWorldService"
  handle "/hindi", using: "WorldServiceHindiTipoHomePage", only_on: "test"
  handle "/hindi/*any", using: "WorldServiceHindi"

  handle "/igbo.amp", using: "WorldServiceIgboTipoHomePage"
  handle "/igbo/manifest.json", using: "WorldServiceIgboAssets"
  handle "/igbo/sw.js", using: "WorldServiceIgboAssets"
  handle "/igbo/rss.xml", using: "WorldServiceIgboHomePageRss"

  handle "/igbo/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end


  handle "/igbo/topics/:id", using: "WorldServiceIgboTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/igbo/topics/:id/rss.xml", using: "WorldServiceIgboTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/igbo/:topic/rss.xml", using: "WorldServiceIgboRss"

  handle "/igbo/articles/:id", using: "WorldServiceIgboArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/igbo/articles/:id.amp", using: "WorldServiceIgboArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/igbo/articles/:id.app", using: "WorldServiceIgboAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/igbo/send/:id", using: "UploaderWorldService"
  handle "/igbo", using: "WorldServiceIgboTipoHomePage"
  handle "/igbo/*any", using: "WorldServiceIgbo"

  redirect "/indonesia/mobile/*any", to: "/indonesia", status: 301

  handle "/indonesia.amp", using: "WorldServiceIndonesiaTipoHomePage"
  handle "/indonesia/manifest.json", using: "WorldServiceIndonesiaAssets"
  handle "/indonesia/sw.js", using: "WorldServiceIndonesiaAssets"
  handle "/indonesia/rss.xml", using: "WorldServiceIndonesiaHomePageRss"

  handle "/indonesia/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/indonesia/topics/:id", using: "WorldServiceIndonesiaTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/indonesia/topics/:id/rss.xml", using: "WorldServiceIndonesiaTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/indonesia/:topic/rss.xml", using: "WorldServiceIndonesiaRss"
  handle "/indonesia/:topic/:subtopic/rss.xml", using: "WorldServiceIndonesiaRss"

  handle "/indonesia/articles/:id", using: "WorldServiceIndonesiaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/indonesia/articles/:id.amp", using: "WorldServiceIndonesiaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/indonesia/articles/:id.app", using: "WorldServiceIndonesiaAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/indonesia/send/:id", using: "UploaderWorldService"
  handle "/indonesia", using: "WorldServiceIndonesiaTipoHomePage"
  handle "/indonesia/*any", using: "WorldServiceIndonesia"

  handle "/japanese.amp", using: "WorldServiceJapanese"
  handle "/japanese.json", using: "WorldServiceJapanese"
  handle "/japanese/manifest.json", using: "WorldServiceJapaneseAssets"
  handle "/japanese/sw.js", using: "WorldServiceJapaneseAssets"
  handle "/japanese/rss.xml", using: "WorldServiceJapaneseHomePageRss"

  handle "/japanese/tipohome.amp", using: "WorldServiceJapaneseTipoHomePage", only_on: "test"

  handle "/japanese/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/japanese/topics/:id", using: "WorldServiceJapaneseTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/japanese/topics/:id/rss.xml", using: "WorldServiceJapaneseTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/japanese/:topic/rss.xml", using: "WorldServiceJapaneseRss"

  handle "/japanese/articles/:id", using: "WorldServiceJapaneseArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/japanese/articles/:id.amp", using: "WorldServiceJapaneseArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/japanese/articles/:id.app", using: "WorldServiceJapaneseAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/japanese/send/:id", using: "UploaderWorldService"
  handle "/japanese", using: "WorldServiceJapaneseTipoHomePage", only_on: "test"
  handle "/japanese/*any", using: "WorldServiceJapanese"

  handle "/korean.amp", using: "WorldServiceKorean"
  handle "/korean.json", using: "WorldServiceKorean"
  handle "/korean/manifest.json", using: "WorldServiceKoreanAssets"
  handle "/korean/sw.js", using: "WorldServiceKoreanAssets"
  handle "/korean/rss.xml", using: "WorldServiceKoreanHomePageRss"

  handle "/korean/tipohome.amp", using: "WorldServiceKoreanTipoHomePage", only_on: "test"

  handle "/korean/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/korean/topics/:id", using: "WorldServiceKoreanTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/korean/topics/:id/rss.xml", using: "WorldServiceKoreanTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/korean/:topic/rss.xml", using: "WorldServiceKoreanRss"

  handle "/korean/articles/:id", using: "WorldServiceKoreanArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/korean/articles/:id.amp", using: "WorldServiceKoreanArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/korean/articles/:id.app", using: "WorldServiceKoreanAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/korean/send/:id", using: "UploaderWorldService"
  handle "/korean", using: "WorldServiceKoreanTipoHomePage", only_on: "test"
  handle "/korean/*any", using: "WorldServiceKorean"

  redirect "/kyrgyz/mobile/*any", to: "/kyrgyz", status: 301

  handle "/kyrgyz.amp", using: "WorldServiceKyrgyzTipoHomePage"
  handle "/kyrgyz/manifest.json", using: "WorldServiceKyrgyzAssets"
  handle "/kyrgyz/sw.js", using: "WorldServiceKyrgyzAssets"
  handle "/kyrgyz/rss.xml", using: "WorldServiceKyrgyzHomePageRss"

  handle "/kyrgyz/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/kyrgyz/topics/:id", using: "WorldServiceKyrgyzTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/kyrgyz/topics/:id/rss.xml", using: "WorldServiceKyrgyzTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/kyrgyz/:topic/rss.xml", using: "WorldServiceKyrgyzRss"
  handle "/kyrgyz/:topic/:subtopic/rss.xml", using: "WorldServiceKyrgyzRss"

  handle "/kyrgyz/articles/:id", using: "WorldServiceKyrgyzArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/kyrgyz/articles/:id.amp", using: "WorldServiceKyrgyzArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/kyrgyz/articles/:id.app", using: "WorldServiceKyrgyzAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/kyrgyz/live/:id", using: "WorldServiceKyrgyzLivePage", only_on: "test" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_live_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/kyrgyz/send/:id", using: "UploaderWorldService"
  handle "/kyrgyz", using: "WorldServiceKyrgyzTipoHomePage"
  handle "/kyrgyz/*any", using: "WorldServiceKyrgyz"

  handle "/marathi.amp", using: "WorldServiceMarathiTipoHomePage"
  handle "/marathi/manifest.json", using: "WorldServiceMarathiAssets"
  handle "/marathi/sw.js", using: "WorldServiceMarathiAssets"
  handle "/marathi/rss.xml", using: "WorldServiceMarathiHomePageRss"

  handle "/marathi/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/marathi/topics/:id", using: "WorldServiceMarathiTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/marathi/topics/:id/rss.xml", using: "WorldServiceMarathiTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/marathi/:topic/rss.xml", using: "WorldServiceMarathiRss"

  handle "/marathi/articles/:id", using: "WorldServiceMarathiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/marathi/articles/:id.amp", using: "WorldServiceMarathiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/marathi/articles/:id.app", using: "WorldServiceMarathiAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/marathi/send/:id", using: "UploaderWorldService"
  handle "/marathi", using: "WorldServiceMarathiTipoHomePage"
  handle "/marathi/*any", using: "WorldServiceMarathi"

  ## World Service - Olympic Redirects
  redirect "/mundo/deportes-57748229", to: "/mundo/deportes-57970068", status: 301

  ## World Service - Topcat to CPS Redirects
  redirect "/mundo/noticias/2014/08/140801_israel_palestinos_conflicto_preguntas_basicas_jp", to: "/mundo/articles/cd1dk2079rgo", status: 301
  redirect "/mundo/noticias/2015/10/151014_israel_palestina_preguntas_basicas_actualizacion_aw", to: "/mundo/articles/cd1dk2079rgo", status: 301

  redirect "/mundo/mobile/*any", to: "/mundo", status: 301
  redirect "/mundo/movil/*any", to: "/mundo", status: 301

  handle "/mundo/mvt/*any", using: "WorldServiceMvtPoc", only_on: "test"

  handle "/mundo.amp", using: "WorldServiceMundo"
  handle "/mundo.json", using: "WorldServiceMundo"
  handle "/mundo/manifest.json", using: "WorldServiceMundoAssets"
  handle "/mundo/sw.js", using: "WorldServiceMundoAssets"
  handle "/mundo/rss.xml", using: "WorldServiceMundoHomePageRss"

  handle "/mundo/tipohome.amp", using: "WorldServiceMundoTipoHomePage", only_on: "test"

  handle "/mundo/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/mundo/topics/:id", using: "WorldServiceMundoTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/mundo/topics/:id/rss.xml", using: "WorldServiceMundoTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/mundo/:topic/rss.xml", using: "WorldServiceMundoRss"
  handle "/mundo/:topic/:subtopic/rss.xml", using: "WorldServiceMundoRss"

  handle "/mundo/articles/:id", using: "WorldServiceMundoArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/mundo/articles/:id.amp", using: "WorldServiceMundoArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/mundo/articles/:id.app", using: "WorldServiceMundoAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/mundo/live/:id", using: "WorldServiceMundoLivePage", only_on: "test" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_live_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/mundo/send/:id", using: "UploaderWorldService"
  handle "/mundo", using: "WorldServiceMundoTipoHomePage", only_on: "test"
  handle "/mundo/*any", using: "WorldServiceMundo"

  redirect "/nepali/mobile/image/*any", to: "/nepali/*any", status: 302
  redirect "/nepali/mobile/*any", to: "/nepali", status: 301

  handle "/nepali.amp", using: "WorldServiceNepaliTipoHomePage"
  handle "/nepali/manifest.json", using: "WorldServiceNepaliAssets"
  handle "/nepali/sw.js", using: "WorldServiceNepaliAssets"
  handle "/nepali/rss.xml", using: "WorldServiceNepaliHomePageRss"

  handle "/nepali/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/nepali/topics/:id", using: "WorldServiceNepaliTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/nepali/topics/:id/rss.xml", using: "WorldServiceNepaliTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/nepali/:topic/rss.xml", using: "WorldServiceNepaliRss"
  handle "/nepali/:topic/:subtopic/rss.xml", using: "WorldServiceNepaliRss"

  handle "/nepali/articles/:id", using: "WorldServiceNepaliArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/nepali/articles/:id.amp", using: "WorldServiceNepaliArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/nepali/articles/:id.app", using: "WorldServiceNepaliAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/nepali/send/:id", using: "UploaderWorldService"
  handle "/nepali", using: "WorldServiceNepaliTipoHomePage"
  handle "/nepali/*any", using: "WorldServiceNepali"

  redirect "/pashto/mobile/image/*any", to: "/pashto/*any", status: 302
  redirect "/pashto/mobile/*any", to: "/pashto", status: 301

  handle "/pashto.amp", using: "WorldServicePashto"
  handle "/pashto.json", using: "WorldServicePashto"
  handle "/pashto/manifest.json", using: "WorldServicePashtoAssets"
  handle "/pashto/sw.js", using: "WorldServicePashtoAssets"
  handle "/pashto/rss.xml", using: "WorldServicePashtoHomePageRss"

  handle "/pashto/tipohome.amp", using: "WorldServicePashtoTipoHomePage", only_on: "test"

  handle "/pashto/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/pashto/topics/:id", using: "WorldServicePashtoTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/pashto/topics/:id/rss.xml", using: "WorldServicePashtoTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/pashto/:topic/rss.xml", using: "WorldServicePashtoRss"
  handle "/pashto/:topic/:subtopic/rss.xml", using: "WorldServicePashtoRss"

  handle "/pashto/articles/:id", using: "WorldServicePashtoArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/pashto/articles/:id.amp", using: "WorldServicePashtoArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/pashto/articles/:id.app", using: "WorldServicePashtoAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/pashto/send/:id", using: "UploaderWorldService"
  handle "/pashto", using: "WorldServicePashtoTipoHomePage", only_on: "test"
  handle "/pashto/*any", using: "WorldServicePashto"

  redirect "/persian/mobile/image/*any", to: "/persian/*any", status: 302
  redirect "/persian/mobile/*any", to: "/persian", status: 301

  handle "/persian.amp", using: "WorldServicePersian"
  handle "/persian.json", using: "WorldServicePersian"
  handle "/persian/manifest.json", using: "WorldServicePersianAssets"
  handle "/persian/sw.js", using: "WorldServicePersianAssets"
  handle "/persian/rss.xml", using: "WorldServicePersianHomePageRss"

  handle "/persian/tipohome.amp", using: "WorldServicePersianTipoHomePage", only_on: "test"

  handle "/persian/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/persian/topics/:id", using: "WorldServicePersianTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/persian/topics/:id/rss.xml", using: "WorldServicePersianTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/persian/:topic/rss.xml", using: "WorldServicePersianRss"
  handle "/persian/:topic/:subtopic/rss.xml", using: "WorldServicePersianRss"

  handle "/persian/articles/:id", using: "WorldServicePersianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/persian/articles/:id.amp", using: "WorldServicePersianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/persian/articles/:id.app", using: "WorldServicePersianAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/persian/send/:id", using: "UploaderWorldService"
  handle "/persian", using: "WorldServicePersianTipoHomePage", only_on: "test"
  handle "/persian/*any", using: "WorldServicePersian"

  handle "/pidgin.amp", using: "WorldServicePidginTipoHomePage"
  handle "/pidgin/manifest.json", using: "WorldServicePidginAssets"
  handle "/pidgin/sw.js", using: "WorldServicePidginAssets"
  handle "/pidgin/rss.xml", using: "WorldServicePidginHomePageRss"

  handle "/pidgin/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/pidgin/topics/:id", using: "WorldServicePidginTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/pidgin/topics/:id/rss.xml", using: "WorldServicePidginTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/pidgin/:topic/rss.xml", using: "WorldServicePidginRss"

  handle "/pidgin/articles/:id", using: "WorldServicePidginArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/pidgin/articles/:id.amp", using: "WorldServicePidginArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/pidgin/articles/:id.app", using: "WorldServicePidginAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/pidgin/live/:id", using: "WorldServicePidginLivePage", only_on: "test" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_live_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/pidgin/send/:id", using: "UploaderWorldService"
  handle "/pidgin", using: "WorldServicePidginTipoHomePage"
  handle "/pidgin/*any", using: "WorldServicePidgin"

  redirect "/portuguese/mobile/*any", to: "/portuguese", status: 301
  redirect "/portuguese/celular/*any", to: "/portuguese", status: 301

  handle "/portuguese.amp", using: "WorldServicePortugueseTipoHomePage"
  handle "/portuguese/manifest.json", using: "WorldServicePortugueseAssets"
  handle "/portuguese/sw.js", using: "WorldServicePortugueseAssets"
  handle "/portuguese/rss.xml", using: "WorldServicePortugueseHomePageRss"


  handle "/portuguese/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/portuguese/topics/:id", using: "WorldServicePortugueseTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/portuguese/topics/:id/rss.xml", using: "WorldServicePortugueseTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/portuguese/:topic/rss.xml", using: "WorldServicePortugueseRss"
  handle "/portuguese/:topic/:subtopic/rss.xml", using: "WorldServicePortugueseRss"

  handle "/portuguese/articles/:id", using: "WorldServicePortugueseArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/portuguese/articles/:id.amp", using: "WorldServicePortugueseArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/portuguese/articles/:id.app", using: "WorldServicePortugueseAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/portuguese/send/:id", using: "UploaderWorldService"
  handle "/portuguese", using: "WorldServicePortugueseTipoHomePage"
  handle "/portuguese/*any", using: "WorldServicePortuguese"

  handle "/punjabi.amp", using: "WorldServicePunjabiTipoHomePage"
  handle "/punjabi/manifest.json", using: "WorldServicePunjabiAssets"
  handle "/punjabi/sw.js", using: "WorldServicePunjabiAssets"
  handle "/punjabi/rss.xml", using: "WorldServicePunjabiHomePageRss"

  handle "/punjabi/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/punjabi/topics/:id", using: "WorldServicePunjabiTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/punjabi/topics/:id/rss.xml", using: "WorldServicePunjabiTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/punjabi/:topic/rss.xml", using: "WorldServicePunjabiRss"

  handle "/punjabi/articles/:id", using: "WorldServicePunjabiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/punjabi/articles/:id.amp", using: "WorldServicePunjabiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/punjabi/articles/:id.app", using: "WorldServicePunjabiAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/punjabi/send/:id", using: "UploaderWorldService"
  handle "/punjabi", using: "WorldServicePunjabiTipoHomePage"
  handle "/punjabi/*any", using: "WorldServicePunjabi"

  ## World Service - Russian Partners Redirects
  redirect "/russian/international/2011/02/000000_g_partners", to: "/russian/institutional-43463215", status: 301

  ## World Service - Russian Newsletter Redirects
  redirect "/russian/institutional/2012/09/000000_newsletter", to: "/russian/resources/idt-b34bb7dd-f094-4722-92eb-cf7aff8cc1bc", status: 301

  redirect "/russian/mobile/*any", to: "/russian", status: 301
  redirect "/russia", to: "/russian", status: 301


  handle "/russian.amp", using: "WorldServiceRussian"
  handle "/russian.json", using: "WorldServiceRussian"
  handle "/russian/manifest.json", using: "WorldServiceRussianAssets"
  handle "/russian/sw.js", using: "WorldServiceRussianAssets"
  handle "/russian/rss.xml", using: "WorldServiceRussianHomePageRss"

  handle "/russian/tipohome.amp", using: "WorldServiceRussianTipoHomePage", only_on: "test"

  handle "/russian/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/russian/topics/:id", using: "WorldServiceRussianTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/russian/topics/:id/rss.xml", using: "WorldServiceRussianTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/russian/:topic/rss.xml", using: "WorldServiceRussianRss"
  handle "/russian/:topic/:subtopic/rss.xml", using: "WorldServiceRussianRss"

  handle "/russian/articles/:id", using: "WorldServiceRussianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/russian/articles/:id.amp", using: "WorldServiceRussianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/russian/articles/:id.app", using: "WorldServiceRussianAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/russian/send/:id", using: "UploaderWorldService"
  handle "/russian", using: "WorldServiceRussianTipoHomePage", only_on: "test"
  handle "/russian/*any", using: "WorldServiceRussian"

  handle "/serbian/manifest.json", using: "WorldServiceSerbianAssets"
  handle "/serbian/sw.js", using: "WorldServiceSerbianAssets"
  handle "/serbian/lat/rss.xml", using: "WorldServiceSerbianHomePageRss"
  handle "/serbian/cyr/rss.xml", using: "WorldServiceSerbianHomePageRss"

  handle "/serbian/lat/tipohome.amp", using: "WorldServiceSerbianTipoHomePage", only_on: "test"
  handle "/serbian/lat/tipohome/manifest.json", using: "WorldServiceSerbianAssets", only_on: "test"
  handle "/serbian/lat/tipohome/sw.js", using: "WorldServiceSerbianAssets", only_on: "test"
  handle "/serbian/lat/tipohome/rss.xml", using: "WorldServiceSerbianHomePageRss", only_on: "test"
  handle "/serbian/lat/tipohome", using: "WorldServiceSerbianTipoHomePage", only_on: "test"

  handle "/serbian/cyr/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end
  handle "/serbian/lat/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/serbian/cyr/topics/:id", using: "WorldServiceSerbianTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end
  handle "/serbian/lat/topics/:id", using: "WorldServiceSerbianTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/serbian/cyr/topics/:id/rss.xml", using: "WorldServiceSerbianTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end
  handle "/serbian/lat/topics/:id/rss.xml", using: "WorldServiceSerbianTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/serbian/lat/:topic/rss.xml", using: "WorldServiceSerbianRss"
  handle "/serbian/cyr/:topic/rss.xml", using: "WorldServiceSerbianRss"


  handle "/serbian/articles/:id/cyr", using: "WorldServiceSerbianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/cyr.amp", using: "WorldServiceSerbianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/cyr.app", using: "WorldServiceSerbianAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/lat", using: "WorldServiceSerbianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/lat.amp", using: "WorldServiceSerbianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/serbian/articles/:id/lat.app", using: "WorldServiceSerbianAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/serbian/live/:id/cyr", using: "WorldServiceSerbianLivePage", only_on: "test" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_live_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/serbian/live/:id/lat", using: "WorldServiceSerbianLivePage", only_on: "test" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_live_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/serbian/send/:id", using: "UploaderWorldService"
  handle "/serbian/*any", using: "WorldServiceSerbian"

  redirect "/sinhala/mobile/image/*any", to: "/sinhala/*any", status: 302
  redirect "/sinhala/mobile/*any", to: "/sinhala", status: 301

  handle "/sinhala.amp", using: "WorldServiceSinhalaTipoHomePage"
  handle "/sinhala/manifest.json", using: "WorldServiceSinhalaAssets"
  handle "/sinhala/sw.js", using: "WorldServiceSinhalaAssets"
  handle "/sinhala/rss.xml", using: "WorldServiceSinhalaHomePageRss"

  handle "/sinhala/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/sinhala/topics/:id", using: "WorldServiceSinhalaTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/sinhala/topics/:id/rss.xml", using: "WorldServiceSinhalaTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/sinhala/:topic/rss.xml", using: "WorldServiceSinhalaRss"
  handle "/sinhala/:topic/:subtopic/rss.xml", using: "WorldServiceSinhalaRss"

  handle "/sinhala/articles/:id", using: "WorldServiceSinhalaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/sinhala/articles/:id.amp", using: "WorldServiceSinhalaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/sinhala/articles/:id.app", using: "WorldServiceSinhalaAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/sinhala/send/:id", using: "UploaderWorldService"
  handle "/sinhala", using: "WorldServiceSinhalaTipoHomePage"
  handle "/sinhala/*any", using: "WorldServiceSinhala"

  redirect "/somali/mobile/*any", to: "/somali", status: 301

  handle "/somali.amp", using: "WorldServiceSomaliTipoHomePage"
  handle "/somali/manifest.json", using: "WorldServiceSomaliAssets"
  handle "/somali/sw.js", using: "WorldServiceSomaliAssets"
  handle "/somali/rss.xml", using: "WorldServiceSomaliHomePageRss"


  handle "/somali/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/somali/topics/:id", using: "WorldServiceSomaliTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/somali/topics/:id/rss.xml", using: "WorldServiceSomaliTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/somali/:topic/rss.xml", using: "WorldServiceSomaliRss"
  handle "/somali/:topic/:subtopic/rss.xml", using: "WorldServiceSomaliRss"

  handle "/somali/articles/:id", using: "WorldServiceSomaliArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/somali/articles/:id.amp", using: "WorldServiceSomaliArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/somali/articles/:id.app", using: "WorldServiceSomaliAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/somali/send/:id", using: "UploaderWorldService"
  handle "/somali", using: "WorldServiceSomaliTipoHomePage"
  handle "/somali/*any", using: "WorldServiceSomali"

  redirect "/swahili/mobile/*any", to: "/swahili", status: 301

  handle "/swahili.amp", using: "WorldServiceSwahili"
  handle "/swahili.json", using: "WorldServiceSwahili"
  handle "/swahili/manifest.json", using: "WorldServiceSwahiliAssets"
  handle "/swahili/sw.js", using: "WorldServiceSwahiliAssets"
  handle "/swahili/rss.xml", using: "WorldServiceSwahiliHomePageRss"

  handle "/swahili/tipohome.amp", using: "WorldServiceSwahiliTipoHomePage", only_on: "test"

  handle "/swahili/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/swahili/topics/:id", using: "WorldServiceSwahiliTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/swahili/topics/:id/rss.xml", using: "WorldServiceSwahiliTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/swahili/:topic/rss.xml", using: "WorldServiceSwahiliRss"
  handle "/swahili/:topic/:subtopic/rss.xml", using: "WorldServiceSwahiliRss"

  handle "/swahili/articles/:id", using: "WorldServiceSwahiliArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/swahili/articles/:id.amp", using: "WorldServiceSwahiliArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/swahili/articles/:id.app", using: "WorldServiceSwahiliAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/swahili/send/:id", using: "UploaderWorldService"
  handle "/swahili", using: "WorldServiceSwahiliTipoHomePage", only_on: "test"
  handle "/swahili/*any", using: "WorldServiceSwahili"

  handle "/tajik/*any", using: "WorldServiceTajik"

  redirect "/tamil/mobile/image/*any", to: "/tamil/*any", status: 302
  redirect "/tamil/mobile/*any", to: "/tamil", status: 301

  handle "/tamil.amp", using: "WorldServiceTamilTipoHomePage"
  handle "/tamil/manifest.json", using: "WorldServiceTamilAssets"
  handle "/tamil/sw.js", using: "WorldServiceTamilAssets"
  handle "/tamil/rss.xml", using: "WorldServiceTamilHomePageRss"

  handle "/tamil/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/tamil/topics/:id", using: "WorldServiceTamilTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/tamil/topics/:id/rss.xml", using: "WorldServiceTamilTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/tamil/:topic/rss.xml", using: "WorldServiceTamilRss"
  handle "/tamil/:topic/:subtopic/rss.xml", using: "WorldServiceTamilRss"

  handle "/tamil/articles/:id", using: "WorldServiceTamilArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/tamil/articles/:id.amp", using: "WorldServiceTamilArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/tamil/articles/:id.app", using: "WorldServiceTamilAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/tamil/send/:id", using: "UploaderWorldService"
  handle "/tamil", using: "WorldServiceTamilTipoHomePage"
  handle "/tamil/*any", using: "WorldServiceTamil"

  handle "/telugu.amp", using: "WorldServiceTeluguTipoHomePage"
  handle "/telugu/manifest.json", using: "WorldServiceTeluguAssets"
  handle "/telugu/sw.js", using: "WorldServiceTeluguAssets"
  handle "/telugu/rss.xml", using: "WorldServiceTeluguHomePageRss"

  handle "/telugu/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/telugu/topics/:id", using: "WorldServiceTeluguTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/telugu/topics/:id/rss.xml", using: "WorldServiceTeluguTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/telugu/:topic/rss.xml", using: "WorldServiceTeluguRss"

  handle "/telugu/articles/:id", using: "WorldServiceTeluguArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/telugu/articles/:id.amp", using: "WorldServiceTeluguArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/telugu/articles/:id.app", using: "WorldServiceTeluguAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/telugu/send/:id", using: "UploaderWorldService"
  handle "/telugu", using: "WorldServiceTeluguTipoHomePage"
  handle "/telugu/*any", using: "WorldServiceTelugu"

  handle "/thai.amp", using: "WorldServiceThaiTipoHomePage"
  handle "/thai/manifest.json", using: "WorldServiceThaiAssets"
  handle "/thai/sw.js", using: "WorldServiceThaiAssets"
  handle "/thai/rss.xml", using: "WorldServiceThaiHomePageRss"

  handle "/thai/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/thai/topics/:id", using: "WorldServiceThaiTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/thai/topics/:id/rss.xml", using: "WorldServiceThaiTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/thai/:topic/rss.xml", using: "WorldServiceThaiRss"

  handle "/thai/articles/:id", using: "WorldServiceThaiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/thai/articles/:id.amp", using: "WorldServiceThaiArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/thai/articles/:id.app", using: "WorldServiceThaiAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/thai/send/:id", using: "UploaderWorldService"
  handle "/thai", using: "WorldServiceThaiTipoHomePage"
  handle "/thai/*any", using: "WorldServiceThai"

  handle "/tigrinya.amp", using: "WorldServiceTigrinyaTipoHomePage"
  handle "/tigrinya/manifest.json", using: "WorldServiceTigrinyaAssets"
  handle "/tigrinya/sw.js", using: "WorldServiceTigrinyaAssets"
  handle "/tigrinya/rss.xml", using: "WorldServiceTigrinyaHomePageRss"

  handle "/tigrinya/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/tigrinya/topics/:id", using: "WorldServiceTigrinyaTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/tigrinya/topics/:id/rss.xml", using: "WorldServiceTigrinyaTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/tigrinya/:topic/rss.xml", using: "WorldServiceTigrinyaRss"

  handle "/tigrinya/articles/:id", using: "WorldServiceTigrinyaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/tigrinya/articles/:id.amp", using: "WorldServiceTigrinyaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/tigrinya/articles/:id.app", using: "WorldServiceTigrinyaAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/tigrinya/send/:id", using: "UploaderWorldService"
  handle "/tigrinya", using: "WorldServiceTigrinyaTipoHomePage"
  handle "/tigrinya/*any", using: "WorldServiceTigrinya"

  redirect "/turkce/mobile/*any", to: "/turkce", status: 301
  redirect "/turkce/cep/*any", to: "/turkce", status: 301

  handle "/turkce.amp", using: "WorldServiceTurkceTipoHomePage"
  handle "/turkce/manifest.json", using: "WorldServiceTurkceAssets"
  handle "/turkce/sw.js", using: "WorldServiceTurkceAssets"
  handle "/turkce/rss.xml", using: "WorldServiceTurkceHomePageRss"

  handle "/turkce/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/turkce/topics/:id", using: "WorldServiceTurkceTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/turkce/topics/:id/rss.xml", using: "WorldServiceTurkceTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/turkce/:topic/rss.xml", using: "WorldServiceTurkceRss"
  handle "/turkce/:topic/:subtopic/rss.xml", using: "WorldServiceTurkceRss"

  handle "/turkce/articles/:id", using: "WorldServiceTurkceArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/turkce/articles/:id.amp", using: "WorldServiceTurkceArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/turkce/articles/:id.app", using: "WorldServiceTurkceAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/turkce/send/:id", using: "UploaderWorldService"
  handle "/turkce", using: "WorldServiceTurkceTipoHomePage"
  handle "/turkce/*any", using: "WorldServiceTurkce"

  redirect "/ukchina/simp/mobile/*any", to: "/ukchina/simp", status: 301
  redirect "/ukchina/trad/mobile/*any", to: "/ukchina/trad", status: 301

  handle "/ukchina/manifest.json", using: "WorldServiceUkChinaAssets"
  handle "/ukchina/sw.js", using: "WorldServiceUkChinaAssets"

  handle "/ukchina/simp/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end
  handle "/ukchina/trad/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/ukchina/simp/topics/:id", using: "WorldServiceUkchinaTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end
  handle "/ukchina/trad/topics/:id", using: "WorldServiceUkchinaTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/ukchina/send/:id", using: "UploaderWorldService"
  handle "/ukchina/*any", using: "WorldServiceUkChina"

  redirect "/ukrainian/mobile/*any", to: "/ukrainian", status: 301

  handle "/ukrainian.amp", using: "WorldServiceUkrainianTipoHomePage"
  handle "/ukrainian/manifest.json", using: "WorldServiceUkrainianAssets"
  handle "/ukrainian/sw.js", using: "WorldServiceUkrainianAssets"
  handle "/ukrainian/rss.xml", using: "WorldServiceUkrainianHomePageRss"

  handle "/ukrainian/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/ukrainian/topics/:id", using: "WorldServiceUkrainianTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/ukrainian/topics/:id/rss.xml", using: "WorldServiceUkrainianTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/ukrainian/:topic/rss.xml", using: "WorldServiceUkrainianRss"
  handle "/ukrainian/:topic/:subtopic/rss.xml", using: "WorldServiceUkrainianRss"

  handle "/ukrainian/articles/:id", using: "WorldServiceUkrainianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/ukrainian/articles/:id.amp", using: "WorldServiceUkrainianArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/ukrainian/articles/:id.app", using: "WorldServiceUkrainianAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/ukrainian/send/:id", using: "UploaderWorldService"
  handle "/ukrainian", using: "WorldServiceUkrainianTipoHomePage"
  handle "/ukrainian/*any", using: "WorldServiceUkrainian"

  redirect "/urdu/mobile/image/*any", to: "/urdu/*any", status: 302
  redirect "/urdu/mobile/*any", to: "/urdu", status: 301

  handle "/urdu.amp", using: "WorldServiceUrduTipoHomePage"
  handle "/urdu/manifest.json", using: "WorldServiceUrduAssets"
  handle "/urdu/sw.js", using: "WorldServiceUrduAssets"
  handle "/urdu/rss.xml", using: "WorldServiceUrduHomePageRss"

  handle "/urdu/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/urdu/topics/:id", using: "WorldServiceUrduTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/urdu/topics/:id/rss.xml", using: "WorldServiceUrduTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/urdu/:topic/rss.xml", using: "WorldServiceUrduRss"
  handle "/urdu/:topic/:subtopic/rss.xml", using: "WorldServiceUrduRss"

  handle "/urdu/articles/:id", using: "WorldServiceUrduArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/urdu/articles/:id.amp", using: "WorldServiceUrduArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/urdu/articles/:id.app", using: "WorldServiceUrduAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/urdu/live/:id", using: "WorldServiceUrduLivePage", only_on: "test" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_live_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/urdu/send/:id", using: "UploaderWorldService"
  handle "/urdu", using: "WorldServiceUrduTipoHomePage"
  handle "/urdu/*any", using: "WorldServiceUrdu"

  redirect "/uzbek/mobile/*any", to: "/uzbek", status: 301

  handle "/uzbek.amp", using: "WorldServiceUzbek"
  handle "/uzbek.json", using: "WorldServiceUzbek"
  handle "/uzbek/manifest.json", using: "WorldServiceUzbekAssets"
  handle "/uzbek/sw.js", using: "WorldServiceUzbekAssets"
  handle "/uzbek/rss.xml", using: "WorldServiceUzbekHomePageRss"

  handle "/uzbek/tipohome.amp", using: "WorldServiceUzbekTipoHomePage", only_on: "test"
  handle "/uzbek/tipohome/manifest.json", using: "WorldServiceUzbekAssets", only_on: "test"
  handle "/uzbek/tipohome/sw.js", using: "WorldServiceUzbekAssets", only_on: "test"
  handle "/uzbek/tipohome/rss.xml", using: "WorldServiceUzbekHomePageRss", only_on: "test"
  handle "/uzbek/tipohome", using: "WorldServiceUzbekTipoHomePage", only_on: "test"

  handle "/uzbek/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/uzbek/topics/:id", using: "WorldServiceUzbekTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/uzbek/topics/:id/rss.xml", using: "WorldServiceUzbekTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/uzbek/:topic/rss.xml", using: "WorldServiceUzbekRss"
  handle "/uzbek/:topic/:subtopic/rss.xml", using: "WorldServiceUzbekRss"

  handle "/uzbek/articles/:id", using: "WorldServiceUzbekArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/uzbek/articles/:id.amp", using: "WorldServiceUzbekArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/uzbek/articles/:id.app", using: "WorldServiceUzbekAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/uzbek/send/:id", using: "UploaderWorldService"
  handle "/uzbek/*any", using: "WorldServiceUzbek"

  redirect "/vietnamese/mobile/*any", to: "/vietnamese", status: 301

  handle "/vietnamese.amp", using: "WorldServiceVietnameseTipoHomePage"
  handle "/vietnamese/manifest.json", using: "WorldServiceVietnameseAssets"
  handle "/vietnamese/sw.js", using: "WorldServiceVietnameseAssets"
  handle "/vietnamese/rss.xml", using: "WorldServiceVietnameseHomePageRss"

  handle "/vietnamese/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/vietnamese/topics/:id", using: "WorldServiceVietnameseTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/vietnamese/topics/:id/rss.xml", using: "WorldServiceVietnameseTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/vietnamese/:topic/rss.xml", using: "WorldServiceVietnameseRss"
  handle "/vietnamese/:topic/:subtopic/rss.xml", using: "WorldServiceVietnameseRss"

  handle "/vietnamese/articles/:id", using: "WorldServiceVietnameseArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/vietnamese/articles/:id.amp", using: "WorldServiceVietnameseArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/vietnamese/articles/:id.app", using: "WorldServiceVietnameseAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/vietnamese/send/:id", using: "UploaderWorldService"
  handle "/vietnamese", using: "WorldServiceVietnameseTipoHomePage"
  handle "/vietnamese/*any", using: "WorldServiceVietnamese"

  handle "/yoruba.amp", using: "WorldServiceYorubaTipoHomePage"
  handle "/yoruba/manifest.json", using: "WorldServiceYorubaAssets"
  handle "/yoruba/sw.js", using: "WorldServiceYorubaAssets"
  handle "/yoruba/rss.xml", using: "WorldServiceYorubaHomePageRss"

  handle "/yoruba/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/yoruba/topics/:id", using: "WorldServiceYorubaTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/yoruba/topics/:id/rss.xml", using: "WorldServiceYorubaTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/yoruba/:topic/rss.xml", using: "WorldServiceYorubaRss"

  handle "/yoruba/articles/:id", using: "WorldServiceYorubaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/yoruba/articles/:id.amp", using: "WorldServiceYorubaArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/yoruba/articles/:id.app", using: "WorldServiceYorubaAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/yoruba/send/:id", using: "UploaderWorldService"
  handle "/yoruba", using: "WorldServiceYorubaTipoHomePage"
  handle "/yoruba/*any", using: "WorldServiceYoruba"

  redirect "/zhongwen/simp/mobile/*any", to: "/zhongwen/simp", status: 301
  redirect "/zhongwen/trad/mobile/*any", to: "/zhongwen/trad", status: 301

  handle "/zhongwen/manifest.json", using: "WorldServiceZhongwenAssets"
  handle "/zhongwen/sw.js", using: "WorldServiceZhongwenAssets"
  handle "/zhongwen/simp/rss.xml", using: "WorldServiceZhongwenHomePageRss"
  handle "/zhongwen/trad/rss.xml", using: "WorldServiceZhongwenHomePageRss"

  handle "/zhongwen/trad/tipohome.amp", using: "WorldServiceZhongwenTipoHomePage", only_on: "test"
  handle "/zhongwen/trad/tipohome/manifest.json", using: "WorldServiceZhongwenAssets", only_on: "test"
  handle "/zhongwen/trad/tipohome/sw.js", using: "WorldServiceZhongwenAssets", only_on: "test"
  handle "/zhongwen/trad/tipohome/rss.xml", using: "WorldServiceZhongwenHomePageRss", only_on: "test"
  handle "/zhongwen/trad/tipohome", using: "WorldServiceZhongwenTipoHomePage", only_on: "test"

  handle "/zhongwen/simp/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end
  handle "/zhongwen/trad/topics/:id/page/:page", using: "WorldServiceTopicsRedirect" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/zhongwen/simp/topics/:id", using: "WorldServiceZhongwenTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end
  handle "/zhongwen/trad/topics/:id", using: "WorldServiceZhongwenTopicPage" do
    return_404 if: [
      !is_ws_tipo_page_id?(id),
      !is_valid_ws_topic_page_parameter?(conn.query_params["page"] || "1")
    ]
  end

  handle "/zhongwen/simp/topics/:id/rss.xml", using: "WorldServiceZhongwenTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end
  handle "/zhongwen/trad/topics/:id/rss.xml", using: "WorldServiceZhongwenTopicRss" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}t$/)
  end

  handle "/zhongwen/simp/:topic/rss.xml", using: "WorldServiceZhongwenRss"
  handle "/zhongwen/simp/:topic/:subtopic/rss.xml", using: "WorldServiceZhongwenRss"

  handle "/zhongwen/trad/:topic/rss.xml", using: "WorldServiceZhongwenRss"
  handle "/zhongwen/trad/:topic/:subtopic/rss.xml", using: "WorldServiceZhongwenRss"

  handle "/zhongwen/articles/:id/simp", using: "WorldServiceZhongwenArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/simp.amp", using: "WorldServiceZhongwenArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/simp.app", using: "WorldServiceZhongwenAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/trad", using: "WorldServiceZhongwenArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/trad.amp", using: "WorldServiceZhongwenArticlePage" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end
  handle "/zhongwen/articles/:id/trad.app", using: "WorldServiceZhongwenAppArticlePage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^c[a-zA-Z0-9]{10}o$/)
  end

  handle "/zhongwen/send/:id", using: "UploaderWorldService"
  handle "/zhongwen/*any", using: "WorldServiceZhongwen"

  handle "/ws/languages", using: "WsLanguages"
  handle "/ws/av-embeds/*any", using: "WsAvEmbeds"
  handle "/ws/includes/*any", using: "WsIncludes"
  handle "/worldservice/assets/images/*any", using: "WsImages"

  # BBC Three

  redirect "/bbcthree/tag/:id/:page", to: "/bbcthree/category/:id/:page", status: 301
  redirect "/bbcthree/tag/:id", to: "/bbcthree/category/:id", status: 301
  redirect "/bbcthree/article/b2a8c0be-5418-4f21-a0ef-992a059136e4", to: "/bbcthree/article/bed59408-8831-42db-b415-2c876017eb5b", status: 301
  redirect "/bbcthree/item/b6402a4c-30af-4e2a-87a6-5c263279b20b", to: "/bbcthree/terms-and-conditions", status: 301
  redirect "/bbcthree/item/9602352d-227e-43b9-a030-c0d577ce49d2", to: "/bbcthree/privacy", status: 301
  handle "/bbcthree/item/:id", using: "ThreeRedirect"

  handle "/bbcthree/sitemap.xml", using: "ThreeSitemap"
  handle "/bbcthree/privacy", using: "ThreeInfo"
  handle "/bbcthree/terms-and-conditions", using: "ThreeInfo"
  handle "/bbcthree/twitter-polls-terms-and-conditions", using: "ThreeInfo"
  handle "/bbcthree/category/:id/:page", using: "ThreeCategory" do
    return_404 if: [
      !String.match?(id, ~r/^[a-z0-9-]+$/),
      !integer_in_range?(page, 2..99)
    ]
  end
  handle "/bbcthree/category/:id", using: "ThreeCategory" do
    return_404 if: !String.match?(id, ~r/^[a-z0-9-]+$/)
  end
  handle "/bbcthree/clip/:id", using: "ThreeClip" do
    return_404 if: !is_guid?(id)
  end
  handle "/bbcthree/article/:id", using: "ThreeArticle" do
    return_404 if: !is_guid?(id)
  end
  handle "/bbcthree", using: "ThreeHomePage"
  handle "/bbcthree/*any", using: "Three"

  # Newsletters
  handle "/newsletters", using: "DotComNewslettersIndex", only_on: "test"

  handle "/newsletters/:id", using: "Newsletter", only_on: "test" do
    return_404 if: !is_zid?(id)
  end

  handle "/newsletters/:slug/:zid", using: "NewsletterLegacy" do
    return_404 if: [
      !String.match?(slug, ~r/^[\w-]+$/),
      !is_zid?(zid),
    ]
  end

  # /programmes

  handle "/programmes/articles/:key/:slug/contact", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/articles/:key/:slug", using: "ProgrammesArticle" do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/articles/:key", using: "ProgrammesArticle" do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/a-z/current", using: "ProgrammesLegacy"

  handle "/programmes/a-z/by/:search/current", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(search, ~r/^[a-zA-Z@]$/)
  end

  handle "/programmes/a-z/by/:search/:slice.json", using: "ProgrammesData" do
    return_404 if: [
      !String.match?(search, ~r/^[a-zA-Z@]$/),
      !Enum.member?(["all", "player"], slice),
    ]
  end

  handle "/programmes/a-z/by/:search.json", using: "ProgrammesData" do
    return_404 if: !String.match?(search, ~r/^[a-zA-Z@]$/)
  end

  handle "/programmes/a-z/by/:search/:slice", using: "Programmes" do
    return_404 if: [
      !String.match?(search, ~r/^[a-zA-Z@]$/),
      !Enum.member?(["all", "player"], slice),
    ]
  end

  handle "/programmes/a-z/by/:search", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(search, ~r/^[a-zA-Z@]$/)
  end

  handle "/programmes/a-z/:slice.json", using: "ProgrammesData" do
    return_404 if: !Enum.member?(["all", "player"], slice)
  end

  handle "/programmes/a-z.json", using: "ProgrammesData"

  handle "/programmes/a-z", using: "Programmes"

  handle "/programmes/formats/:category/:slice", using: "Programmes" do
    return_404 if: !Enum.member?(["all", "player"], slice)
  end

  handle "/programmes/formats/:category", using: "Programmes"

  handle "/programmes/formats", using: "Programmes"

  handle "/programmes/genres", using: "Programmes"

  handle "/programmes/genres/*any", using: "Programmes"

  handle "/programmes/profiles/:key/:slug", using: "Programmes" do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/profiles/:key", using: "Programmes" do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/snippet/:records_ids.json", using: "ProgrammesData"

  handle "/programmes/topics/:topic/:slice", using: "Programmes"

  handle "/programmes/topics/:topic", using: "Programmes"

  handle "/programmes/topics", using: "Programmes"

  handle "/programmes/:pid/articles", using: "ProgrammesArticle" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/broadcasts/:year/:month", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/broadcasts", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/children.json", using: "ProgrammesData" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/clips", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/contact", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/credits", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/a-z/:az", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/downloads.rss", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/downloads", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/guide", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/guide.2013inc", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/last.json", using: "ProgrammesData" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/player", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/upcoming.json", using: "ProgrammesData" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes/:year/:month.json", using: "ProgrammesData" do
    return_404 if: [
      !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/),
      !String.match?(year, ~r/^[1-2][0-9]{3}$/),
      !String.match?(month, ~r/^0?[1-9]|1[0-2]$/)
    ]
  end

  handle "/programmes/:pid/episodes.json", using: "ProgrammesData" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/episodes", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/galleries", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/members/all", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/members", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/microsite", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/player", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/playlist.json", using: "ProgrammesData" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/podcasts", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/profiles", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/recipes.ameninc", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/recipes.2013inc", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/recipes", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/schedules", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/schedules/*any", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/segments.json", using: "ProgrammesData" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/segments", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/series.json", using: "ProgrammesData" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/series", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/topics/:topic", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/topics", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid.html", using: "ProgrammesLegacy" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid.json", using: "ProgrammesData" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes/:pid/:imagepid", using: "ProgrammesEntity" do
    return_404 if: [
      !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/),
      !String.match?(imagepid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
    ]
  end

  handle "/programmes/:pid", using: "ProgrammesEntity" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/programmes", using: "ProgrammesHomePage"

  # /programmes catch all
  handle "/programmes/*any", using: "Programmes"

  # /schedules

  handle "/schedules/network/:network/on-now", using: "Schedules" do
    return_404 if: !String.match?(network, ~r/^[a-zA-Z0-9]{2,35}$/)
  end

  handle "/schedules/network/:network", using: "Schedules" do
    return_404 if: !String.match?(network, ~r/^[a-zA-Z0-9]{2,35}$/)
  end

  handle "/schedules/:pid/*any", using: "Schedules" do
    return_404 if: !String.match?(pid, ~r/^[0-9b-df-hj-np-tv-z]{8,15}$/)
  end

  handle "/schedules", using: "Schedules"

  # /schedules catch all
  handle "/schedules/*any", using: "Schedules"

  # Uploader

  handle "/send/:id", using: "Uploader"

  # topics

  handle "/topics", using: "TopicPage"

  handle "/topics/:id", using: "TopicPage" do
    return_404 if: [
      !is_tipo_id?(id),
      !integer_in_range?(conn.query_params["page"] || "1", 1..42)
    ]
  end

  handle "/topics/:id/rss.xml", using: "TopicRss" do
    # example "/topics/c57jjx4233xt/rss.xml" need "feeds.api.bbci.co.uk" as host
    return_404 if: !is_tipo_id?(id)
  end

  handle "/live/news", using: "LiveNewsIndex"
  handle "/live/sport", using: "LiveSportIndex"

  ## Live WebCore
  handle "/live/:asset_id", using: "Live", only_on: "test" do
    return_404 if: [
      !String.match?(asset_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}t$/), # TIPO IDs
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-4][0-9]|50|[1-9])\z/)
    ]
  end

  ## Live WebCore - .app route
  handle "/live/:asset_id.app", using: "Live",  only_on: "test" do
    return_404 if: [
      !String.match?(asset_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}t$/), # TIPO IDs
      !String.match?(conn.query_params["page"] || "1", ~r/\A([1-4][0-9]|50|[1-9])\z/)
    ]
  end

  # Weather
  redirect "/weather/0/*any", to: "/weather/*any", status: 301

  handle "/weather", using: "WeatherHomePage"

  handle "/weather/search", using: "WeatherSearch" do
    return_404 if: [
        !is_valid_length?(conn.query_params["s"] || "", 0..100),
        !integer_in_range?(conn.query_params["page"] || "1", 0..999)
      ]
  end

  handle "/weather/outlook", using: "Weather"

  handle "/weather/map", using: "Weather"

  redirect "/weather/warnings", to: "/weather/warnings/weather", status: 302
  handle "/weather/warnings/weather", using: "WeatherWarnings"
  handle "/weather/warnings/floods", using: "WeatherWarnings"

  redirect "/weather/coast_and_sea", to: "/weather/coast-and-sea", status: 301
  redirect "/weather/coast_and_sea/shipping_forecast", to: "/weather/coast-and-sea/shipping-forecast", status: 301
  handle "/weather/coast-and-sea/tide-tables", using: "WeatherCoastAndSea"
  handle "/weather/coast-and-sea/tide-tables/:region_id", using: "WeatherCoastAndSea" do
    return_404 if: !integer_in_range?(region_id, 1..12)
  end
  handle "/weather/coast-and-sea/tide-tables/:region_id/:tide_location_id", using: "WeatherCoastAndSea" do
    return_404 if: [
        !matches?(tide_location_id, ~r/^\d{1,4}[a-f]?$/),
        !integer_in_range?(region_id, 1..12)
      ]
  end
  handle "/weather/coast_and_sea/inshore_waters/:id", using: "WeatherCoastAndSea"
  handle "/weather/coast-and-sea/*any", using: "WeatherCoastAndSea"

  handle "/weather/error/:status", using: "Weather" do
    return_404 if: !integer_in_range?(status, [404, 500])
  end

  handle "/weather/language/:language", using: "WeatherLanguage" do
    return_404(
      if: [
        !starts_with?(conn.query_params["redirect_location"] || "/weather", "/"),
        !is_language?(language)
      ]
    )
  end

  redirect "/weather/forecast-video/:asset_id", to: "/weather/av/:asset_id", status: 302

  handle "/weather/about/:cps_id", using: "WeatherArticlePage" do
    return_404 if: !integer_in_range?(cps_id, 1..999_999_999_999)
  end
  handle "/weather/features/:cps_id", using: "WeatherArticlePage" do
    return_404 if: !integer_in_range?(cps_id, 1..999_999_999_999)
  end
  handle "/weather/feeds/:cps_id", using: "WeatherArticlePage" do
    return_404 if: !integer_in_range?(cps_id, 1..999_999_999_999)
  end
   handle "/weather/weather-watcher/:cps_id", using: "WeatherArticlePage" do
    return_404 if: !integer_in_range?(cps_id, 1..999_999_999_999)
  end
  handle "/weather/articles/:optimo_id", using: "WeatherStorytellingPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end
  handle "/weather/articles/:optimo_id.app", using: "WeatherStorytellingAppPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  redirect "/weather/about", to: "/weather", status: 302
  redirect "/weather/features", to: "/weather", status: 302
  redirect "/weather/feeds", to: "/weather", status: 302
  redirect "/weather/forecast-video", to: "/weather", status: 302
  redirect "/weather/weather-watcher", to: "/weather", status: 302

  handle "/weather/av/:asset_id.app", using: "WeatherVideosAppPage", only_on: "test" do
    return_404 if: !integer_in_range?(asset_id, 1..999_999_999_999)
  end

  handle "/weather/av/:asset_id", using: "WeatherVideos" do
    return_404 if: !integer_in_range?(asset_id, 1..999_999_999_999)
  end

  handle "/weather/videos/:optimo_id.app", using: "WeatherVideosAppPage", only_on: "test" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/weather/videos/:optimo_id", using: "WeatherVideos" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/weather/:location_id", using: "WeatherLocation" do
    return_404 if: !matches?(location_id, ~r/^([a-z0-9]{1,50})$/)
  end
  handle "/weather/:location_id/:day", using: "WeatherLocation" do
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

  handle "/articles/:optimo_id", using: "StorytellingPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/articles/:optimo_id.app", using: "StorytellingAppPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  # Catch all

  # example test route: "/comments/embed/news/world-europe-23348005"
  handle "/comments/embed/*any", using: "CommentsEmbed"

  handle "/my/session", using: "MySession", only_on: "test"

  handle "/scotland/articles/*any", using: "ScotlandArticles"
  # TODO this may not be an actual required route
  handle "/scotland/*any", using: "Scotland"

  handle "/archive/articles/*any", using: "ArchiveArticles"
  # TODO this may not be an actual required route e.g. archive/collections-transport-and-travel/zhb9f4j showing as Morph Router
  handle "/archive/*any", using: "Archive"

  # CBBC
  handle "/cbbc/findoutmore/help-me-out-exercise", using: "CBBCArticlePage"
  handle "/cbbc/joinin/five-things-to-think-when-you-look-in-the-mirror", using: "CBBCArticlePage", only_on: "test"
  handle "/cbbc/*any", using: "CBBCLegacy"

  # Newsround
  redirect "/newsround/amp/:id", to: "/newsround/:id.amp", status: 301
  handle "/newsround/:id.amp", using: "NewsroundAmp"
  handle "/newsround/articles/manifest.json", using: "NewsroundAmp"

  handle "/newsround/articles/:optimo_id", using: "NewsroundStorytellingPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end
  handle "/newsround/articles/:optimo_id.app", using: "NewsroundStorytellingAppPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end
  handle "/newsround/articles/:optimo_id.amp", using: "NewsroundStorytellingAmp" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/newsround/news/watch_newsround.app", using: "NewsroundVideoPageAppPage", only_on: "test"
  handle "/newsround/news/watch_newsround", using: "NewsroundVideoPage"
  handle "/newsround/news/newsroundbsl.app", using: "NewsroundVideoPageAppPage", only_on: "test"
  handle "/newsround/news/newsroundbsl", using: "NewsroundVideoPage"

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
  redirect "/schoolreport", to: "/news/topics/cg41ylwv43pt", status: 301

  handle "/newsround/av/:id.app", using: "NewsroundVideoPageAppPage", only_on: "test" do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end
  handle "/newsround/av/:id", using: "NewsroundVideoPage" do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end
  handle "/newsround/:id", using: "NewsroundArticlePage" do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end

  handle "/newsround", using: "NewsroundHomePage"

  handle "/schoolreport/*any", using: "Schoolreport"

  handle "/wide/*any", using: "Wide"

  handle "/archivist/*any", using: "Archivist"

  # TODO /proms/extra
  handle "/proms/*any", using: "Proms"

  handle "/music", using: "Music"

  # Bitesize
  # Bitesize guides .app routes
  handle "/bitesize/guides/:id/revision.app", using: "BitesizeGuides" do
    return_404()
  end
  handle "/bitesize/preview/guides/:id/revision.app", using: "Bitesize", only_on: "test" do
    return_404()
  end

  # GCSE Eduqas Science deprecation - Study guide redirects
  redirect "/bitesize/guides/zcxmfcw/revision/1", to: "/bitesize/guides/zgmpgdm/revision/1", status: 301
  redirect "/bitesize/guides/z9m6v9q/revision/2", to: "/bitesize/guides/z8gx3k7/revision/2", status: 301

  # KS3 Maths study guide redirects
  redirect "/bitesize/guides/zvybkqt/revision/2", to: "/bitesize/topics/z3nygk7/articles/zr9wxg8", status: 301
  redirect "/bitesize/guides/zvybkqt/revision/3", to: "/bitesize/topics/z3nygk7/articles/zr9wxg8", status: 301
  redirect "/bitesize/guides/zvybkqt/revision/4", to: "/bitesize/topics/z3nygk7/articles/z39wxg8", status: 301
  redirect "/bitesize/guides/zvybkqt/revision/5", to: "/bitesize/topics/z3nygk7/articles/z9qxs82", status: 301
  redirect "/bitesize/guides/zvybkqt/revision/7", to: "/bitesize/topics/z3nygk7/articles/z82tywx", status: 301
  redirect "/bitesize/guides/zrg4jxs/revision/2", to: "/bitesize/topics/ztwhvj6/articles/zy7xs82", status: 301
  redirect "/bitesize/guides/zrg4jxs/revision/3", to: "/bitesize/topics/ztwhvj6/articles/zr76fdm", status: 301
  redirect "/bitesize/guides/zrg4jxs/revision/4", to: "/bitesize/topics/ztwhvj6/articles/zjvrdnb", status: 301
  redirect "/bitesize/guides/zrg4jxs/revision/5", to: "/bitesize/topics/ztwhvj6/articles/z3mhvj6", status: 301
  redirect "/bitesize/guides/zrg4jxs/revision/6", to: "/bitesize/topics/ztwhvj6/articles/z3mhvj6", status: 301
  redirect "/bitesize/guides/zrg4jxs/revision/7", to: "/bitesize/topics/ztwhvj6/articles/zt6v46f", status: 301
  redirect "/bitesize/guides/zrg4jxs/revision/8", to: "/bitesize/topics/ztwhvj6/articles/z8prdnb", status: 301
  redirect "/bitesize/guides/zrg4jxs/revision/9", to: "/bitesize/topics/ztwhvj6/articles/z8prdnb", status: 301
  redirect "/bitesize/guides/znhsgk7/revision/1", to: "/bitesize/topics/zbsvr82/articles/zj6nb7h", status: 301
  redirect "/bitesize/guides/znhsgk7/revision/3", to: "/bitesize/topics/zbsvr82/articles/zj6nb7h", status: 301
  redirect "/bitesize/guides/znhsgk7/revision/4", to: "/bitesize/topics/zbsvr82/articles/zj6nb7h", status: 301
  redirect "/bitesize/guides/znhsgk7/revision/5", to: "/bitesize/topics/zbsvr82/articles/z7qsg2p", status: 301
  redirect "/bitesize/guides/znhsgk7/revision/6", to: "/bitesize/topics/zbsvr82/articles/zvkj6rd", status: 301
  redirect "/bitesize/guides/znhsgk7/revision/7", to: "/bitesize/topics/zbsvr82/articles/z3kj6rd", status: 301

  redirect "/bitesize/guides/:id", to: "/bitesize/guides/:id/revision/1", status: 301
  redirect "/bitesize/guides/:id/revision", to: "/bitesize/guides/:id/revision/1", status: 301

  redirect "/bitesize/preview/guides/:id", to: "/bitesize/preview/guides/:id/revision/1", status: 301
  redirect "/bitesize/preview/guides/:id/revision", to: "/bitesize/preview/guides/:id/revision/1", status: 301

  redirect "/bitesize/articles/znsmxyc", to: "/bitesize/parents", status: 301                                         # Parents' Toolkit
  redirect "/bitesize/articles/zf4gg7h", to: "/bitesize/parents", status: 301                                         # Parents' Toolkit
  redirect "/bitesize/articles/zs64r2p", to: "/bitesize/parents", status: 301                                         # Parents' Toolkit
  redirect "/bitesize/articles/z7j496f", to: "/bitesize/parents", status: 301                                         # Parents' Toolkit
  redirect "/bitesize/articles/zhxpscw", to: "/bitesize/parents", status: 301                                         # Parents' Toolkit
  redirect "/bitesize/articles/z4rkd6f", to: "/bitesize/parents", status: 301                                         # Parents' Toolkit
  redirect "/bitesize/articles/z7fb3j6", to: "/bitesize/parents", status: 301                                         # Parents' Toolkit
  redirect "/bitesize/articles/zgqq6rd", to: "/bitesize/parents", status: 301                                         # Parents' Toolkit
  redirect "/bitesize/articles/zxvqdp3", to: "/bitesize/parents", status: 301                                         # Parents' Toolkit
  redirect "/bitesize/articles/z63htrd", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zwcfp4j", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zv7mh4j", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zvpvbqt", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/z9pxtrd", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/z32kjfr", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zy44bqt", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/z4b3sk7", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zkcfsk7", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/z84yf82", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/z9rsn9q", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zchysk7", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zkyr47h", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/z4crvwx", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zctbydm", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zt42jsg", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zd8kr2p", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zx9mqfr", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zm42jsg", to: "/bitesize/groups/cw9v6l8d0q6t", status: 301                             # Parents' Toolkit - Wellbeing
  redirect "/bitesize/articles/zqbt6g8", to: "/bitesize/groups/cx1lpm3x7v4t", status: 301                             # Parents' Toolkit - Learning
  redirect "/bitesize/articles/z32mxbk", to: "/bitesize/groups/cx1lpm3x7v4t", status: 301                             # Parents' Toolkit - Learning
  redirect "/bitesize/articles/zmxc96f", to: "/bitesize/groups/cx1lpm3x7v4t", status: 301                             # Parents' Toolkit - Learning
  redirect "/bitesize/articles/zr99g7h", to: "/bitesize/groups/cx1lpm3x7v4t", status: 301                             # Parents' Toolkit - Learning
  redirect "/bitesize/articles/zp64cmn", to: "/bitesize/groups/cx1lpm3x7v4t", status: 301                             # Parents' Toolkit - Learning
  redirect "/bitesize/articles/zbnpxbk", to: "/bitesize/groups/cx1lpm3x7v4t", status: 301                             # Parents' Toolkit - Learning
  redirect "/bitesize/articles/zcnw8hv", to: "/bitesize/groups/cx1lpm3x7v4t", status: 301                             # Parents' Toolkit - Learning
  redirect "/bitesize/articles/zhm7jsg", to: "/bitesize/groups/cx1lpm3x7v4t", status: 301                             # Parents' Toolkit - Learning
  redirect "/bitesize/articles/z9948hv", to: "/bitesize/groups/cx1lpm3x7v4t", status: 301                             # Parents' Toolkit - Learning
  redirect "/bitesize/articles/zrsbrj6", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zpj896f", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/z6nk4xs", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zw3fn9q", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zq8cg7h", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zywtxbk", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zkbf3j6", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zt7q8hv", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/znxmjsg", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zn27dp3", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zdhxm39", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zg6qwnb", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/z3cbcmn", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zn3svwx", to: "/bitesize/groups/ceq8p90x033t", status: 301                             # Parents' Toolkit - Activities
  redirect "/bitesize/articles/zh9v382", to: "/bitesize/groups/c5vpkq13gpxt", status: 301                             # Parents' Toolkit - SEND
  redirect "/bitesize/articles/zh744xs", to: "/bitesize/groups/c5vpkq13gpxt", status: 301                             # Parents' Toolkit - SEND
  redirect "/bitesize/articles/zmcvrmn", to: "/bitesize/groups/c5vpkq13gpxt", status: 301                             # Parents' Toolkit - SEND
  redirect "/bitesize/articles/zw94bqt", to: "/bitesize/groups/c5vpkq13gpxt", status: 301                             # Parents' Toolkit - SEND
  redirect "/bitesize/articles/z6xmjsg", to: "/bitesize/groups/c5vpkq13gpxt", status: 301                             # Parents' Toolkit - SEND
  redirect "/bitesize/collections/starting-primary-school", to: "/bitesize/groups/cx1lpm3ve37t", status: 301          # Parents' Toolkit - Starting Primary School (English)
  redirect "/bitesize/collections/starting-primary-school/*any", to: "/bitesize/groups/cx1lpm3ve37t", status: 301     # Parents' Toolkit - Starting Primary School (English)
  redirect "/bitesize/articles/z6vfn9q", to: "/bitesize/groups/cjx58zqw94xt", status: 301                             # Parents' Toolkit - Starting Primary School (Welsh)
  redirect "/bitesize/tags/zh4wy9q/starting-secondary-school", to: "/bitesize/groups/c5vpkq1l934t", status: 301       # Parents' Toolkit - Starting Secondary School (English)
  redirect "/bitesize/tags/zh4wy9q/starting-secondary-school/*any", to: "/bitesize/groups/c5vpkq1l934t", status: 301  # Parents' Toolkit - Starting Secondary School (English)
  redirect "/bitesize/articles/zjkk96f", to: "/bitesize/groups/c5vpkq1l934t", status: 301                             # Parents' Toolkit - Starting Secondary School (English)
  redirect "/bitesize/articles/zhkjbdm", to: "/bitesize/groups/cq0zpjylx38t", status: 301                             # Parents' Toolkit - Starting Secondary School (Welsh)
  redirect "/bitesize/support", to: "/bitesize/study-support", status: 301                                            # Study Support
  redirect "/bitesize/articles/zv3bvwx", to: "/bitesize/groups/cp60w97z7y1t", status: 301                             # Study Support - Study Skills (English)
  redirect "/bitesize/articles/zfwnb7h", to: "/bitesize/groups/cp60w97z7y1t", status: 301                             # Study Support - Study Skills (English)
  redirect "/bitesize/articles/zqpnhcw", to: "/bitesize/groups/cp60w97z7y1t", status: 301                             # Study Support - Study Skills (English)
  redirect "/bitesize/articles/zxq76rd", to: "/bitesize/groups/cp60w97z7y1t", status: 301                             # Study Support - Study Skills (English)
  redirect "/bitesize/articles/zmt42sg", to: "/bitesize/groups/c89rm0640e9t", status: 301                             # Study Support - Study Skills (Welsh)
  redirect "/bitesize/articles/zghhxbk", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/articles/z877wnb", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/articles/zwtdwnb", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/articles/z42496f", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/articles/zcbcr2p", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/articles/zdbwmbk", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/articles/zcf3vwx", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/articles/z999r2p", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/articles/zrjqwnb", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/articles/ztxnp4j", to: "/bitesize/groups/cd5exmm663et", status: 301                             # Study Support - Exams and revision
  redirect "/bitesize/collections/exams-and-revision/1", to: "/bitesize/groups/c89rm0640e9t", status: 301             # Study Support - Exams and revision (Welsh)
  redirect "/bitesize/articles/z3x6m39", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/zc72qfr", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/z9cd8hv", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/zwnw8hv", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/zjf3vwx", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/zkyvvwx", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/z3sm7yc", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/zj3h6g8", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/zwkqjsg", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/z7ddkty", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/z4hsn9q", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/zn8jwnb", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/zhc2jhv", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/articles/z2rccmn", to: "/bitesize/groups/c306433371zt", status: 301                             # Study Support - Wellbeing
  redirect "/bitesize/collections/life-and-wellbeing/1", to: "/bitesize/groups/c306433371zt", status: 301             # Study Support - Wellbeing
  redirect "/bitesize/tags/z7qg6v4/mental-health/1", to: "/bitesize/groups/c306433371zt", status: 301                 # Study Support - Wellbeing

  redirect "/bitesize/articles/zv6yhbk", to: "/usingthebbc/privacy/privacy-notice-for-bbc-quizzes-and-polls", status: 301      # privacy-notice-for-bbc-quizzes-and-polls

  redirect "/bitesize/articles/z7j6jhv", to: "/bitesize/careers", status: 301                                                  # Careers homepage
  redirect "/bitesize/articles/zhst2sg", to: "/bitesize/groups/cpw27rkvq6pt", status: 301                                      # Jobs that use...
  redirect "/bitesize/articles/zmdc382", to: "/bitesize/groups/cpw27rkdkkyt", status: 301                                      # Careers in…
  redirect "/bitesize/collections/job-profiles", to: "/bitesize/groups/cpw27rkdkkyt", status: 301                              # Careers in…
  redirect "/bitesize/collections/job-profiles/*_any", to: "/bitesize/groups/cpw27rkdkkyt", status: 301                        # Careers in…
  redirect "/bitesize/articles/zv6992p", to: "/bitesize/groups/cpw27rkdkkyt", status: 301                                      # Careers in…
  redirect "/bitesize/articles/zn377nb", to: "/bitesize/groups/cpw27rkdkkyt", status: 301                                      # Careers in…
  redirect "/bitesize/articles/znyyt39", to: "/bitesize/groups/cpw27rkdkkyt", status: 301                                      # Careers in…
  redirect "/bitesize/tags/zbb692p/job-applications", to: "/bitesize/groups/ckqd82k4m03t", status: 301                         # Skills and qualities
  redirect "/bitesize/tags/zbb692p/job-applications/*_any", to: "/bitesize/groups/ckqd82k4m03t", status: 301                   # Skills and qualities
  redirect "/bitesize/tags/zrrh8xs/cvs", to: "/bitesize/groups/ckqd82k4m03t", status: 301                                      # Skills and qualities
  redirect "/bitesize/tags/zrrh8xs/cvs/*_any", to: "/bitesize/groups/ckqd82k4m03t", status: 301                                # Skills and qualities
  redirect "/bitesize/tags/znpwvk7/interviews", to: "/bitesize/groups/ckqd82k4m03t", status: 301                               # Skills and qualities
  redirect "/bitesize/tags/znpwvk7/interviews/*_any", to: "/bitesize/groups/ckqd82k4m03t", status: 301                         # Skills and qualities
  redirect "/bitesize/collections/tips-and-advice", to: "/bitesize/groups/ckqd82k4m03t", status: 301                           # Skills and qualities
  redirect "/bitesize/collections/tips-and-advice/*_any", to: "/bitesize/groups/ckqd82k4m03t", status: 301                    # Skills and qualities
  redirect "/bitesize/articles/zdyfhcw", to: "/bitesize/groups/ckqd82k4m03t", status: 301                                      # Skills and qualities
  redirect "/bitesize/articles/zn9k92p", to: "/bitesize/groups/ckqd82k4m03t", status: 301                                      # Skills and qualities
  redirect "/bitesize/articles/zmfstrd", to: "/bitesize/groups/ckqd82k4m03t", status: 301                                      # Skills and qualities
  redirect "/bitesize/articles/zkgbhbk", to: "/bitesize/groups/ckqd82k4m03t", status: 301                                      # Skills and qualities
  redirect "/bitesize/collections/college-and-apprenticeships", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301               # College, apprenticeships and uni
  redirect "/bitesize/collections/college-and-apprenticeships/*_any", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301         # College, apprenticeships and uni
  redirect "/bitesize/tags/z7vct39/apprenticeships", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301                          # College, apprenticeships and uni
  redirect "/bitesize/tags/z7vct39/apprenticeships/*_any", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301                    # College, apprenticeships and uni
  redirect "/bitesize/tags/zk9sjhv/college", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301                                  # College, apprenticeships and uni
  redirect "/bitesize/tags/zk9sjhv/college/*_any", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301                            # College, apprenticeships and uni
  redirect "/bitesize/tags/z6r8scw/university", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301                               # College, apprenticeships and uni
  redirect "/bitesize/tags/z6r8scw/university/*_any", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301                         # College, apprenticeships and uni
  redirect "/bitesize/tags/zjw3mfr/a-levels", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301                                 # College, apprenticeships and uni
  redirect "/bitesize/tags/zjw3mfr/a-levels/*_any", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301                           # College, apprenticeships and uni
  redirect "/bitesize/articles/zbwbnrd", to: "/bitesize/groups/cm5m6rkdwyvt", status: 301                                      # College, apprenticeships and uni
  redirect "/bitesize/articles/z79h2sg", to: "/bitesize/groups/cj13rxxpq0vt", status: 301                                      # Tips and inspiration
  redirect "/bitesize/articles/zvtrscw", to: "/bitesize/groups/cerwn4l35mrt", status: 301                                      # Careers in performing arts
  redirect "/bitesize/articles/znwtjhv", to: "/bitesize/groups/cpevl4pq6z4t", status: 301                                      # Careers in healthcare and frontline services
  redirect "/bitesize/articles/z7rd96f", to: "/bitesize/groups/cljdxvywe6rt", status: 301                                      # Careers in media and creative sector
  redirect "/bitesize/articles/z7t27nb", to: "/bitesize/groups/cljdxvywe6rt", status: 301                                      # Careers in media and creative sector
  redirect "/bitesize/articles/zdtgy9q", to: "/bitesize/groups/cxvx2n3zxkqt", status: 301                                      # Careers in education and childcare
  redirect "/bitesize/articles/zhbjkmn", to: "/bitesize/groups/cw9ydv3l74qt", status: 301                                      # Careers in agriculture, environment, sustainability and animal care
  redirect "/bitesize/articles/zr73pg8", to: "/bitesize/groups/c44dvle5jemt", status: 301                                      # Careers in business, marketing and finance
  redirect "/bitesize/tags/zk39nrd/jobs-that-use-modern-foreign-languages", to: "/bitesize/groups/c44r0vv4498t", status: 301          # Jobs that use Modern Languages
  redirect "/bitesize/tags/zk39nrd/jobs-that-use-modern-foreign-languages/*_any", to: "/bitesize/groups/c44r0vv4498t", status: 301    # Jobs that use Modern Languages
  redirect "/bitesize/tags/zhj692p/jobs-that-use-computing-and-ict", to: "/bitesize/groups/cvpqdxx04v3t", status: 301                 # Jobs that use Computing and ICT
  redirect "/bitesize/tags/zhj692p/jobs-that-use-computing-and-ict/*_any", to: "/bitesize/groups/cvpqdxx04v3t", status: 301           # Jobs that use Computing and ICT
  redirect "/bitesize/tags/zrsg6v4/jobs-that-use-maths", to: "/bitesize/groups/c2e2vnne0nkt", status: 301                             # Jobs that use Maths
  redirect "/bitesize/tags/zrsg6v4/jobs-that-use-maths/*_any", to: "/bitesize/groups/c2e2vnne0nkt", status: 301                       # Jobs that use Maths
  redirect "/bitesize/tags/zfmnwty/jobs-that-use-english-and-drama", to: "/bitesize/groups/cr0r5883rj8t", status: 301                 # Jobs that use English and Drama
  redirect "/bitesize/tags/zfmnwty/jobs-that-use-english-and-drama/*_any", to: "/bitesize/groups/cr0r5883rj8t", status: 301           # Jobs that use English and Drama
  redirect "/bitesize/tags/zbp3mfr/jobs-that-use-geography", to: "/bitesize/groups/c0rx344r1g5t", status: 301                         # Jobs that use Geography, History and Religious Studies
  redirect "/bitesize/tags/zbp3mfr/jobs-that-use-geography/*_any", to: "/bitesize/groups/c0rx344r1g5t", status: 301                   # Jobs that use Geography, History and Religious Studies
  redirect "/bitesize/tags/z7p6d6f/jobs-that-use-history", to: "/bitesize/groups/c0rx344r1g5t", status: 301                           # Jobs that use Geography, History and Religious Studies
  redirect "/bitesize/tags/z7p6d6f/jobs-that-use-history/*_any", to: "/bitesize/groups/c0rx344r1g5t", status: 301                     # Jobs that use Geography, History and Religious Studies
  redirect "/bitesize/tags/z79qbdm/jobs-that-use-religious-studies", to: "/bitesize/groups/c0rx344r1g5t", status: 301                 # Jobs that use Geography, History and Religious Studies
  redirect "/bitesize/tags/z79qbdm/jobs-that-use-religious-studies/*_any", to: "/bitesize/groups/c0rx344r1g5t", status: 301           # Jobs that use Geography, History and Religious Studies
  redirect "/bitesize/tags/zkjnwty/jobs-that-use-art-and-design", to: "/bitesize/groups/c44r0vv1xe4t", status: 301                    # Jobs that use Art and Design
  redirect "/bitesize/tags/zkjnwty/jobs-that-use-art-and-design/*_any", to: "/bitesize/groups/c44r0vv1xe4t", status: 301              # Jobs that use Art and Design
  redirect "/bitesize/tags/z4x3y9q/jobs-that-use-biology", to: "/bitesize/groups/ce8q155gnd3t", status: 301                           # Jobs that use Science
  redirect "/bitesize/tags/z4x3y9q/jobs-that-use-biology/*_any", to: "/bitesize/groups/ce8q155gnd3t", status: 301                     # Jobs that use Science
  redirect "/bitesize/tags/zdpcgwx/jobs-that-use-physics", to: "/bitesize/groups/ce8q155gnd3t", status: 301                           # Jobs that use Science
  redirect "/bitesize/tags/zdpcgwx/jobs-that-use-physics/*_any", to: "/bitesize/groups/ce8q155gnd3t", status: 301                     # Jobs that use Science
  redirect "/bitesize/tags/zktg382/jobs-that-use-chemistry", to: "/bitesize/groups/ce8q155gnd3t", status: 301                         # Jobs that use Science
  redirect "/bitesize/tags/zktg382/jobs-that-use-chemistry/*_any", to: "/bitesize/groups/ce8q155gnd3t", status: 301                   # Jobs that use Science
  redirect "/bitesize/tags/zjb8f4j/jobs-that-use-science", to: "/bitesize/groups/ce8q155gnd3t", status: 301                           # Jobs that use Science
  redirect "/bitesize/tags/zjb8f4j/jobs-that-use-science/*_any", to: "/bitesize/groups/ce8q155gnd3t", status: 301                     # Jobs that use Science
  redirect "/bitesize/tags/zjcwvk7/jobs-that-use-pe", to: "/bitesize/groups/c44r0vvjp5vt", status: 301                                # Jobs that use PE
  redirect "/bitesize/tags/zjcwvk7/jobs-that-use-pe/*_any", to: "/bitesize/groups/c44r0vvjp5vt", status: 301                          # Jobs that use PE
  redirect "/bitesize/tags/zn7h8xs/jobs-that-use-design-and-technology", to: "/bitesize/groups/cvpqdxxd824t", status: 301             # Jobs that use Design and Technology
  redirect "/bitesize/tags/zn7h8xs/jobs-that-use-design-and-technology/*_any", to: "/bitesize/groups/cvpqdxxd824t", status: 301       # Jobs that use Design and Technology
  redirect "/bitesize/tags/zd7fqp3/jobs-that-use-business", to: "/bitesize/groups/cynj6r3jy5yt", status: 301                          # Jobs that use Business Studies
  redirect "/bitesize/tags/zd7fqp3/jobs-that-use-business/*_any", to: "/bitesize/groups/cynj6r3jy5yt", status: 301                    # Jobs that use Business Studies
  redirect "/bitesize/tags/zdg8f4j/jobs-that-use-music", to: "/bitesize/groups/cn3zjnnjk8gt", status: 301                             # Jobs that use Music
  redirect "/bitesize/tags/zdg8f4j/jobs-that-use-music/*_any", to: "/bitesize/groups/cn3zjnnjk8gt", status: 301                       # Jobs that use Music
  redirect "/bitesize/tags/zvty7nb/jobs-that-use-food-and-nutrition", to: "/bitesize/groups/c5qrjvvnmqet", status: 301                # Jobs that use Food and Nutrition
  redirect "/bitesize/tags/zvty7nb/jobs-that-use-food-and-nutrition/*_any", to: "/bitesize/groups/c5qrjvvnmqet", status: 301          # Jobs that use Food and Nutrition
  redirect "/bitesize/tags/z4ychbk/jobs-that-use-media-studies", to: "/bitesize/groups/cjyxej576d4t", status: 301                     # Jobs that use Media Studies
  redirect "/bitesize/tags/z4ychbk/jobs-that-use-media-studies/*_any", to: "/bitesize/groups/cjyxej576d4t", status: 301               # Jobs that use Media Studies

  handle "/bitesize", using: "BitesizeHomePage"

  handle "/bitesize/primary", using: "BitesizePrimary"
  handle "/bitesize/preview/primary", using: "Bitesize", only_on: "test"

  handle "/bitesize/preview/secondary", using: "Bitesize", only_on: "test"

  handle "/bitesize/subjects", using: "Bitesize"
  handle "/bitesize/subjects/:id", using: "BitesizeSubjects" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/subjects/:id/year/:year_id", using: "BitesizeSubjectsYear" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/preview/subjects/:id", using: "Bitesize", only_on: "test" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/preview/subjects/:id/year/:year_id", using: "Bitesize", only_on: "test" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/courses/:id", using: "BitesizeTransition", only_on: "test"

  handle "/bitesize/articles/:id", using: "BitesizeArticles" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/topics/:topic_id/articles/:id", using: "BitesizeArticles" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/preview/articles/:id", using: "Bitesize", only_on: "test" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/preview/articles/:id/:game_version", using: "Bitesize", only_on: "test"
  handle "/bitesize/preview/topics/:topic_id/articles/:id", using: "Bitesize", only_on: "test" do
    return_404 if: !is_zid?(id)
  end


  handle "/bitesize/levels/:id", using: "BitesizeLevels"
  handle "/bitesize/levels/:id/year/:year_id", using: "BitesizeLevels" do
    return_404 if: !(
      String.match?(id, ~r/^(z3g4d2p)$/) and String.match?(year_id, ~r/^(zjpqqp3|z7s22sg)$/)
      or String.match?(id, ~r/^(zbr9wmn)$/) and String.match?(year_id, ~r/^(zmyxxyc|z63tt39|zhgppg8|zncsscw)$/)
    )
  end

  handle "/bitesize/preview/levels/:id", using: "Bitesize", only_on: "test"
  handle "/bitesize/preview/levels/:id/year/:year_id", using: "Bitesize", only_on: "test" do
    return_404 if: !(
      String.match?(id, ~r/^(z3g4d2p)$/) and String.match?(year_id, ~r/^(zjpqqp3|z7s22sg)$/)
      or String.match?(id, ~r/^(zbr9wmn)$/) and String.match?(year_id, ~r/^(zmyxxyc|z63tt39|zhgppg8|zncsscw)$/)
    )
  end

  handle "/bitesize/guides/:id/revision/:page", using: "BitesizeGuides" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/guides/:id/test", using: "BitesizeGuides" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/guides/:id/audio", using: "BitesizeGuides" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/guides/:id/video", using: "BitesizeGuides" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/preview/guides/:id/revision/:page", using: "Bitesize", only_on: "test" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/preview/guides/:id/test", using: "Bitesize", only_on: "test" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/preview/guides/:id/audio", using: "Bitesize", only_on: "test" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/preview/guides/:id/video", using: "Bitesize", only_on: "test" do
    return_404 if: !is_zid?(id)
  end

  handle "/bitesize/topics/:id", using: "BitesizeTopics"
  handle "/bitesize/topics/:id/year/:year_id", using: "BitesizeTopics"

  handle "/bitesize/preview/topics/:id", using: "Bitesize", only_on: "test"
  handle "/bitesize/preview/topics/:id/year/:year_id", using: "Bitesize", only_on: "test"
  handle "/bitesize/guides/:id/test.hybrid", using: "BitesizeLegacy"
  handle "/bitesize/groups/:id", using: "BitesizeTipoTopic"
  handle "/bitesize/parents", using: "BitesizeTipoTopic"
  handle "/bitesize/study-support", using: "BitesizeTipoTopic"
  handle "/bitesize/learn", using: "BitesizeTipoTopic"
  handle "/bitesize/careers", using: "BitesizeTipoTopic"
  handle "/bitesize/trending", using: "BitesizeTipoTopic", only_on: "test"

  handle "/bitesize/*any", using: "BitesizeLegacy"


  # Games
  handle "/games/*any", using: "Games"


  # Classic Apps

  handle "/content/trending/events", using: "ClassicApp" do
    return_404 if: true
  end
  handle "/content/cps/news/front_page", using: "ClassicAppNewsFrontpage"
  handle "/content/cps/news/live/*any", using: "ClassicAppNewsLive"
  handle "/content/cps/news/av/*any", using: "ClassicAppNewsAv"
  handle "/content/cps/news/articles/*any", using: "ClassicAppNewsArticles"
  handle "/content/cps/news/video_and_audio/*any", using: "ClassicAppNewsAudioVideo"
  handle "/content/cps/news/*any", using: "ClassicAppNewsCps"

  handle "/content/cps/sport/front-page", using: "ClassicAppSportFrontpage"
  handle "/content/cps/sport/live/*any", using: "ClassicAppSportLive"
  handle "/content/cps/sport/football/*any", using: "ClassicAppSportFootball"
  handle "/content/cps/sport/av/football/*any", using: "ClassicAppSportFootballAv"
  handle "/content/cps/sport/*any", using: "ClassicAppSportCps"

  handle "/content/cps/newsround/*any", using: "ClassicAppNewsround"
  handle "/content/cps/naidheachdan/*any", using: "ClassicAppNaidheachdan"
  handle "/content/cps/mundo/*any", using: "ClassicAppMundo"
  handle "/content/cps/arabic/*any", using: "ClassicAppArabic"
  handle "/content/cps/russian/*any", using: "ClassicAppRussianCps"
  handle "/content/cps/hindi/*any", using: "ClassicAppHindi"
  handle "/content/cps/learning_english/*any", using: "ClassicAppLearningEnglish"
  handle "/content/cps/:product/*any", using: "ClassicAppProducts"
  handle "/content/cps/*any", using: "ClassicAppCps"

  handle "/content/ldp/:guid", using: "ClassicAppFablLdp"
  handle "/content/most_popular/*any", using: "ClassicAppMostPopular"
  handle "/content/ww/*any", using: "ClassicAppWw"
  handle "/content/news/*any", using: "ClassicAppNews"
  handle "/content/sport/*any", using: "ClassicAppSport"
  handle "/content/russian/*any", using: "ClassicAppRussian"
  handle "/content/:hash", using: "ClassicAppId"
  handle "/content/:service/*any", using: "ClassicAppService"
  handle "/content/*any", using: "ClassicApp"
  handle "/static/*any", using: "ClassicAppStaticContent"
  handle "/flagpoles/*any", using: "ClassicAppFlagpole"

  # BBCX index routes
  handle "/business/*any", using: "BBCXIndex"
  handle "/future-planet/*any", using: "BBCXIndex"
  handle "/innovation/*any", using: "BBCXIndex"
  handle "/live", using: "BBCXIndex"
  handle "/video/*any", using: "BBCXIndex"
  handle "/watch-live-news", using: "BBCXIndex"

  # DotCom routes
  handle "/future", using: "DotComFuture"
  handle "/future/future-planet", using: "DotComFuture"
  handle "/future/article/:id", using: "DotComFuture"
  handle "/future/tags/:id", using: "DotComFuture"
  handle "/future/*any", using: "DotComFutureAny"
  handle "/culture", using: "DotComCulture"
  handle "/culture/article/:id", using: "DotComCulture"
  handle "/culture/art", using: "BBCXIndex"
  handle "/culture/books", using: "BBCXIndex"
  handle "/culture/entertainment-news", using: "BBCXIndex"
  handle "/culture/film-tv", using: "BBCXIndex"
  handle "/culture/music", using: "DotComCulture"
  handle "/culture/style", using: "DotComCulture"
  handle "/culture/tags/:id", using: "DotComCulture"
  handle "/culture/columns/film", using: "DotComCulture"
  handle "/culture/columns/art", using: "DotComCulture"
  handle "/culture/*any", using: "DotComCultureAny"
  handle "/reel", using: "DotComReel"
  handle "/reel/video/:id/:slug", using: "DotComReel"
  handle "/reel/topic/:id", using: "DotComReel"
  handle "/reel/*any", using: "DotComReelAny"
  handle "/travel", using: "DotComTravel"
  handle "/travel/article/:id", using: "DotComTravel"
  handle "/travel/adventures", using: "BBCXIndex"
  handle "/travel/cultural-experiences", using: "BBCXIndex"
  handle "/travel/destinations/*any", using: "DotComTravel"
  handle "/travel/history-heritage", using: "BBCXIndex"
  handle "/travel/specialist", using: "BBCXIndex"
  handle "/travel/worlds-table", using: "DotComTravel"
  handle "/travel/tags/:id", using: "DotComTravel"
  handle "/travel/columns/culture-identity", using: "DotComTravel"
  handle "/travel/columns/adventure-experience", using: "DotComTravel"
  handle "/travel/columns/the-specialist", using: "DotComTravel"
  handle "/travel/*any", using: "DotComTravelAny"
  handle "/worklife/article/:id", using: "DotComWorklife"
  handle "/worklife/tags/:id", using: "DotComWorklife"
  handle "/worklife/*any", using: "DotComWorklifeAny"

  # ElectoralComission routes
  handle "/election2023postcode/:postcode", using: "ElectoralCommissionPostcode" do
    return_404 if: !String.match?(postcode, ~r/^(GIR 0AA|[A-PR-UWYZ]([0-9]{1,2}|([A-HK-Y][0-9]|[A-HK-Y][0-9]([0-9]|[ABEHMNPRV-Y]))|[0-9][A-HJKPS-UW]) *[0-9][ABD-HJLNP-UW-Z]{2})$/)
  end
  handle "/election2023address/:uprn", using: "ElectoralCommissionAddress" do
    return_404 if: !String.match?(uprn, ~r/^\d{6,12}$/)
  end

  # Platform Health Observability endpoints for response time monitoring of Webcore platform
  handle "/_health/public_content", using: "PhoPublicContent"
  handle "/_health/private_content", using: "PhoPrivateContent"

  # handle "/news/business-:id", using: ["NewsStories", "NewsSFV", "MozartNews"]
  # handle "/news/business-:id", using: ["NewsBusiness", "MozartNews"]

  handle "/full-stack-test/a/*any", using: "FullStackTestA", only_on: "test"
  handle "/full-stack-test/b/*any", using: "FullStackTestB", only_on: "test"
  redirect "/full-stack-test/*any", to: "/full-stack-test/a/*any", status: 302

  handle "/echo", using: "EchoSpec", only_on: "test"

  # Personalised Account
  handle "/foryou", using: "PersonalisedAccount"

  handle_proxy_pass "/*any", using: "ProxyPass", only_on: "test"

  no_match()
end
