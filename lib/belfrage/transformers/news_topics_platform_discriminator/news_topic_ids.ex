defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminator.NewsTopicIds do
  @moduledoc """
  News Topics IDs that need to be served by Mozart.
  """

  @test_ids [
    #### Currency Topics

    # Euro (EUR)
    "c34v29kj722t",
    # Japanese Yen (JPY)
    "c34v29ky0zkt",
    # Pound Sterling (GBP)
    "cg83gy20ynpt",
    # US Dollar (USD)
    "crnvl9k9790t",

    #### Commodity Topics

    # Gold
    "cdj5gpy2el9t",
    # Natural gas
    "cdj5gpyedz6t",
    # Oil
    "c2x6gdkj24kt",

    #### Business Topics

    # 3i
    "cn2qze2e79zt",
    # 3i Infrastructure
    "crnvj8nz593t",
    # A.G. Barr
    "cx3j4d37e5kt",
    # Aberforth Smaller Companies Trust
    "c4dn07z4qq3t",
    # abrdn
    "c2x62vyvdj2t",
    # Acacia Mining
    "cg83le0y3g8t",
    # Activision Blizzard
    "ce3eprqpd6yt",
    # Adidas
    "cqg5m6yq0x9t",
    # Admiral Group
    "cdj5248rk2jt",
    # AEX
    "cx3jp6rqg78t",
    # Aggreko
    "ce3eprq99jdt",
    # Air France KLM
    "c527xr34jk6t",
    # Aldermore
    "cg83le0kpz2t",
    # Alibaba
    "c527xrd9045t",
    # Alliance Trust
    "c9nje3re365t",
    # Alphabet
    "ckxqp8e092gt",
    # Amazon
    "c8ve8j4epp5t",
    # American Airlines
    "c527xrvg3xkt",
    # Anglo American
    "cve546ykvy9t",
    # Antofagasta
    "cdj524xg8k6t",
    # Apple
    "c5n8yyxv8g2t",
    # Ascential
    "cg83le2d5vzt",
    # Ashmore Group
    "ce3eprye9x7t",
    # Ashtead Group
    "cn2qz4j093qt",
    # Associated British Foods
    "cy632g4gyd8t",
    # Assura
    "ckxqp8rjgy0t",
    # AstraZeneca
    "cj0qx67v6v4t",
    # Auto Trader Group
    "c2x62vk4k0zt",
    # Aveva
    "cpz2y76k9nkt",
    # Aviva
    "cz860vn8qp6t",
    # Babcock International
    "c4dn07k86ylt",
    # BAE Systems
    "cz860ve92yyt",
    # Balfour Beatty
    "cve546n8j3gt",
    # Bank of America
    "c8ve8jg6l5yt",
    # Bank of Georgia
    "crnvj5k72zrt",
    # Bankers Investment Trust
    "c0gjd2ryl0yt",
    # Barclays
    "c34v888q5qpt",
    # Barratt Developments
    "cdj524k3pnrt",
    # BBA Aviation
    "cj0qx6kvzz2t",
    # Beazley Group
    "cpz2y7k88p7t",
    # Bellway
    "c8ve6nn8z30t",
    # Berkeley Group Holdings
    "c34v0n48067t",
    # Berkshire Hathaway Inc.
    "c6lrd5l7rdyt",
    # BHP Billiton
    "cn2qz42z0ket",
    # Big Yellow Group
    "cn2qz42p59kt",
    # Blackberry Ltd
    "cn2qz4284xrt",
    # BMW
    "cg83le80vn7t",
    # BNP Paribas
    "c6lrd5lnd2yt",
    # Bodycote
    "c527xr264xyt",
    # Boeing
    "crnvj5nnke3t",
    # Booker Group
    "cn2qz423vzkt",
    # Bovis Homes Group
    "ce3epr377r2t",
    # BP
    "cqg5kkgqrjkt",
    # Brewin Dolphin
    "ckxqp854304t",
    # British American Tobacco
    "c2x62v3d2vqt",
    # British Empire Trust
    "cly0xqen84dt",
    # British Land
    "c7z59e09r5jt",
    # Britvic
    "cve546d8426t",
    # BSE Sensex
    "cg83grr9745t",
    # BT Group
    "c527xrqpynrt",
    # BTG
    "crnvj5g7xe4t",
    # Bunzl
    "c9nje3yj35jt",
    # Burberry Group
    "crnvj5g866jt",
    # CAC 40
    "cg83grryyy2t",
    # Cairn Energy
    "c34v0n6n08pt",
    # Caledonia Investments
    "c34v0n6qv5dt",
    # Capita
    "cx3j4qle3n2t",
    # Capital & Counties Properties
    "cve546d0yykt",
    # Card Factory
    "c0gjd2eqg2pt",
    # Carnival Corporation
    "c2x62v3evd7t",
    # Centamin
    "cly0xqeydkzt",
    # Centrica
    "crnvj5gg4zdt",
    # Cineworld
    "ce3eprz7d49t",
    # Citigroup
    "crnvj5g64vpt",
    # City of London Investment Trust
    "cz860v422gvt",
    # Clarkson
    "c2x62vyr40kt",
    # Close Brothers Group
    "c4dn074v3n8t",
    # CLS Holdings
    "c6lrd5zdldpt",
    # Coats Group
    "cve546pqy24t",
    # Cobham
    "cj0qx63l4let",
    # Coca-Cola
    "c9nje3vjkz7t",
    # Coca-Cola HBC AG
    "cz860v4ykj4t",
    # Compass Group
    "c2x62vyjxyxt",
    # Computacenter
    "c7z59ep2yd3t",
    # ConvaTec
    "cpz2y7xgl7lt",
    # Countryside Properties
    "c2x62vy5ngyt",
    # Cranswick
    "cg83le5nzp4t",
    # Credit Agricole
    "cj0qx637n83t",
    # Crest Nicholson
    "cdj524nkdl7t",
    # CRH
    "cn2qz4g20eyt",
    # Croda International
    "ce3epr7zdv0t",
    # CYBG
    "c8ve8j976qqt",
    # Daejan Holdings
    "c527xrzgxrgt",
    # Dairy Crest
    "c2x62v0rlejt",
    # DAX
    "c4dnpe3gn4dt",
    # DCC
    "cy632gvqv9rt",
    # Debenhams
    "c527xrzjkd5t",
    # Dechra Pharmaceuticals
    "cg83le69lyjt",
    # Delta Air Lines
    "cdj5247exyxt",
    # Derwent London
    "c527xrzrrpgt",
    # Deutsche Bank
    "cly0xqzddj4t",
    # Diageo
    "cj0qx6ye0lrt",
    # Dignity
    "c7z59evn5pzt",
    # Diploma
    "ckxqp82kgzpt",
    # Direct Line Group
    "cg83le68gvvt",
    # Disney limited
    "c4dn07282e5t",
    # Dixons Carphone
    "c2x62v008r9t",
    # DJIA
    "cz86qzzjd52t",
    # Domino's Pizza Group
    "cly0xdpp7r8t",
    # Drax Group
    "c4dn0gxedv0t",
    # DS Smith
    "cly0xdp2nret",
    # Dunelm Group
    "c527x09x53nt",
    # eBay
    "cdj523604y7t",
    # EDF Energy
    "ckxqpd4qgrgt",
    # Edinburgh Investment Trust
    "c9nje29d498t",
    # Electra Private Equity
    "c0gjd3l5g0yt",
    # Electrocomponents
    "cn2qzd7ddxvt",
    # Electronic Arts
    "c4e6e65je9vt",
    # Elementis
    "cy6327pjj74t",
    # Engie
    "c0gjd3l7k28t",
    # Entertainment One
    "c34v0q5x457t",
    # Essentra
    "crnvjzrqk2jt",
    # Esure
    "c2x628pey0et",
    # Euromoney Institutional Investor
    "c8ve825xp0zt",
    # EuroStoxx 50
    "c34v29jpdkjt",
    # Evraz
    "cg83lqx5qzvt",
    # Experian
    "c9nje2l9lj3t",
    # Exxon Mobil
    "cdj523ppgryt",
    # F&C Commercial Property Trust
    "cn2qzdxrexpt",
    # Facebook
    "c054kg2m86yt",
    # FDM Group
    "cly0xdv2ddzt",
    # Ferguson
    "cpz2ydeyk68t",
    # Ferrexpo
    "c34v0q9gq7jt",
    # Fidelity China Special Situations
    "ckxqpd3lve7t",
    # Fidelity European Values
    "cn2qzdxqnrnt",
    # Fidessa
    "cz860r2yrqxt",
    # Finsbury Growth & Income Trust
    "c0gjd345evqt",
    # FirstGroup
    "cpz2pe6y4r7t",
    # Flybe
    "c6lrd202j5qt",
    # Ford
    "crnvjz94jp8t",
    # Foreign & Colonial Investment Trust
    "c9nje2lr6let",
    # Fresnillo
    "c2x628dkyj3t",
    # FTSE 100
    "cx3jp6rk8yjt",
    # FTSE 250
    "cy638e535r9t",
    # G4S
    "cqv92d7vj8dt",
    # Galliford Try
    "cdj523pngjdt",
    # GCP Infrastructure Investments
    "c7z592lv3y5t",
    # General Electric
    "c9nje2k96e3t",
    # General Motors
    "cg83lqry4djt",
    # Genesis Emerging Markets Fund
    "c4dn0g99ljkt",
    # Genus
    "c2x628rq49pt",
    # GKN
    "c8ve82l893vt",
    # GlaxoSmithKline
    "ce3ep6l4jvxt",
    # Glencore
    "c527x0k5d9xt",
    # Go-Ahead Group
    "cz860r0x0dkt",
    # Goldman Sachs
    "c8vek58yq3yt",
    # Grafton Group
    "cy638p2ge66t",
    # Grainger
    "cqv94e2dq3rt",
    # Great Portland Estates
    "cve5874ryjrt",
    # Greencoat UK Wind
    "cqv94e2jrqxt",
    # Greencore
    "c527j9j98nxt",
    # Greene King
    "c527j9jg4vqt",
    # Greggs
    "cx3jpzp8nvxt",
    # Groupon
    "c34v252092gt",
    # GVC Holdings
    "c8vek5kkyjvt",
    # Halfords
    "crnvlrle8q7t",
    # Halma
    "c0gjplp8j0yt",
    # Hammerson
    "c8vek5kp4p2t",
    # Hang Seng
    "c527jkk5vr4t",
    # Hansteen Holdings
    "cpz2p4p2znlt",
    # Hargreaves Lansdown
    "cly06p64p5pt",
    # Hastings Insurance
    "c2x6gpgvrvvt",
    # Hays
    "cg83gxgqpr8t",
    # HICL Infrastructure Company
    "cj0qp4penk3t",
    # Hikma Pharmaceuticals
    "crnvlrl4jxqt",
    # Hill & Smith
    "ce3eg2gdn7zt",
    # Hiscox
    "cy638p8rnlvt",
    # Hochschild Mining
    "c0gjplpkk4zt",
    # Homeserve
    "c34v2524d0dt",
    # Howdens Joinery
    "ckxqg4g6vl9t",
    # HP Inc
    "ce3eg2g73k7t",
    # HSBC
    "ckxqg499zy3t",
    # Hunting
    "c527j9jzl66t",
    # IBEX 35
    "c7z5xrlpvv7t",
    # IBM
    "c6lrx43p3zyt",
    # Ibstock
    "cqv94e5lv4jt",
    # IG Group
    "cx3jpzgkv6yt",
    # IGas Energy
    "cx3jpzgd5lqt",
    # IMI
    "cve587qxrv8t",
    # Imperial Brands
    "c9njx9q30j8t",
    # Inchcape
    "cn2qp7ndv96t",
    # Indivior
    "c9njx9qg97jt",
    # Informa
    "cn2qp7n5g79t",
    # Inmarsat
    "ce3eg24ydj3t",
    # Intel
    "c4dnpxq8qjlt",
    # InterContinental Hotels Group
    "c0gjpl9rq73t",
    # Intermediate Capital Group
    "c527j9pl55nt",
    # International Public Partnerships
    "cg83gx96neqt",
    # Intertek
    "cz86q9x9l7gt",
    # Intu Properties
    "c527j95g399t",
    # Investec
    "cg83gxdr30xt",
    # IP Group
    "cn2qp7y9lzpt",
    # ITV
    "c527j95x8z7t",
    # IWG
    "ce3eg20gy4vt",
    # James Fisher & Sons
    "c7z5xdjyqx8t",
    # Jardine Lloyd Thompson
    "c34v2577k02t",
    # JD Sports
    "cj0qp48qx67t",
    # John Laing Group
    "c6lrx4eqdnvt",
    # John Laing Infrastructure Fund
    "ce3eg20r895t",
    # Johnson Matthey
    "cqv94eld0xgt",
    # Johnston Press
    "crnvlryxd0qt",
    # JP Morgan
    "c4dnpxryvxjt",
    # JPMorgan American Investment Trust
    "c6lrx4enng9t",
    # JPMorgan Emerging Markets Investment Trust
    "c34v2574gp2t",
    # JPMorgan Indian Investment Trust
    "c2x6gpn37v3t",
    # Jupiter Fund Management
    "c6lrx4ezekxt",
    # Just Eat
    "cpz2p4l539jt",
    # Just Group
    "cz86q9k9329t",
    # KAZ Minerals
    "c6lrx4j0687t",
    # Kennedy-Wilson Holdings
    "c4dnpx59zdlt",
    # Kier Group
    "ckxqg4lyd3lt",
    # Kingfisher
    "cz86q9k06v2t",
    # Ladbrokes Coral
    "c9njx9pxpx8t",
    # Lancashire Holdings
    "cn2qp7lyz9zt",
    # Land Securities
    "ce3eg288n0et",
    # Legal & General
    "cj0qp4ln7x5t",
    # Lloyds Banking Group
    "crnvlr7vy0qt",
    # London Stock Exchange Group
    "cmj7nvxk8w2t",
    # LondonMetric Property
    "ckxqg4ld8k2t",
    # Lufthansa
    "c527j9e42n8t",
    # Man Group
    "cve587j0dn6t",
    # Marks & Spencer
    "c4q2ww6mk2jt",
    # Marshalls
    "cpz2p4v695xt",
    # Marston's Brewery
    "ckxqg4lkvxlt",
    # McCarthy & Stone
    "c2x6gp7xgrkt",
    # McDonald's
    "cdj5g6dl24xt",
    # Mediclinic International
    "cy638pknx7rt",
    # Meggitt
    "ckxqg4l2qygt",
    # Melrose Industries
    "c4dnpxnev0xt",
    # Mercantile Investment Trust
    "c4dnpxn90dpt",
    # Merlin Entertainments
    "cqv94e92le9t",
    # Metro Bank (United Kingdom)
    "c4dnpxnvnnxt",
    # Micro Focus
    "crnvlrvle22t",
    # Microsoft
    "c7z5xd5yxgqt",
    # Millennium & Copthorne Hotels
    "cve5875l3ext",
    # Mitchells & Butlers
    "ckxqg4q00gpt",
    # Mitie
    "cpz2p42vl38t",
    # Mondi
    "cve5875x5n4t",
    # Moneysupermarket.com
    "cly06p0q0l7t",
    # Monks Investment Trust
    "c4dnpxn4zlvt",
    # Morgan Advanced Materials
    "crnvlrv6gejt",
    # Morgan Stanley
    "c2x6gpldnknt",
    # Morrisons
    "cve587lzjxlt",
    # Murray International Trust
    "cve587lkyv9t",
    # N Brown Group
    "cn2qp7epx3nt",
    # NASDAQ
    "cy638992l27t",
    # National Express
    "ckxqg479y8lt",
    # National Grid - 1
    "c0gjply8x94t",
    # Netflix
    "c9njx9dpq6lt",
    # NewRiver
    "cg83gx43g3pt",
    # NEX Group
    "c6lrx4yyrj9t",
    # Nike Inc.
    "c34v25p3nqgt",
    # Nikkei 225
    "cy63899dgl3t",
    # NMC Health
    "cy638pyglvnt",
    # Northgate
    "c527j9y3j45t",
    # Nostrum Oil & Gas
    "cpz2p43dkkkt",
    # Nvidia
    "cx3jpzd7py5t",
    # Ocado
    "cn2qp7ejy70t",
    # Old Mutual
    "cve587ln53vt",
    # OneSavings Bank
    "cqv94e6v3ent",
    # P2P Global Investments
    "cdj5g6ene3qt",
    # Paddy Power Betfair
    "cg83gx5ypz7t",
    # PageGroup
    "ckxqg46vr0zt",
    # Parkmead Group
    "cve587p4jdnt",
    # PayPal
    "ckxqg46g07lt",
    # PayPoint
    "cj0qp439pylt",
    # Pearson
    "cg83gx5p3kyt",
    # Pennon Group
    "c0gjpl0jp7et",
    # PepsiCo
    "cy638pnyx22t",
    # Perpetual Income & Growth Investment Trust
    "cz86q94d06rt",
    # Persimmon
    "c2x6gpyvd06t",
    # Personal Assets Trust
    "c0gjpl03dget",
    # Petra Diamonds
    "cdj5g6n9vq7t",
    # Petrobras
    "ckxqg46n4l7t",
    # Petrofac
    "cn2qp7g5v4nt",
    # Peugeot-Citroen
    "c34v25dkynvt",
    # Pfizer
    "cg83gx58j20t",
    # Phoenix Group
    "cve587p29k6t",
    # Playtech
    "cn2qp7v786et",
    # Polar Capital Technology Trust
    "cj0qp4yjvnzt",
    # Polymetal International
    "cg83gx6r89rt",
    # Polypipe
    "cve58724n33t",
    # Procter & Gamble
    "c2x6gp0nrdqt",
    # Provident Financial
    "c0gjpl6vnljt",
    # PZ Cussons
    "cg83gx6zqplt",
    # Qinetiq
    "cly06pzqdnxt",
    # Randgold Resources
    "ckxqg42dq0xt",
    # Rathbones Group
    "ckxqg42jd59t",
    # Reckitt Benckiser
    "c527j9z339gt",
    # Redefine International
    "cg83gx6nep5t",
    # Redrow
    "cy638pv4ggdt",
    # RELX Group
    "cz86q97ed42t",
    # Renault
    "c9njx95n3jqt",
    # Renewables Infrastructure Group
    "c527j9zq00kt",
    # Renishaw
    "cn2qp7vg4yvt",
    # Rentokil Initial
    "crnvlr6688rt",
    # Restaurant Group
    "cdj5gp6g83jt",
    # Rightmove
    "cz86q29g5rjt",
    # Rio Tinto
    "c8vek356480t",
    # RIT Capital Partners
    "c6lrx04j6llt",
    # Riverstone Energy
    "cg83gyx4yjnt",
    # Rotork
    "cj0qpj4zgdlt",
    # RPC Group
    "c2x6285p7gpt",
    # RSA Insurance Group
    "c8ve82qp2ext",
    # Ryanair
    "c9nje22k52pt",
    # S&P 500
    "c34v2882e79t",
    # Safestore
    "c0gjd320j40t",
    # Saga
    "c348m29q17qt",
    # Sage Group
    "cpz2yd7zpr6t",
    # Sainsbury's
    "cve54969ge6t",
    # Sanne Group
    "c6lrd25rjjgt",
    # Santander Group
    "c8ve82j6zrxt",
    # Savills
    "c0gjd32pedpt",
    # Schroders
    "cpz2yd06009t",
    # Scottish Investment Trust
    "cn2qzd05474t",
    # Scottish Mortgage Investment Trust
    "c34v0q3nvy5t",
    # Segro
    "cvqlj671xrxt",
    # Senior
    "c2x6286x689t",
    # Serco
    "c34v0qvvnd4t",
    # Severn Trent
    "c2x62869kz0t",
    # Shaftesbury
    "cj0qxdqxz40t",
    # Shell
    "c527jg94v7dt",
    # Shire (pharmaceutical company)
    "c527x0gpvq9t",
    # Siemens
    "c9nje29e5ggt",
    # SIG
    "ckxqpd4yr4xt",
    # Sirius Minerals
    "cz860r92pyyt",
    # Smiths Group
    "c0gjd266pk2t",
    # Smurfit Kappa Group
    "cx3j4q9l4kgt",
    # Societe Generale
    "ce3epr5k6kkt",
    # Softcat
    "cx3j4q97ngnt",
    # Sophos
    "c9nje35g869t",
    # Spectris
    "c4dn072grx7t",
    # Spirax-Sarco Engineering
    "cy632gvdr3rt",
    # Spire Healthcare
    "crnvj56vj5kt",
    # Sports Direct
    "c34v0nyg0vet",
    # SSE
    "ce3epr5pnp5t",
    # SSE Composite
    "cx3jp88n8rrt",
    # St. James's Place
    "ce3epr7yke9t",
    # St. Modwen Properties
    "cve546pvjk3t",
    # Stagecoach
    "cdj524n97pnt",
    # Standard Chartered
    "cn2qz4gdq5gt",
    # Starbucks
    "cdj524nej58t",
    # Stobart Group
    "c9nje3vj266t",
    # Superdry
    "ce3epr78g4vt",
    # Syncona
    "c8ve8j9dv36t",
    # Synthomer
    "cj0qx63pdv4t",
    # TalkTalk Group
    "c34v0nd0838t",
    # Tate & Lyle
    "cly0xq8v4xdt",
    # Taylor Wimpey
    "c8ve8jxvr22t",
    # TBC Bank
    "cx3j4qlr42yt",
    # Ted Baker
    "crnvj5g0zqvt",
    # Telecom Plus
    "cj0qx6rnz6nt",
    # Temple Bar Investment Trust
    "cj0qx6rlgvdt",
    # Templeton Emerging Markets Investment Trust
    "c7z59e0yenvt",
    # Tesco
    "c8rjp7le05gt",
    # Tesla
    "crnvj5gjng0t",
    # The Rank Group
    "cly0xqe26k2t",
    # The Royal Bank of Scotland Group
    "c4dn07d2k9dt",
    # Thomas Cook Group
    "cy632g6n83dt",
    # Total
    "c8ve8jvvgryt",
    # TP ICAP
    "cdj524jx7vqt",
    # TR Property Investment Trust
    "cn2qz426zllt",
    # Travis Perkins
    "c2x62vxze09t",
    # Tritax Big Box REIT
    "ckxqp8xddq2t",
    # Trying out for testing
    "ce3ep6229djt",
    # TUI Group
    "cqv92rv54dqt",
    # Tullow Oil
    "cpz2y7zpn9dt",
    # Twitter
    "c34vnzgl026t",
    # Twitter
    "c9nje3n8z6pt",
    # UBM
    "cn2qz42x3xkt",
    # UDG Healthcare
    "c2x62vxpdvyt",
    # UK Commercial Property Trust
    "c7z59eqpny2t",
    # Ultra Electronics
    "c2x62ve3ng6t",
    # Unilever
    "crnvj5kk8qzt",
    # Unite Students
    "cpz2y7kgqj4t",
    # United Utilities
    "cj0qx6kze3lt",
    # Vectura Group
    "ckxqp8k7308t",
    # Vedanta Resources
    "cg83lekpzj0t",
    # Vesuvius
    "cn2qz4kyx2jt",
    # Victrex
    "ce3eprkpq4qt",
    # Vietnam Enterprise Investments
    "cqv92rkee73t",
    # Virgin Money UK
    "crnvj5qd99lt",
    # Vodafone
    "c6lrd5nl3e6t",
    # Volkswagen
    "ckxqp8rre37t",
    # Walmart
    "c07g2599zylt",
    # Weir Group
    "cdj524xyr8yt",
    # Wetherspoons
    "crnvj5qxk0zt",
    # Whitbread
    "c527xrv0kept",
    # WHSmith
    "cz860vnd2r7t",
    # William Hill (bookmaker)
    "cve546y505vt",
    # Witan Investment Trust
    "cve546yj386t",
    # Wizz Air
    "cn2qz4jn4r3t",
    # Wood Group
    "ce3eprynydrt",
    # Woodford Patient Capital Trust
    "cdj524xpn35t",
    # Workspace Group
    "c0gjd2qqnplt",
    # Worldpay
    "cly0xqjxj8qt",
    # Worldwide Healthcare Trust
    "cpz2y7qe6dqt",
    # WPP
    "cj0qx6v364gt",
    # ZPG
    "cj0qx6vvkj8t",

    #### Politics Topics

    # Aberdeen City Council
    "cnx95551myzt",
    # Aberdeenshire Council
    "cyw9kkkzmyjt",
    # Adur Council
    "c4dnne8v4y3t",
    # Allerdale Borough Council
    "cdg2gqyg33zt",
    # Amber Valley Council
    "ce3eexyve89t",
    # Angus Council
    "c77gzzz1eykt",
    # Antrim and Newtownabbey Borough Council
    "cwg7pqnw7xwt",
    # Argyll and Bute Council
    "ckpr1114dmyt",
    # Armagh City, Banbridge and Craigavon District Council
    "cg8kegl28yqt",
    # Arun District Council
    "c7z7zeppp2wt",
    # Ashfield District Council
    "c9y4ye32rqlt",
    # Ashford Borough Council
    "cnrgrnmvvl9t",
    # Aylesbury Vale District Council
    "cmdnd39r97zt",
    # Babergh District Council
    "cwgdgkzwn92t",
    # Barking and Dagenham Council
    "cpz22ex99jzt",
    # Barnet Council
    "cly00ve70nnt",
    # Barnsley Council
    "cy633enq72pt",
    # Barrow Borough Council
    "cnrgrnmdlrxt",
    # Basildon Council
    "ckxqq3r6949t",
    # Basingstoke and Deane Borough Council
    "cqv997k7d3et",
    # Bassetlaw District Council
    "cyq4qrmeq6gt",
    # Bath and North East Somerset Council
    "cjl7lyx6gdkt",
    # Bedford Borough Council
    "cxwrw49dw2lt",
    # Belfast City Council
    "c8mjlyr86wqt",
    # Bexley London Borough Council
    "c7z55l072ryt",
    # Birmingham City Council
    "cx3jj6v4685t",
    # Blaby District Council
    "cry6y8q3xddt",
    # Blackburn with Darwen Borough Council
    "c6lrr094rdvt",
    # Blackpool Council
    "c7z7zemrwpxt",
    # Blaenau Gwent Council
    "c77gzzz1ezkt",
    # Bolsover District Council
    "c6eyep9rz97t",
    # Bolton Metropolitan Borough Council
    "c9njjlve732t",
    # Borough Council of King's Lynn and West Norfolk
    "cmdndl7egget",
    # Borough Council of Wellingborough
    "cry6yv79x9wt",
    # Boston Borough Council
    "cnrgrnm38zjt",
    # Bournemouth, Christchurch and Poole Council
    "cvnxn4r2nppt",
    # Bracknell Forest Borough Council
    "c22k26l6gq4t",
    # Braintree District Council
    "cmdnd39l829t",
    # Breckland Council
    "cg8r8jqpldgt",
    # Brent London Borough Council
    "ce3eexzvzj2t",
    # Brentwood Borough Council
    "cz8662nnl0et",
    # Bridgend County Borough Council
    "ckpr1114d1yt",
    # Brighton and Hove City Council
    "cjl7lyx3j4vt",
    # Bristol City Council
    "cz4e333z1rmt",
    # Broadland District Council
    "ck2v27rvlvmt",
    # Bromley London Borough Council
    "cpz22e87nx6t",
    # Bromsgrove District Council
    "cqm8mqg8m67t",
    # Broxbourne Borough Council
    "cj0qqj09zx4t",
    # Broxtowe Borough Council
    "cjl7lyxkeekt",
    # Buckinghamshire Council
    "cjgd964pge8t",
    # Buckinghamshire County Council
    "cg41llldy3dt",
    # Burnley Borough Council
    "c4dnnedy0d7t",
    # Bury Metropolitan Borough Council
    "cn2qqxgpl9gt",
    # Caerphilly County Borough Council
    "c30qmmmg3mnt",
    # Calderdale Council
    "cz86624g2zpt",
    # Cambridge City Council
    "c0gjj4k5e7qt",
    # Cambridgeshire County Council
    "cz4e333zqn0t",
    # Camden London Borough Council
    "c9njjlv92l5t",
    # Cannock Chase Council
    "c6lrr0lz635t",
    # Canterbury City Council
    "cnrgrnmwly9t",
    # Cardiff Council
    "cdr8nnnw9ngt",
    # Carlisle City Council
    "c0gjj4k3d57t",
    # Carmarthenshire County Council
    "clmjwwwegwnt",
    # Castle Point Borough Council
    "c4dnnek43zzt",
    # Causeway Coast and Glens District Council
    "cnrkx2ed4vmt",
    # Central Bedfordshire Council
    "cwgdgkz9ennt",
    # Ceredigion County Council
    "c93g777zr7yt",
    # Charnwood Borough Council
    "cmdndl22j69t",
    # Chelmsford City Council
    "cz8y8jww847t",
    # Cheltenham Borough Council
    "cly00vkp8q4t",
    # Cherwell District Council
    "cj0qqj0r4p6t",
    # Cheshire East Council
    "cyq4q69prlkt",
    # Cheshire West and Chester Council
    "cnrgr2xpxmnt",
    # Chesterfield Borough Council
    "c8mvmylgwy2t",
    # Chichester District Council
    "cz8y8jwkg7jt",
    # Chiltern District Council
    "c34k46ypqmwt",
    # Chorley Borough Council
    "c7z55lz4724t",
    # City and County of Swansea Council
    "cx1l777p8zdt",
    # City of Bradford Metropolitan District Council
    "c5277glxlj4t",
    # City of Lincoln Council
    "c0gjj4gq63rt",
    # City of Westminster Council
    "c5277gl9gxdt",
    # Clackmannanshire Council
    "c30qmmmg38nt",
    # Colchester Borough Council
    "c9njjl4ylpdt",
    # Comhairle nan Eilean Siar
    "cx1l777pepdt",
    # Conwy County Borough Council
    "ce1q3334e31t",
    # Copeland Borough Council
    "c8mvmyl8v2et",
    # Cornwall Council
    "cyw9kkkzmk9t",
    # Cotswold District Council
    "cyq4q69ew4wt",
    # Coventry City Council
    "cx3jj6vglzdt",
    # Craven District Council
    "cly00vyyn8kt",
    # Crawley Borough Council
    "cx3jj6lj5yvt",
    # Croydon London Borough Council
    "cz8662pd5llt",
    # Cumbria County Council
    "c00eqqqgyn8t",
    # Cyngor Bwrdeistref Sirol Castell-nedd Port Talbot
    "c77gzzz1xzjt",
    # Cyngor Bwrdeistref Sirol Rhondda Cynon Taf
    "clmjwwwedwzt",
    # Cyngor Sir Ynys M�n
    "cwrmyyydpg4t",
    # Dacorum Borough Council
    "cewxw4vev7qt",
    # Darlington Borough Council
    "c6eye2lgpmkt",
    # Dartford Borough Council
    "cz8y8jw9dlmt",
    # Daventry District Council
    "ce3eex3kev2t",
    # Denbighshire County Council
    "cr3nmmmp7m8t",
    # Derby City Council
    "ckxqq32382nt",
    # Derbyshire County Council
    "cnx95551mwrt",
    # Derbyshire Dales District Council
    "c4dkdj7nerwt",
    # Derry City and Strabane District Council
    "c4dw7jq3p34t",
    # Devon County Council
    "cyw9kkkzm79t",
    # Doncaster Metropolitan Borough Council
    "ce1q3334e3zt",
    # Dorset Council
    "c22k28jv2llt",
    # Dorset County Council
    "c77gzzz1epet",
    # Dover District Council
    "ck2v268w4kqt",
    # Dudley Metropolitan Borough Council
    "c8vee396kp2t",
    # Dumfries and Galloway Council
    "cdr8nnnw9kgt",
    # Dundee City Council
    "clmjwwwegxnt",
    # Durham County Council
    "c77gzzz1ezet",
    # Ealing London Borough Council
    "cx3jj6ln6grt",
    # East Ayrshire Council
    "c93g777zrdyt",
    # East Cambridgeshire District Council
    "c8mvmyl6r93t",
    # East Devon District Council
    "cdg2gv4q6y6t",
    # East Dunbartonshire Council
    "ce1q3334ed1t",
    # East Hampshire District Council
    "cnrgr2xyxdxt",
    # East Hertfordshire District Council
    "c6eye2lm3jdt",
    # East Lindsey District Council
    "cnrgr2xqgjkt",
    # East Lothian Council
    "cr3nmmmp7r8t",
    # East Renfrewshire Council
    "c10r88897w8t",
    # East Riding of Yorkshire Council
    "c22k28jk73gt",
    # East Staffordshire Borough Council
    "cewxw4vxz84t",
    # East Suffolk Council
    "cdg2gv4knrnt",
    # East Sussex County Council
    "ckpr1114de3t",
    # Eastbourne Borough Council
    "cxwrw8zv9y6t",
    # Eastleigh Borough Council
    "cz8662ezjjxt",
    # Eden District Council
    "cyq4q69qll7t",
    # Elmbridge Borough Council
    "cpz22e8ngnlt",
    # Enfield London Borough Council
    "ck0wg9gq4nlt",
    # England local elections 2017
    "clr89d553ggt",
    # England local elections 2018
    "c9xk4k8wn4kt",
    # England local elections 2019
    "cqqqppyln75t",
    # England local elections 2021
    "cmn3ww61yn5t",
    # England local elections 2021
    "cjgd9xmkj3jt",
    # Epping Forest District Council
    "cve553ynprqt",
    # Epsom and Ewell Borough Council
    "cvnxnw6dkvgt",
    # Erewash Borough Council
    "cpzqzy98qket",
    # Essex County Council
    "c30qmmmg34lt",
    # European Elections 2019
    "ck33e7n437wt",
    # Exeter City Council
    "cn2qqxj834zt",
    # Falkirk Council
    "c404jjj3n33t",
    # Fareham Borough Council
    "c5277g2n2jlt",
    # Fenland District Council
    "c34k469yxngt",
    # Fermanagh and Omagh District Council
    "c7z6j4rxng8t",
    # Fife Council
    "c50wnnnpjpmt",
    # Flintshire County Council
    "c10r8889788t",
    # Folkestone and Hythe District Council
    "c22nj8v362et",
    # Forest of Dean District Council
    "cnrgr288jq3t",
    # Fylde Borough Council
    "cnrgr28v2ngt",
    # Gateshead Council
    "cly00v8gyl7t",
    # Gedling Borough Council
    "c6eye267x2pt",
    # Glasgow City Council
    "cqkwppp0501t",
    # Gloucester City Council
    "c11le4pp20gt",
    # Gloucestershire County Council
    "cdr8nnnw9y5t",
    # Gosport Borough Council
    "c0gjj4rx222t",
    # Gravesham Borough Council
    "cz8y8jxkjlmt",
    # Great Yarmouth Borough Council
    "c5277g2v77rt",
    # Greenwich London Borough Council
    "cj0qqjr725qt",
    # Guildford Borough Council
    "c9y4y768k8zt",
    # Gwynedd Council
    "cwrmyyydqyxt",
    # Hackney London Borough Council
    "c34vv9d96k8t",
    # Halton Borough Council
    "cpz22e5932dt",
    # Hambleton District Council
    "cg8r8gn6q3nt",
    # Hammersmith and Fulham London Borough Council
    "c6lrr0g9dp6t",
    # Hampshire County Council
    "c93g777zrjxt",
    # Harborough District Council
    "c34k469e6y2t",
    # Haringey London Borough Council
    "ce3eex7l0get",
    # Harlow District Council
    "cj0qqj7r7z7t",
    # Harrogate Borough Council
    "c8vee3vvjnvt",
    # Harrow London Borough Council
    "c0gjj4ezv2jt",
    # Hart District Council
    "ce3eexknxvxt",
    # Hartlepool Borough Council
    "cpz22e5ypvgt",
    # Hastings Borough Council
    "cve553yvzlqt",
    # Havant Borough Council
    "c9njjlne47vt",
    # Havering London Borough Council
    "cdj55pl342pt",
    # Herefordshire Council
    "c9y4y76dwwet",
    # Hertfordshire County Council
    "clmjwwwegrqt",
    # Hertsmere Borough Council
    "cjl7l8j94k2t",
    # High Peak Borough Council
    "c9y4y7693pmt",
    # Highland Council
    "c8ngyyyp4prt",
    # Hillingdon London Borough Council
    "ce3eexz6780t",
    # Hinckley and Bosworth Borough Council
    "cnrgr28439jt",
    # Horsham District Council
    "c4dkdj2qmrmt",
    # Hounslow London Borough Council
    "c2x66d3vvl7t",
    # Hull City Council
    "c34vv9y89vdt",
    # Huntingdonshire District Council
    "cdj55px044jt",
    # Hyndburn Borough Council
    "crnvv9n40njt",
    # Inverclyde Council
    "cp7r8881z1rt",
    # Ipswich Borough Council
    "c5277g2zrl4t",
    # Isle of Wight Council
    "ckpr1114d13t",
    # Islington London Borough Council
    "c6lrr0z0y6jt",
    # Kensington and Chelsea London Borough Council
    "cpz22e85dxpt",
    # Kent County Council
    "ce1q3334e7zt",
    # Kingston Upon Thames London Borough Council
    "cg833yvzdx7t",
    # Kirklees Council
    "cdj55pnz5d4t",
    # Knowsley Metropolitan Borough Council
    "ckxqq36zx69t",
    # Lambeth London Borough Council
    "ce3eexzqz2yt",
    # Lancashire County Council
    "cr3nmmmp78jt",
    # Lancaster City Council
    "cz8y8jxrlj8t",
    # Leeds City Council
    "cqv997yrnret",
    # Leicester City Council
    "cnrgr2824g3t",
    # Leicestershire County Council
    "c10r888971zt",
    # Lewes District Council
    "clx3xj4pym9t",
    # Lewisham London Borough Council
    "c5277gqddvqt",
    # Lichfield District Council
    "c22k28my8p7t",
    # Lincolnshire County Council
    "cwrmyyydqg5t",
    # Lisburn City and Castlereagh District Council
    "cvny6w3jpwjt",
    # Liverpool City Council
    "cz86624v8lpt",
    # London elections 2021
    "cklvjmjvd28t",
    # Luton Borough Council
    "cnrgr28qzx7t",
    # Maidstone Borough Council
    "c7z55lzgdqrt",
    # Maldon District Council
    "c4dkdj2x4jxt",
    # Malvern Hills District Council
    "c34k469k3kwt",
    # Manchester City Council
    "crnvv9dz5pqt",
    # Mansfield District Council
    "cqm8m7nklnrt",
    # Mayor of Bristol
    "cggp25drqj3t",
    # Mayor of Cambridgeshire & Peterborough
    "cvvkd5ky9z7t",
    # Mayor of Doncaster
    "cpd3nyz79n1t",
    # Mayor of Greater Manchester
    "c5y42d62v23t",
    # Mayor of Liverpool
    "c11gpej5524t",
    # Mayor of London
    "c7j16rjpl4nt",
    # Mayor of North Tyneside
    "c2my4d69j87t",
    # Mayor of Salford
    "c3e5lr41mlgt",
    # Mayor of the Liverpool City Region
    "ckdj67wq01dt",
    # Mayor of the Tees Valley
    "czprj20qgn2t",
    # Mayor of the West Midlands
    "cg54y70zg1mt",
    # Mayor of the West of England
    "cggp25kpqejt",
    # Mayor of West Yorkshire
    "cpd3nyk6l62t",
    # Medway Council
    "cg8r8gnkr6dt",
    # Melton Borough Council
    "cmdndl7d444t",
    # Mendip District Council
    "cpzqzyl8l9lt",
    # Merthyr Tydfil County Borough Council
    "c404jjj3dm3t",
    # Merton London Borough Council
    "crnvv9gdvx8t",
    # Mid and East Antrim District Council
    "cxwvz8gyewet",
    # Mid Devon District Council
    "clx3xj4npyxt",
    # Mid Suffolk District Council
    "clx3xj48mqet",
    # Mid Sussex District Council
    "clx3xj483vet",
    # Mid Ulster District Council
    "cqmk97eejlrt",
    # Middlesbrough Borough Council
    "cdg2gv67rxyt",
    # Midlothian Council
    "cmjr4449l9gt",
    # Milton Keynes Council
    "c7z55lv98gjt",
    # Mole Valley District Council
    "ce3eexzxzkkt",
    # Monmouthshire County Council
    "c50wnnnpexmt",
    # Moray Council
    "cjn5rrrlklkt",
    # Neath Port Talbot County Borough Council
    "cqkwppp0y91t",
    # New Forest District Council
    "cvnxnwz92v9t",
    # Newark and Sherwood District Council
    "cjl7l824xwxt",
    # Newcastle City Council
    "cj0qqj3dy05t",
    # Newcastle-under-Lyme Borough Council
    "cj0qqj039ent",
    # Newham London Borough Council
    "cqv997ypgz3t",
    # Newport City Council
    "c8ngyyypekrt",
    # Newry City, Mourne and Down District Council
    "c4dw7jqzqypt",
    # Norfolk County Council
    "c404jjj3d5yt",
    # North Ayrshire Council
    "cg41llldnd5t",
    # North Devon Council
    "c9y4y7knreyt",
    # North Down and Ards District Council
    "cvny6w32mq6t",
    # North East Derbyshire District Council
    "cjl7l82dzg7t",
    # North East Lincolnshire Council
    "crnvv96lp03t",
    # North Hertfordshire District Council
    "ckxqq3xlp74t",
    # North Kesteven District Council
    "c7z7z4n3gk8t",
    # North Lanarkshire Council
    "cz4e333z1zrt",
    # North Lincolnshire Council
    "cry6yvpzwzkt",
    # North Norfolk District Council
    "c22k28qdnvyt",
    # North Northamptonshire Council
    "cezgg0yj533t",
    # North Somerset Council
    "ck2v26mxe9wt",
    # North Tyneside Council
    "c4dnne4zle0t",
    # North Warwickshire Borough Council
    "cvnxnwzlnqqt",
    # North West Leicestershire District Council
    "cewxw4nme26t",
    # North Yorkshire County Council
    "c50wnnnpeq1t",
    # Northamptonshire County Council
    "cqkwppp0yq3t",
    # Northern Ireland local elections 2019
    "c344vvedknjt",
    # Northumberland County Council
    "cdr8nnnw9n5t",
    # Norwich City Council
    "ce3eex3y392t",
    # Nottingham City Council
    "c34k46lw9g9t",
    # Nottinghamshire County Council
    "c8ngyyypemjt",
    # Nuneaton and Bedworth Borough Council
    "cve553dk6kzt",
    # Oadby and Wigston Borough Council
    "c7z7z4nre48t",
    # Oldham Council
    "cy633enlq04t",
    # Orkney Islands Council
    "c00eqqqgmg7t",
    # Oxford City Council
    "cdj55pjlj8xt",
    # Oxfordshire County Council
    "cp7r8881m57t",
    # Pembrokeshire County Council
    "cp7r8881mdrt",
    # Pendle Borough Council
    "cpz22ezdl54t",
    # Perth and Kinross Council
    "cnx9555101zt",
    # Peterborough City Council
    "cn2qqxvr0g9t",
    # Plymouth City Council
    "cve553257qdt",
    # Portsmouth City Council
    "cn2qqxvl07yt",
    # Powys Council
    "cmjr4449gzgt",
    # Preston City Council
    "c6lrr0l5lyet",
    # Purbeck District Council
    "clgl3qwe0krt",
    # Reading Borough Council
    "c8vee37kzlzt",
    # Redbridge London Borough Council
    "cj0qqjrr27lt",
    # Redcar and Cleveland Borough Council
    "cmdndlr84ndt",
    # Redditch Borough Council
    "cj0qqjrnrqvt",
    # Reigate and Banstead Borough Council
    "cqv997q7zn0t",
    # Renfrewshire Council
    "cyw9kkkzrzjt",
    # Rhondda Cynon Taf County Borough Council
    "cjn5rrrl38kt",
    # Ribble Valley Borough Council
    "cvnxnwzepzpt",
    # Richmond upon Thames London Borough Council
    "c7z55l0pdj3t",
    # Richmondshire District Council
    "cdg2gvzdv34t",
    # Rochdale Metropolitan Borough Council
    "cly00v8739vt",
    # Rochford District Council
    "cve553yngzxt",
    # Rossendale Borough Council
    "cdj55pj409pt",
    # Rother District Council
    "cxwrw8q4kmzt",
    # Rotherham Metropolitan Borough Council
    "ck2lmzpg5k7t",
    # Rugby Borough Council
    "c34vv96l8net",
    # Runnymede Borough Council
    "crnvv9g9pvxt",
    # Rushcliffe Borough Council
    "c9y4y7ke42jt",
    # Rushmoor Borough Council
    "c34vv942224t",
    # Rutland County Council
    "ck2v26m6lp4t",
    # Ryedale District Council
    "c8mvmykyv66t",
    # Salford City Council
    "cve553pv3vlt",
    # Sandwell Metropolitan Borough Council
    "cz866245rxyt",
    # Scarborough Borough Council
    "cdg2gvz299kt",
    # Scotland local elections 2017
    "cel8w94z1mpt",
    # Scottish Borders Council
    "c77gzzz1x1kt",
    # Scottish Parliament election 2021
    "cjgd9xk5r51t",
    # Sedgemoor District Council
    "cyq4q6j43d2t",
    # Sefton Metropolitan Borough Council
    "c34vv9dk92lt",
    # Selby District Council
    "cry6yvpkmznt",
    # Sevenoaks District Council
    "c8mvmyk7863t",
    # Sheffield City Council
    "cx3jj6v2d35t",
    # Shetland Islands Council
    "ckpr111434yt",
    # Shropshire Council
    "clmjwwwegwqt",
    # Slough Borough Council
    "c9njjl5qk35t",
    # Solihull Metropolitan Borough Council
    "cj0qqj37r46t",
    # Somerset County Council
    "cmjr4449g11t",
    # Somerset West and Taunton Council
    "clx3xjyz3rwt",
    # South Ayrshire Council
    "c30qmmmgrgnt",
    # South Bucks District Council
    "cvnxnw96kynt",
    # South Cambridgeshire District Council
    "c7z55l7yyent",
    # South Derbyshire District Council
    "cg8r8gwekeqt",
    # South Gloucestershire Council
    "cxwrw8p6l64t",
    # South Hams District Council
    "c8mvmyg3mwwt",
    # South Holland District Council
    "c7z7z4dnx74t",
    # South Kesteven District Council
    "c6eye23xj2jt",
    # South Lanarkshire Council
    "cdr8nnnwqwgt",
    # South Norfolk Council
    "cpzqzy44vndt",
    # South Oxfordshire District Council
    "cvnxnw9k77pt",
    # South Ribble Borough Council
    "cz8y8jzknlrt",
    # South Somerset District Council
    "cpzqzy4ppkqt",
    # South Staffordshire Council
    "ck2v264l227t",
    # South Tyneside Council
    "c34vv9djgryt",
    # Southampton City Council
    "crnvv96p6kvt",
    # Southend-on-Sea Borough Council
    "cve5532qrq0t",
    # Southwark London Borough Council
    "c6lrr0gvee6t",
    # Spelthorne Borough Council
    "cpzqzy4drwrt",
    # St Albans City & District Council
    "c2x66dxnqxnt",
    # St. Helens Metropolitan Borough Council
    "c8vee39vnl8t",
    # Stafford Borough Council
    "cyq4q6ney66t",
    # Staffordshire County Council
    "cjn5rrrl39rt",
    # Staffordshire Moorlands District Council
    "c34k46rvn2zt",
    # Stevenage Borough Council
    "c6lrr0lr4kzt",
    # Stirling Council
    "clmjwwwedent",
    # Stockport Metropolitan Borough Council
    "ckxqq36x39jt",
    # Stockton-on-Tees Borough Council
    "c34k46r8l3gt",
    # Stoke-on-Trent City Council
    "cg8r8gw93ext",
    # Stratford-on-Avon District Council
    "c8mvmygzrg4t",
    # Stroud District Council
    "cv50gdqnqpzt",
    # Suffolk County Council
    "cggzzdne1qyt",
    # Sunderland City Council
    "c0gjj40gen7t",
    # Surrey County Council
    "cg41llldyldt",
    # Surrey Heath Borough Council
    "c22k28pvx9mt",
    # Sutton London Borough Council
    "cn2qqx3380vt",
    # Swale Borough Council
    "c9y4y7grpg9t",
    # Swindon Borough Council
    "ckxqq320y55t",
    # Tameside Metropolitan Borough Council
    "cly00v8e4ypt",
    # Tamworth Borough Council
    "cpz22ez5nd9t",
    # Tandridge District Council
    "c0gjj4g66l7t",
    # Teignbridge District Council
    "cwgdgqwqy29t",
    # Telford and Wrekin Borough Council
    "c4dkdjevkk6t",
    # Tendring District Council
    "c4dkdjex99et",
    # Test Valley Borough Council
    "c34k46r24jqt",
    # Tewkesbury Borough Council
    "cg8r8g2ej68t",
    # Thanet District Council
    "c4dkdjm26rdt",
    # The UK’s European Elections 2019
    "cmwg67l8r7jt",
    # Three Rivers District Council
    "c6lrr0lx624t",
    # Thurrock Council
    "c8vee3762prt",
    # Tonbridge and Malling Borough Council
    "cvnxnwkg8xlt",
    # Torbay Council
    "cxwrw8kq3yqt",
    # Torfaen County Borough Council
    "cg41llldyr5t",
    # Torridge District Council
    "cnrgr27vqqnt",
    # Tower Hamlets London Borough Council
    "cg833y5x636t",
    # Trafford Metropolitan Borough Council
    "cz8662449j4t",
    # Tunbridge Wells Borough Council
    "ckxqq3xqz92t",
    # Uttlesford District Council
    "cjl7l8z44w8t",
    # Vale of Glamorgan Council
    "cz4e333zqkrt",
    # Vale of White Horse District Council
    "cjl7l8z4p8zt",
    # Wakefield Metropolitan District Council
    "ckxqq366z6jt",
    # Wales local elections 2017
    "crnv5k9z73vt",
    # Walsall Metropolitan Borough Council
    "c4dnne444x5t",
    # Waltham Forest London Borough Council
    "cn2qqx3kg4yt",
    # Wandsworth London Borough Council
    "cz8662p4e6zt",
    # Warrington Borough Council
    "cjrpk3n19xet",
    # Warwick District Council
    "c7z7z4vv43rt",
    # Warwickshire County Council
    "cz4e333zq30t",
    # Watford Borough Council
    "c8vee3vpzgzt",
    # Waverley Borough Council
    "ck2v26jlw44t",
    # Wealden District Council
    "cnrgr27d7nqt",
    # Welsh Parliament election 2021
    "cezg9pkykeet",
    # Welwyn Hatfield Borough Council
    "cly00vyg5q5t",
    # West + && || Suffolk (Council)
    "c4dkdjmz7krt",
    # West Berkshire Council
    "clx3xjmwywkt",
    # West Devon Borough Council
    "cmdndlyqn7qt",
    # West Dunbartonshire Council
    "c93g777z4zyt",
    # West Lancashire Borough Council
    "ce3eex3jqzxt",
    # West Lindsey District Council
    "cpzqzymer6dt",
    # West Northamptonshire Council
    "cv0kk5pwr0zt",
    # West Oxfordshire District Council
    "cg833y8v30jt",
    # West Sussex County Council
    "c00eqqqgyq8t",
    # Wigan Metropolitan Borough Council
    "c6lrr0z9y04t",
    # Wiltshire Council
    "c93g777zr7xt",
    # Winchester City Council
    "c8vee3gl24et",
    # Windsor and Maidenhead Borough Council
    "c22k289zwjmt",
    # Wirral Metropolitan Borough Council
    "c2x66dy03nqt",
    # Woking Borough Council
    "crnvv9grxd2t",
    # Wokingham Borough Council
    "cpz22e5v45jt",
    # Wolverhampton City Council
    "crnvv9de287t",
    # Worcester City Council
    "c4dnne8lnx6t",
    # Worcestershire County Council
    "cnx95551m5rt",
    # Worthing Borough Council
    "cy633ez2kn8t",
    # Wrexham County Borough Council
    "c00eqqqgyr7t",
    # Wychavon District Council
    "cxwrw8k2xlkt",
    # Wycombe District Council
    "c4dkdjmlyjgt",
    # Wyre Council
    "c7z7z4v48p9t",
    # Wyre Forest District Council
    "cve553d5d00t",
    # York City Council
    "cpzqzymvq8gt"
  ]

  @live_ids [
    #### Currency Topics

    # Euro (EUR)
    "ce2gz75e8g0t",
    # Japanese Yen (JPY)
    "cleld6gp05et",
    # Pound Sterling (GBP)
    "cx250jmk4e7t",
    # US Dollar (USD)
    "cljevy2yz5lt",

    #### Commodity Topics

    # Gold
    "cwjzj55q2p3t",
    # Natural gas
    "cxwdwz5d8gxt",
    # Oil
    "cmjpj223708t",

    #### Business Topics

    # 3i Group
    "c2rnyqdrvqnt",
    # 3i Infrastructure
    "cwz4l8xj794t",
    # A.G. Barr
    "cgv6l44yrnjt",
    # AA
    "c2rnyvlkrwlt",
    # Aberforth Smaller Companies Trust
    "crem2vvvd6vt",
    # abrdn
    "cp7dmw7pppdt",
    # Acacia Mining
    "c5y4p555e6qt",
    # Activision Blizzard
    "cwz4ldqgy28t",
    # Admiral Group
    "cj5pd62kpe6t",
    # AEX
    "clyeyy6q0g4t",
    # Aggreko
    "c2rnyvvjjygt",
    # Aldermore
    "czv6reejxqqt",
    # Alibaba
    "ce1qrvlelqqt",
    # Alliance Trust
    "c779e88zj2nt",
    # Alphabet
    "c50znx8v421t",
    # Amazon
    "c50znx8v8y4t",
    # AMD
    "c91242yylkzt",
    # American Airlines
    "cj5pd6v524kt",
    # Anglo American
    "cp7dm4zwg9vt",
    # Antofagasta
    "cxw7q5vrrkwt",
    # Apple
    "crr7mlg0gqqt",
    # Ascential
    "czv6reey8l5t",
    # Ashmore Group
    "cl86mjjp7xxt",
    # Ashtead Group
    "cm6pmejyklvt",
    # Asos
    "cj1xj07qx9et",
    # Associated British Foods
    "c207p54m4lnt",
    # Assura
    "c46zqddr25et",
    # Aston Martin
    "cev9zn0ggzpt",
    # AstraZeneca
    "cz4pr2gd52lt",
    # AT&T
    "c2q3k34gnw1t",
    # Auto Trader Group
    "cgv6l889m9et",
    # Aveva
    "crem2vvjkelt",
    # Aviva
    "cdl8n2edxj7t",
    # B&M European Value
    "cny6mmxwgwgt",
    # Babcock International
    "cdz5gv7pwjkt",
    # BAE Systems
    "c302m85q57zt",
    # Balfour Beatty
    "c9edzmmyplkt",
    # Bank of America
    "cp7dm484262t",
    # Bank of Georgia
    "czv6rrldgw8t",
    # Bankers Investment Trust
    "c46zqeenew5t",
    # Barclays
    "c302m85q170t",
    # Barratt Developments
    "cj5pd62qyvkt",
    # BBA Aviation
    "c46zqeqy52et",
    # Beazley Group
    "cj5pdndw4kdt",
    # Bellway
    "ckr6ddkvljmt",
    # Berkeley Group Holdings
    "cgv6llkxlm2t",
    # Berkshire Hathaway Inc.
    "cewrlqz7xygt",
    # Big Yellow Group
    "cewrllqxln2t",
    # Blackberry
    "c008ql15ddgt",
    # Bloomsbury Publishing
    "cqx75jx9955t",
    # Bodycote
    "czv6rr8ljmyt",
    # Boeing
    "c40rjmqd0pgt",
    # Boohoo
    "cj2700dj78kt",
    # Booker Group
    "c779ee665mwt",
    # BP
    "cp7r8vgl27rt",
    # Brewin Dolphin
    "cj5pdd6e24et",
    # British American Tobacco
    "c9edzkvlp2gt",
    # British Empire Trust
    "cl86mm2e94dt",
    # British Land
    "cwz4ld6vzn2t",
    # Britvic
    "ckr6dd4lm65t",
    # BSE Sensex
    "cpglgg6zyd0t",
    # BT Group
    "cwlw3xz0zwet",
    # BTG
    "c779ee6r7yxt",
    # Bunzl
    "czv6r8qrrrwt",
    # Burberry Group
    "cywd23g0g10t",
    # CAC 40
    "cwjzjjz559yt",
    # Cairn Energy
    "cgv6ll59d9wt",
    # Caledonia Investments
    "c6mk228z8xlt",
    # Capita
    "cm6pmmerd28t",
    # Capital & Counties Properties
    "cgv6ll57nmyt",
    # Card Factory
    "c46zqq524e4t",
    # Carnival Corporation
    "cj5pd678m8rt",
    # Centamin
    "ckr6dd46d54t",
    # Centrica
    "c302m85q0w3t",
    # Cineworld
    "c5y4pp57rpyt",
    # Citigroup
    "cwlw3xz0zqet",
    # City of London Investment Trust
    "cj5pddewkwmt",
    # Clarkson
    "cewrll5xjnjt",
    # Close Brothers Group
    "cl86mmjl62mt",
    # CLS Holdings
    "crem22v5ggpt",
    # Coats Group
    "cl86mmjpnqpt",
    # Cobham
    "cewrll5nz94t",
    # Coca-Cola
    "cz4pr2gd5w0t",
    # Coca-Cola HBC AG
    "cm6pmev6zmnt",
    # Compass Group
    "czv6r8gdy58t",
    # Computacenter
    "crem22vmy99t",
    # ConvaTec
    "czv6r86xgqyt",
    # Countryside Properties
    "c9edzzm72xjt",
    # Cranswick
    "cvl7nnr8zdkt",
    # Crest Nicholson
    "crem22v7742t",
    # CRH
    "c5y4pr4me8wt",
    # Croda International
    "cewrlqr7eylt",
    # Currys
    "c1038wnxnp7t",
    # CYBG
    "cq2655n5jwvt",
    # Dairy Crest
    "cxw7qqrw8rlt",
    # DAX
    "ckwlwwg6507t",
    # DCC
    "c8254y52gwwt",
    # Dechra Pharmaceuticals
    "ckr6dd2kq9nt",
    # Delta Airlines
    "cwz4ldqpjp8t",
    # Derwent London
    "c46zqql55r4t",
    # Diageo
    "cywd23g04net",
    # Dignity
    "c6mk22wr96kt",
    # Diploma
    "cwz4ll584r4t",
    # Direct Line Group
    "c2rnyqnqvv8t",
    # Disney
    "c40rjmqdw2vt",
    # Domino's Pizza Group
    "crem22w5kz5t",
    # Dow Jones Industrial Average
    "clyeyy8851qt",
    # Drax Group
    "crem22wl58zt",
    # DS Smith
    "c6y3erpprq9t",
    # Dunelm Group
    "c6mk22wymldt",
    # Easyjet
    "c302m85q52jt",
    # eBay
    "c1038wnxnmpt",
    # Edinburgh Investment Trust
    "cewrllvp26xt",
    # Electra Private Equity
    "cdz5ggnw7xdt",
    # Electrocomponents
    "cq26554x797t",
    # Electronic Arts
    "czv6r8m2d49t",
    # Elementis
    "c9edzzqxmkwt",
    # Entain
    "cnegp95g5g8t",
    # Entertainment One
    "c9edzzqxjmet",
    # Essentra
    "cvl7nndm2v7t",
    # Esure
    "czv6rr2gzket",
    # Euromoney Institutional Investor
    "crem22wmw9dt",
    # EuroStoxx 50
    "clyeyy6464qt",
    # Evraz
    "cp7dmmlnvrmt",
    # Experian
    "cvl7nq7wmq8t",
    # Exxon Mobil
    "cx1m7zg0g0lt",
    # F&C Commercial Property Trust
    "cyn9ww8w6gvt",
    # Facebook
    "cmj34zmwxjlt",
    # FDM Group
    "c2rnyyjmww6t",
    # Ferguson
    "cxw7q57v2vkt",
    # Ferrexpo
    "cm6pmmxdnw2t",
    # Fidelity China Special Situations
    "cvl7nn4ypz7t",
    # Fidelity European Values
    "c46zqqj4ypwt",
    # Fidessa
    "ckr6ddmn7p6t",
    # Finsbury Growth & Income Trust
    "crem22ydmkvt",
    # FirstGroup
    "cyn9wwxgewlt",
    # Flutter Entertainment
    "c779e6gmpzrt",
    # Flybe
    "cewrlqm4wz5t",
    # Ford
    "cz4pr2gdgyyt",
    # Frasers Group
    "c23p6mx67v8t",
    # French Connection Group
    "cdl70lgvlp1t",
    # Fresnillo
    "cl86m26w75pt",
    # FTSE 100
    "c9qdqqkgz27t",
    # FTSE 250
    "cjl3llgk4k2t",
    # G4S
    "cwz4ld4el2jt",
    # Galliford Try
    "c48yr0yx42nt",
    # GameStop
    "cyzp91yk1ydt",
    # Gap
    "cgdzn8v44jlt",
    # GCP Infrastructure Investments
    "c5elzyl58xjt",
    # GDF Suez
    "cvv4m4mqkymt",
    # General Electric
    "c1038wnxezrt",
    # General Motors
    "cx1m7zg0g55t",
    # Genesis Emerging Markets Fund
    "c5elzyl8ze7t",
    # Genus
    "cp3mv9mvm2jt",
    # GKN
    "cm6pmepplmzt",
    # GlaxoSmithKline
    "cjnwl8q4qvjt",
    # Glencore
    "c50znx8v8z4t",
    # Go-Ahead Group
    "cnegp9gn1zdt",
    # Goldman Sachs
    "cx1m7zg0g3nt",
    # Grafton Group
    "c48yr0xgprjt",
    # Grainger
    "cljev9p0r1mt",
    # Great Portland Estates
    "cljev9pn8zrt",
    # Greencoat UK Wind
    "cdnpj79g404t",
    # Greencore
    "c340rzx790jt",
    # Greene King
    "c8z0l18e9pet",
    # Greggs
    "cljev9przz1t",
    # Groupon
    "cg41ylwvwqgt",
    # Halfords
    "cr07g9zzvn9t",
    # Halma
    "c2gze4pm7k4t",
    # Hammerson
    "c9edzkd6qket",
    # Hang Seng
    "cq75774n157t",
    # Hansteen Holdings
    "cljev9pz5g4t",
    # Hargreaves Lansdown
    "cp7dm4dx4lnt",
    # Hastings Insurance
    "cnegp95yp05t",
    # Hays
    "cljev9d3nylt",
    # HICL Infrastructure Company
    "cm8m14z754et",
    # Hikma Pharmaceuticals
    "c340rzp8p08t",
    # Hill & Smith
    "ce2gzrp3gxrt",
    # Hiscox
    "c48yr0p2z08t",
    # Hochschild Mining
    "ce2gzrplynvt",
    # Homeserve
    "ckgj7945n97t",
    # Howdens Joinery
    "cg5rv92ljgxt",
    # HP Inc
    "cj5pd6m8zxxt",
    # HSBC
    "cdl8n2eden0t",
    # Hunting
    "c734jd19gvkt",
    # IAG
    "c77jz3mdmy3t",
    # IBEX 35
    "c34l44l8d48t",
    # IBM
    "c77jz3mdqwpt",
    # Ibstock
    "czzn8le8899t",
    # IG Group
    "c7d65kqy9j3t",
    # IGas Energy
    "crem2z8xexnt",
    # IMI
    "cpd6nj4x2get",
    # Imperial Brands
    "cgv6l542p65t",
    # Inchcape
    "cyg1q3xl7n4t",
    # Indivior
    "c8l6dp595lxt",
    # Informa
    "cxw7q5nn5rxt",
    # Inmarsat
    "ceq4ej1yxnnt",
    # Intel
    "cj5pd6gqk4kt",
    # InterContinental Hotels Group
    "cp7dm4nmm5kt",
    # Intermediate Capital Group
    "cpd6nj5yq42t",
    # International Public Partnerships
    "cxqe2z8rg7gt",
    # Interserve 
    "cwjdyzqwqqwt",
    # Intertek
    "cwz4ldl72yxt",
    # Intu Properties
    "cm1ygzmd3rqt",
    # Investec
    "ceq4ej1lpn6t",
    # IP Group
    "ceq4ej122qet",
    # ITV
    "c008ql151q8t",
    # IWG
    "czzn8lxng89t",
    # James Fisher & Sons
    "cvl7nn4qpzqt",
    # Jardine Lloyd Thompson
    "c28gld9nyzqt",
    # JD Sports
    "cpd6nj989nmt",
    # Jet Airways
    "cwwwewx7rrwt",
    # John Laing Group
    "c7d65k4dr79t",
    # John Laing Infrastructure Fund
    "cd67elljy34t",
    # Johnson & Johnson
    "c7zl7v00x15t",
    # Johnson Matthey
    "cxw7q5qmw24t",
    # JP Morgan
    "cjnwl8q4nr3t",
    # JPI Media
    "c2rnyqkew57t",
    # JPMorgan American Investment Trust
    "cql8qmmeq4zt",
    # JPMorgan Emerging Markets Investment Trust
    "c6y3ekjkqnmt",
    # JPMorgan Indian Investment Trust
    "c9jx2pd38x1t",
    # Jumia
    "cpzz7xmjgvwt",
    # Jupiter Fund Management
    "cyg1q3m48pkt",
    # Just Eat Takeaway
    "czzn8l7l79rt",
    # Just Group
    "crjy47ndqymt",
    # KAZ Minerals
    "cql8qm2dkl5t",
    # Kellogg Company
    "cq04218m929t",
    # Kennedy-Wilson Holdings
    "cql8qm223z2t",
    # Kier Group
    "c1nxedyylz1t",
    # Kingfisher
    "c40rjmqd0ggt",
    # Ladbrokes Coral
    "c8l6dpnqy7yt",
    # Lancashire Holdings
    "cxqe2zjerlxt",
    # Land Securities
    "cp7dm4my2wqt",
    # Lastminute.com
    "cjqx35j92pet",
    # Legal & General
    "c9edzkzwx2xt",
    # Lloyds Banking Group
    "c40rjmqdww3t",
    # London Stock Exchange Group
    "ce7l82zl978t",
    # LondonMetric Property
    "ck832qn4q93t",
    # Lyft
    "c10094dkqkrt",
    # Man Group
    "c5x2p4ke9lxt",
    # Marks & Spencer
    "cywd23g0ggxt",
    # Marshalls
    "c416ndyn2xdt",
    # Marston's Brewery
    "c8l6dpkpe99t",
    # McCarthy & Stone
    "ck832q6yn26t",
    # McDonald's
    "cywd23g04g4t",
    # Mediclinic International
    "crem2z2m5wqt",
    # Meggitt
    "c7d65k8m5kxt",
    # Melrose Industries
    "c6y3ekxnyd6t",
    # Mercantile Investment Trust
    "cle48g4j4zxt",
    # Merlin Entertainments
    "czv6r8rnl9jt",
    # Metro Bank (United Kingdom)
    "cgzj67jnynkt",
    # Micro Focus
    "c6mk2822l94t",
    # Microsoft
    "cvenzmgyg0lt",
    # Millennium & Copthorne Hotels
    "c348jd8984rt",
    # Mitchells & Butlers
    "c5x2p421yj3t",
    # Mitie
    "cgzj67jx17et",
    # Moderna
    "c8grzynv1mgt",
    # Mondi
    "cvl7nqn9pr2t",
    # Moneysupermarket.com
    "c5x2p42knryt",
    # Monks Investment Trust
    "c5x2p428gnkt",
    # Morgan Advanced Materials
    "c5x2p428re7t",
    # Morgan Stanley
    "cp7r8vglgljt",
    # Morrisons
    "c207p54m4det",
    # Mothercare
    "c0n69181n53t",
    # Mulberry
    "czlm1nzpzlvt",
    # Murray International Trust
    "c5x2p42qr1mt",
    # N Brown Group
    "cq2655lgldnt",
    # NASDAQ
    "c08k88ey6d5t",
    # National Express
    "cpd6nj666zkt",
    # National Grid
    "cywd23g04jlt",
    # NatWest Group
    "cdvdx4l9y4xt",
    # Netflix
    "crr7mlg0v1lt",
    # NewRiver
    "cxqe2zpqdl5t",
    # NEX Group
    "ceq4ejpkjr7t",
    # Next
    "c008ql151lwt",
    # Nike, Inc.
    "czv6r8w2vqqt",
    # Nikkei 225
    "c55p555ng9gt",
    # NMC Health
    "cyg1q3e632zt",
    # Northgate
    "c6y3ekn87zqt",
    # Nostrum Oil & Gas
    "c28gldjmjq1t",
    # Nvidia
    "cewrlqz847yt",
    # Ocado
    "c302m85q5xjt",
    # Old Mutual
    "c779e6gjd6zt",
    # OneSavings Bank
    "c1nxedl1j77t",
    # P2P Global Investments
    "c6y3eknjy61t",
    # PageGroup
    "cql8qmp2expt",
    # Paragon Banking Group
    "cle48gxn6ynt",
    # Parkmead Group
    "czv6r8mnjq8t",
    # Patisserie Valerie
    "crd7jvq987kt",
    # PayPal
    "c50znx8v8j4t",
    # PayPoint
    "c7d65kz8285t",
    # Pearson
    "cl86m2gm2w8t",
    # Pennon Group
    "crjy47py3g2t",
    # PepsiCo
    "ckr6d48pk46t",
    # Perpetual Income & Growth Investment Trust
    "crjy47lg55gt",
    # Pershing Square Holdings
    "c6y3ekl2323t",
    # Persimmon
    "c6mk28n8x6kt",
    # Personal Assets Trust
    "c8l6dp4lym1t",
    # Petra Diamonds
    "c8l6dp42444t",
    # Petrobras
    "cl86m2y7px6t",
    # Petrofac
    "c28gld3zeg2t",
    # Pets at Home
    "cpd6njnmzmjt",
    # Pfizer
    "cq23pdgvglxt",
    # Phoenix Group
    "c348jdx1pq9t",
    # Playtech
    "c416ndm1r9qt",
    # Polar Capital Technology Trust
    "c28gld42313t",
    # Polymetal International
    "cql8qmr9pret",
    # Polypipe
    "c7d65kyk9yrt",
    # Procter & Gamble
    "cywd23g041et",
    # Provident Financial
    "c8254yp6lwdt",
    # Prudential
    "c8nq32jwjg0t",
    # PZ Cussons
    "cxqe2z6mx3jt",
    # Qinetiq
    "c7d65kym7jkt",
    # Randgold Resources
    "c779e6kl2y5t",
    # Rathbone Brothers
    "c5x2p1z8x4lt",
    # Reach PLC
    "c514vpxv5llt",
    # Reckitt Benckiser
    "cewrlqj4gnzt",
    # Redefine International
    "cjnr2yxl7znt",
    # Redrow
    "cm1ygplykydt",
    # RELX Group
    "cvl7nqzxe69t",
    # Renewables Infrastructure Group
    "c7d651zyy1xt",
    # Renishaw
    "c6y3e1l946lt",
    # Rentokil Initial
    "czv6r87zrd2t",
    # Restaurant Group
    "c416n3gddg8t",
    # Rightmove
    "c6y3erj1m4pt",
    # Rio Tinto
    "crr7mlg0gr3t",
    # RIT Capital Partners
    "c7d65xmmr36t",
    # Riverstone Energy
    "c8l6d37nld6t",
    # Rolls-Royce Holdings
    "ce1qrvlex71t",
    # Rotork
    "c9jx2g48ngdt",
    # Royal Bank of Scotland
    "c302m85q5m3t",
    # Royal Dutch Shell
    "c8nq32jwnelt",
    # Royal Mail
    "cp7r8vglgwjt",
    # RPC Group
    "cd67er3xjmdt",
    # RSA Insurance Group
    "c9edzm29jmpt",
    # Ryanair
    "cvenzmgygg7t",
    # S&P 500
    "c4dldd02yp3t",
    # Safestore
    "c28glx6rl3kt",
    # Saga
    "crem2z954ndt",
    # Sage Group
    "cp7dmwr82vnt",
    # Sainsbury's
    "ce1qrvlexr1t",
    # Sanne Group
    "c348jzqj411t",
    # Santander Group
    "cdl8n2ededdt",
    # Savills
    "c6y3erj582qt",
    # Schroders
    "c825469m8pet",
    # Scottish Investment Trust
    "crjy4rer173t",
    # Scottish Mortgage Investment Trust
    "cny6mld4y2xt",
    # Segro
    "cq265n8m8qqt",
    # Senior
    "ck832pnxd18t",
    # Serco
    "cyg1qpmgp5kt",
    # Severn Trent
    "ce1qrvlel2qt",
    # Shaftesbury
    "cyg1qpmrqg1t",
    # Shire (pharmaceutical company)
    "cxw7q6m6wxrt",
    # SIG
    "c9jx2gd4rrkt",
    # Sirius Minerals
    "c8l6d3n7elxt",
    # Sky
    "cp7r8vgl7pzt",
    # Smith & Nephew
    "c82546rw58gt",
    # Smiths Group
    "cgv6l8v27myt",
    # Smurfit Kappa Group
    "cxw7q6wwpy8t",
    # Softcat
    "c7d65x9j4m7t",
    # Sophos
    "crjy4rnrgyxt",
    # Spectris
    "czzn89798d5t",
    # Spirax-Sarco Engineering
    "cm1yg8d9yg3t",
    # Spire Healthcare
    "cle482yzymrt",
    # SSE
    "c8nq32jwjqnt",
    # SSE Composite
    "cq757713q97t",
    # SSP Group
    "c416n381d13t",
    # St. James's Place
    "ckr6dxrqll7t",
    # St. Modwen Properties
    "c5x2p78ndqgt",
    # Stagecoach
    "c9edzkwe7xrt",
    # Standard Chartered
    "c207p54m485t",
    # Starbucks
    "cq265ly55e9t",
    # Stobart Group
    "cgzj6dm3gj7t",
    # Superdry
    "c348jz2lex6t",
    # Syncona
    "cpd6nx35xpdt",
    # Synthomer
    "cjnr2z5m4rjt",
    # TalkTalk Group
    "cjnr2zl1x6nt",
    # Tate & Lyle
    "c1nxez79n95t",
    # Taylor Wimpey
    "cewrl5w94e9t",
    # TBC Bank
    "cle482myknet",
    # Ted Baker
    "c6y3erggy4et",
    # Telecom Plus
    "c28glxrr4qnt",
    # Temple Bar Investment Trust
    "c8l6d3q4jrrt",
    # Templeton Emerging Markets Investment Trust
    "cm1yg87ggzyt",
    # Tesco
    "c77jz3mdmlvt",
    # Tesla
    "c8nq32jwjnmt",
    # The Rank Group
    "cle481xnlndt",
    # The Royal Bank of Scotland Group
    "czv6rev6mz7t",
    # Thomas Cook Group
    "c416n3k3156t",
    # TP ICAP
    "c6y3er39zlxt",
    # TR Property Investment Trust
    "cql8rjkmkq9t",
    # Travis Perkins
    "cle4824zl78t",
    # Tritax Big Box REIT
    "c416mkqj681t",
    # TUI Group
    "cj5pde5nvd9t",
    # Tullow Oil
    "c9jx7qxqy36t",
    # Twitter
    "cmj34zmwx51t",
    # UBM
    "ck835j332p2t",
    # UDG Healthcare
    "cql8rj8ppj8t",
    # UK Commercial Property Trust
    "cjnr4lxend1t",
    # Ultra Electronics
    "cm1yx7l98g6t",
    # Unilever
    "c40rjmqdqvlt",
    # Unite Students
    "crjy5mp1l9kt",
    # United Airlines
    "c6mk28llrk7t",
    # United Utilities
    "crr7mlg0gdnt",
    # Vectura Group
    "c5x2rqzxdjpt",
    # Vedanta Resources
    "czzng315j56t",
    # Vesuvius
    "c7d6y2z7rgdt",
    # Victrex
    "cql8rjpm187t",
    # Vietnam Enterprise Investments
    "c9jx7q942xxt",
    # Vodafone
    "crr7mlg0vg2t",
    # Walmart
    "ce1qrvlex0et",
    # Weir Group
    "c6mk28y4dw7t",
    # Wetherspoons
    "c11le1xvm4yt",
    # WH Smith
    "ce8jr869nwkt",
    # Whitbread
    "cl86mjkkgn6t",
    # William Hill (bookmaker)
    "c704e0kj142t",
    # Witan Investment Trust
    "cy5m75wwmvwt",
    # Wizz Air
    "cmleylw141et",
    # Wood Group
    "cewrlqm8ylet",
    # Woodford Patient Capital Trust
    "c11le1kp83mt",
    # Workspace Group
    "ckm4xm64551t",
    # WorldPay
    "c82546dy7rwt",
    # Worldwide Healthcare Trust
    "c5ewlerdr0kt",
    # WPP
    "cewrlqp59x7t",
    # ZPG
    "cle46m8d471t",
    # Zynga
    "c025k7k4ex2t",

    #### Politics Topics

    # Aberdeen City Council
    "c77jz3mdq8pt",
    # Aberdeenshire Council
    "c207p54mljpt",
    # Adur District Council
    "c6z8969d13mt",
    # Allerdale Borough Council
    "c0gkgvm4pwgt",
    # Amber Valley Borough Council
    "cmex9yrk2v8t",
    # Angus Council
    "crr7mlg0v3lt",
    # Antrim and Newtownabbey Borough Council
    "c4l3n2y73wkt",
    # Ards and North Down Borough Council
    "cqykv0xmkwdt",
    # Argyll and Bute Council
    "cvenzmgyl7rt",
    # Armagh City, Banbridge and Craigavon Borough Council
    "c347gew58gdt",
    # Arun District Council
    "c0gkw73yz0yt",
    # Ashfield District Council
    "cx3xvw0xmymt",
    # Ashford Borough Council
    "c9041ge8k12t",
    # Aylesbury Vale District Council
    "cmlw7p1lpxnt",
    # Babergh District Council
    "ckde2v0zg8dt",
    # Barking and Dagenham London Borough Council
    "c34mxdk2k15t",
    # Barnet London Borough Council
    "c95egxx8738t",
    # Barnsley Metropolitan Borough Council
    "cn1r2w32629t",
    # Barrow Borough Council
    "czm0p3lym40t",
    # Basildon Borough Council
    "c7ry2vg44ykt",
    # Basingstoke and Deane Borough Council
    "c1v20y4k60pt",
    # Bassetlaw District Council
    "c34kqd05n0mt",
    # Bath and North East Somerset Council
    "cqymne3d9k9t",
    # Bedford Borough Council
    "c9041g3w3vmt",
    # Belfast City Council
    "c18230em1n1t",
    # Bexley London Borough Council
    "c2n5vwne8z1t",
    # Birmingham City Council
    "cpr6g35nne1t",
    # Blaby District Council
    "cyq4zglxnknt",
    # Blackburn with Darwen Borough Council
    "cmex9y5r55pt",
    # Blackpool Council
    "c18k74v979zt",
    # Blaenau Gwent Council
    "c40rjmqdwxmt",
    # Bolsover District Council
    "c4lkmd5pwdqt",
    # Bolton Metropolitan Borough Council
    "c82wmn8nz2dt",
    # Borough Council of King's Lynn and West Norfolk
    "cmlw7pwzvl3t",
    # Borough Council of Wellingborough
    "c34kq9gk22xt",
    # Boston Borough Council
    "ckde2v04z2wt",
    # Bournemouth, Christchurch and Poole Council
    "crx6dnl749jt",
    # Bracknell Forest Borough Council
    "c7z584wxzzlt",
    # Braintree District Council
    "cpzqm870wmxt",
    # Breckland Council
    "cgmxywg0pd9t",
    # Brent London Borough Council
    "cewngrr5rmkt",
    # Brentwood Borough Council
    "cyd02r0dg8rt",
    # Bridgend County Borough Council
    "c50znx8v4gpt",
    # Brighton and Hove City Council
    "cmlw7pe3wgmt",
    # Bristol City Council
    "cez4j3p4ynet",
    # Broadland District Council
    "c18k74v5m20t",
    # Bromley London Borough Council
    "cwypr193rx1t",
    # Bromsgrove District Council
    "c9041g3n8kyt",
    # Broxbourne Borough Council
    "c4e713mgrn3t",
    # Broxtowe Borough Council
    "cw7lxedy4g0t",
    # Buckinghamshire Council
    "c8l541jm9pnt",
    # Buckinghamshire County Council
    "c008ql15d3jt",
    # Burnley Borough Council
    "cv8k1pz74mmt",
    # Bury Metropolitan Borough Council
    "c2n5vw38z7vt",
    # Caerphilly County Borough Council
    "cq23pdgvrzmt",
    # Calderdale Council
    "c7ry2vg4374t",
    # Cambridge City Council
    "ckn41n142d2t",
    # Cambridgeshire County Council
    "cnx753jend8t",
    # Camden London Borough Council
    "ckn41g829e2t",
    # Cannock Chase Council
    "cr5pden698pt",
    # Canterbury City Council
    "czm0p3kq544t",
    # Cardiff Council
    "c8nq32jw8xet",
    # Carlisle City Council
    "c82wm2mxrpzt",
    # Carmarthenshire County Council
    "cp7r8vgl2qlt",
    # Castle Point Borough Council
    "cz3nmp588gnt",
    # Causeway Coast and Glens Borough Council
    "c7zn73e1le3t",
    # Central Bedfordshire Council
    "cvw1ledev3vt",
    # Ceredigion County Council
    "cmj34zmwxq3t",
    # Charnwood Borough Council
    "ce31zxg8xy4t",
    # Chelmsford City Council
    "ce31zxg8wx0t",
    # Cheltenham Borough Council
    "c6z89r5y0wdt",
    # Cherwell District Council
    "ckn41dx7dprt",
    # Cheshire East Council
    "cpzqm835vl5t",
    # Cheshire West and Chester Council
    "c7z584klwn4t",
    # Chesterfield Borough Council
    "cx3xvwk47w4t",
    # Chichester District Council
    "ckde2v5lk2kt",
    # Chiltern District Council
    "c7z584kg133t",
    # Chorley Borough Council
    "c2n5vx19e7rt",
    # City and County of Swansea Council
    "cywd23g04eqt",
    # City of Bradford Metropolitan District Council
    "c2n5vw3n26nt",
    # City of Edinburgh Council
    "c50znx8v4d5t",
    # City of Lincoln Council
    "cxwp925nzm2t",
    # Clackmannanshire Council
    "cywd23g04vlt",
    # Colchester Borough Council
    "c4e713y1wxvt",
    # Comhairle nan Eilean Siar
    "cz4pr2gd5y8t",
    # Conwy County Borough Council
    "cjnwl8q4xm5t",
    # Copeland Borough Council
    "ce31zxge2vlt",
    # Cornwall Council
    "c207p54mlnzt",
    # Cotswold District Council
    "cqymneqxp4wt",
    # Coventry City Council
    "ckn41gy8p59t",
    # Craven District Council
    "cv8k1pznxw7t",
    # Crawley Borough Council
    "c51gr0r9r6nt",
    # Croydon London Borough Council
    "cr5pd6e1knkt",
    # Cumbria County Council
    "c302m85q1rdt",
    # Dacorum Borough Council
    "c5xyn34w1k8t",
    # Darlington Borough Council
    "cw7lxe13x82t",
    # Dartford Borough Council
    "cpzqm83qglmt",
    # Daventry District Council
    "c06zdv5x905t",
    # Denbighshire County Council
    "cx1m7zg0wdvt",
    # Derby City Council
    "c1v20ym0z2dt",
    # Derbyshire County Council
    "c77jz3mdqnyt",
    # Derbyshire Dales District Council
    "c9041gz41w7t",
    # Derry City and Strabane District Council
    "cgmk73e4ey7t",
    # Devon County Council
    "c207p54ml2zt",
    # Doncaster Metropolitan Borough Council
    "c1038wnxeq1t",
    # Dorset Council
    "czrx0741qxjt",
    # Dorset County Council
    "crr7mlg0v4et",
    # Dover District Council
    "c2dk3qzwm2vt",
    # Dudley Metropolitan Borough Council
    "c2n5vw3e1nkt",
    # Dumfries and Galloway Council
    "cdl8n2edxp7t",
    # Dundee City Council
    "ce1qrvlexpet",
    # Durham County Council
    "crr7mlg0vqet",
    # Ealing London Borough Council
    "cz3nmp4xwgdt",
    # East Ayrshire Council
    "clm1wxp5n81t",
    # East Cambridgeshire District Council
    "c2dk3qz35kgt",
    # East Devon District Council
    "cvw1ledp44lt",
    # East Dunbartonshire Council
    "c1038wnxe2rt",
    # East Hampshire District Council
    "c9041gzyzzpt",
    # East Hertfordshire District Council
    "cyq4zgkyn1qt",
    # East Lindsey District Council
    "cnx73lwyw88t",
    # East Lothian Council
    "cwlw3xz012rt",
    # East Northamptonshire Council
    "cjjdnen12lrt",
    # East Renfrewshire Council
    "c40rjmqdwyvt",
    # East Riding of Yorkshire Council
    "c5xyn3w9l3pt",
    # East Staffordshire Borough Council
    "ckde2vgm0x5t",
    # East Suffolk Council
    "czrx0743vknt",
    # East Sussex County Council
    "cvenzmgylqdt",
    # Eastbourne Borough Council
    "czm0p3n381kt",
    # Eastleigh Borough Council
    "c6z896g4m00t",
    # Eden District Council
    "cqymne08vnnt",
    # Elmbridge Borough Council
    "cwypr1rx82yt",
    # Enfield London Borough Council
    "c51gr01kx32t",
    # England local elections 2017
    "cmj34zmwx1lt",
    # England local elections 2018
    "cz3nmp2eyxgt",
    # England local elections 2019
    "ceeqy0e9894t",
    # England local elections 2021
    "c481drqqzv7t",
    # Epping Forest District Council
    "c82wmnz23eet",
    # Epsom and Ewell Borough Council
    "czm0p3n804lt",
    # Erewash Borough Council
    "ckde2vg8p3nt",
    # Essex County Council
    "cywd23g04mqt",
    # European elections 2019
    "c7zzdg3pmgpt",
    # Exeter City Council
    "ckn41gr9d26t",
    # Falkirk Council
    "cq23pdgvr8zt",
    # Fareham Borough Council
    "cmex9ygmen9t",
    # Fenland District Council
    "ckde2vgl84wt",
    # Fermanagh and Omagh District Council
    "cnxkv19pvpgt",
    # Fife Council
    "c8nq32jw811t",
    # Flintshire County Council
    "cg41ylwvxe8t",
    # Folkestone and Hythe District Council
    "cgmk7g1732lt",
    # Forest of Dean District Council
    "c18k740mgeet",
    # Fylde Borough Council
    "cx3xvwq5z2pt",
    # Gateshead Council
    "c4e7135rrr6t",
    # Gedling Borough Council
    "c5xyn3w8mv4t",
    # Glasgow City Council
    "cp7r8vgl20xt",
    # Gloucester City Council
    "c6rv64k4n6mt",
    # Gloucestershire County Council
    "cdl8n2edxwxt",
    # Gosport Borough Council
    "c7ry2v83060t",
    # Gravesham Borough Council
    "cl12w48p892t",
    # Great Yarmouth Borough Council
    "cpr6gnee362t",
    # Greenwich London Borough Council
    "c2n5vwndvv5t",
    # Guildford Borough Council
    "cyq4zgmlnqkt",
    # Gwynedd Council
    "cz4pr2gd5lxt",
    # Hackney London Borough Council
    "cn1r2wdermgt",
    # Halton Borough Council
    "cv8k1ezvmg8t",
    # Hambleton District Council
    "cl12w48zm0nt",
    # Hammersmith and Fulham London Borough Council
    "cdyemznv72rt",
    # Hampshire County Council
    "clm1wxp5nvmt",
    # Harborough District Council
    "cd7dvxd1klkt",
    # Haringey London Borough Council
    "ckn41g8zm4pt",
    # Harlow District Council
    "cz3nmp5y5ggt",
    # Harrogate Borough Council
    "c2n5vx7zw1xt",
    # Harrow London Borough Council
    "c6z8966k3emt",
    # Hart District Council
    "cn1r2w8m645t",
    # Hartlepool Borough Council
    "cv8k1ezy9m9t",
    # Hastings Borough Council
    "c1v20yxy2xvt",
    # Havant Borough Council
    "cdyemzpe6d1t",
    # Havering London Borough Council
    "cyd02rr91z8t",
    # Herefordshire Council
    "c5xyn3y3572t",
    # Hertfordshire County Council
    "ce1qrvlexwlt",
    # Hertsmere Borough Council
    "c9041g4g1mmt",
    # High Peak Borough Council
    "cd7dvxdp9eqt",
    # Highland Council
    "cmj34zmwx80t",
    # Hillingdon London Borough Council
    "c7ry2vvenzwt",
    # Hinckley and Bosworth Borough Council
    "c34kqdk9qwqt",
    # Horsham District Council
    "cmlw7pw8g45t",
    # Hounslow London Borough Council
    "c1v20ynr140t",
    # Hull Council
    "cg3nd2zg937t",
    # Huntingdonshire District Council
    "c51gr1rxyr8t",
    # Hyndburn Borough Council
    "cg3ndgz6vn3t",
    # Inverclyde Council
    "cjnwl8q4xp7t",
    # Ipswich Borough Council
    "cyd025ng43pt",
    # Isle of Anglesey County Council
    "cwlw3xz0183t",
    # Isle of Wight Council
    "cvenzmgyl1dt",
    # Islington London Borough Council
    "cpr6g30ee2rt",
    # Kensington and Chelsea London Borough Council
    "c82wmnxwn18t",
    # Kent County Council
    "c1038wnxe71t",
    # Kingston Upon Thames London Borough Council
    "cn1r2w6d407t",
    # Kirklees Council
    "cxwp9z34p8zt",
    # Knowsley Metropolitan Borough Council
    "cmex9ydggy3t",
    # Lambeth London Borough Council
    "cmex9yygmvzt",
    # Lancashire County Council
    "cwlw3xz01q3t",
    # Lancaster City Council
    "cd7dvxd4lxmt",
    # Leeds City Council
    "cpr6g37145et",
    # Leicester City Council
    "cgmxywxe9nzt",
    # Leicestershire County Council
    "c40rjmqdwvmt",
    # Lewes District Council
    "c4lkmdky3z3t",
    # Lewisham London Borough Council
    "cewngrrnky9t",
    # Lichfield District Council
    "c34kqdkpxn2t",
    # Lincolnshire County Council
    "c50znx8v45pt",
    # Lisburn and Castlereagh City Council
    "c0ge2y53wzxt",
    # Liverpool City Council
    "c95egxe339nt",
    # London elections 2021
    "c27kz1m3j9mt",
    # Luton Borough Council
    "cmlw7pwyv48t",
    # Maidstone Borough Council
    "c06zdv117xxt",
    # Maldon District Council
    "ce31zx1y1w0t",
    # Malvern Hills District Council
    "ce31zx1ney8t",
    # Manchester City Council
    "c7ry2vy7d52t",
    # Mansfield District Council
    "c2dk3qk41llt",
    # Mayor of Bristol
    "cm24v76zl6rt",
    # Mayor of Cambridgeshire & Peterborough
    "c40rjmqdwevt",
    # Mayor of Doncaster
    "c27e3401kdet",
    # Mayor of Greater Manchester
    "c50znx8v4l5t",
    # Mayor of Liverpool
    "cg699vx7d3et",
    # Mayor of London
    "c7rmp6p1vz1t",
    # Mayor of North Tyneside
    "cpg996d0pzlt",
    # Mayor of Salford
    "c3388lz4l28t",
    # Mayor of the Liverpool City Region
    "cq23pdgvrxzt",
    # Mayor of the Tees Valley
    "c8nq32jw801t",
    # Mayor of the West Midlands
    "cp7r8vgl2xxt",
    # Mayor of the West of England
    "cmj34zmwxn0t",
    # Mayor of West Yorkshire
    "crx9762gl4pt",
    # Medway Council
    "cvw1le1gwv4t",
    # Melton Borough Council
    "ckde2ve1w21t",
    # Mendip District Council
    "cgmxywxg8xlt",
    # Merthyr Tydfil County Borough Council
    "c008ql15djjt",
    # Merton London Borough Council
    "cmex9yex6xdt",
    # Mid and East Antrim Borough Council
    "cqykv0x3md4t",
    # Mid Devon District Council
    "c4lkmdk537et",
    # Mid Suffolk District Council
    "czm0p30kxn0t",
    # Mid Sussex District Council
    "ckde2ve5gk8t",
    # Mid Ulster District Council
    "c5xq9w04q72t",
    # Middlesbrough Borough Council
    "c5xyn3yw11kt",
    # Midlothian Council
    "cx1m7zg0wrqt",
    # Milton Keynes Council
    "c95egx6pve9t",
    # Mole Valley District Council
    "cpr6g3gm81wt",
    # Monmouthshire County Council
    "cnx753jenp8t",
    # Moray Council
    "cg41ylwvxpdt",
    # Neath Port Talbot County Borough Council
    "c302m85q1pdt",
    # New Forest District Council
    "ce31zxkpyqgt",
    # Newark and Sherwood District Council
    "cyq4zg2w03kt",
    # Newcastle City Council
    "c34mxdm59xzt",
    # Newcastle under Lyme Council
    "c6z89r4r55dt",
    # Newham London Borough Council
    "cmex9y63z2kt",
    # Newport City Council
    "c77jz3mdq8yt",
    # Newry City, Mourne and Down District Council
    "czmwqn2ne4et",
    # Norfolk County Council
    "cq23pdgvremt",
    # North Ayrshire Council
    "c008ql15d7dt",
    # North Devon Council
    "c4lkmd3d8w1t",
    # North East Derbyshire District Council
    "cqymneke70dt",
    # North East Lincolnshire Council
    "cpr6g3e6z15t",
    # North Hertfordshire District Council
    "c7ry2v8v7xwt",
    # North Kesteven District Council
    "cl12w4k90q1t",
    # North Lanarkshire Council
    "cnx753jen8jt",
    # North Lincolnshire Council
    "c2dk3qw9247t",
    # North Norfolk District Council
    "cpzqm8k5mx8t",
    # North Northamptonshire Council
    "c5nwpzkn523t",
    # North Somerset Council
    "c34kqd758vwt",
    # North Tyneside Council
    "c51gr0gm35pt",
    # North Warwickshire Borough Council
    "czm0p3w7y02t",
    # North West Leicestershire District Council
    "ckde2vk95q5t",
    # North Yorkshire County Council
    "c8nq32jw8zet",
    # Northamptonshire County Council
    "cp7r8vgl2dlt",
    # Northern Ireland local elections 2019
    "cj736r74vq9t",
    # Northumberland County Council
    "cdl8n2edx5xt",
    # Norwich City Council
    "c95eg26d22yt",
    # Nottingham City Council
    "c9041g8wxe4t",
    # Nottinghamshire County Council
    "cmj34zmwxr3t",
    # Nuneaton and Bedworth Borough Council
    "cr5pd6d7g41t",
    # Oadby and Wigston Borough Council
    "c7z584nenw1t",
    # Oldham Council
    "c6z8968d08nt",
    # Orkney Islands Council
    "c302m85q1v0t",
    # Oxford City Council
    "c95eg29gdp9t",
    # Oxfordshire County Council
    "cjnwl8q4x35t",
    # Pembrokeshire County Council
    "c207p54mljzt",
    # Pendle Borough Council
    "cdyem5rexgyt",
    # Perth and Kinross Council
    "c77jz3mdqlpt",
    # Peterborough Council
    "c4e713newp7t",
    # Plymouth Council
    "c82wmneydegt",
    # Portsmouth Council
    "c2n5vw68gkpt",
    # Powys Council
    "crr7mlg0v3et",
    # Preston City Council
    "cmex90p0z3vt",
    # Purbeck District Council
    "c4dmyrl14l9t",
    # Reading Borough Council
    "c7ry2vdm586t",
    # Redbridge London Borough Council
    "cv8k1e8x6x4t",
    # Redcar and Cleveland Borough Council
    "c2dk3q82m7lt",
    # Redditch Borough Council
    "c7ry2v2mez7t",
    # Reigate and Banstead Borough Council
    "c4e714vn4dwt",
    # Renfrewshire Council
    "c207p54mlrpt",
    # Rhondda Cynon Taf County Borough Council
    "cvenzmgylvdt",
    # Ribble Valley Borough Council
    "c2dk3q8v744t",
    # Richmond upon Thames London Borough Council
    "c06zd86my3gt",
    # Richmondshire District Council
    "c8yedk51wv2t",
    # Rochdale Metropolitan Borough Council
    "cv8k1ekkm08t",
    # Rochford District Council
    "cz3nmpgw3zgt",
    # Rossendale Borough Council
    "c82wm9kmynkt",
    # Rother District Council
    "c4lkmdx14z9t",
    # Rotherham Metropolitan Borough Council
    "cnjpwmdz92zt",
    # Rugby Borough Council
    "c06zd8d3g18t",
    # Runnymede Borough Council
    "c51grzv2ep6t",
    # Rushcliffe Borough Council
    "c2dk3q8lp27t",
    # Rushmoor Borough Council
    "cmex9yg23p0t",
    # Rutland County Council
    "c2dk3q84vxkt",
    # Ryedale District Council
    "c4lkmdx82g9t",
    # Salford City Council
    "c82wmn3xr1rt",
    # Sandwell Metropolitan Borough Council
    "cdyemzd76ert",
    # Scarborough Borough Council
    "cx3xvw9dl17t",
    # Scotland local elections 2017
    "c50znx8v8m4t",
    # Scottish Borders Council
    "crr7mlg0vzlt",
    # Scottish Parliament election 2021
    "c37d28xdn99t",
    # Sedgemoor District Council
    "c4lkmdxg7wnt",
    # Sefton Metropolitan Borough Council
    "cmex9y13vdpt",
    # Selby District Council
    "cgmxywqnggkt",
    # Sevenoaks District Council
    "c2dk3q8ygpvt",
    # Sheffield City Council
    "c06zd893pd1t",
    # Shetland Islands Council
    "cvenzmgyl0rt",
    # Shropshire Council
    "ce1qrvlex5lt",
    # Slough Borough Council
    "cewngryvepgt",
    # Solihull Metropolitan Borough Council
    "c7ry2v3zzz2t",
    # Somerset County Council
    "cx1m7zg0w4vt",
    # Somerset West and Taunton Council
    "cjg52102j71t",
    # South Ayrshire Council
    "cywd23g04xlt",
    # South Bucks District Council
    "c2dk3q8ye2kt",
    # South Cambridgeshire District Council
    "c1v20vnw7n5t",
    # South Derbyshire District Council
    "c2dk3q8z7zyt",
    # South Gloucestershire Council
    "cx3xvw9k0x8t",
    # South Hams District Council
    "cw7lxez3w3yt",
    # South Holland District Council
    "c18k74n05vxt",
    # South Kesteven District Council
    "c34kqd1e172t",
    # South Lakeland District Council
    "cwypryrmyvxt",
    # South Lanarkshire Council
    "cdl8n2edxz7t",
    # South Norfolk Council
    "ce31zx217wlt",
    # South Northamptonshire Council
    "c33p6e694q0t",
    # South Oxfordshire District Council
    "c7z584yn8xzt",
    # South Ribble Borough Council
    "c2dk3q8dyxqt",
    # South Somerset District Council
    "ce31zx2zx2nt",
    # South Staffordshire Council
    "cgmxywqy4wet",
    # South Tyneside Council
    "cn1r2wpr38zt",
    # Southampton Council
    "c34mxdwyr9kt",
    # Southend-on-Sea Borough Council
    "c82wmn4gp01t",
    # Southwark London Borough Council
    "cewngrr2ddyt",
    # Spelthorne Borough Council
    "c8yedk5d523t",
    # St Albans City & District Council
    "c06zd83769kt",
    # St. Helens Metropolitan Borough Council
    "c06zd89x55dt",
    # Stafford Borough Council
    "c0gkw7qq1dzt",
    # Staffordshire County Council
    "cg41ylwvx58t",
    # Staffordshire Moorlands District Council
    "c7z584yyyn5t",
    # Stevenage Borough Council
    "cz3nm49dx89t",
    # Stirling Council
    "ce1qrvlexzet",
    # Stockport Metropolitan Borough Council
    "cn1r2wp78eyt",
    # Stockton-on-Tees Borough Council
    "c18k7w3315qt",
    # Stoke-on-Trent City Council
    "cd7dvp1xxv5t",
    # Stratford-on-Avon District Council
    "c4lkm7ndzm7t",
    # Stroud District Council
    "cd63lw8mdpvt",
    # Suffolk County Council
    "cz4pr2gd5xxt",
    # Sunderland City Council
    "c4e713dvy2wt",
    # Surrey County Council
    "c008ql15dxjt",
    # Surrey Heath Borough Council
    "c34kq9g93q1t",
    # Sutton London Borough Council
    "c82wmn28zx5t",
    # Swale Borough Council
    "czm0p8q8pyqt",
    # Swindon Borough Council
    "c82wmn481ynt",
    # Tameside Metropolitan Borough Council
    "cr5pd69r77et",
    # Tamworth Borough Council
    "cr5pden59kdt",
    # Tandridge District Council
    "c06zdvnge1zt",
    # Teignbridge District Council
    "c34kq9g5ylvt",
    # Telford and Wrekin Borough Council
    "cqymn8vdwxqt",
    # Tendring District Council
    "cvw1lm24dqlt",
    # Test Valley Borough Council
    "c5xyng90g31t",
    # Tewkesbury Borough Council
    "c9041d5wnp1t",
    # Thanet District Council
    "cw7lxw20z9et",
    # The UK’s European elections 2019
    "crjeqkdevwvt",
    # Three Rivers District Council
    "cz3nmpyrgrmt",
    # Thurrock Council
    "c2n5vwpp0x7t",
    # Tonbridge and Malling Borough Council
    "c5xyng91pnkt",
    # Torbay Council
    "cyq4z3w9g41t",
    # Torfaen County Borough Council
    "cdl8n2edxvxt",
    # Torridge District Council
    "c9041d5vev0t",
    # Tower Hamlets London Borough Council
    "cr5pd6v9p6dt",
    # Trafford Metropolitan Borough Council
    "c2n5vw1n224t",
    # Tunbridge Wells Borough Council
    "c7ry2pm3072t",
    # Uttlesford District Council
    "c7z58d7vywet",
    # Vale of Glamorgan Council
    "ce1qrvlexylt",
    # Vale of White Horse District Council
    "c7z58d7wqv4t",
    # Wakefield Metropolitan District Council
    "c82wmn76d1nt",
    # Wales local elections 2017
    "cg41ylwvx45t",
    # Walsall Metropolitan Borough Council
    "cyd02rve9vnt",
    # Waltham Forest London Borough Council
    "cdyemzy7w0dt",
    # Wandsworth London Borough Council
    "cv8k1e8g5dwt",
    # Warrington Borough Council
    "c2jq0m4ezm0t",
    # Warwick District Council
    "c8yed30qn84t",
    # Warwickshire County Council
    "cnx753jenv8t",
    # Watford Borough Council
    "c82wmng7xpyt",
    # Waverley Borough Council
    "czm0p8qnlv2t",
    # Wealden District Council
    "c9041d54d50t",
    # Welsh Parliament election 2021
    "cqwn14k92zwt",
    # Welwyn Hatfield Borough Council
    "cwypr17yndyt",
    # West Berkshire Council
    "cd7dvp1d5gpt",
    # West Devon Borough Council
    "ce31z8pky5zt",
    # West Dunbartonshire Council
    "clm1wxp5nz1t",
    # West Lancashire Borough Council
    "cmex905py9vt",
    # West Lindsey District Council
    "c9041d58yedt",
    # West Lothian Council
    "c1038wnxevrt",
    # West Northamptonshire Council
    "cxq3k9pj1kqt",
    # West Oxfordshire District Council
    "cwypr9e60edt",
    # West Suffolk Council
    "cpzqg374rl1t",
    # West Sussex County Council
    "c302m85q1xdt",
    # Westminster Council
    "c7ry2vnx2n5t",
    # Wigan Metropolitan Borough Council
    "cxwp9znd7k0t",
    # Wiltshire Council
    "clm1wxp5n2mt",
    # Winchester City Council
    "cz3nmpykrnvt",
    # Windsor and Maidenhead Borough Council
    "cgmxyp7mn08t",
    # Wirral Metropolitan Borough Council
    "cewngre8686t",
    # Woking Borough Council
    "c51grzvnevvt",
    # Wokingham Borough Council
    "cpr6g3dzwr8t",
    # Wolverhampton City Council
    "c7ry2vgwg1pt",
    # Worcester City Council
    "cxwp9z984xyt",
    # Worcestershire County Council
    "c77jz3mdq5yt",
    # Worthing Borough Council
    "c95egxge58gt",
    # Wrexham County Borough Council
    "c302m85q1p0t",
    # Wychavon District Council
    "cl12w9v1zp4t",
    # Wycombe District Council
    "c18k7w37503t",
    # Wyre Council
    "cl12w9vmg3pt",
    # Wyre Forest District Council
    "c95egxg00kpt",
    # York City Council
    "cpzqml8lgpkt"
  ]

  def get() do
    case Application.get_env(:belfrage, :production_environment) do
      "test" -> @test_ids
      "live" -> @live_ids
    end
  end
end
