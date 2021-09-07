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

  redirect("/news/10318089", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302)
  redirect("/news/av/10318089", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302)
  redirect("/news/av/10318089/bbc-news-channel", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302)
  redirect("/news/video_and_audio/headlines/10318089/bbc-news-channel", to: "https://www.bbc.co.uk/tv/bbcnews", status: 302)

  redirect("/news/video_and_audio/international", to: "/news/av/10462520", status: 302)
  redirect("/news/video_and_audio/video", to: "/news/av/10318236", status: 302)
  redirect("/news/video_and_audio/features/:section_and_asset/:asset_id", to: "/news/av/:section_and_asset", status: 302)

  redirect("/cymrufyw/etholiad", to: "/cymrufyw/gwleidyddiaeth", status: 302)
  redirect("/cymrufyw/etholiad/2021", to: "/cymrufyw/gwleidyddiaeth", status: 302)
  redirect("/cymrufyw/etholiad/2021/cymru", to: "/cymrufyw/pynciau/cvd627zw9rjt/etholiad-senedd-cymru-2021", status: 302)
  redirect("/news/election", to: "/news/politics", status: 302)
  redirect("/news/election/2021", to: "/news/politics", status: 302)
  redirect("/news/election/2021/scotland", to: "/news/topics/c37d28xdn99t/scottish-parliament-election-2021", status: 302)
  redirect("/news/election/2021/wales", to: "/news/topics/cqwn14k92zwt/welsh-parliament-election-2021", status: 302)
  redirect("/news/election/2021/england", to: "/news/topics/c481drqqzv7t/england-local-elections-2021", status: 302)
  redirect("/news/election/2021/london", to: "/news/topics/c27kz1m3j9mt/london-elections-2021", status: 302)

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

  redirect "/news/articles", to: "/news", status: 302

  ## News - Mobile Redirect
  redirect "/news/mobile/*any", to: "/news", status: 301

  handle "/news", using: "NewsHomePage", examples: ["/news"]

  handle "/news/election/2021/:polity/:division_name", using: "NewsElection2021", examples: ["/news/election/2021/england/councils", "/news/election/2021/scotland/constituencies", "/news/election/2021/wales/constituencies"] do
    return_404 if: [
      !String.match?(polity, ~r/^(england|scotland|wales)$/),
      !String.match?(division_name, ~r/^(councils|constituencies)$/),
    ]
  end

  handle "/news/election/2021/:polity/:division_name/:division_id", using: "NewsElection2021", examples: ["/news/election/2021/scotland/constituencies/S16000084", "/news/election/2021/scotland/regions/S17000014", "/news/election/2021/wales/constituencies/W09000001", "/news/election/2021/wales/regions/W10000006"] do
    return_404 if: [
      !String.match?(polity, ~r/^(scotland|wales)$/),
      !String.match?(division_name, ~r/^(regions|constituencies)$/),
      !String.match?(division_id, ~r/^[SW][0-9]{8}$/)
    ]
  end

  handle "/news/election", using: "NewsElection", examples: []

  handle "/news/live/:asset_id", using: "NewsLive", examples: ["/news/live/uk-55930940"] do
    return_404 if: !String.match?(asset_id, ~r/^([0-9]{5,9}|[a-z0-9\-_]+-[0-9]{5,9})$/)
  end

  handle "/news/live/:asset_id/page/:page_number", using: "NewsLive", examples: ["/news/live/uk-55930940/page/2"] do
    return_404 if: [
      !String.match?(asset_id, ~r/^([0-9]{5,9}|[a-z0-9\-_]+-[0-9]{5,9})$/),
      !String.match?(page_number, ~r/\A[1-9][0-9]{0,2}\z/)
    ]
  end

  handle "/news/topics/:id/:slug", using: "NewsTopics", examples: [] do
    return_404 if: [
      !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/),
      !String.match?(slug, ~r/^([a-z0-9-]+)$/)
    ]
  end

  handle "/news/topics/:id", using: "NewsTopics", examples: [] do
    return_404 if: !String.match?(id, ~r/^(c[a-zA-Z0-9]{10}t)|([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$/)
  end

  redirect "/news/amp/:id", to: "/news/:id.amp", status: 302
  redirect "/news/amp/:topic/:id", to: "/news/:topic/:id.amp", status: 302

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

  handle "/news/articles/:optimo_id.amp", using: "NewsAmp", examples: []
  handle "/news/articles/:optimo_id.json", using: "NewsAmp", examples: []

  handle "/news/articles/:optimo_id", using: "StorytellingPage", examples: ["/news/articles/c5ll353v7y9o", "/news/articles/c8xxl4l3dzeo"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/news/:id", using: "NewsArticlePage", examples: ["/news/uk-politics-49336144", "/news/world-asia-china-51787936", "/news/technology-51960865", "/news/uk-england-derbyshire-18291916", "/news/entertainment+arts-10636043"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  # TODO issue with routes such as /news/education-46131593 being matched to the /news/:id matcher
  handle "/news/*_any", using: "News", examples: ["/news/election/2019", {"/news/contact-us/editorial", 302}]

  # Cymrufyw

  redirect "/newyddion/*any", to: "/cymrufyw/*any", status: 302
  redirect "/democratiaethfyw", to: "/cymrufyw/gwleidyddiaeth", status: 302
  redirect "/cymrufyw/amp/:id", to: "/cymrufyw/:id.amp", status: 302
  redirect "/cymrufyw/amp/:topic/:id", to: "/cymrufyw/:topic/:id.amp", status: 302

  handle "/cymrufyw/etholiad/2021/cymru/etholaethau", using: "CymrufywEtholiad2021", examples: ["/cymrufyw/etholiad/2021/cymru/etholaethau"]

  handle "/cymrufyw/etholiad/2021/cymru/:division_name/:division_id", using: "CymrufywEtholiad2021", examples: ["/cymrufyw/etholiad/2021/cymru/etholaethau/W09000001", "/cymrufyw/etholiad/2021/cymru/rhanbarthau/W10000006"] do
    return_404 if: [
      !String.match?(division_name, ~r/^(rhanbarthau|etholaethau)$/),
      !String.match?(division_id, ~r/^W[0-9]{8}$/)
    ]
  end

  handle "/cymrufyw/cylchgrawn", using: "Cymrufyw", examples: ["/cymrufyw/cylchgrawn"]
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

  handle "/cymrufyw/*_any", using: "Cymrufyw", examples: ["/cymrufyw"]

  # Naidheachdan

  handle "/naidheachdan", using: "NaidheachdanHomePage", examples: ["/naidheachdan"]
  handle "/naidheachdan/dachaigh", using: "Naidheachdan", examples: [{"/naidheachdan/dachaigh", 301}]
  handle "/naidheachdan/components", using: "Naidheachdan", examples: []
  redirect "/naidheachdan/amp/:id", to: "/naidheachdan/:id.amp", status: 302
  redirect "/naidheachdan/amp/:topic/:id", to: "/naidheachdan/:topic/:id.amp", status: 302
  handle "/naidheachdan/:id", using: "NaidheachdanArticlePage", examples: ["/naidheachdan/52992845", "/naidheachdan/52990788", "/naidheachdan/52991029"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{4,9}$/)
  end

  handle "/naidheachdan/fbh/:id", using: "NaidheachdanVideos", examples: ["/naidheachdan/fbh/53159144"] do
    return_404 if: !String.match?(id, ~r/^([a-zA-Z0-9\+]+-)*[0-9]{8}$/)
  end

  handle "/naidheachdan/*_any", using: "Naidheachdan", examples: []

  handle "/pres-test/personalisation", using: "PresTestPersonalised", only_on: "test", examples: ["/pres-test/personalisation"]
  handle "/pres-test/*any", using: "PresTest", only_on: "test", examples: ["/pres-test/greeting-loader"]

  handle "/devx-test/personalisation", using: "DevXPersonalisation", only_on: "test", examples: ["/devx-test/personalisation"]

  # Container API
  handle "/container/envelope/editorial-text/*any", using: "ContainerEnvelopeEditorialText", examples: ["/container/envelope/editorial-text/heading/Belfrage%20Test/headingLevel/2"]
  handle "/container/envelope/election-banner/*any", using: "ContainerEnvelopeElectionBanner", examples: ["/container/envelope/election-banner/logoOnly/true"]
  handle "/container/envelope/page-link/*any", using: "ContainerEnvelopePageLink", examples: ["/container/envelope/page-link/linkHref/%23belfrage/linkLabel/Belfrage%20Test"]
  handle "/container/envelope/scoreboard/*any", using: "ContainerEnvelopeScoreboard", examples: ["/container/envelope/scoreboard/assetUri/%2Fnews%2Felection%2F2021%2Fscotland%2Fconstituencies%2FS16000084/hasFetcher/true"]
  handle "/container/envelope/test-:name/*any", using: "ContainerEnvelopeTestContainers", only_on: "test", examples: ["/container/envelope/test-message/message/hello"]
  handle "/container/envelope/*any", using: "ContainerEnvelope", examples: ["/container/envelope/global-footer/hasFetcher/true"]

  # World Service

  ## World Service - Podcast Redirects
  redirect "/arabic/media-45669761", to: "/arabic/podcasts/p02pc9qc", status: 301
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
  redirect "/nepali/media-45658289", to: "/nepali/podcasts/p02pc9w3", status: 301
  redirect "/persian/media-45683503", to: "/persian/podcasts/p05gyy09", status: 301
  redirect "/persian/media-45679210", to: "/persian/podcasts/p02pc9mc", status: 301
  redirect "/russian/media-37828473", to: "/russian/podcasts/p05607v8", status: 301
  redirect "/zhongwen/simp/institutional-38228429", to: "/zhongwen/simp/podcasts/p02pc9xp", status: 301
  redirect "/zhongwen/trad/institutional-38228429", to: "/zhongwen/trad/podcasts/p02pc9xp", status: 301

  ## World Service - "Access to News" Redirects
  redirect "/persian/institutional-43952617", to: "/persian/access-to-news", status: 301
  redirect "/persian/institutional/2011/04/000001_bbcpersian_proxy", to: "/persian/access-to-news", status: 301

  ## World Service - Simorgh and ARES
  ##    Kaleidoscope Redirects: /<service>/mobile/image/*any
  ##    Mobile Redirects: /<service>/mobile/*any
  handle "/afaanoromoo.amp", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo.amp"]
  handle "/afaanoromoo.json", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo.json"]
  handle "/afaanoromoo/*_any", using: "WorldServiceAfaanoromoo", examples: ["/afaanoromoo", "/afaanoromoo/example-123", "/afaanoromoo/example-123.amp", "/afaanoromoo/example-123.json"]

  redirect "/afrique/mobile/*any", to: "/afrique", status: 301

  handle "/afrique.amp", using: "WorldServiceAfrique", examples: ["/afrique.amp"]
  handle "/afrique.json", using: "WorldServiceAfrique", examples: ["/afrique.json"]
  handle "/afrique/*_any", using: "WorldServiceAfrique", examples: ["/afrique", "/afrique/example-123", "/afrique/example-123.amp", "/afrique/example-123.json"]
  handle "/amharic.amp", using: "WorldServiceAmharic", examples: ["/amharic.amp"]
  handle "/amharic.json", using: "WorldServiceAmharic", examples: ["/amharic.json"]
  handle "/amharic/*_any", using: "WorldServiceAmharic", examples: ["/amharic", "/amharic/example-123", "/amharic/example-123.amp", "/amharic/example-123.json"]

  redirect "/arabic/mobile/*any", to: "/arabic", status: 301
  redirect "/arabic/institutional/2011/01/000000_tv_schedule", to: "/arabic/tv-and-radio-58432380", status: 301

  handle "/arabic.amp", using: "WorldServiceArabic", examples: ["/arabic.amp"]
  handle "/arabic.json", using: "WorldServiceArabic", examples: ["/arabic.json"]
  handle "/arabic/*_any", using: "WorldServiceArabic", examples: ["/arabic", "/arabic/example-123", "/arabic/example-123.amp", "/arabic/example-123.json"]

  redirect "/azeri/mobile/*any", to: "/azeri", status: 301

  handle "/azeri.amp", using: "WorldServiceAzeri", examples: ["/azeri.amp"]
  handle "/azeri.json", using: "WorldServiceAzeri", examples: ["/azeri.json"]
  handle "/azeri/*_any", using: "WorldServiceAzeri", examples: ["/azeri", "/azeri/example-123", "/azeri/example-123.amp", "/azeri/example-123.json"]

  redirect "/bengali/mobile/image/*any", to: "/bengali/*any", status: 302
  redirect "/bengali/mobile/*any", to: "/bengali", status: 301

  handle "/bengali.amp", using: "WorldServiceBengali", examples: ["/bengali.amp"]
  handle "/bengali.json", using: "WorldServiceBengali", examples: ["/bengali.json"]
  handle "/bengali/*_any", using: "WorldServiceBengali", examples: ["/bengali", "/bengali/example-123", "/bengali/example-123.amp", "/bengali/example-123.json"]

  redirect "/burmese/mobile/image/*any", to: "/burmese/*any", status: 302
  redirect "/burmese/mobile/*any", to: "/burmese", status: 301

  handle "/burmese.amp", using: "WorldServiceBurmese", examples: ["/burmese.amp"]
  handle "/burmese.json", using: "WorldServiceBurmese", examples: ["/burmese.json"]
  handle "/burmese/*_any", using: "WorldServiceBurmese", examples: ["/burmese", "/burmese/example-123", "/burmese/example-123.amp", "/burmese/example-123.json"]

  redirect "/gahuza/mobile/*any", to: "/gahuza", status: 301

  handle "/gahuza.amp", using: "WorldServiceGahuza", examples: ["/gahuza.amp"]
  handle "/gahuza.json", using: "WorldServiceGahuza", examples: ["/gahuza.json"]
  handle "/gahuza/*_any", using: "WorldServiceGahuza", examples: ["/gahuza", "/gahuza/example-123", "/gahuza/example-123.amp", "/gahuza/example-123.json"]
  handle "/gujarati.amp", using: "WorldServiceGujarati", examples: ["/gujarati.amp"]
  handle "/gujarati.json", using: "WorldServiceGujarati", examples: ["/gujarati.json"]
  handle "/gujarati/*_any", using: "WorldServiceGujarati", examples: ["/gujarati", "/gujarati/example-123", "/gujarati/example-123.amp", "/gujarati/example-123.json"]

  redirect "/hausa/mobile/*any", to: "/hausa", status: 301

  handle "/hausa.amp", using: "WorldServiceHausa", examples: ["/hausa.amp"]
  handle "/hausa.json", using: "WorldServiceHausa", examples: ["/hausa.json"]
  handle "/hausa/*_any", using: "WorldServiceHausa", examples: ["/hausa", "/hausa/example-123", "/hausa/example-123.amp", "/hausa/example-123.json"]

  redirect "/hindi/mobile/image/*any", to: "/hindi/*any", status: 302
  redirect "/hindi/mobile/*any", to: "/hindi", status: 301

  handle "/hindi.amp", using: "WorldServiceHindi", examples: ["/hindi.amp"]
  handle "/hindi.json", using: "WorldServiceHindi", examples: ["/hindi.json"]
  handle "/hindi/*_any", using: "WorldServiceHindi", examples: ["/hindi", "/hindi/example-123", "/hindi/example-123.amp", "/hindi/example-123.json"]
  handle "/igbo.amp", using: "WorldServiceIgbo", examples: ["/igbo.amp"]
  handle "/igbo.json", using: "WorldServiceIgbo", examples: ["/igbo.json"]
  handle "/igbo/*_any", using: "WorldServiceIgbo", examples: ["/igbo", "/igbo/example-123", "/igbo/example-123.amp", "/igbo/example-123.json"]

  redirect "/indonesia/mobile/*any", to: "/indonesia", status: 301

  handle "/indonesia.amp", using: "WorldServiceIndonesia", examples: ["/indonesia.amp"]
  handle "/indonesia.json", using: "WorldServiceIndonesia", examples: ["/indonesia.json"]
  handle "/indonesia/*_any", using: "WorldServiceIndonesia", examples: ["/indonesia", "/indonesia/example-123", "/indonesia/example-123.amp", "/indonesia/example-123.json"]
  handle "/japanese.amp", using: "WorldServiceJapanese", examples: ["/japanese.amp"]
  handle "/japanese.json", using: "WorldServiceJapanese", examples: ["/japanese.json"]
  handle "/japanese/*_any", using: "WorldServiceJapanese", examples: ["/japanese", "/japanese/example-123", "/japanese/example-123.amp", "/japanese/example-123.json"]
  handle "/korean.amp", using: "WorldServiceKorean", examples: ["/korean.amp"]
  handle "/korean.json", using: "WorldServiceKorean", examples: ["/korean.json"]
  handle "/korean/*_any", using: "WorldServiceKorean", examples: ["/korean", "/korean/example-123", "/korean/example-123.amp", "/korean/example-123.json"]

  redirect "/kyrgyz/mobile/*any", to: "/kyrgyz", status: 301

  handle "/kyrgyz.amp", using: "WorldServiceKyrgyz", examples: ["/kyrgyz.amp"]
  handle "/kyrgyz.json", using: "WorldServiceKyrgyz", examples: ["/kyrgyz.json"]
  handle "/kyrgyz/*_any", using: "WorldServiceKyrgyz", examples: ["/kyrgyz", "/kyrgyz/example-123", "/kyrgyz/example-123.amp", "/kyrgyz/example-123.json"]
  handle "/marathi.amp", using: "WorldServiceMarathi", examples: ["/marathi.amp"]
  handle "/marathi.json", using: "WorldServiceMarathi", examples: ["/marathi.json"]
  handle "/marathi/*_any", using: "WorldServiceMarathi", examples: ["/marathi", "/marathi/example-123", "/marathi/example-123.amp", "/marathi/example-123.json"]

  ## World Service - Olympic Redirects
  redirect "/mundo/deportes-57748229", to: "/mundo/deportes-57970068", status: 301

  ## World Service - Topcat to CPS Redirects
  redirect "/mundo/noticias/2014/08/140801_israel_palestinos_conflicto_preguntas_basicas_jp", to: "/mundo/noticias-internacional-44125537", status: 301
  redirect "/mundo/noticias/2015/10/151014_israel_palestina_preguntas_basicas_actualizacion_aw", to: "/mundo/noticias-internacional-44125537", status: 301

  redirect "/mundo/mobile/*any", to: "/mundo", status: 301
  redirect "/mundo/movil/*any", to: "/mundo", status: 301

  handle "/mundo.amp", using: "WorldServiceMundo", examples: ["/mundo.amp"]
  handle "/mundo.json", using: "WorldServiceMundo", examples: ["/mundo.json"]
  handle "/mundo/*_any", using: "WorldServiceMundo", examples: ["/mundo", "/mundo/example-123", "/mundo/example-123.amp", "/mundo/example-123.json"]

  redirect "/nepali/mobile/image/*any", to: "/nepali/*any", status: 302
  redirect "/nepali/mobile/*any", to: "/nepali", status: 301

  handle "/nepali.amp", using: "WorldServiceNepali", examples: ["/nepali.amp"]
  handle "/nepali.json", using: "WorldServiceNepali", examples: ["/nepali.json"]
  handle "/nepali/*_any", using: "WorldServiceNepali", examples: ["/nepali", "/nepali/example-123", "/nepali/example-123.amp", "/nepali/example-123.json"]

  redirect "/pashto/mobile/image/*any", to: "/pashto/*any", status: 302
  redirect "/pashto/mobile/*any", to: "/pashto", status: 301

  handle "/pashto.amp", using: "WorldServicePashto", examples: ["/pashto.amp"]
  handle "/pashto.json", using: "WorldServicePashto", examples: ["/pashto.json"]
  handle "/pashto/*_any", using: "WorldServicePashto", examples: ["/pashto", "/pashto/example-123", "/pashto/example-123.amp", "/pashto/example-123.json"]

  redirect "/persian/mobile/image/*any", to: "/persian/*any", status: 302
  redirect "/persian/mobile/*any", to: "/persian", status: 301

  handle "/persian.amp", using: "WorldServicePersian", examples: ["/persian.amp"]
  handle "/persian.json", using: "WorldServicePersian", examples: ["/persian.json"]
  handle "/persian/*_any", using: "WorldServicePersian", examples: ["/persian", "/persian/example-123", "/persian/example-123.amp", "/persian/example-123.json"]
  handle "/pidgin.amp", using: "WorldServicePidgin", examples: ["/pidgin.amp"]
  handle "/pidgin.json", using: "WorldServicePidgin", examples: ["/pidgin.json"]
  handle "/pidgin/*_any", using: "WorldServicePidgin", examples: ["/pidgin", "/pidgin/example-123", "/pidgin/example-123.amp", "/pidgin/example-123.json"]

  redirect "/portuguese/mobile/*any", to: "/portuguese", status: 301
  redirect "/portuguese/celular/*any", to: "/portuguese", status: 301

  handle "/portuguese.amp", using: "WorldServicePortuguese", examples: ["/portuguese.amp"]
  handle "/portuguese.json", using: "WorldServicePortuguese", examples: ["/portuguese.json"]
  handle "/portuguese/*_any", using: "WorldServicePortuguese", examples: ["/portuguese", "/portuguese/example-123", "/portuguese/example-123.amp", "/portuguese/example-123.json"]
  handle "/punjabi.amp", using: "WorldServicePunjabi", examples: ["/punjabi.amp"]
  handle "/punjabi.json", using: "WorldServicePunjabi", examples: ["/punjabi.json"]
  handle "/punjabi/*_any", using: "WorldServicePunjabi", examples: ["/punjabi", "/punjabi/example-123", "/punjabi/example-123.amp", "/punjabi/example-123.json"]

  ## World Service - Russian Partners Redirects
  redirect "/russian/international/2011/02/000000_g_partners", to: "/russian/institutional-43463215", status: 301

  redirect "/russian/mobile/*any", to: "/russian", status: 301

  handle "/russian.amp", using: "WorldServiceRussian", examples: ["/russian.amp"]
  handle "/russian.json", using: "WorldServiceRussian", examples: ["/russian.json"]
  handle "/russian/*_any", using: "WorldServiceRussian", examples: ["/russian", "/russian/example-123", "/russian/example-123.amp", "/russian/example-123.json"]
  handle "/serbian.amp", using: "WorldServiceSerbian", examples: ["/serbian.amp"]
  handle "/serbian.json", using: "WorldServiceSerbian", examples: ["/serbian.json"]
  handle "/serbian/*_any", using: "WorldServiceSerbian", examples: ["/serbian", "/serbian/example-123", "/serbian/example-123.amp", "/serbian/example-123.json"]

  redirect "/sinhala/mobile/image/*any", to: "/sinhala/*any", status: 302
  redirect "/sinhala/mobile/*any", to: "/sinhala", status: 301

  handle "/sinhala.amp", using: "WorldServiceSinhala", examples: ["/sinhala.amp"]
  handle "/sinhala.json", using: "WorldServiceSinhala", examples: ["/sinhala.json"]
  handle "/sinhala/*_any", using: "WorldServiceSinhala", examples: ["/sinhala", "/sinhala/example-123", "/sinhala/example-123.amp", "/sinhala/example-123.json"]

  redirect "/somali/mobile/*any", to: "/somali", status: 301

  handle "/somali.amp", using: "WorldServiceSomali", examples: ["/somali.amp"]
  handle "/somali.json", using: "WorldServiceSomali", examples: ["/somali.json"]
  handle "/somali/*_any", using: "WorldServiceSomali", examples: ["/somali", "/somali/example-123", "/somali/example-123.amp", "/somali/example-123.json"]

  redirect "/swahili/mobile/*any", to: "/swahili", status: 301

  handle "/swahili.amp", using: "WorldServiceSwahili", examples: ["/swahili.amp"]
  handle "/swahili.json", using: "WorldServiceSwahili", examples: ["/swahili.json"]
  handle "/swahili/*_any", using: "WorldServiceSwahili", examples: ["/swahili", "/swahili/example-123", "/swahili/example-123.amp", "/swahili/example-123.json"]
  handle "/tajik.amp", using: "WorldServiceTajik", examples: ["/tajik.amp"]
  handle "/tajik.json", using: "WorldServiceTajik", examples: ["/tajik.json"]
  handle "/tajik/*_any", using: "WorldServiceTajik", examples: ["/tajik", "/tajik/example-123", "/tajik/example-123.amp", "/tajik/example-123.json"]

  redirect "/tamil/mobile/image/*any", to: "/tamil/*any", status: 302
  redirect "/tamil/mobile/*any", to: "/tamil", status: 301

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

  redirect "/turkce/mobile/*any", to: "/turkce", status: 301
  redirect "/turkce/cep/*any", to: "/turkce", status: 301

  handle "/turkce.amp", using: "WorldServiceTurkce", examples: ["/turkce.amp"]
  handle "/turkce.json", using: "WorldServiceTurkce", examples: ["/turkce.json"]
  handle "/turkce/*_any", using: "WorldServiceTurkce", examples: ["/turkce", "/turkce/example-123", "/turkce/example-123.amp", "/turkce/example-123.json"]

  redirect "/ukchina/simp/mobile/*any", to: "/ukchina/simp", status: 301
  redirect "/ukchina/trad/mobile/*any", to: "/ukchina/trad", status: 301

  handle "/ukchina.amp", using: "WorldServiceUkChina", examples: [{"/ukchina.amp", 302}]
  handle "/ukchina/*_any", using: "WorldServiceUkChina", examples: ["/ukchina/simp", "/ukchina/trad", "/ukchina/trad.json", "/ukchina/trad.amp"]

  redirect "/ukrainian/mobile/*any", to: "/ukrainian", status: 301

  handle "/ukrainian.amp", using: "WorldServiceUkrainian", examples: ["/ukrainian.amp"]
  handle "/ukrainian.json", using: "WorldServiceUkrainian", examples: ["/ukrainian.json"]
  handle "/ukrainian/*_any", using: "WorldServiceUkrainian", examples: ["/ukrainian", "/ukrainian/example-123", "/ukrainian/example-123.amp", "/ukrainian/example-123.json"]

  redirect "/urdu/mobile/image/*any", to: "/urdu/*any", status: 302
  redirect "/urdu/mobile/*any", to: "/urdu", status: 301

  handle "/urdu.amp", using: "WorldServiceUrdu", examples: ["/urdu.amp"]
  handle "/urdu.json", using: "WorldServiceUrdu", examples: ["/urdu.json"]
  handle "/urdu/*_any", using: "WorldServiceUrdu", examples: ["/urdu", "/urdu/example-123", "/urdu/example-123.amp", "/urdu/example-123.json"]

  redirect "/uzbek/mobile/*any", to: "/uzbek", status: 301

  handle "/uzbek.amp", using: "WorldServiceUzbek", examples: ["/uzbek.amp"]
  handle "/uzbek.json", using: "WorldServiceUzbek", examples: ["/uzbek.json"]
  handle "/uzbek/*_any", using: "WorldServiceUzbek", examples: ["/uzbek", "/uzbek/example-123", "/uzbek/example-123.amp", "/uzbek/example-123.json"]

  redirect "/vietnamese/mobile/*any", to: "/vietnamese", status: 301

  handle "/vietnamese.amp", using: "WorldServiceVietnamese", examples: ["/vietnamese.amp"]
  handle "/vietnamese.json", using: "WorldServiceVietnamese", examples: ["/vietnamese.json"]
  handle "/vietnamese/*_any", using: "WorldServiceVietnamese", examples: ["/vietnamese", "/vietnamese/example-123", "/vietnamese/example-123.amp", "/vietnamese/example-123.json"]
  handle "/yoruba.amp", using: "WorldServiceYoruba", examples: ["/yoruba.amp"]
  handle "/yoruba.json", using: "WorldServiceYoruba", examples: ["/yoruba.json"]
  handle "/yoruba/*_any", using: "WorldServiceYoruba", examples: ["/yoruba", "/yoruba/example-123", "/yoruba/example-123.amp", "/yoruba/example-123.json"]

  redirect "/zhongwen/simp/mobile/*any", to: "/zhongwen/simp", status: 301
  redirect "/zhongwen/trad/mobile/*any", to: "/zhongwen/trad", status: 301

  handle "/zhongwen.amp", using: "WorldServiceZhongwen", examples: [{"/zhongwen.amp", 302}]
  handle "/zhongwen.json", using: "WorldServiceZhongwen", examples: ["/zhongwen/simp", "/zhongwen/simp.json", "/zhongwen/simp.amp"]
  handle "/zhongwen/*_any", using: "WorldServiceZhongwen", examples: ["/zhongwen", "/zhongwen/example-123", "/zhongwen/example-123.amp", "/zhongwen/example-123.json"]

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

  handle "/programmes/articles/:key/:slug", using: "ProgrammesArticle", examples: ["/programmes/articles/49FbN1s7dwnWXBmHRGK308B/5-unforgettable-moments-from-the-semi-final"] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/articles/:key", using: "ProgrammesArticle", examples: [{"/programmes/articles/yHvY1qp0QstSmj6NKbJlKk", 301}] do
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

  handle "/programmes/profiles/:key/:slug", using: "Programmes", examples: ["/programmes/profiles/4T5qnzlnvHmWQcrl3yZyLwC/tommy-shelby"] do
    return_404 if: !String.match?(key, ~r/^[a-zA-Z0-9-]{1,40}$/)
  end

  handle "/programmes/profiles/:key", using: "Programmes", examples: [{"/programmes/profiles/23ca89bd-f35e-4803-bb86-c300c88afb2f", 301}, {"/programmes/profiles/4T5qnzlnvHmWQcrl3yZyLwC", 301}] do
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

  handle "/programmes/:pid/contact", using: "ProgrammesEntity", examples: ["/programmes/b006m8dq/contact"] do
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

  handle "/programmes/:pid/profiles", using: "ProgrammesEntity", examples: ["/programmes/b045fz8r/profiles"] do
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

  handle "/programmes", using: "Programmes", examples: ["/programmes"]

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

  # topics

  handle "/topics", using: "TopicPage", examples: ["/topics"]

  handle "/topics/:id", using: "TopicPage", examples: ["/topics/c583y7zk042t"] do
    return_404 if: !String.match?(id, ~r/^c[\w]{10}t$/)
  end

  # Sport

  redirect "/sport/0.app", to: "/sport.app", status: 301
  redirect "/sport/0/*any", to: "/sport/*any", status: 301

  # Sport Optimo Articles
  redirect "/sport/articles", to: "/sport", status: 302

  handle "/sport/articles/:optimo_id", using: "StorytellingPage", examples: ["/sport/articles/cx94820kl0mo"] do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  redirect "/sport/amp/:id", to: "/sport/:id.amp", status: 302
  redirect "/sport/amp/:topic/:id", to: "/sport/:topic/:id.amp", status: 302
  redirect "/sport/uk.app", to: "/sport.app", status: 301
  redirect "/sport/uk/*any", to: "/sport/*any", status: 301
  redirect "/sport/world.app", to: "/sport.app", status: 301
  redirect "/sport/world/*any", to: "/sport/*any", status: 301

  redirect "/sport/contact.app", to: "/send/u49719405", status: 301
  redirect "/sport/contact", to: "/send/u49719405", status: 301

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

  ## Sport rss feed redirects
  handle "/sport/rss.xml", using: "SportRss", examples: [{"/sport/rss.xml", 301}]
  handle "/sport/:discipline/rss.xml", using: "SportRss", examples: [{"/sport/football/rss.xml", 301}, {"/sport/england/rss.xml", 301}]
  handle "/sport/:discipline/:tournament/rss.xml", using: "SportRss", examples: [{"/sport/football/champions-league/rss.xml", 301}, {"/sport/cricket/womens/rss.xml", 301}]
  handle "/sport/:discipline/teams/:team/rss.xml", using: "SportRss", examples: [{"/sport/football/teams/liverpool/rss.xml", 301}]

  ## Sport Supermovers redirects
  redirect "/sport/football/supermovers.app", to: "/teach/supermovers", status: 301
  redirect "/sport/football/supermovers", to: "/teach/supermovers", status: 301
  redirect "/sport/supermovers/42612496.app", to: "/teach/supermovers/ks1-collection/zbr4scw", status: 301
  redirect "/sport/supermovers/42612496", to: "/teach/supermovers/ks1-collection/zbr4scw", status: 301
  redirect "/sport/supermovers/42612499.app", to: "/teach/supermovers/ks2-collection/zr4ky9q", status: 301
  redirect "/sport/supermovers/42612499", to: "/teach/supermovers/ks2-collection/zr4ky9q", status: 301
  redirect "/sport/supermovers/42612500.app", to: "/teach/supermovers/cymru/zkdjgwx", status: 301
  redirect "/sport/supermovers/42612500", to: "/teach/supermovers/cymru/zkdjgwx", status: 301
  redirect "/sport/supermovers/42612503.app", to: "/teach/supermovers/just-for-fun-collection/z7tymfr", status: 301
  redirect "/sport/supermovers/42612503", to: "/teach/supermovers/just-for-fun-collection/z7tymfr", status: 301
  redirect "/sport/supermovers/:id.app", to: "/teach/supermovers", status: 301
  redirect "/sport/supermovers/:id", to: "/teach/supermovers", status: 301
  redirect "/sport/av/supermovers/:id.app", to: "/teach/supermovers", status: 301
  redirect "/sport/av/supermovers/:id", to: "/teach/supermovers", status: 301

  ## Sport Stories redirects
  redirect "/sport/34476378", to: "/sport/my-sport", status: 301
  redirect "/sport/34476378.app", to: "/sport/my-sport.app", status: 301
  redirect "/sport/53783520.app", to: "/sport/all-sports.app", status: 301
  redirect "/sport/53783520", to: "/sport/all-sports", status: 301
  redirect "/sport/cricket/53783524.app", to: "/sport/cricket/teams.app", status: 301
  redirect "/sport/cricket/53783524", to: "/sport/cricket/teams", status: 301
  redirect "/sport/darts/19333759.app", to: "/sport/ice-hockey/results.app", status: 301
  redirect "/sport/darts/19333759", to: "/sport/ice-hockey/results", status: 301
  redirect "/sport/football/53783525.app", to: "/sport/football/leagues-cups.app", status: 301
  redirect "/sport/football/53783525", to: "/sport/football/leagues-cups", status: 301
  redirect "/sport/football/53783521.app", to: "/sport/football/teams.app", status: 301
  redirect "/sport/football/53783521", to: "/sport/football/teams", status: 301
  redirect "/sport/rugby-league/53783522.app", to: "/sport/rugby-league/teams.app", status: 301
  redirect "/sport/rugby-league/53783522", to: "/sport/rugby-league/teams", status: 301
  redirect "/sport/rugby-union/53783523.app", to: "/sport/rugby-union/teams.app", status: 301
  redirect "/sport/rugby-union/53783523", to: "/sport/rugby-union/teams", status: 301
  redirect "/sport/tennis/20096126.app", to: "/sport/tennis/live-scores.app", status: 301
  redirect "/sport/tennis/20096126", to: "/sport/tennis/live-scores", status: 301
  redirect "/sport/tennis/20096125.app", to: "/sport/tennis/results.app", status: 301
  redirect "/sport/tennis/20096125", to: "/sport/tennis/results", status: 301
  redirect "/sport/tennis/22713811.app", to: "/sport/tennis/order-of-play.app", status: 301
  redirect "/sport/tennis/22713811", to: "/sport/tennis/order-of-play", status: 301
  redirect "/sport/golf/20096131.app", to: "/sport/golf/leaderboard.app", status: 301
  redirect "/sport/golf/20096131", to: "/sport/golf/leaderboard", status: 301

  ## Sport Index redirects
  redirect "/sport/football/african.app", to: "/sport/africa.app", status: 301
  redirect "/sport/football/african", to: "/sport/africa", status: 301
  redirect "/sport/front-page.app", to: "/sport.app", status: 301
  redirect "/sport/front-page", to: "/sport", status: 301
  redirect "/sport/get-inspired/bodypositive.app", to: "/sport/get-inspired.app", status: 301
  redirect "/sport/get-inspired/bodypositive", to: "/sport/get-inspired", status: 301
  redirect "/sport/get-inspired/fa-peoples-cup.app", to: "/sport/get-inspired.app", status: 301
  redirect "/sport/get-inspired/fa-peoples-cup", to: "/sport/get-inspired", status: 301
  redirect "/sport/get-inspired/unsung-heroes.app", to: "/sport/get-inspired.app", status: 301
  redirect "/sport/get-inspired/unsung-heroes", to: "/sport/get-inspired", status: 301

  ## Sport unsupported data page redirects
  redirect "/sport/disability-sport/paralympics-2012.app", to: "/sport/disability-sport.app", status: 301
  redirect "/sport/disability-sport/paralympics-2012", to: "/sport/disability-sport", status: 301
  redirect "/sport/football/european-championship/euro-2016/video.app", to: "/sport/football/european-championship/video.app", status: 301
  redirect "/sport/football/european-championship/euro-2016/video", to: "/sport/football/european-championship/video", status: 301
  redirect "/sport/football/european-championship/fixtures.app", to: "/sport/football/european-championship/scores-fixtures.app", status: 301
  redirect "/sport/football/european-championship/fixtures", to: "/sport/football/european-championship/scores-fixtures", status: 301
  redirect "/sport/olympics/rio-2016/video.app", to: "/sport/olympics/video.app", status: 301
  redirect "/sport/olympics/rio-2016/video", to: "/sport/olympics/video", status: 301

  ## Sport unsupported data page redirects handled by Mozart
  handle "/sport/commonwealth-games/home-nations/*_any", using: "SportRedirects", examples: [{"/sport/commonwealth-games/home-nations", 302}, {"/sport/commonwealth-games/home-nations.app", 302}]
  handle "/sport/commonwealth-games/medals/*_any", using: "SportRedirects", examples: [{"/sport/commonwealth-games/medals/countries/canada", 302}, {"/sport/commonwealth-games/medals/countries/british-virgin-islands.app", 302}]
  handle "/sport/commonwealth-games/results/*_any", using: "SportRedirects", examples: [{"/sport/commonwealth-games/results/sports/hockey/hockey-women", 302}, {"/sport/commonwealth-games/results.app", 302}]
  handle "/sport/commonwealth-games/schedule/*_any", using: "SportRedirects", examples: [{"/sport/commonwealth-games/schedule/sports/gymnastics", 302}, {"/sport/commonwealth-games/schedule/sports/volleyball.app", 302}]
  handle "/sport/commonwealth-games/sports/*_any", using: "SportRedirects", examples: [{"/sport/commonwealth-games/sports", 302}, {"/sport/commonwealth-games/sports.app", 302}]
  handle "/sport/football/european-championship/2012/*_any", using: "SportRedirects", examples: [{"/sport/football/european-championship/2012", 301}, {"/sport/football/european-championship/2012.app", 301}]
  handle "/sport/football/european-championship/2016/*_any", using: "SportRedirects", examples: [{"/sport/football/european-championship/2016", 301}, {"/sport/football/european-championship/2016.app", 301}]
  handle "/sport/football/european-championship/euro-2016/*_any", using: "SportRedirects", examples: [{"/sport/football/european-championship/euro-2016", 301}, {"/sport/football/european-championship/euro-2016.app", 301}]
  handle "/sport/football/european-championship/schedule/*_any", using: "SportRedirects", examples: [{"/sport/football/european-championship/schedule/knockout-stage", 302}, {"/sport/football/european-championship/schedule.app", 302}]
  handle "/sport/football/world-cup/schedule/*_any", using: "SportRedirects", examples: [{"/sport/football/world-cup/schedule/group-stage", 302}, {"/sport/football/world-cup/schedule.app", 302}]
  handle "/sport/olympics/2012/*_any", using: "SportRedirects", examples: [{"/sport/olympics/2012", 301}, {"/sport/olympics/2012/medals.app", 301}]
  handle "/sport/olympics/2016/*_any", using: "SportRedirects", examples: [{"/sport/olympics/2016", 301}, {"/sport/olympics/2016/schedule.app", 301}]
  handle "/sport/olympics/rio-2016/*_any", using: "SportRedirects", examples: [{"/sport/olympics/rio-2016", 301}, {"/sport/olympics/rio-2016.app", 301}]
  handle "/sport/paralympics/rio-2016/medals/*_any", using: "SportRedirects", examples: [{"/sport/paralympics/rio-2016/medals", 301}, {"/sport/paralympics/rio-2016/medals.app", 301}]
  handle "/sport/paralympics/rio-2016/schedule/*_any", using: "SportRedirects", examples: [{"/sport/paralympics/rio-2016/schedule", 301}, {"/sport/paralympics/rio-2016/schedule.app", 301}]
  handle "/sport/winter-olympics/home-nations/*_any", using: "SportRedirects", examples: [{"/sport/winter-olympics/home-nations", 302}, {"/sport/winter-olympics/home-nations.app", 302}]
  handle "/sport/winter-olympics/medals/*_any", using: "SportRedirects", examples: [{"/sport/winter-olympics/medals/countries/new-zealand", 302}, {"/sport/winter-olympics/medals/countries/great-britain.app", 302}]
  handle "/sport/winter-olympics/results/*_any", using: "SportRedirects", examples: [{"/sport/winter-olympics/results/sports/ski-jumping/ski-jumping-mens-team", 302}, {"/sport/winter-olympics/results/sports/curling/curling-mixed-doubles.app", 302}]
  handle "/sport/winter-olympics/schedule/*_any", using: "SportRedirects", examples: [{"/sport/winter-olympics/schedule/sports/figure-skating", 302}, {"/sport/winter-olympics/schedule/sports/snowboarding.app", 302}]
  handle "/sport/winter-olympics/sports/*_any", using: "SportRedirects", examples: [{"/sport/winter-olympics/sports", 302}, {"/sport/winter-olympics/sports.app", 302}]

  ## Sport Visual Journalism
  handle "/sport/extra/*_any", using: "Sport", examples: ["/sport/extra/c1nx5lutpg/The-real-Lewis-Hamilton-story"]

  ## Sport SFV - use query string params in example URLs to use live data via Mozart where required
  handle "/sport/av/:id.app", using: "SportMediaAssetPage", examples: ["/sport/av/51107180.app?morph_env=live&renderer_env=live"]
  handle "/sport/av/:id", using: "SportVideos", examples: ["/sport/av/51107180"] do
    return_404 if: !String.match?(id, ~r/^[0-9]{4,9}$/)
  end

  handle "/sport/av/:discipline/:id.app", using: "SportMediaAssetPage", examples: ["/sport/av/football/55975423.app?morph_env=live&renderer_env=live"]

  ## Sport SFV - validate Section(Discipline) and ID
  handle "/sport/av/:discipline/:id", using: "SportVideos", examples: ["/sport/av/football/55975423", "/sport/av/formula1/55303534", "/sport/av/rugby-league/56462310"] do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportVideos.sports_disciplines_routes, discipline),
      !String.match?(id, ~r/^[0-9]{4,9}$/)
    ]
  end

  handle "/sport/videos/:id", using: "SportVideos", examples: [{"/sport/videos/49104905", 301}] do
    return_404 if: String.length(id) != 8
  end

  ## Sport Internal Tools - use query string params in example URLs to use live data via Mozart where required
  handle "/sport/internal/football-team-selector/:slug", using: "Sport", examples: ["/sport/internal/football-team-selector/england-xi?morph_env=live&renderer_env=live"]
  handle "/sport/internal/player-rater/:event_id", using: "Sport", examples: ["/sport/internal/player-rater/EFBO2128305?morph_env=live&renderer_env=live"]
  handle "/sport/internal/ranked-list/:slug", using: "Sport", examples: ["/sport/internal/ranked-list/lions-2021-XV?morph_env=live&renderer_env=live"]

  ## Sport Top 4
  handle "/sport/alpha/top-4.app", using: "Sport", examples: ["/sport/alpha/top-4.app"]
  handle "/sport/alpha/top-4", using: "Sport", examples: ["/sport/alpha/top-4"]
  handle "/sport/top-4.app", using: "Sport", examples: ["/sport/top-4.app"]
  handle "/sport/top-4", using: "Sport", examples: ["/sport/top-4"]

  ## Sport Misc
  handle "/sport/sitemap.xml", using: "Sport", examples: ["/sport/sitemap.xml"]
  handle "/sport/alpha/*_any", using: "SportAlpha", examples: ["/sport/alpha/basketball/scores-fixtures"]

  ## Sport BBC Live - use query string params in example URLs to use live data via Mozart where required
  handle "/sport/live/football/*_any", using: "SportFootballLivePage", examples: ["/sport/live/football/52581366.app?morph_env=live&renderer_env=live", "/sport/live/football/52581366?morph_env=live&renderer_env=live", "/sport/live/football/52581366/page/2?morph_env=live&renderer_env=live"]

  handle "/sport/live/*_any", using: "SportLivePage", examples: ["/sport/live/rugby-union/56269849.app?morph_env=live&renderer_env=live", "/sport/live/rugby-union/56269849?morph_env=live&renderer_env=live", "/sport/live/rugby-union/56269849/page/2?morph_env=live&renderer_env=live"]

  handle "/sport/live-guide.app", using: "SportLiveGuide", examples: ["/sport/live-guide.app"]
  handle "/sport/live-guide", using: "SportLiveGuide", examples: ["/sport/live-guide"]
  handle "/sport/live-guide/*_any", using: "SportLiveGuide", examples: ["/sport/live-guide/football.app", "/sport/live-guide/football"]

  ## Sport Video Collections
  handle "/sport/:discipline/video.app", using: "SportMediaAssetPage", examples: ["/sport/cricket/video.app"]
  handle "/sport/:discipline/video", using: "SportMediaAssetPage", examples: ["/sport/cricket/video"]
  handle "/sport/:discipline/:tournament/video.app", using: "SportMediaAssetPage", examples: ["/sport/football/fa-cup/video.app"]
  handle "/sport/:discipline/:tournament/video", using: "SportMediaAssetPage", examples: ["/sport/football/fa-cup/video"]

  ## Sport Vanity Urls
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
  handle "/sport.app", using: "SportMajorIndexPage", examples: ["/sport.app"]
  handle "/sport", using: "SportMajorIndexPage", examples: ["/sport"]
  handle "/sport/africa.app", using: "SportIndexPage", examples: ["/sport/africa.app"]
  handle "/sport/africa", using: "SportIndexPage", examples: ["/sport/africa"]
  handle "/sport/american-football.app", using: "SportIndexPage", examples: ["/sport/american-football.app"]
  handle "/sport/american-football", using: "SportIndexPage", examples: ["/sport/american-football"]
  handle "/sport/athletics.app", using: "SportMajorIndexPage", examples: ["/sport/athletics.app"]
  handle "/sport/athletics", using: "SportMajorIndexPage", examples: ["/sport/athletics"]
  handle "/sport/basketball.app", using: "SportIndexPage", examples: ["/sport/basketball.app"]
  handle "/sport/basketball", using: "SportIndexPage", examples: ["/sport/basketball"]
  handle "/sport/boxing.app", using: "SportIndexPage", examples: ["/sport/boxing.app"]
  handle "/sport/boxing", using: "SportIndexPage", examples: ["/sport/boxing"]
  handle "/sport/commonwealth-games.app", using: "SportIndexPage", examples: ["/sport/commonwealth-games.app"]
  handle "/sport/commonwealth-games", using: "SportIndexPage", examples: ["/sport/commonwealth-games"]
  handle "/sport/cricket.app", using: "SportCricketIndexPage", examples: ["/sport/cricket.app"]
  handle "/sport/cricket", using: "SportCricketIndexPage", examples: ["/sport/cricket"]
  handle "/sport/cricket/counties.app", using: "SportCricketIndexPage", examples: ["/sport/cricket/counties.app"]
  handle "/sport/cricket/counties", using: "SportCricketIndexPage", examples: ["/sport/cricket/counties"]
  handle "/sport/cricket/womens.app", using: "SportCricketIndexPage", examples: ["/sport/cricket/womens.app"]
  handle "/sport/cricket/womens", using: "SportCricketIndexPage", examples: ["/sport/cricket/womens"]
  handle "/sport/cycling.app", using: "SportMajorIndexPage", examples: ["/sport/cycling.app"]
  handle "/sport/cycling", using: "SportMajorIndexPage", examples: ["/sport/cycling"]
  handle "/sport/disability-sport.app", using: "SportIndexPage", examples: ["/sport/disability-sport.app"]
  handle "/sport/disability-sport", using: "SportIndexPage", examples: ["/sport/disability-sport"]
  handle "/sport/england.app", using: "SportHomeNationIndexPage", examples: ["/sport/england.app"]
  handle "/sport/england", using: "SportHomeNationIndexPage", examples: ["/sport/england"]
  handle "/sport/football.app", using: "SportFootballIndexPage", examples: ["/sport/football.app"]
  handle "/sport/football", using: "SportFootballIndexPage", examples: ["/sport/football"]
  handle "/sport/football/championship.app", using: "SportFootballIndexPage", examples: ["/sport/football/championship.app"]
  handle "/sport/football/championship", using: "SportFootballIndexPage", examples: ["/sport/football/championship"]
  handle "/sport/football/european-championship.app", using: "SportFootballIndexPage", examples: ["/sport/football/european-championship.app"]
  handle "/sport/football/european-championship", using: "SportFootballIndexPage", examples: ["/sport/football/european-championship"]
  handle "/sport/football/european.app", using: "SportFootballIndexPage", examples: ["/sport/football/european.app"]
  handle "/sport/football/european", using: "SportFootballIndexPage", examples: ["/sport/football/european"]
  handle "/sport/football/fa-cup.app", using: "SportFootballIndexPage", examples: ["/sport/football/fa-cup.app"]
  handle "/sport/football/fa-cup", using: "SportFootballIndexPage", examples: ["/sport/football/fa-cup"]
  handle "/sport/football/irish.app", using: "SportFootballIndexPage", examples: ["/sport/football/irish.app"]
  handle "/sport/football/irish", using: "SportFootballIndexPage", examples: ["/sport/football/irish"]
  handle "/sport/football/premier-league.app", using: "SportFootballIndexPage", examples: ["/sport/football/premier-league.app"]
  handle "/sport/football/premier-league", using: "SportFootballIndexPage", examples: ["/sport/football/premier-league"]
  handle "/sport/football/scottish.app", using: "SportFootballIndexPage", examples: ["/sport/football/scottish.app"]
  handle "/sport/football/scottish", using: "SportFootballIndexPage", examples: ["/sport/football/scottish"]
  handle "/sport/football/welsh.app", using: "SportFootballIndexPage", examples: ["/sport/football/welsh.app"]
  handle "/sport/football/welsh", using: "SportFootballIndexPage", examples: ["/sport/football/welsh"]
  handle "/sport/football/womens.app", using: "SportFootballIndexPage", examples: ["/sport/football/womens.app"]
  handle "/sport/football/womens", using: "SportFootballIndexPage", examples: ["/sport/football/womens"]
  handle "/sport/football/world-cup.app", using: "SportFootballIndexPage", examples: ["/sport/football/world-cup.app"]
  handle "/sport/football/world-cup", using: "SportFootballIndexPage", examples: ["/sport/football/world-cup"]
  handle "/sport/formula1.app", using: "SportMajorIndexPage", examples: ["/sport/formula1.app"]
  handle "/sport/formula1", using: "SportMajorIndexPage", examples: ["/sport/formula1"]
  handle "/sport/get-inspired.app", using: "SportIndexPage", examples: ["/sport/get-inspired.app"]
  handle "/sport/get-inspired", using: "SportIndexPage", examples: ["/sport/get-inspired"]
  handle "/sport/get-inspired/activity-guides.app", using: "SportIndexPage", examples: ["/sport/get-inspired/activity-guides.app"]
  handle "/sport/get-inspired/activity-guides", using: "SportIndexPage", examples: ["/sport/get-inspired/activity-guides"]
  handle "/sport/golf.app", using: "SportMajorIndexPage", examples: ["/sport/golf.app"]
  handle "/sport/golf", using: "SportMajorIndexPage", examples: ["/sport/golf"]
  handle "/sport/horse-racing.app", using: "SportIndexPage", examples: ["/sport/horse-racing.app"]
  handle "/sport/horse-racing", using: "SportIndexPage", examples: ["/sport/horse-racing"]
  handle "/sport/mixed-martial-arts.app", using: "SportIndexPage", examples: ["/sport/mixed-martial-arts.app"]
  handle "/sport/mixed-martial-arts", using: "SportIndexPage", examples: ["/sport/mixed-martial-arts"]
  handle "/sport/motorsport.app", using: "SportIndexPage", examples: ["/sport/motorsport.app"]
  handle "/sport/motorsport", using: "SportIndexPage", examples: ["/sport/motorsport"]
  handle "/sport/netball.app", using: "SportIndexPage", examples: ["/sport/netball.app"]
  handle "/sport/netball", using: "SportIndexPage", examples: ["/sport/netball"]
  handle "/sport/northern-ireland.app", using: "SportHomeNationIndexPage", examples: ["/sport/northern-ireland.app"]
  handle "/sport/northern-ireland", using: "SportHomeNationIndexPage", examples: ["/sport/northern-ireland"]
  handle "/sport/northern-ireland/gaelic-games.app", using: "SportHomeNationIndexPage", examples: ["/sport/northern-ireland/gaelic-games.app"]
  handle "/sport/northern-ireland/gaelic-games", using: "SportHomeNationIndexPage", examples: ["/sport/northern-ireland/gaelic-games"]
  handle "/sport/northern-ireland/motorbikes.app", using: "SportHomeNationIndexPage", examples: ["/sport/northern-ireland/motorbikes.app"]
  handle "/sport/northern-ireland/motorbikes", using: "SportHomeNationIndexPage", examples: ["/sport/northern-ireland/motorbikes"]
  handle "/sport/olympics.app", using: "SportIndexPage", examples: ["/sport/olympics.app"]
  handle "/sport/olympics", using: "SportIndexPage", examples: ["/sport/olympics"]
  handle "/sport/rugby-league.app", using: "SportRugbyIndexPage", examples: ["/sport/rugby-league.app"]
  handle "/sport/rugby-league", using: "SportRugbyIndexPage", examples: ["/sport/rugby-league"]
  handle "/sport/rugby-union.app", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union.app"]
  handle "/sport/rugby-union", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union"]
  handle "/sport/rugby-union/english.app", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union/english.app"]
  handle "/sport/rugby-union/english", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union/english"]
  handle "/sport/rugby-union/irish.app", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union/irish.app"]
  handle "/sport/rugby-union/irish", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union/irish"]
  handle "/sport/rugby-union/scottish.app", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union/scottish.app"]
  handle "/sport/rugby-union/scottish", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union/scottish"]
  handle "/sport/rugby-union/welsh.app", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union/welsh.app"]
  handle "/sport/rugby-union/welsh", using: "SportRugbyIndexPage", examples: ["/sport/rugby-union/welsh"]
  handle "/sport/scotland.app", using: "SportHomeNationIndexPage", examples: ["/sport/scotland.app"]
  handle "/sport/scotland", using: "SportHomeNationIndexPage", examples: ["/sport/scotland"]
  handle "/sport/snooker.app", using: "SportIndexPage", examples: ["/sport/snooker.app"]
  handle "/sport/snooker", using: "SportIndexPage", examples: ["/sport/snooker"]
  handle "/sport/sports-personality.app", using: "SportIndexPage", examples: ["/sport/sports-personality.app"]
  handle "/sport/sports-personality", using: "SportIndexPage", examples: ["/sport/sports-personality"]
  handle "/sport/swimming.app", using: "SportIndexPage", examples: ["/sport/swimming.app"]
  handle "/sport/swimming", using: "SportIndexPage", examples: ["/sport/swimming"]
  handle "/sport/tennis.app", using: "SportMajorIndexPage", examples: ["/sport/tennis.app"]
  handle "/sport/tennis", using: "SportMajorIndexPage", examples: ["/sport/tennis"]
  handle "/sport/wales.app", using: "SportHomeNationIndexPage", examples: ["/sport/wales.app"]
  handle "/sport/wales", using: "SportHomeNationIndexPage", examples: ["/sport/wales"]
  handle "/sport/winter-olympics.app", using: "SportIndexPage", examples: ["/sport/winter-olympics.app"]
  handle "/sport/winter-olympics", using: "SportIndexPage", examples: ["/sport/winter-olympics"]
  handle "/sport/winter-sports.app", using: "SportIndexPage", examples: ["/sport/winter-sports.app"]
  handle "/sport/winter-sports", using: "SportIndexPage", examples: ["/sport/winter-sports"]

  ## Sport Calendars
  handle "/sport/formula1/calendar.app", using: "SportFormula1DataPage", examples: ["/sport/formula1/calendar.app"]
  handle "/sport/formula1/calendar/*_any", using: "SportFormula1DataPage", examples: ["/sport/formula1/calendar", "/sport/formula1/calendar/2022-04", "/sport/formula1/calendar/2022-04.app"]
  handle "/sport/horse-racing/calendar.app", using: "SportHorseRacingDataPage", examples: ["/sport/horse-racing/calendar.app"]
  handle "/sport/horse-racing/calendar/*_any", using: "SportHorseRacingDataPage", examples: ["/sport/horse-racing/calendar", "/sport/horse-racing/calendar/2021-05", "/sport/horse-racing/calendar/2021-05.app"]
  handle "/sport/:discipline/calendar.app", using: "SportDataPage", examples: ["/sport/winter-sports/calendar.app"]
  handle "/sport/:discipline/calendar/*_any", using: "SportDataPage", examples: ["/sport/winter-sports/calendar", "/sport/winter-sports/calendar/2022-04", "/sport/winter-sports/calendar/2022-04.app"]

  ## Sport Fixtures pages
  redirect "/sport/basketball/:tournament/fixtures.app", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/:tournament/fixtures", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/fixtures.app", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/fixtures", to: "/sport/basketball/scores-fixtures", status: 301

  handle "/sport/:discipline/:tournament/fixtures.app", using: "SportDataPage", examples: ["/sport/ice-hockey/nba/fixtures.app"]
  handle "/sport/:discipline/:tournament/fixtures", using: "SportDataPage", examples: ["/sport/ice-hockey/nba/fixtures"]
  handle "/sport/:discipline/fixtures.app", using: "SportDataPage", examples: ["/sport/ice-hockey/fixtures.app"]
  handle "/sport/:discipline/fixtures", using: "SportDataPage", examples: ["/sport/ice-hockey/fixtures"]

  ## Sport Horse Racing Results
  handle "/sport/horse-racing/:tournament/results.app", using: "SportHorseRacingDataPage", examples: ["/sport/horse-racing/uk-ireland/results.app"]
  handle "/sport/horse-racing/:tournament/results/*_any", using: "SportHorseRacingDataPage", examples: ["/sport/horse-racing/uk-ireland/results", "/sport/horse-racing/uk-ireland/results/2021-02-26", "/sport/horse-racing/uk-ireland/results/2021-02-26.app"]

  ## Sport Formula 1 Pages
  redirect "/sport/formula1/standings.app", to: "/sport/formula1/drivers-world-championship/standings.app", status: 302
  redirect "/sport/formula1/standings", to: "/sport/formula1/drivers-world-championship/standings", status: 302
  handle "/sport/formula1/latest.app", using: "SportFormula1DataPage", examples: ["/sport/formula1/latest.app"]
  handle "/sport/formula1/latest", using: "SportFormula1DataPage", examples: ["/sport/formula1/latest"]
  handle "/sport/formula1/results.app", using: "SportFormula1DataPage", examples: ["/sport/formula1/results.app"]
  handle "/sport/formula1/results", using: "SportFormula1DataPage", examples: ["/sport/formula1/results"]
  handle "/sport/formula1/:season/results.app", using: "SportFormula1DataPage", examples: ["/sport/formula1/2020/results.app"]
  handle "/sport/formula1/:season/results", using: "SportFormula1DataPage", examples: ["/sport/formula1/2020/results"]
  handle "/sport/formula1/:season/:tournament/results.app", using: "SportFormula1DataPage", examples: ["/sport/formula1/2019/monaco-grand-prix/results.app"]
  handle "/sport/formula1/:season/:tournament/results", using: "SportFormula1DataPage", examples: ["/sport/formula1/2019/monaco-grand-prix/results"]
  handle "/sport/formula1/:season/:tournament/results/*_any", using: "SportFormula1DataPage", examples: ["/sport/formula1/2020/70th-anniversary-grand-prix/results/qualifying.app", "/sport/formula1/2020/70th-anniversary-grand-prix/results/race"]
  handle "/sport/formula1/constructors-world-championship/standings.app", using: "SportFormula1DataPage", examples: ["/sport/formula1/constructors-world-championship/standings.app"]
  handle "/sport/formula1/constructors-world-championship/standings", using: "SportFormula1DataPage", examples: ["/sport/formula1/constructors-world-championship/standings"]
  handle "/sport/formula1/drivers-world-championship/standings.app", using: "SportFormula1DataPage", examples: ["/sport/formula1/drivers-world-championship/standings.app"]
  handle "/sport/formula1/drivers-world-championship/standings", using: "SportFormula1DataPage", examples: ["/sport/formula1/drivers-world-championship/standings"]

  ## Sport Results pages
  redirect "/sport/basketball/:tournament/results.app", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/:tournament/results", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/results.app", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/results", to: "/sport/basketball/scores-fixtures", status: 301

  handle "/sport/:discipline/:tournament/results.app", using: "SportDataPage", examples: ["/sport/athletics/british-championship/results.app"]
  handle "/sport/:discipline/:tournament/results", using: "SportDataPage", examples: ["/sport/athletics/british-championship/results"]
  handle "/sport/:discipline/results.app", using: "SportDataPage", examples: ["/sport/snooker/results.app"]
  handle "/sport/:discipline/results", using: "SportDataPage", examples: ["/sport/snooker/results"]

  ## Sport Football Scores-Fixtures pages
  handle "/sport/football/scores-fixtures.app", using: "SportFootballMainScoresFixturesDataPage", examples: ["/sport/football/scores-fixtures.app"]
  handle "/sport/football/scores-fixtures/*_any", using: "SportFootballMainScoresFixturesDataPage", examples: ["/sport/football/scores-fixtures", "/sport/football/scores-fixtures/2021-04-26", "/sport/football/scores-fixtures/2021-04-26.app"]
  handle "/sport/football/:tournament/scores-fixtures.app", using: "SportFootballScoresFixturesDataPage", examples: ["/sport/football/champions-league/scores-fixtures.app"]
  handle "/sport/football/:tournament/scores-fixtures/*_any", using: "SportFootballScoresFixturesDataPage", examples: ["/sport/football/champions-league/scores-fixtures", "/sport/football/champions-league/scores-fixtures/2022-04", "/sport/football/champions-league/scores-fixtures/2022-04.app"]
  handle "/sport/football/teams/:team/scores-fixtures.app", using: "SportFootballScoresFixturesDataPage", examples: ["/sport/football/teams/hull-city/scores-fixtures.app"]
  handle "/sport/football/teams/:team/scores-fixtures/*_any", using: "SportFootballScoresFixturesDataPage", examples: ["/sport/football/teams/hull-city/scores-fixtures", "/sport/football/teams/hull-city/scores-fixtures/2022-04", "/sport/football/teams/hull-city/scores-fixtures/2022-04.app"]

  ## Sport Basketball Scores-Fixtures pages
  handle "/sport/basketball/scores-fixtures", using: "SportDataWebcore", examples: ["/sport/basketball/scores-fixtures"]
  handle "/sport/basketball/scores-fixtures/:date", using: "SportDataWebcore", examples: ["/sport/basketball/scores-fixtures/2021-04-26"] do
    return_404 if: !String.match?(date, ~r/^202[0-9]-[01][0-9]-[0123][0-9]$/)
  end
  handle "/sport/basketball/:tournament/scores-fixtures", using: "SportDataWebcore", examples: ["/sport/basketball/nba/scores-fixtures"]
  handle "/sport/basketball/:tournament/scores-fixtures/:date", using: "SportDataWebcore", examples: ["/sport/basketball/nba/scores-fixtures/2021-04-26"] do
    return_404 if: !String.match?(date, ~r/^202[0-9]-[01][0-9]-[0123][0-9]$/)
  end

  ## Sport Scores-Fixtures pages
  handle "/sport/:discipline/scores-fixtures.app", using: "SportDataPage", examples: ["/sport/rugby-league/scores-fixtures.app"]
  handle "/sport/:discipline/scores-fixtures/*_any", using: "SportDataPage", examples: ["/sport/rugby-league/scores-fixtures", "/sport/rugby-league/scores-fixtures/2021-04-26", "/sport/rugby-league/scores-fixtures/2021-04-26.app"]
  handle "/sport/:discipline/:tournament/scores-fixtures.app", using: "SportDataPage", examples: ["/sport/rugby-league/super-league/scores-fixtures.app"]
  handle "/sport/:discipline/:tournament/scores-fixtures/*_any", using: "SportDataPage", examples: ["/sport/rugby-league/super-league/scores-fixtures", "/sport/rugby-league/super-league/scores-fixtures/2022-04", "/sport/rugby-league/super-league/scores-fixtures/2022-04.app"]
  handle "/sport/:discipline/teams/:team/scores-fixtures.app", using: "SportDataPage", examples: ["/sport/rugby-league/teams/st-helens/scores-fixtures.app"]
  handle "/sport/:discipline/teams/:team/scores-fixtures/*_any", using: "SportDataPage", examples: ["/sport/rugby-league/teams/st-helens/scores-fixtures", "/sport/rugby-league/teams/st-helens/scores-fixtures/2022-04", "/sport/rugby-league/teams/st-helens/scores-fixtures/2022-04.app"]

  ## Sport Football Table pages
  handle "/sport/football/tables.app", using: "SportFootballDataPage", examples: ["/sport/football/tables.app"]
  handle "/sport/football/tables", using: "SportFootballDataPage", examples: ["/sport/football/tables"]
  handle "/sport/football/:tournament/table.app", using: "SportFootballDataPage", examples: ["/sport/football/championship/table.app"]
  handle "/sport/football/:tournament/table", using: "SportFootballDataPage", examples: ["/sport/football/championship/table"]
  handle "/sport/football/teams/:team/table.app", using: "SportFootballDataPage", examples: ["/sport/football/teams/arsenal/table.app"]
  handle "/sport/football/teams/:team/table", using: "SportFootballDataPage", examples: ["/sport/football/teams/arsenal/table"]

  ## Sport Table pages
  handle "/sport/:discipline/tables.app", using: "SportDataPage", examples: ["/sport/rugby-league/tables.app"]
  handle "/sport/:discipline/tables", using: "SportDataPage", examples: ["/sport/rugby-league/tables"]
  handle "/sport/:discipline/:tournament/table.app", using: "SportDataPage", examples: ["/sport/rugby-league/super-league/table.app"]
  handle "/sport/:discipline/:tournament/table", using: "SportDataPage", examples: ["/sport/rugby-league/super-league/table"]
  handle "/sport/:discipline/teams/:team/table.app", using: "SportDataPage", examples: ["/sport/rugby-league/teams/st-helens/table.app"]
  handle "/sport/:discipline/teams/:team/table", using: "SportDataPage", examples: ["/sport/rugby-league/teams/st-helens/table"]

  ## Sport Cricket Averages
  handle "/sport/cricket/averages.app", using: "SportDataPage", examples: ["/sport/cricket/averages.app"]
  handle "/sport/cricket/averages", using: "SportDataPage", examples: ["/sport/cricket/averages"]
  handle "/sport/cricket/:tournament/averages.app", using: "SportDataPage", examples: ["/sport/cricket/indian-premier-league/averages.app"]
  handle "/sport/cricket/:tournament/averages", using: "SportDataPage", examples: ["/sport/cricket/indian-premier-league/averages"]
  handle "/sport/cricket/teams/:team/averages.app", using: "SportDataPage", examples: [{"/sport/cricket/teams/lancashire/averages.app", 302}]
  handle "/sport/cricket/teams/:team/averages", using: "SportDataPage", examples: [{"/sport/cricket/teams/lancashire/averages", 302}]

  ## Sport Football Top-Scorers
  handle "/sport/football/:tournament/top-scorers.app", using: "SportFootballDataPage", examples: ["/sport/football/european-championship/top-scorers.app"]
  handle "/sport/football/:tournament/top-scorers", using: "SportFootballDataPage", examples: ["/sport/football/european-championship/top-scorers"]
  handle "/sport/football/:tournament/top-scorers/assists.app", using: "SportFootballDataPage", examples: ["/sport/football/european-championship/top-scorers/assists.app"]
  handle "/sport/football/:tournament/top-scorers/assists", using: "SportFootballDataPage", examples: ["/sport/football/european-championship/top-scorers/assists"]
  handle "/sport/football/teams/:team/top-scorers.app", using: "SportFootballDataPage", examples: ["/sport/football/teams/everton/top-scorers.app"]
  handle "/sport/football/teams/:team/top-scorers", using: "SportFootballDataPage", examples: ["/sport/football/teams/everton/top-scorers"]
  handle "/sport/football/teams/:team/top-scorers/assists.app", using: "SportFootballDataPage", examples: ["/sport/football/teams/everton/top-scorers/assists.app"]
  handle "/sport/football/teams/:team/top-scorers/assists", using: "SportFootballDataPage", examples: ["/sport/football/teams/everton/top-scorers/assists"]

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
  handle "/sport/horse-racing/race/:id.app", using: "SportHorseRacingDataPage", examples: ["/sport/horse-racing/race/EHRP771835.app"]
  handle "/sport/horse-racing/race/:id", using: "SportHorseRacingDataPage", examples: ["/sport/horse-racing/race/EHRP771835"]
  handle "/sport/rugby-league/match/:id.app", using: "SportDataPage", examples: ["/sport/rugby-league/match/EVP3489302.app"]
  handle "/sport/rugby-league/match/:id", using: "SportDataPage", examples: ["/sport/rugby-league/match/EVP3489302"]
  handle "/sport/rugby-union/match/:id.app", using: "SportDataPage", examples: ["/sport/rugby-union/match/EVP3551735.app"]
  handle "/sport/rugby-union/match/:id", using: "SportDataPage", examples: ["/sport/rugby-union/match/EVP3551735"]

  ## Sport Topics
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
  handle "/sport/karate", using: "SportDisciplineTopic", examples: ["/sport/karate"]
  handle "/sport/luge", using: "SportDisciplineTopic", examples: ["/sport/luge"]
  handle "/sport/modern-pentathlon", using: "SportDisciplineTopic", examples: ["/sport/modern-pentathlon"]
  handle "/sport/nordic-combined", using: "SportDisciplineTopic", examples: ["/sport/nordic-combined"]
  handle "/sport/rowing", using: "SportDisciplineTopic", examples: ["/sport/rowing"]
  handle "/sport/rugby-sevens", using: "SportDisciplineTopic", examples: ["/sport/rugby-sevens"]
  handle "/sport/sailing", using: "SportDisciplineTopic", examples: ["/sport/sailing"]
  handle "/sport/shooting", using: "SportDisciplineTopic", examples: ["/sport/shooting"]
  handle "/sport/short-track-skating", using: "SportDisciplineTopic", examples: ["/sport/short-track-skating"]
  handle "/sport/skateboarding", using: "SportDisciplineTopic", examples: ["/sport/skateboarding"]
  handle "/sport/skeleton", using: "SportDisciplineTopic", examples: ["/sport/skeleton"]
  handle "/sport/ski-jumping", using: "SportDisciplineTopic", examples: ["/sport/ski-jumping"]
  handle "/sport/snowboarding", using: "SportDisciplineTopic", examples: ["/sport/snowboarding"]
  handle "/sport/speed-skating", using: "SportDisciplineTopic", examples: ["/sport/speed-skating"]
  handle "/sport/sport-climbing", using: "SportDisciplineTopic", examples: ["/sport/sport-climbing"]
  handle "/sport/squash", using: "SportDisciplineTopic", examples: ["/sport/squash"]
  handle "/sport/surfing", using: "SportDisciplineTopic", examples: ["/sport/surfing"]
  handle "/sport/synchronised-swimming", using: "SportDisciplineTopic", examples: ["/sport/synchronised-swimming"]
  handle "/sport/table-tennis", using: "SportDisciplineTopic", examples: ["/sport/table-tennis"]
  handle "/sport/taekwondo", using: "SportDisciplineTopic", examples: ["/sport/taekwondo"]
  handle "/sport/triathlon", using: "SportDisciplineTopic", examples: ["/sport/triathlon"]
  handle "/sport/volleyball", using: "SportDisciplineTopic", examples: ["/sport/volleyball"]
  handle "/sport/water-polo", using: "SportDisciplineTopic", examples: ["/sport/water-polo"]
  handle "/sport/weightlifting", using: "SportDisciplineTopic", examples: ["/sport/weightlifting"]
  handle "/sport/wrestling", using: "SportDisciplineTopic", examples: ["/sport/wrestling"]

  handle "/sport/:discipline/teams/:team", using: "SportDisciplineTeamTopic", examples: ["/sport/rugby-league/teams/wigan"]

  handle "/sport/cricket/the-hundred", using: "SportDisciplineCompetitionTopic", examples: ["/sport/cricket/the-hundred"]
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

## Sport Stories AMP & JSON - use query string params in example URLs to use live data via Mozart
  handle "/sport/:id.amp", using: "SportAmp", examples: ["/sport/50562296.amp?morph_env=live&renderer_env=live"]
  handle "/sport/:id.json", using: "SportAmp", examples: ["/sport/50562296.json?morph_env=live&renderer_env=live"]
  handle "/sport/:discipline/:id.amp", using: "SportAmp", examples: ["/sport/football/56064289.amp?morph_env=live&renderer_env=live"]
  handle "/sport/:discipline/:id.json", using: "SportAmp", examples: ["/sport/football/56064289.json?morph_env=live&renderer_env=live"]

  ## Sport Stories - use query string params in example URLs to use live data via Mozart
  handle "/sport/:id.app", using: "SportMajorStoryPage", examples: ["/sport/50562296.app?morph_env=live&renderer_env=live"]
  handle "/sport/:id", using: "SportMajorStoryPage", examples: ["/sport/50562296?morph_env=live&renderer_env=live"]
  handle "/sport/athletics/:id.app", using: "SportMajorStoryPage", examples: ["/sport/athletics/56628151.app?morph_env=live&renderer_env=live"]
  handle "/sport/athletics/:id", using: "SportMajorStoryPage", examples: ["/sport/athletics/56628151?morph_env=live&renderer_env=live"]
  handle "/sport/cricket/:id.app", using: "SportCricketStoryPage", examples: ["/sport/cricket/56734095.app?morph_env=live&renderer_env=live"]
  handle "/sport/cricket/:id", using: "SportCricketStoryPage", examples: ["/sport/cricket/56734095?morph_env=live&renderer_env=live"]
  handle "/sport/cycling/:id.app", using: "SportMajorStoryPage", examples: ["/sport/cycling/56655734.app?morph_env=live&renderer_env=live"]
  handle "/sport/cycling/:id", using: "SportMajorStoryPage", examples: ["/sport/cycling/56655734?morph_env=live&renderer_env=live"]
  handle "/sport/football/:id.app", using: "SportFootballStoryPage", examples: ["/sport/football/56064289.app?morph_env=live&renderer_env=live"]
  handle "/sport/football/:id", using: "SportFootballStoryPage", examples: ["/sport/football/56064289?morph_env=live&renderer_env=live"]
  handle "/sport/formula1/:id.app", using: "SportFormula1StoryPage", examples: ["/sport/formula1/56604356.app?morph_env=live&renderer_env=live"]
  handle "/sport/formula1/:id", using: "SportFormula1StoryPage", examples: ["/sport/formula1/56604356?morph_env=live&renderer_env=live"]
  handle "/sport/golf/:id.app", using: "SportMajorStoryPage", examples: ["/sport/golf/56713156.app?morph_env=live&renderer_env=live"]
  handle "/sport/golf/:id", using: "SportMajorStoryPage", examples: ["/sport/golf/56713156?morph_env=live&renderer_env=live"]
  handle "/sport/rugby-league/:id.app", using: "SportRugbyStoryPage", examples: ["/sport/rugby-league/56730320.app?morph_env=live&renderer_env=live"]
  handle "/sport/rugby-league/:id", using: "SportRugbyStoryPage", examples: ["/sport/rugby-league/56730320?morph_env=live&renderer_env=live"]
  handle "/sport/rugby-union/:id.app", using: "SportRugbyStoryPage", examples: ["/sport/rugby-union/56719025.app?morph_env=live&renderer_env=live"]
  handle "/sport/rugby-union/:id", using: "SportRugbyStoryPage", examples: ["/sport/rugby-union/56719025?morph_env=live&renderer_env=live"]
  handle "/sport/tennis/:id.app", using: "SportMajorStoryPage", examples: ["/sport/tennis/56731414.app?morph_env=live&renderer_env=live"]
  handle "/sport/tennis/:id", using: "SportMajorStoryPage", examples: ["/sport/tennis/56731414?morph_env=live&renderer_env=live"]

  handle "/sport/:discipline/:id.app", using: "SportStoryPage", examples: ["/sport/swimming/56674917.app?morph_env=live&renderer_env=live"]
  handle "/sport/:discipline/:id", using: "SportStoryPage", examples: ["/sport/swimming/56674917?morph_env=live&renderer_env=live"]

  # Sport catch-all
  handle "/sport/*_any", using: "Sport", examples: []

  # Weather

  handle "/weather", using: "WeatherHomePage", examples: ["/weather"]
  handle "/weather/*_any", using: "Weather", examples: ["/weather/2650225"]

  # WebCore Hub
  handle "/webcore/*_any", using: "WebCoreHub", examples: ["/webcore", "/webcore/tutorials", "/webcore/tutorials/getting-started"]

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

  redirect "/newsround/amp/:id", to: "/newsround/:id.amp", status: 302
  redirect "/newsround/amp/:topic/:id", to: "/newsround/:topic/:id.amp", status: 302

  handle "/newsround/*_any", using: "Newsround", examples: []

  handle "/schoolreport/*_any", using: "Schoolreport", examples: [{"/schoolreport", 301}, {"/schoolreport/home", 301}]

  handle "/wide/*_any", using: "Wide", examples: []

  handle "/archivist/*_any", using: "Archivist", examples: []

  # TODO /proms/extra
  handle "/proms/*_any", using: "Proms", examples: []

  handle "/music", using: "Music", examples: []

   # Bitesize
   handle "/bitesize/secondary", using: "Bitesize", only_on: "test", examples: ["/bitesize/secondary"]

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

  handle_proxy_pass "/*any", using: "ProxyPass", only_on: "test", examples: ["/foo/bar"]

  no_match()
end
