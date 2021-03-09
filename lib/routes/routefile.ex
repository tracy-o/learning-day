#
# How to add a route:
# https://github.com/bbc/belfrage/wiki/Routing-in-Belfrage#how-to-add-a-route
# What types of route matcher you can  use:
# https://github.com/bbc/belfrage/wiki/Types-of-Route-Matchers-in-Belfrage
#
defmodule Routes.Routefile do
  use BelfrageWeb.RouteMaster

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
  redirect("http://www.bbcrussian.com/*any", to: "https://www.bbc.com/russian/*any", status: 302)
  redirect("http://m.bbcrussian.com/*any", to: "https://www.bbc.com/russian/*any", status: 302)
  redirect("http://bbcrussian.com/*any", to: "https://www.bbc.com/russian/*any", status: 302)
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

  # RESFRAME-4095 for only-on routing test
  handle "/newstipo", using: "NewsTipoHomePage", only_on: "test", examples: ["/newstipo"]

  handle "/homepage/testing", using: "TestHomePage", only_on: "test", examples: ["/homepage/testing"]
  handle "/homepage/testing", using: "HomePage", examples: []

  handle "/homepage/preview", using: "HomePagePreview", only_on: "test", examples: ["/homepage/preview"]
  handle "/homepage/preview/scotland", using: "HomePagePreviewScotland", only_on: "test", examples: ["/homepage/preview/scotland"]
  handle "/homepage/preview/wales", using: "HomePagePreviewWales", only_on: "test", examples: ["/homepage/preview/wales"]
  handle "/homepage/preview/northernireland", using: "HomePagePreviewNorthernIreland", only_on: "test", examples: ["/homepage/preview/northernireland"]
  handle "/homepage/preview/cymru", using: "HomePagePreviewCymru", only_on: "test", examples: ["/homepage/preview/cymru"]
  handle "/homepage/preview/alba", using: "HomePagePreviewAlba", only_on: "test", examples: ["/homepage/preview/alba"]

  handle "/sportproto", using: "SportHomePage", only_on: "test", examples: ["/sportproto"]
  handle "/sporttipo", using: "SportTipo", only_on: "test", examples: ["/sporttipo"]

  # data endpoints

  handle "/fd/preview/:name", using: "FablData", examples: ["/fd/preview/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=2&platform=ios"]
  handle "/fd/:name", using: "FablData", examples: ["/fd/sport-app-page?page=http%3A%2F%2Fwww.bbc.co.uk%2Fsport%2Fgymnastics.app&v=2&platform=ios"]

  handle "/wc-data/container/:name", using: "ContainerData", examples: ["/wc-data/container/consent-banner"]
  handle "/wc-data/page-composition", using: "PageComposition", examples: ["/wc-data/page-composition?path=/search&params=%7B%7D"]

  # Search

  handle "/search", using: "Search", examples: ["/search"]
  handle "/chwilio", using: "WelshSearch", examples: ["/chwilio"]
  handle "/cbeebies/search", using: "Search", examples: ["/cbeebies/search"]
  handle "/cbbc/search", using: "Search", examples: ["/cbbc/search"]
  handle "/bitesize/search", using: "Search", examples: ["/bitesize/search"]
  handle "/sounds/search", using: "Search", examples: ["/sounds/search"]
  handle "/pres-test/new-chwilio", using: "WelshNewSearch", only_on: "test", examples: ["/pres-test/new-chwilio"]
  handle "/news/search", using: "NewsSearch", examples: ["/news/search"]

  # News

  handle "/news", using: "NewsHomePage", examples: ["/news"]

  handle "/news/live/:asset_id", using: "NewsLive", examples: ["/news/live/uk-55930940"] do
    return_404 if: !String.match?(asset_id, ~r/^([0-9]{5,9}|[a-z0-9\-_]+-[0-9]{5,9})$/)
  end

  handle "/news/live/:asset_id/page/:page_number", using: "NewsLive", examples: ["/news/live/uk-55930940/page/2"] do
    return_404 if: !String.match?(asset_id, ~r/^([0-9]{5,9}|[a-z0-9\-_]+-[0-9]{5,9})$/)
    return_404 if: !String.match?(page_number, ~r/\A[1-9][0-9]{0,2}\z/)
  end

  handle "/news/topics/:id/:slug", using: "NewsTopics", examples: [] do
    return_404 if: !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/)
    return_404 if: !String.match?(slug, ~r/^([a-z0-9-]+)$/)
  end

  handle "/news/topics/:id", using: "NewsTopics", examples: [] do
    return_404 if: !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/)
  end

  handle "/news/av/:id", using: "NewsVideos", examples: ["/news/av/48404351", "/news/av/uk-51729702", "/news/av/uk-england-hampshire-50266218", "/news/av/entertainment+arts-10646650"] do
      return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/news/video_and_audio/:index/:id/:slug", using: "NewsVideoAndAudio", examples: [{"/news/video_and_audio/must_see/54327412/scientists-create-a-microscopic-robot-that-walks", 301}, {"/news/video_and_audio/features/uk-36617915/36617915", 301}] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/news/articles/:optimo_id", using: "StorytellingPage", only_on: "test", examples: ["/news/articles/crkxdvxzwxko?mode=testData", "/news/articles/c3wmq4d1y3wo?mode=testData"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/news/:id", using: "NewsArticlePage", examples: ["/news/uk-politics-49336144", "/news/world-asia-china-51787936", "/news/technology-51960865", "/news/uk-england-derbyshire-18291916", "/news/entertainment+arts-10636043"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  # TODO issue with routes such as /news/education-46131593 being matched to the /news/:id matcher
  handle "/news/*_any", using: "News", examples: ["/news/election/2019", "/news/contact-us/editorial"]

  # Cymrufyw

  redirect "/newyddion/*any", to: "/cymrufyw/*any", status: 302
  redirect "/democratiaethfyw", to: "/cymrufyw/gwleidyddiaeth", status: 302

  handle "/cymrufyw/cylchgrawn", using: "Cymrufyw", examples: ["/cymrufyw/cylchgrawn"]
  handle "/cymrufyw/gwleidyddiaeth", using: "Cymrufyw", examples: ["/cymrufyw/gwleidyddiaeth"]
  handle "/cymrufyw/gogledd-orllewin", using: "Cymrufyw", examples: ["/cymrufyw/gogledd-orllewin"]
  handle "/cymrufyw/gogledd-ddwyrain", using: "Cymrufyw", examples: ["/cymrufyw/gogledd-ddwyrain"]
  handle "/cymrufyw/canolbarth", using: "Cymrufyw", examples: ["/cymrufyw/canolbarth"]
  handle "/cymrufyw/de-orllewin", using: "Cymrufyw", examples: ["/cymrufyw/de-orllewin"]
  handle "/cymrufyw/de-ddwyrain", using: "Cymrufyw", examples: ["/cymrufyw/de-ddwyrain"]
  handle "/cymrufyw/eisteddfod", using: "Cymrufyw", examples: ["/cymrufyw/eisteddfod"]
  handle "/cymrufyw/components", using: "Cymrufyw", examples: ["/cymrufyw/components"]
  handle "/cymrufyw/hafan", using: "Cymrufyw", examples: ["/cymrufyw/hafan"]
  handle "/cymrufyw/etholiad", using: "Cymrufyw", examples: ["/cymrufyw/etholiad"]

  handle "/cymrufyw/:id", using: "CymrufywArticlePage", examples: ["/cymrufyw/52998018", "/cymrufyw/52995676", "/cymrufyw/etholiad-2017-39407507"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  handle "/cymrufyw/saf/:id", using: "CymrufywVideos", examples: ["/cymrufyw/saf/53073086"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/cymrufyw/*_any", using: "Cymrufyw", examples: ["/cymrufyw"]

  # Naidheachdan

  handle "/naidheachdan/dachaigh", using: "Naidheachdan", examples: ["/naidheachdan/dachaigh"]
  handle "/naidheachdan/components", using: "Naidheachdan", examples: ["/naidheachdan/components"]

  handle "/naidheachdan/:id", using: "NaidheachdanArticlePage", examples: ["/naidheachdan/52992845", "/naidheachdan/52990788", "/naidheachdan/52991029"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  handle "/naidheachdan/fbh/:id", using: "NaidheachdanVideos", examples: ["/naidheachdan/fbh/53159144"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/naidheachdan/*_any", using: "Naidheachdan", examples: ["/naidheachdan"]

  handle "/pres-test/personalisation", using: "PresTestPersonalised", only_on: "test", examples: ["/pres-test/personalisation"]
  handle "/pres-test/*any", using: "PresTest", only_on: "test", examples: ["/pres-test/greeting-loader"]

  handle "/container/envelope/*any", using: "ContainerEnvelope", examples: ["/container/envelope/global-navigation/hasFetcher/true"]

  # World Service

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
  handle "/serbian.amp", using: "WorldServiceSerbian", examples: ["/serbian.amp"]
  handle "/serbian.json", using: "WorldServiceSerbian", examples: ["/serbian.json"]
  handle "/serbian/*_any", using: "WorldServiceSerbian", examples: ["/serbian", "/serbian/example-123", "/serbian/example-123.amp", "/serbian/example-123.json"]
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
  handle "/ukchina.amp", using: "WorldServiceUkChina", examples: [{"/ukchina.amp", 302}]
  handle "/ukchina/*_any", using: "WorldServiceUkChina", examples: ["/ukchina/simp", "/ukchina/trad", "/ukchina/trad.json", "/ukchina/trad.amp"]
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
  handle "/zhongwen.amp", using: "WorldServiceZhongwen", examples: [{"/zhongwen.amp", 302}]
  handle "/zhongwen.json", using: "WorldServiceZhongwen", examples: ["/zhongwen/simp", "/zhongwen/simp.json", "/zhongwen/simp.amp"]
  handle "/zhongwen/*_any", using: "WorldServiceZhongwen", examples: ["/zhongwen", "/zhongwen/example-123", "/zhongwen/example-123.amp", "/zhongwen/example-123.json"]

  handle "/ws/languages", using: "WsLanguages", examples: ["/ws/languages"]
  handle "/ws/av-embeds/*_any", using: "WsAvEmbeds", examples: []
  handle "/ws/includes/*_any", using: "WsIncludes", examples: ["/ws/includes/include/vjamericas/176-eclipse-lookup/mundo/app/embed"]

  # topics

  handle "/topics", using: "TopicPage", examples: ["/topics"]

  handle "/topics/:id", using: "TopicPage", examples: ["/topics/c583y7zk042t"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  # Sport

  ## Sport correspondents redirects
  redirect "/sport/andrewbenson", to: "/sport/topics/cl16knzpeq5t", status: 301
  redirect "/sport/danroan", to: "/sport/topics/cd61kendv7et", status: 301
  redirect "/sport/davewoods", to: "/sport/topics/c48de9x0zert", status: 301
  redirect "/sport/iaincarter", to: "/sport/topics/cezlkpjd8ent", status: 301
  redirect "/sport/jonathanagnew", to: "/sport/topics/cj26k5030q3t", status: 301
  redirect "/sport/mikecostello", to: "/sport/topics/cl16knzpjzzt", status: 301
  redirect "/sport/philmcnulty", to: "/sport/topics/c37dl80p4y3t", status: 301
  redirect "/sport/russellfuller", to: "/sport/topics/c5yd7pzqx6pt", status: 301
  redirect "/sport/tomenglish", to: "/sport/topics/cd61kend6lzt", status: 301
  
  redirect "/sport/correspondents/andrewbenson", to: "/sport/topics/cl16knzpeq5t", status: 301
  redirect "/sport/correspondents/danroan", to: "/sport/topics/cd61kendv7et", status: 301
  redirect "/sport/correspondents/davewoods", to: "/sport/topics/c48de9x0zert", status: 301
  redirect "/sport/correspondents/iaincarter", to: "/sport/topics/cezlkpjd8ent", status: 301
  redirect "/sport/correspondents/jonathanagnew", to: "/sport/topics/cj26k5030q3t", status: 301
  redirect "/sport/correspondents/mikecostello", to: "/sport/topics/cl16knzpjzzt", status: 301
  redirect "/sport/correspondents/philmcnulty", to: "/sport/topics/c37dl80p4y3t", status: 301
  redirect "/sport/correspondents/russellfuller", to: "/sport/topics/c5yd7pzqx6pt", status: 301
  redirect "/sport/correspondents/tomenglish", to: "/sport/topics/cd61kend6lzt", status: 301

  handle "/sport/extra/*_any", using: "Sport", examples: ["/sport/extra/c1nx5lutpg/The-real-Lewis-Hamilton-story"]

  handle "/sport/videos/service-worker.js", using: "SportVideos", examples: ["/sport/videos/service-worker.js"]
  handle "/sport/videos/:id", using: "SportVideos", examples: ["/sport/videos/49104905"] do
    return_404 if: String.length(id) != 8
  end

  # includes query string params in example URL to use live data in Mozart
  handle "/sport/av/:id.app", using: "SportMediaAssetPage", examples: ["/sport/av/51107180.app?morph_env=live&renderer_env=live"]
  handle "/sport/av/:id", using: "SportMediaAssetPage", examples: ["/sport/av/51107180?morph_env=live&renderer_env=live"]

  # includes query string params in example URL to use live data in Mozart
  handle "/sport/av/:section/:id.app", using: "SportMediaAssetPage", examples: ["/sport/av/football/55975423.app?morph_env=live&renderer_env=live"]

  # includes query string params in example URL to use live data in Mozart
  handle "/sport/av/:section/:id", using: "SportVideoAndAudio", examples: ["/sport/av/football/55975423?morph_env=live&renderer_env=live"] do
      return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end

  handle "/sport/sitemap.xml", using: "Sport", examples: ["/sport/sitemap.xml"]

  ## Sport Internal Tools
  handle "/sport/internal/football-team-selector/:slug", using: "Sport", examples: ["/sport/internal/football-team-selector/england-xi?morph_env=live&renderer_env=live"]
  handle "/sport/internal/player-rater/:event_id", using: "Sport", examples: ["/sport/internal/player-rater/EFBO2128305?morph_env=live&renderer_env=live"]
  handle "/sport/internal/ranked-list/:slug", using: "Sport", examples: ["/sport/internal/ranked-list/lions-2021-XV"]

  ## Sport Top 4
  handle "/sport/alpha/top-4.app", using: "Sport", examples: ["/sport/alpha/top-4.app"]
  handle "/sport/alpha/top-4", using: "Sport", examples: ["/sport/alpha/top-4"]
  handle "/sport/top-4.app", using: "Sport", examples: ["/sport/top-4.app"]
  handle "/sport/top-4", using: "Sport", examples: ["/sport/top-4"]

  ## Sport BBC Live
  handle "/sport/live/*_any", using: "SportLivePage", examples: ["/sport/live/football/52581366.app", "/sport/live/football/52581366"]
  handle "/sport/live-guide.app", using: "Sport", examples: ["/sport/live-guide.app"]
  handle "/sport/live-guide", using: "Sport", examples: ["/sport/live-guide"]
  handle "/sport/live-guide/*_any", using: "Sport", examples: ["/sport/live-guide/football.app", "/sport/live-guide/football"]

  ## Sport Video Collections
  handle "/sport/:discipline/video.app", using: "SportMediaAssetPage", examples: ["/sport/cricket/video.app"]
  handle "/sport/:discipline/video", using: "SportMediaAssetPage", examples: ["/sport/cricket/video"]
  handle "/sport/:discipline/:tournament/video.app", using: "SportMediaAssetPage", examples: ["/sport/football/fa-cup/video.app"]
  handle "/sport/:discipline/:tournament/video", using: "SportMediaAssetPage", examples: ["/sport/football/fa-cup/video"]

  ## Sport Stories with Vanity Urls 
  handle "/sport/all-sports.app", using: "SportStoryPage", examples: ["/sport/all-sports.app"]
  handle "/sport/all-sports", using: "SportStoryPage", examples: ["/sport/all-sports"]
  handle "/sport/cricket/teams.app", using: "SportStoryPage", examples: ["/sport/cricket/teams.app"]
  handle "/sport/cricket/teams", using: "SportStoryPage", examples: ["/sport/cricket/teams"]
  handle "/sport/football/gossip.app", using: "SportStoryPage", examples: ["/sport/football/gossip.app"]
  handle "/sport/football/gossip", using: "SportStoryPage", examples: ["/sport/football/gossip"]
  handle "/sport/football/leagues-cups.app", using: "SportStoryPage", examples: ["/sport/football/leagues-cups.app"]
  handle "/sport/football/leagues-cups", using: "SportStoryPage", examples: ["/sport/football/leagues-cups"]
  handle "/sport/football/scottish/gossip.app", using: "SportStoryPage", examples: ["/sport/football/scottish/gossip.app"]
  handle "/sport/football/scottish/gossip", using: "SportStoryPage", examples: ["/sport/football/scottish/gossip"]
  handle "/sport/football/teams.app", using: "SportStoryPage", examples: ["/sport/football/teams.app"]
  handle "/sport/football/teams", using: "SportStoryPage", examples: ["/sport/football/teams"]
  handle "/sport/football/transfers.app", using: "SportStoryPage", examples: ["/sport/football/transfers.app"]
  handle "/sport/football/transfers", using: "SportStoryPage", examples: ["/sport/football/transfers"]
  handle "/sport/my-sport.app", using: "SportStoryPage", examples: ["/sport/my-sport.app"]
  handle "/sport/my-sport", using: "SportStoryPage", examples: ["/sport/my-sport"]
  handle "/sport/rugby-league/teams.app", using: "SportStoryPage", examples: ["/sport/rugby-league/teams.app"]
  handle "/sport/rugby-league/teams", using: "SportStoryPage", examples: ["/sport/rugby-league/teams"]
  handle "/sport/rugby-union/teams.app", using: "SportStoryPage", examples: ["/sport/rugby-union/teams.app"]
  handle "/sport/rugby-union/teams", using: "SportStoryPage", examples: ["/sport/rugby-union/teams"]

  ## Sport Manual Indexes
  handle "/sport.app", using: "SportIndexPage", examples: ["/sport.app"]
  handle "/sport", using: "SportIndexPage", examples: ["/sport"]
  handle "/sport/africa.app", using: "SportIndexPage", examples: ["/sport/africa.app"]
  handle "/sport/africa", using: "SportIndexPage", examples: ["/sport/africa"]
  handle "/sport/american-football.app", using: "SportIndexPage", examples: ["/sport/american-football.app"]
  handle "/sport/american-football", using: "SportIndexPage", examples: ["/sport/american-football"]
  handle "/sport/athletics.app", using: "SportIndexPage", examples: ["/sport/athletics.app"]
  handle "/sport/athletics", using: "SportIndexPage", examples: ["/sport/athletics"]
  handle "/sport/basketball.app", using: "SportIndexPage", examples: ["/sport/basketball.app"]
  handle "/sport/basketball", using: "SportIndexPage", examples: ["/sport/basketball"]
  handle "/sport/boxing.app", using: "SportIndexPage", examples: ["/sport/boxing.app"]
  handle "/sport/boxing", using: "SportIndexPage", examples: ["/sport/boxing"]
  handle "/sport/commonwealth-games.app", using: "SportIndexPage", examples: ["/sport/commonwealth-games.app"]
  handle "/sport/commonwealth-games", using: "SportIndexPage", examples: ["/sport/commonwealth-games"]
  handle "/sport/cricket.app", using: "SportIndexPage", examples: ["/sport/cricket.app"]
  handle "/sport/cricket", using: "SportIndexPage", examples: ["/sport/cricket"]
  handle "/sport/cricket/counties.app", using: "SportIndexPage", examples: ["/sport/cricket/counties.app"]
  handle "/sport/cricket/counties", using: "SportIndexPage", examples: ["/sport/cricket/counties"]
  handle "/sport/cricket/womens.app", using: "SportIndexPage", examples: ["/sport/cricket/womens.app"]
  handle "/sport/cricket/womens", using: "SportIndexPage", examples: ["/sport/cricket/womens"]
  handle "/sport/cycling.app", using: "SportIndexPage", examples: ["/sport/cycling.app"]
  handle "/sport/cycling", using: "SportIndexPage", examples: ["/sport/cycling"]
  handle "/sport/disability-sport.app", using: "SportIndexPage", examples: ["/sport/disability-sport.app"]
  handle "/sport/disability-sport", using: "SportIndexPage", examples: ["/sport/disability-sport"]
  handle "/sport/england.app", using: "SportIndexPage", examples: ["/sport/england.app"]
  handle "/sport/england", using: "SportIndexPage", examples: ["/sport/england"]
  handle "/sport/football.app", using: "SportIndexPage", examples: ["/sport/football.app"]
  handle "/sport/football", using: "SportIndexPage", examples: ["/sport/football"]
  handle "/sport/football/championship.app", using: "SportIndexPage", examples: ["/sport/football/championship.app"]
  handle "/sport/football/championship", using: "SportIndexPage", examples: ["/sport/football/championship"]
  handle "/sport/football/european-championship.app", using: "SportIndexPage", examples: ["/sport/football/european-championship.app"]
  handle "/sport/football/european-championship", using: "SportIndexPage", examples: ["/sport/football/european-championship"]
  handle "/sport/football/european.app", using: "SportIndexPage", examples: ["/sport/football/european.app"]
  handle "/sport/football/european", using: "SportIndexPage", examples: ["/sport/football/european"]
  handle "/sport/football/fa-cup.app", using: "SportIndexPage", examples: ["/sport/football/fa-cup.app"]
  handle "/sport/football/fa-cup", using: "SportIndexPage", examples: ["/sport/football/fa-cup"]
  handle "/sport/football/irish.app", using: "SportIndexPage", examples: ["/sport/football/irish.app"]
  handle "/sport/football/irish", using: "SportIndexPage", examples: ["/sport/football/irish"]
  handle "/sport/football/premier-league.app", using: "SportIndexPage", examples: ["/sport/football/premier-league.app"]
  handle "/sport/football/premier-league", using: "SportIndexPage", examples: ["/sport/football/premier-league"]
  handle "/sport/football/scottish.app", using: "SportIndexPage", examples: ["/sport/football/scottish.app"]
  handle "/sport/football/scottish", using: "SportIndexPage", examples: ["/sport/football/scottish"]
  handle "/sport/football/welsh.app", using: "SportIndexPage", examples: ["/sport/football/welsh.app"]
  handle "/sport/football/welsh", using: "SportIndexPage", examples: ["/sport/football/welsh"]
  handle "/sport/football/womens.app", using: "SportIndexPage", examples: ["/sport/football/womens.app"]
  handle "/sport/football/womens", using: "SportIndexPage", examples: ["/sport/football/womens"]
  handle "/sport/football/world-cup.app", using: "SportIndexPage", examples: ["/sport/football/world-cup.app"]
  handle "/sport/football/world-cup", using: "SportIndexPage", examples: ["/sport/football/world-cup"]
  handle "/sport/formula1.app", using: "SportIndexPage", examples: ["/sport/formula1.app"]
  handle "/sport/formula1", using: "SportIndexPage", examples: ["/sport/formula1"]
  handle "/sport/get-inspired.app", using: "SportIndexPage", examples: ["/sport/get-inspired.app"]
  handle "/sport/get-inspired", using: "SportIndexPage", examples: ["/sport/get-inspired"]
  handle "/sport/get-inspired/activity-guides.app", using: "SportIndexPage", examples: ["/sport/get-inspired/activity-guides.app"]
  handle "/sport/get-inspired/activity-guides", using: "SportIndexPage", examples: ["/sport/get-inspired/activity-guides"]
  handle "/sport/golf.app", using: "SportIndexPage", examples: ["/sport/golf.app"]
  handle "/sport/golf", using: "SportIndexPage", examples: ["/sport/golf"]
  handle "/sport/horse-racing.app", using: "SportIndexPage", examples: ["/sport/horse-racing.app"]
  handle "/sport/horse-racing", using: "SportIndexPage", examples: ["/sport/horse-racing"]
  handle "/sport/mixed-martial-arts.app", using: "SportIndexPage", examples: ["/sport/mixed-martial-arts.app"]
  handle "/sport/mixed-martial-arts", using: "SportIndexPage", examples: ["/sport/mixed-martial-arts"]
  handle "/sport/motorsport.app", using: "SportIndexPage", examples: ["/sport/motorsport.app"]
  handle "/sport/motorsport", using: "SportIndexPage", examples: ["/sport/motorsport"]
  handle "/sport/netball.app", using: "SportIndexPage", examples: ["/sport/netball.app"]
  handle "/sport/netball", using: "SportIndexPage", examples: ["/sport/netball"]
  handle "/sport/northern-ireland.app", using: "SportIndexPage", examples: ["/sport/northern-ireland.app"]
  handle "/sport/northern-ireland", using: "SportIndexPage", examples: ["/sport/northern-ireland"]
  handle "/sport/northern-ireland/gaelic-games.app", using: "SportIndexPage", examples: ["/sport/northern-ireland/gaelic-games.app"]
  handle "/sport/northern-ireland/gaelic-games", using: "SportIndexPage", examples: ["/sport/northern-ireland/gaelic-games"]
  handle "/sport/northern-ireland/motorbikes.app", using: "SportIndexPage", examples: ["/sport/northern-ireland/motorbikes.app"]
  handle "/sport/northern-ireland/motorbikes", using: "SportIndexPage", examples: ["/sport/northern-ireland/motorbikes"]
  handle "/sport/olympics.app", using: "SportIndexPage", examples: ["/sport/olympics.app"]
  handle "/sport/olympics", using: "SportIndexPage", examples: ["/sport/olympics"]
  handle "/sport/rugby-league.app", using: "SportIndexPage", examples: ["/sport/rugby-league.app"]
  handle "/sport/rugby-league", using: "SportIndexPage", examples: ["/sport/rugby-league"]
  handle "/sport/rugby-union.app", using: "SportIndexPage", examples: ["/sport/rugby-union.app"]
  handle "/sport/rugby-union", using: "SportIndexPage", examples: ["/sport/rugby-union"]
  handle "/sport/rugby-union/english.app", using: "SportIndexPage", examples: ["/sport/rugby-union/english.app"]
  handle "/sport/rugby-union/english", using: "SportIndexPage", examples: ["/sport/rugby-union/english"]
  handle "/sport/rugby-union/irish.app", using: "SportIndexPage", examples: ["/sport/rugby-union/irish.app"]
  handle "/sport/rugby-union/irish", using: "SportIndexPage", examples: ["/sport/rugby-union/irish"]
  handle "/sport/rugby-union/scottish.app", using: "SportIndexPage", examples: ["/sport/rugby-union/scottish.app"]
  handle "/sport/rugby-union/scottish", using: "SportIndexPage", examples: ["/sport/rugby-union/scottish"]
  handle "/sport/rugby-union/welsh.app", using: "SportIndexPage", examples: ["/sport/rugby-union/welsh.app"]
  handle "/sport/rugby-union/welsh", using: "SportIndexPage", examples: ["/sport/rugby-union/welsh"]
  handle "/sport/scotland.app", using: "SportIndexPage", examples: ["/sport/scotland.app"]
  handle "/sport/scotland", using: "SportIndexPage", examples: ["/sport/scotland"]
  handle "/sport/snooker.app", using: "SportIndexPage", examples: ["/sport/snooker.app"]
  handle "/sport/snooker", using: "SportIndexPage", examples: ["/sport/snooker"]
  handle "/sport/sports-personality.app", using: "SportIndexPage", examples: ["/sport/sports-personality.app"]
  handle "/sport/sports-personality", using: "SportIndexPage", examples: ["/sport/sports-personality"]
  handle "/sport/swimming.app", using: "SportIndexPage", examples: ["/sport/swimming.app"]
  handle "/sport/swimming", using: "SportIndexPage", examples: ["/sport/swimming"]
  handle "/sport/tennis.app", using: "SportIndexPage", examples: ["/sport/tennis.app"]
  handle "/sport/tennis", using: "SportIndexPage", examples: ["/sport/tennis"]
  handle "/sport/wales.app", using: "SportIndexPage", examples: ["/sport/wales.app"]
  handle "/sport/wales", using: "SportIndexPage", examples: ["/sport/wales"]
  handle "/sport/winter-olympics.app", using: "SportIndexPage", examples: ["/sport/winter-olympics.app"]
  handle "/sport/winter-olympics", using: "SportIndexPage", examples: ["/sport/winter-olympics"]
  handle "/sport/winter-sports.app", using: "SportIndexPage", examples: ["/sport/winter-sports.app"]
  handle "/sport/winter-sports", using: "SportIndexPage", examples: ["/sport/winter-sports"]

  ## Sport Calendars
  handle "/sport/:discipline/calendar.app", using: "SportDataPage", examples: ["/sport/formula1/calendar.app"]
  handle "/sport/:discipline/calendar", using: "SportDataPage", examples: ["/sport/formula1/calendar"]
  handle "/sport/:discipline/calendar/*_any", using: "SportDataPage", examples: ["/sport/winter-sports/calendar/2021-05", "/sport/winter-sports/calendar/2021-05.app"]

  ## Sport Fixtures pages
  handle "/sport/:discipline/:tournament/fixtures.app", using: "SportDataPage", examples: ["/sport/basketball/nba/fixtures.app"]
  handle "/sport/:discipline/:tournament/fixtures", using: "SportDataPage", examples: ["/sport/basketball/nba/fixtures"]
  handle "/sport/:discipline/fixtures.app", using: "SportDataPage", examples: ["/sport/ice-hockey/fixtures.app"]
  handle "/sport/:discipline/fixtures", using: "SportDataPage", examples: ["/sport/ice-hockey/fixtures"]

  ## Sport Horse Racing Results
  handle "/sport/horse-racing/:tournament/results.app", using: "SportDataPage", examples: ["/sport/horse-racing/uk-ireland/results.app"]
  handle "/sport/horse-racing/:tournament/results", using: "SportDataPage", examples: ["/sport/horse-racing/uk-ireland/results"]
  handle "/sport/horse-racing/:tournament/results/*_any", using: "SportDataPage", examples: ["/sport/horse-racing/uk-ireland/results/2021-02-26", "/sport/horse-racing/uk-ireland/results/2021-02-26.app"]

  ## Sport Results pages
  handle "/sport/:discipline/:tournament/results.app", using: "SportDataPage", examples: ["/sport/athletics/british-championship/results.app"]
  handle "/sport/:discipline/:tournament/results", using: "SportDataPage", examples: ["/sport/athletics/british-championship/results"]
  handle "/sport/:discipline/results.app", using: "SportDataPage", examples: ["/sport/snooker/results.app"]
  handle "/sport/:discipline/results", using: "SportDataPage", examples: ["/sport/snooker/results"]

  ## Sport Scores-Fixtures pages
  handle "/sport/:discipline/scores-fixtures.app", using: "SportDataPage", examples: ["/sport/football/scores-fixtures.app"]
  handle "/sport/:discipline/scores-fixtures", using: "SportDataPage", examples: ["/sport/football/scores-fixtures"]
  handle "/sport/:discipline/scores-fixtures/*_any", using: "SportDataPage", examples: ["/sport/football/scores-fixtures/2021-02-27", "/sport/football/scores-fixtures/2021-02-27.app"]
  handle "/sport/:discipline/:tournament/scores-fixtures.app", using: "SportDataPage", examples: ["/sport/football/champions-league/scores-fixtures.app"]
  handle "/sport/:discipline/:tournament/scores-fixtures", using: "SportDataPage", examples: ["/sport/football/champions-league/scores-fixtures"]
  handle "/sport/:discipline/:tournament/scores-fixtures/*_any", using: "SportDataPage", examples: ["/sport/football/champions-league/scores-fixtures/2021-02", "/sport/football/champions-league/scores-fixtures/2021-02.app"]
  handle "/sport/:discipline/teams/:team/scores-fixtures.app", using: "SportDataPage", examples: ["/sport/football/teams/manchester-united/scores-fixtures.app"]
  handle "/sport/:discipline/teams/:team/scores-fixtures", using: "SportDataPage", examples: ["/sport/football/teams/manchester-united/scores-fixtures"]
  handle "/sport/:discipline/teams/:team/scores-fixtures/*_any", using: "SportDataPage", examples: ["/sport/football/teams/manchester-united/scores-fixtures/2021-02", "/sport/football/teams/manchester-united/scores-fixtures/2021-02.app"]

  ## Sport Table pages
  handle "/sport/:discipline/tables.app", using: "SportDataPage", examples: ["/sport/football/tables.app"]
  handle "/sport/:discipline/tables", using: "SportDataPage", examples: ["/sport/football/tables"]
  handle "/sport/:discipline/:tournament/table.app", using: "SportDataPage", examples: ["/sport/football/championship/table.app"]
  handle "/sport/:discipline/:tournament/table", using: "SportDataPage", examples: ["/sport/football/championship/table"]
  handle "/sport/:discipline/teams/:team/table.app", using: "SportDataPage", examples: ["/sport/football/teams/arsenal/table.app"]
  handle "/sport/:discipline/teams/:team/table", using: "SportDataPage", examples: ["/sport/football/teams/arsenal/table"]

  ## Sport Cricket Averages
  handle "/sport/cricket/averages.app", using: "SportDataPage", examples: ["/sport/cricket/averages.app"]
  handle "/sport/cricket/averages", using: "SportDataPage", examples: ["/sport/cricket/averages"]
  handle "/sport/cricket/:tournament/averages.app", using: "SportDataPage", examples: ["/sport/cricket/indian-premier-league/averages.app"]
  handle "/sport/cricket/:tournament/averages", using: "SportDataPage", examples: ["/sport/cricket/indian-premier-league/averages"]
  handle "/sport/cricket/teams/:team/averages.app", using: "SportDataPage", examples: ["/sport/cricket/teams/lancashire/averages.app"]
  handle "/sport/cricket/teams/:team/averages", using: "SportDataPage", examples: ["/sport/cricket/teams/lancashire/averages"]

  ## Sport Football Top-Scorers
  handle "/sport/football/:tournament/top-scorers.app", using: "SportDataPage", examples: ["/sport/football/european-championship/top-scorers.app"]
  handle "/sport/football/:tournament/top-scorers", using: "SportDataPage", examples: ["/sport/football/european-championship/top-scorers"]
  handle "/sport/football/:tournament/top-scorers/assists.app", using: "SportDataPage", examples: ["/sport/football/european-championship/top-scorers/assists.app"]
  handle "/sport/football/:tournament/top-scorers/assists", using: "SportDataPage", examples: ["/sport/football/european-championship/top-scorers/assists"]
  handle "/sport/football/teams/:team/top-scorers.app", using: "SportDataPage", examples: ["/sport/football/teams/everton/top-scorers.app"]
  handle "/sport/football/teams/:team/top-scorers", using: "SportDataPage", examples: ["/sport/football/teams/everton/top-scorers"]
  handle "/sport/football/teams/:team/top-scorers/assists.app", using: "SportDataPage", examples: ["/sport/football/teams/everton/top-scorers/assists.app"]
  handle "/sport/football/teams/:team/top-scorers/assists", using: "SportDataPage", examples: ["/sport/football/teams/everton/top-scorers/assists"]

  ## Sport Formula 1 Pages
  handle "/sport/formula1/latest.app", using: "SportDataPage", examples: ["/sport/formula1/latest.app"]
  handle "/sport/formula1/latest", using: "SportDataPage", examples: ["/sport/formula1/latest"]
  handle "/sport/formula1/results.app", using: "SportDataPage", examples: ["/sport/formula1/results.app"]
  handle "/sport/formula1/results", using: "SportDataPage", examples: ["/sport/formula1/results"]
  handle "/sport/formula1/:season/results.app", using: "SportDataPage", examples: ["/sport/formula1/2020/results.app"]
  handle "/sport/formula1/:season/results", using: "SportDataPage", examples: ["/sport/formula1/2020/results"]
  handle "/sport/formula1/:season/:tournament/results.app", using: "SportDataPage", examples: ["/sport/formula1/2019/monaco-grand-prix/results.app"]
  handle "/sport/formula1/:season/:tournament/results", using: "SportDataPage", examples: ["/sport/formula1/2019/monaco-grand-prix/results"]
  handle "/sport/formula1/:season/:tournament/results/*_any", using: "SportDataPage", examples: ["/sport/formula1/2020/70th-anniversary-grand-prix/results/qualifying.app", "/sport/formula1/2020/70th-anniversary-grand-prix/results/race"]
  handle "/sport/formula1/constructors-world-championship/standings.app", using: "SportDataPage", examples: ["/sport/formula1/constructors-world-championship/standings.app"]
  handle "/sport/formula1/constructors-world-championship/standings", using: "SportDataPage", examples: ["/sport/formula1/constructors-world-championship/standings"]
  handle "/sport/formula1/drivers-world-championship/standings.app", using: "SportDataPage", examples: ["/sport/formula1/drivers-world-championship/standings.app"]
  handle "/sport/formula1/drivers-world-championship/standings", using: "SportDataPage", examples: ["/sport/formula1/drivers-world-championship/standings"]

  ## Sport Golf Leaderboard
  handle "/sport/golf/leaderboard.app", using: "SportDataPage", examples: ["/sport/golf/leaderboard.app"]
  handle "/sport/golf/leaderboard", using: "SportDataPage", examples: ["/sport/golf/leaderboard"]
  handle "/sport/golf/:tournament/leaderboard.app", using: "SportDataPage", examples: ["/sport/golf/lpga-tour/leaderboard.app"]
  handle "/sport/golf/:tournament/leaderboard", using: "SportDataPage", examples: ["/sport/golf/lpga-tour/leaderboard"]

  ## Sport Tennis Pages
  handle "/sport/tennis/live-scores.app", using: "SportDataPage", examples: ["/sport/tennis/live-scores.app"]
  handle "/sport/tennis/live-scores", using: "SportDataPage", examples: ["/sport/tennis/live-scores"]
  handle "/sport/tennis/live-scores/*_any", using: "SportDataPage", examples: ["/sport/tennis/live-scores/australian-open.app", "/sport/tennis/live-scores/australian-open"]
  handle "/sport/tennis/order-of-play.app", using: "SportDataPage", examples: ["/sport/tennis/order-of-play.app"]
  handle "/sport/tennis/order-of-play", using: "SportDataPage", examples: ["/sport/tennis/order-of-play"]
  handle "/sport/tennis/order-of-play/*_any", using: "SportDataPage", examples: ["/sport/tennis/order-of-play/australian-open.app", "/sport/tennis/order-of-play/australian-open"]
  handle "/sport/tennis/results.app", using: "SportDataPage", examples: ["/sport/tennis/results.app"]
  handle "/sport/tennis/results", using: "SportDataPage", examples: ["/sport/tennis/results"]
  handle "/sport/tennis/results/*_any", using: "SportDataPage", examples: ["/sport/tennis/results/australian-open/mens-singles.app", "/sport/tennis/results/australian-open/mens-singles"]

  ## Sport Event Data Pages 
  handle "/sport/cricket/scorecard/:id.app", using: "SportDataPage", examples: ["/sport/cricket/scorecard/ECKO39913.app"]
  handle "/sport/cricket/scorecard/:id", using: "SportDataPage", examples: ["/sport/cricket/scorecard/ECKO39913"]
  handle "/sport/horse-racing/race/:id.app", using: "SportDataPage", examples: ["/sport/horse-racing/race/EHRP771835.app"]
  handle "/sport/horse-racing/race/:id", using: "SportDataPage", examples: ["/sport/horse-racing/race/EHRP771835"]
  handle "/sport/rugby-league/match/:id.app", using: "SportDataPage", examples: ["/sport/rugby-league/match/EVP3210786.app"]
  handle "/sport/rugby-league/match/:id", using: "SportDataPage", examples: ["/sport/rugby-league/match/EVP3210786"]
  handle "/sport/rugby-union/match/:id.app", using: "SportDataPage", examples: ["/sport/rugby-union/match/EVP3207417.app"]
  handle "/sport/rugby-union/match/:id", using: "SportDataPage", examples: ["/sport/rugby-union/match/EVP3207417"]

  handle "/sport/topics/:id", using: "SportTopicPage", examples: ["/sport/topics/cd61kendv7et"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  handle "/sport/topics-test-blitzball", using: "SportDisciplineTopic", only_on: "test", examples: ["/sport/topics-test-blitzball"]

  handle "/sport/alpine-skiing", using: "SportDisciplineTopic", examples: ["/sport/alpine-skiing"]
  handle "/sport/archery", using: "SportDisciplineTopic", examples: ["/sport/archery"]
  handle "/sport/badminton", using: "SportDisciplineTopic", examples: ["/sport/badminton"]
  handle "/sport/baseball", using: "SportDisciplineTopic", examples: ["/sport/baseball"]
  handle "/sport/biathlon", using: "SportDisciplineTopic", examples: ["/sport/biathlon"]
  handle "/sport/bobsleigh", using: "SportDisciplineTopic", examples: ["/sport/bobsleigh"]
  handle "/sport/bowls", using: "SportDisciplineTopic", examples: ["/sport/bowls"]
  handle "/sport/canoeing", using: "SportDisciplineTopic", examples: ["/sport/canoeing"]
  handle "/sport/cross-country-skiing", using: "SportDisciplineTopic", examples: ["/sport/cross-country-skiing"]
  handle "/sport/curling", using: "SportDisciplineTopic", examples: ["/sport/curling"]
  handle "/sport/darts", using: "SportDisciplineTopic", examples: ["/sport/darts"]
  handle "/sport/diving", using: "SportDisciplineTopic", examples: ["/sport/diving"]
  handle "/sport/equestrian", using: "SportDisciplineTopic", examples: ["/sport/equestrian"]
  handle "/sport/fencing", using: "SportDisciplineTopic", examples: ["/sport/fencing"]
  handle "/sport/figure-skating", using: "SportDisciplineTopic", examples: ["/sport/figure-skating"]
  handle "/sport/freestyle-skiing", using: "SportDisciplineTopic", examples: ["/sport/freestyle-skiing"]
  handle "/sport/gymnastics", using: "SportDisciplineTopic", examples: ["/sport/gymnastics"]
  handle "/sport/handball", using: "SportDisciplineTopic", examples: ["/sport/handball"]
  handle "/sport/hockey", using: "SportDisciplineTopic", examples: ["/sport/hockey"]
  handle "/sport/ice-hockey", using: "SportDisciplineTopic", examples: ["/sport/ice-hockey"]
  handle "/sport/judo", using: "SportDisciplineTopic", examples: ["/sport/judo"]
  handle "/sport/luge", using: "SportDisciplineTopic", examples: ["/sport/luge"]
  handle "/sport/modern-pentathlon", using: "SportDisciplineTopic", examples: ["/sport/modern-pentathlon"]
  handle "/sport/nordic-combined", using: "SportDisciplineTopic", examples: ["/sport/nordic-combined"]
  handle "/sport/rowing", using: "SportDisciplineTopic", examples: ["/sport/rowing"]
  handle "/sport/rugby-sevens", using: "SportDisciplineTopic", examples: ["/sport/rugby-sevens"]
  handle "/sport/sailing", using: "SportDisciplineTopic", examples: ["/sport/sailing"]
  handle "/sport/shooting", using: "SportDisciplineTopic", examples: ["/sport/shooting"]
  handle "/sport/short-track-skating", using: "SportDisciplineTopic", examples: ["/sport/short-track-skating"]
  handle "/sport/skeleton", using: "SportDisciplineTopic", examples: ["/sport/skeleton"]
  handle "/sport/ski-jumping", using: "SportDisciplineTopic", examples: ["/sport/ski-jumping"]
  handle "/sport/snowboarding", using: "SportDisciplineTopic", examples: ["/sport/snowboarding"]
  handle "/sport/speed-skating", using: "SportDisciplineTopic", examples: ["/sport/speed-skating"]
  handle "/sport/squash", using: "SportDisciplineTopic", examples: ["/sport/squash"]
  handle "/sport/synchronised-swimming", using: "SportDisciplineTopic", examples: ["/sport/synchronised-swimming"]
  handle "/sport/table-tennis", using: "SportDisciplineTopic", examples: ["/sport/table-tennis"]
  handle "/sport/taekwondo", using: "SportDisciplineTopic", examples: ["/sport/taekwondo"]
  handle "/sport/triathlon", using: "SportDisciplineTopic", examples: ["/sport/triathlon"]
  handle "/sport/volleyball", using: "SportDisciplineTopic", examples: ["/sport/volleyball"]
  handle "/sport/water-polo", using: "SportDisciplineTopic", examples: ["/sport/water-polo"]
  handle "/sport/weightlifting", using: "SportDisciplineTopic", examples: ["/sport/weightlifting"]
  handle "/sport/wrestling", using: "SportDisciplineTopic", examples: ["/sport/wrestling"]

  handle "/sport/:discipline/teams/:team", using: "SportDisciplineTeamTopic", examples: ["/sport/rugby-league/teams/wigan"]

  handle "/sport/football/champions-league", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/champions-league"]
  handle "/sport/football/dutch-eredivisie", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/dutch-eredivisie"]
  handle "/sport/football/europa-league", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/europa-league"]
  handle "/sport/football/french-ligue-one", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/french-ligue-one"]
  handle "/sport/football/german-bundesliga", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/german-bundesliga"]
  handle "/sport/football/italian-serie-a", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/italian-serie-a"]
  handle "/sport/football/league-cup", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/league-cup"]
  handle "/sport/football/league-one", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/league-one"]
  handle "/sport/football/league-two", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/league-two"]
  handle "/sport/football/national-league", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/national-league"]
  handle "/sport/football/portuguese-primeira-liga", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/portuguese-primeira-liga"]
  handle "/sport/football/scottish-challenge-cup", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/scottish-challenge-cup"]
  handle "/sport/football/scottish-championship", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/scottish-championship"]
  handle "/sport/football/scottish-cup", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/scottish-cup"]
  handle "/sport/football/scottish-league-cup", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/scottish-league-cup"]
  handle "/sport/football/scottish-league-one", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/scottish-league-one"]
  handle "/sport/football/scottish-league-two", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/scottish-league-two"]
  handle "/sport/football/scottish-premiership", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/scottish-premiership"]
  handle "/sport/football/spanish-la-liga", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/spanish-la-liga"]
  handle "/sport/football/us-major-league", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/us-major-league"]
  handle "/sport/football/welsh-premier-league", using: "SportDisciplineCompetitionTopic", examples: ["/sport/football/welsh-premier-league"]

  ## Sport Stories (without discipline) - all use query string params in example URL to use live data in Mozart
  handle "/sport/:id.amp", using: "SportAmp", examples: ["/sport/50562296.amp?morph_env=live&renderer_env=live"] do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end
  handle "/sport/:id.json", using: "SportAmp", examples: ["/sport/50562296.json?morph_env=live&renderer_env=live"] do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end
  handle "/sport/:id.app", using: "SportStoryPage", examples: ["/sport/50562296.app?morph_env=live&renderer_env=live"] do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end
  handle "/sport/:id", using: "SportStoryPage", examples: ["/sport/50562296?morph_env=live&renderer_env=live"] do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end

  ## Sport Stories (with discipline) - all use query string params in example URL to use live data in Mozart
  handle "/sport/:discipline/:id.amp", using: "SportAmp", examples: ["/sport/football/56064289.amp?morph_env=live&renderer_env=live"] do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end
  handle "/sport/:discipline/:id.json", using: "SportAmp", examples: ["/sport/football/56064289.json?morph_env=live&renderer_env=live"] do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end
  handle "/sport/:discipline/:id.app", using: "SportStoryPage", examples: ["/sport/football/56064289.app?morph_env=live&renderer_env=live"] do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end
  handle "/sport/:discipline/:id", using: "SportStoryPage", examples: ["/sport/football/56064289?morph_env=live&renderer_env=live"] do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end

  # Sport catch-all
  handle "/sport/*_any", using: "Sport", examples: []
    
  # Weather

  handle "/weather", using: "WeatherHomePage", examples: ["/weather"]
  handle "/weather/*_any", using: "Weather", examples: ["/weather/2650225"]

  # News Beat

  redirect("/newsbeat/:asset_id", to: "/news/newsbeat-:asset_id", status: 301)
  redirect("/newsbeat/articles/:asset_id", to: "/news/newsbeat-:asset_id", status: 301)
  redirect("/newsbeat/article/:asset_id/:slug", to: "/news/newsbeat-:asset_id", status: 301)
  redirect("/newsbeat", to: "/news/newsbeat", status: 301)

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
  handle "/newsround/*_any", using: "Newsround", examples: []

  handle "/schoolreport/*_any", using: "Schoolreport", examples: [{"/schoolreport", 301}, {"/schoolreport/home", 301}]

  handle "/wide/*_any", using: "Wide", examples: []

  handle "/archivist/*_any", using: "Archivist", examples: []

  # TODO /proms/extra
  handle "/proms/*_any", using: "Proms", examples: []

  handle "/music", using: "Music", examples: []

  handle "/_private/belfrage-cascade-test", using: ["WorldServiceTajik", "WorldServiceKorean", "ProxyPass"], only_on: "test", examples: []
  handle "/_private/lambda-cascade-test", using: ["HomePage", "ProxyPass"], only_on: "test", examples: []
  # handle "/news/business-:id", using: ["NewsStories", "NewsSFV", "MozartNews"], examples: ["/"]
  # handle "/news/business-:id", using: ["NewsBusiness", "MozartNews"], examples: ["/"]

  handle_proxy_pass "/*any", using: "ProxyPass", only_on: "test", examples: ["/foo/bar"]

  no_match()
end
