use Mix.Config

config :statix,
  pool_size: 6

config :logger,
  backends: [{LoggerFileBackend, :file}, {LoggerFileBackend, :cloudwatch}, Belfrage.Metrics.CrashTracker]

config :logger, :file,
  path: System.get_env("LOG_PATH"),
  format: {Belfrage.Logger.Formatter, :app},
  level: :error,
  metadata: :all

config :logger, :cloudwatch,
  path: System.get_env("LOG_PATH_CLOUDWATCH"),
  format: {Belfrage.Logger.Formatter, :cloudwatch},
  level: :warn,
  metadata: :all,
  metadata_filter: [cloudwatch: true]

config :belfrage,
  production_environment: "live",
  http_cert: System.get_env("SERVICE_CERT"),
  http_cert_key: System.get_env("SERVICE_CERT_KEY"),
  http_cert_ca: System.get_env("SERVICE_CERT_CA"),
  not_found_page: "/var/www/html/errors/404-data-ssl.html",
  not_supported_page: "/var/www/html/errors/405-data-ssl.html",
  internal_error_page: "/var/www/html/errors/500-data-ssl.html",
  mozart_ids: [
    # Page cannot be found - BBC News
    "cvv4m4mqkymt",
    # Page cannot be found - BBC News
    "czv6reejxqqt",
    # Page cannot be found - BBC News
    "c6y3ekl2323t",
    # Page cannot be found - BBC News
    "czv6rev6mz7t",
    # Amazon - BBC News
    "c50znx8v8y4t",
    # GameStop - BBC News
    "cyzp91yk1ydt",
    # Moderna - BBC News
    "c8grzynv1mgt",
    # NatWest Group - BBC News
    "cdvdx4l9y4xt",
    # EuroStoxx 50 - BBC News
    "clyeyy6464qt",
    # Lyft - BBC News
    "c10094dkqkrt",
    # Jet Airways - BBC News
    "cwwwewx7rrwt",
    # Asos - BBC News
    "cj1xj07qx9et",
    # Superdry - BBC News
    "c348jz2lex6t",
    # Smurfit Kappa Group - BBC News
    "cxw7q6wwpy8t",
    # French Connection Group - BBC News
    "cdl70lgvlp1t",
    # Boohoo - BBC News
    "cj2700dj78kt",
    # Bloomsbury Publishing - BBC News
    "cqx75jx9955t",
    # Patisserie Valerie - BBC News
    "crd7jvq987kt",
    # Aston Martin - BBC News
    "cev9zn0ggzpt",
    # Paragon Banking Group - BBC News
    "cle48gxn6ynt",
    # AA - BBC News
    "c2rnyvlkrwlt",
    # Reach PLC - BBC News
    "c514vpxv5llt",
    # B&M European Value - BBC News
    "cny6mmxwgwgt",
    # Johnson & Johnson - BBC News
    "c7zl7v00x15t",
    # Mothercare - BBC News
    "c0n69181n53t",
    # Gap - BBC News
    "cgdzn8v44jlt",
    # Saga - BBC News
    "crem2z954ndt",
    # Segro - BBC News
    "cq265n8m8qqt",
    # Worldwide Healthcare Trust - BBC News
    "c5ewlerdr0kt",
    # FirstGroup - BBC News
    "cyn9wwxgewlt",
    # Frasers Group - BBC News
    "c23p6mx67v8t",
    # Kellogg Company - BBC News
    "cq04218m929t",
    # Lastminute.com - BBC News
    "cjqx35j92pet",
    # Jumia - BBC News
    "cpzz7xmjgvwt",
    # Interserve  - BBC News
    "cwjdyzqwqqwt",
    # AT&T - BBC News
    "c2q3k34gnw1t",
    # AMD - BBC News
    "c91242yylkzt",
    # Zynga - BBC News
    "c025k7k4ex2t",
    # Mulberry - BBC News
    "czlm1nzpzlvt",
    # London Stock Exchange Group - BBC News
    "ce7l82zl978t",
    # Workspace Group - BBC News
    "ckm4xm64551t",
    # Woodford Patient Capital Trust - BBC News
    "c11le1kp83mt",
    # Wizz Air - BBC News
    "cmleylw141et",
    # Witan Investment Trust - BBC News
    "cy5m75wwmvwt",
    # William Hill (bookmaker) - BBC News
    "c704e0kj142t",
    # WH Smith - BBC News
    "ce8jr869nwkt",
    # Wetherspoons - BBC News
    "c11le1xvm4yt",
    # SSE Composite - BBC News
    "cq757713q97t",
    # Nikkei 225 - BBC News
    "c55p555ng9gt",
    # Hang Seng - BBC News
    "cq75774n157t",
    # BSE Sensex - BBC News
    "cpglgg6zyd0t",
    # S&P 500 - BBC News
    "c4dldd02yp3t",
    # NASDAQ - BBC News
    "c08k88ey6d5t",
    # Dow Jones Industrial Average - BBC News
    "clyeyy8851qt",
    # CAC 40 - BBC News
    "cwjzjjz559yt",
    # IBEX 35 - BBC News
    "c34l44l8d48t",
    # DAX - BBC News
    "ckwlwwg6507t",
    # AEX - BBC News
    "clyeyy6q0g4t",
    # FTSE 250 - BBC News
    "cjl3llgk4k2t",
    # FTSE 100 - BBC News
    "c9qdqqkgz27t",
    # Vedanta Resources - BBC News
    "czzng315j56t",
    # IWG - BBC News
    "czzn8lxng89t",
    # Ibstock - BBC News
    "czzn8le8899t",
    # Just Eat Takeaway - BBC News
    "czzn8l7l79rt",
    # Spectris - BBC News
    "czzn89798d5t",
    # Bank of Georgia - BBC News
    "czv6rrldgw8t",
    # Bodycote - BBC News
    "czv6rr8ljmyt",
    # Esure - BBC News
    "czv6rr2gzket",
    # Ascential - BBC News
    "czv6reey8l5t",
    # Nike, Inc. - BBC News
    "czv6r8w2vqqt",
    # Merlin Entertainments - BBC News
    "czv6r8rnl9jt",
    # Bunzl - BBC News
    "czv6r8qrrrwt",
    # Parkmead Group - BBC News
    "czv6r8mnjq8t",
    # Electronic Arts - BBC News
    "czv6r8m2d49t",
    # Compass Group - BBC News
    "czv6r8gdy58t",
    # Rentokil Initial - BBC News
    "czv6r87zrd2t",
    # ConvaTec - BBC News
    "czv6r86xgqyt",
    # Ford - BBC News
    "cz4pr2gdgyyt",
    # Coca-Cola - BBC News
    "cz4pr2gd5w0t",
    # AstraZeneca - BBC News
    "cz4pr2gd52lt",
    # Marks & Spencer - BBC News
    "cywd23g0ggxt",
    # Burberry Group - BBC News
    "cywd23g0g10t",
    # Diageo - BBC News
    "cywd23g04net",
    # National Grid - BBC News
    "cywd23g04jlt",
    # McDonald's - BBC News
    "cywd23g04g4t",
    # Procter & Gamble - BBC News
    "cywd23g041et",
    # F&C Commercial Property Trust - BBC News
    "cyn9ww8w6gvt",
    # Shaftesbury - BBC News
    "cyg1qpmrqg1t",
    # Serco - BBC News
    "cyg1qpmgp5kt",
    # Inchcape - BBC News
    "cyg1q3xl7n4t",
    # Jupiter Fund Management - BBC News
    "cyg1q3m48pkt",
    # NMC Health - BBC News
    "cyg1q3e632zt",
    # Dairy Crest - BBC News
    "cxw7qqrw8rlt",
    # Shire (pharmaceutical company) - BBC News
    "cxw7q6m6wxrt",
    # Antofagasta - BBC News
    "cxw7q5vrrkwt",
    # Johnson Matthey - BBC News
    "cxw7q5qmw24t",
    # Informa - BBC News
    "cxw7q5nn5rxt",
    # Ferguson - BBC News
    "cxw7q57v2vkt",
    # NewRiver - BBC News
    "cxqe2zpqdl5t",
    # Lancashire Holdings - BBC News
    "cxqe2zjerlxt",
    # International Public Partnerships - BBC News
    "cxqe2z8rg7gt",
    # PZ Cussons - BBC News
    "cxqe2z6mx3jt",
    # General Motors - BBC News
    "cx1m7zg0g55t",
    # Goldman Sachs - BBC News
    "cx1m7zg0g3nt",
    # Exxon Mobil - BBC News
    "cx1m7zg0g0lt",
    # Diploma - BBC News
    "cwz4ll584r4t",
    # Delta Airlines - BBC News
    "cwz4ldqpjp8t",
    # Activision Blizzard - BBC News
    "cwz4ldqgy28t",
    # Intertek - BBC News
    "cwz4ldl72yxt",
    # British Land - BBC News
    "cwz4ld6vzn2t",
    # G4S - BBC News
    "cwz4ld4el2jt",
    # 3i Infrastructure - BBC News
    "cwz4l8xj794t",
    # BT Group - BBC News
    "cwlw3xz0zwet",
    # Citigroup - BBC News
    "cwlw3xz0zqet",
    # RELX Group - BBC News
    "cvl7nqzxe69t",
    # Mondi - BBC News
    "cvl7nqn9pr2t",
    # Experian - BBC News
    "cvl7nq7wmq8t",
    # Cranswick - BBC News
    "cvl7nnr8zdkt",
    # Essentra - BBC News
    "cvl7nndm2v7t",
    # Fidelity China Special Situations - BBC News
    "cvl7nn4ypz7t",
    # James Fisher & Sons - BBC News
    "cvl7nn4qpzqt",
    # Ryanair - BBC News
    "cvenzmgygg7t",
    # Microsoft - BBC News
    "cvenzmgyg0lt",
    # Vodafone - BBC News
    "crr7mlg0vg2t",
    # Netflix - BBC News
    "crr7mlg0v1lt",
    # Rio Tinto - BBC News
    "crr7mlg0gr3t",
    # Apple - BBC News
    "crr7mlg0gqqt",
    # United Utilities - BBC News
    "crr7mlg0gdnt",
    # Unite Students - BBC News
    "crjy5mp1l9kt",
    # Sophos - BBC News
    "crjy4rnrgyxt",
    # Scottish Investment Trust - BBC News
    "crjy4rer173t",
    # Pennon Group - BBC News
    "crjy47py3g2t",
    # Just Group - BBC News
    "crjy47ndqymt",
    # Perpetual Income & Growth Investment Trust - BBC News
    "crjy47lg55gt",
    # IGas Energy - BBC News
    "crem2z8xexnt",
    # Mediclinic International - BBC News
    "crem2z2m5wqt",
    # Aberforth Smaller Companies Trust - BBC News
    "crem2vvvd6vt",
    # Aveva - BBC News
    "crem2vvjkelt",
    # Finsbury Growth & Income Trust - BBC News
    "crem22ydmkvt",
    # Euromoney Institutional Investor - BBC News
    "crem22wmw9dt",
    # Drax Group - BBC News
    "crem22wl58zt",
    # Domino's Pizza Group - BBC News
    "crem22w5kz5t",
    # Computacenter - BBC News
    "crem22vmy99t",
    # Crest Nicholson - BBC News
    "crem22v7742t",
    # CLS Holdings - BBC News
    "crem22v5ggpt",
    # Halfords - BBC News
    "cr07g9zzvn9t",
    # Victrex - BBC News
    "cql8rjpm187t",
    # TR Property Investment Trust - BBC News
    "cql8rjkmkq9t",
    # UDG Healthcare - BBC News
    "cql8rj8ppj8t",
    # Polymetal International - BBC News
    "cql8qmr9pret",
    # PageGroup - BBC News
    "cql8qmp2expt",
    # JPMorgan American Investment Trust - BBC News
    "cql8qmmeq4zt",
    # KAZ Minerals - BBC News
    "cql8qm2dkl5t",
    # Kennedy-Wilson Holdings - BBC News
    "cql8qm223z2t",
    # Starbucks - BBC News
    "cq265ly55e9t",
    # CYBG - BBC News
    "cq2655n5jwvt",
    # N Brown Group - BBC News
    "cq2655lgldnt",
    # Electrocomponents - BBC News
    "cq26554x797t",
    # Pfizer - BBC News
    "cq23pdgvglxt",
    # Syncona - BBC News
    "cpd6nx35xpdt",
    # Pets at Home - BBC News
    "cpd6njnmzmjt",
    # JD Sports - BBC News
    "cpd6nj989nmt",
    # National Express - BBC News
    "cpd6nj666zkt",
    # Intermediate Capital Group - BBC News
    "cpd6nj5yq42t",
    # IMI - BBC News
    "cpd6nj4x2get",
    # Royal Mail - BBC News
    "cp7r8vglgwjt",
    # Morgan Stanley - BBC News
    "cp7r8vglgljt",
    # Sky - BBC News
    "cp7r8vgl7pzt",
    # BP - BBC News
    "cp7r8vgl27rt",
    # Sage Group - BBC News
    "cp7dmwr82vnt",
    # abrdn - BBC News
    "cp7dmw7pppdt",
    # Evraz - BBC News
    "cp7dmmlnvrmt",
    # Anglo American - BBC News
    "cp7dm4zwg9vt",
    # InterContinental Hotels Group - BBC News
    "cp7dm4nmm5kt",
    # Land Securities - BBC News
    "cp7dm4my2wqt",
    # Hargreaves Lansdown - BBC News
    "cp7dm4dx4lnt",
    # Bank of America - BBC News
    "cp7dm484262t",
    # Genus - BBC News
    "cp3mv9mvm2jt",
    # Scottish Mortgage Investment Trust - BBC News
    "cny6mld4y2xt",
    # Go-Ahead Group - BBC News
    "cnegp9gn1zdt",
    # Hastings Insurance - BBC News
    "cnegp95yp05t",
    # Entain - BBC News
    "cnegp95g5g8t",
    # Facebook - BBC News
    "cmj34zmwxjlt",
    # Twitter - BBC News
    "cmj34zmwx51t",
    # HICL Infrastructure Company - BBC News
    "cm8m14z754et",
    # Ferrexpo - BBC News
    "cm6pmmxdnw2t",
    # Capita - BBC News
    "cm6pmmerd28t",
    # Coca-Cola HBC AG - BBC News
    "cm6pmev6zmnt",
    # GKN - BBC News
    "cm6pmepplmzt",
    # Ashtead Group - BBC News
    "cm6pmejyklvt",
    # Ultra Electronics - BBC News
    "cm1yx7l98g6t",
    # Intu Properties - BBC News
    "cm1ygzmd3rqt",
    # Redrow - BBC News
    "cm1ygplykydt",
    # Spirax-Sarco Engineering - BBC News
    "cm1yg8d9yg3t",
    # Templeton Emerging Markets Investment Trust - BBC News
    "cm1yg87ggzyt",
    # Hansteen Holdings - BBC News
    "cljev9pz5g4t",
    # Greggs - BBC News
    "cljev9przz1t",
    # Great Portland Estates - BBC News
    "cljev9pn8zrt",
    # Grainger - BBC News
    "cljev9p0r1mt",
    # Hays - BBC News
    "cljev9d3nylt",
    # Mercantile Investment Trust - BBC News
    "cle48g4j4zxt",
    # Spire Healthcare - BBC News
    "cle482yzymrt",
    # TBC Bank - BBC News
    "cle482myknet",
    # Travis Perkins - BBC News
    "cle4824zl78t",
    # The Rank Group - BBC News
    "cle481xnlndt",
    # ZPG - BBC News
    "cle46m8d471t",
    # Internal server error - BBC News
    "cl86mmjpnqpt",
    # Close Brothers Group - BBC News
    "cl86mmjl62mt",
    # British Empire Trust - BBC News
    "cl86mm2e94dt",
    # Whitbread - BBC News
    "cl86mjkkgn6t",
    # Ashmore Group - BBC News
    "cl86mjjp7xxt",
    # Petrobras - BBC News
    "cl86m2y7px6t",
    # Pearson - BBC News
    "cl86m2gm2w8t",
    # Fresnillo - BBC News
    "cl86m26w75pt",
    # St. James's Place - BBC News
    "ckr6dxrqll7t",
    # Fidessa - BBC News
    "ckr6ddmn7p6t",
    # Bellway - BBC News
    "ckr6ddkvljmt",
    # Britvic - BBC News
    "ckr6dd4lm65t",
    # Centamin - BBC News
    "ckr6dd46d54t",
    # Dechra Pharmaceuticals - BBC News
    "ckr6dd2kq9nt",
    # PepsiCo - BBC News
    "ckr6d48pk46t",
    # Homeserve - BBC News
    "ckgj7945n97t",
    # UBM - BBC News
    "ck835j332p2t",
    # LondonMetric Property - BBC News
    "ck832qn4q93t",
    # McCarthy & Stone - BBC News
    "ck832q6yn26t",
    # Senior - BBC News
    "ck832pnxd18t",
    # GlaxoSmithKline - BBC News
    "cjnwl8q4qvjt",
    # JP Morgan - BBC News
    "cjnwl8q4nr3t",
    # UK Commercial Property Trust - BBC News
    "cjnr4lxend1t",
    # TalkTalk Group - BBC News
    "cjnr2zl1x6nt",
    # Synthomer - BBC News
    "cjnr2z5m4rjt",
    # Redefine International - BBC News
    "cjnr2yxl7znt",
    # Beazley Group - BBC News
    "cj5pdndw4kdt",
    # TUI Group - BBC News
    "cj5pde5nvd9t",
    # City of London Investment Trust - BBC News
    "cj5pddewkwmt",
    # Brewin Dolphin - BBC News
    "cj5pdd6e24et",
    # American Airlines - BBC News
    "cj5pd6v524kt",
    # HP Inc - BBC News
    "cj5pd6m8zxxt",
    # Intel - BBC News
    "cj5pd6gqk4kt",
    # Carnival Corporation - BBC News
    "cj5pd678m8rt",
    # Barratt Developments - BBC News
    "cj5pd62qyvkt",
    # Admiral Group - BBC News
    "cj5pd62kpe6t",
    # Stobart Group - BBC News
    "cgzj6dm3gj7t",
    # Mitie - BBC News
    "cgzj67jx17et",
    # Metro Bank (United Kingdom) - BBC News
    "cgzj67jnynkt",
    # Berkeley Group Holdings - BBC News
    "cgv6llkxlm2t",
    # Cairn Energy - BBC News
    "cgv6ll59d9wt",
    # Capital & Counties Properties - BBC News
    "cgv6ll57nmyt",
    # Smiths Group - BBC News
    "cgv6l8v27myt",
    # Auto Trader Group - BBC News
    "cgv6l889m9et",
    # Imperial Brands - BBC News
    "cgv6l542p65t",
    # A.G. Barr - BBC News
    "cgv6l44yrnjt",
    # Howdens Joinery - BBC News
    "cg5rv92ljgxt",
    # Groupon - BBC News
    "cg41ylwvwqgt",
    # Nvidia - BBC News
    "cewrlqz847yt",
    # Berkshire Hathaway Inc. - BBC News
    "cewrlqz7xygt",
    # Croda International - BBC News
    "cewrlqr7eylt",
    # WPP - BBC News
    "cewrlqp59x7t",
    # Wood Group - BBC News
    "cewrlqm8ylet",
    # Flybe - BBC News
    "cewrlqm4wz5t",
    # Reckitt Benckiser - BBC News
    "cewrlqj4gnzt",
    # Edinburgh Investment Trust - BBC News
    "cewrllvp26xt",
    # Big Yellow Group - BBC News
    "cewrllqxln2t",
    # Clarkson - BBC News
    "cewrll5xjnjt",
    # Cobham - BBC News
    "cewrll5nz94t",
    # Taylor Wimpey - BBC News
    "cewrl5w94e9t",
    # NEX Group - BBC News
    "ceq4ejpkjr7t",
    # Inmarsat - BBC News
    "ceq4ej1yxnnt",
    # Investec - BBC News
    "ceq4ej1lpn6t",
    # IP Group - BBC News
    "ceq4ej122qet",
    # Hochschild Mining - BBC News
    "ce2gzrplynvt",
    # Hill & Smith - BBC News
    "ce2gzrp3gxrt",
    # Sainsbury's - BBC News
    "ce1qrvlexr1t",
    # Rolls-Royce Holdings - BBC News
    "ce1qrvlex71t",
    # Walmart - BBC News
    "ce1qrvlex0et",
    # Alibaba - BBC News
    "ce1qrvlelqqt",
    # Severn Trent - BBC News
    "ce1qrvlel2qt",
    # Babcock International - BBC News
    "cdz5gv7pwjkt",
    # Electra Private Equity - BBC News
    "cdz5ggnw7xdt",
    # Greencoat UK Wind - BBC News
    "cdnpj79g404t",
    # Aviva - BBC News
    "cdl8n2edxj7t",
    # HSBC - BBC News
    "cdl8n2eden0t",
    # Santander Group - BBC News
    "cdl8n2ededdt",
    # RPC Group - BBC News
    "cd67er3xjmdt",
    # John Laing Infrastructure Fund - BBC News
    "cd67elljy34t",
    # Tullow Oil - BBC News
    "c9jx7qxqy36t",
    # Vietnam Enterprise Investments - BBC News
    "c9jx7q942xxt",
    # JPMorgan Indian Investment Trust - BBC News
    "c9jx2pd38x1t",
    # SIG - BBC News
    "c9jx2gd4rrkt",
    # Rotork - BBC News
    "c9jx2g48ngdt",
    # Elementis - BBC News
    "c9edzzqxmkwt",
    # Entertainment One - BBC News
    "c9edzzqxjmet",
    # Countryside Properties - BBC News
    "c9edzzm72xjt",
    # Balfour Beatty - BBC News
    "c9edzmmyplkt",
    # RSA Insurance Group - BBC News
    "c9edzm29jmpt",
    # Legal & General - BBC News
    "c9edzkzwx2xt",
    # Stagecoach - BBC News
    "c9edzkwe7xrt",
    # British American Tobacco - BBC News
    "c9edzkvlp2gt",
    # Hammerson - BBC News
    "c9edzkd6qket",
    # Greene King - BBC News
    "c8z0l18e9pet",
    # Royal Dutch Shell - BBC News
    "c8nq32jwnelt",
    # SSE - BBC News
    "c8nq32jwjqnt",
    # Tesla - BBC News
    "c8nq32jwjnmt",
    # Prudential - BBC News
    "c8nq32jwjg0t",
    # Ladbrokes Coral - BBC News
    "c8l6dpnqy7yt",
    # Marston's Brewery - BBC News
    "c8l6dpkpe99t",
    # Indivior - BBC News
    "c8l6dp595lxt",
    # Personal Assets Trust - BBC News
    "c8l6dp4lym1t",
    # Petra Diamonds - BBC News
    "c8l6dp42444t",
    # Temple Bar Investment Trust - BBC News
    "c8l6d3q4jrrt",
    # Sirius Minerals - BBC News
    "c8l6d3n7elxt",
    # Riverstone Energy - BBC News
    "c8l6d37nld6t",
    # Provident Financial - BBC News
    "c8254yp6lwdt",
    # DCC - BBC News
    "c8254y52gwwt",
    # Smith & Nephew - BBC News
    "c82546rw58gt",
    # WorldPay - BBC News
    "c82546dy7rwt",
    # Schroders - BBC News
    "c825469m8pet",
    # Vesuvius - BBC News
    "c7d6y2z7rgdt",
    # RIT Capital Partners - BBC News
    "c7d65xmmr36t",
    # Softcat - BBC News
    "c7d65x9j4m7t",
    # PayPoint - BBC News
    "c7d65kz8285t",
    # Qinetiq - BBC News
    "c7d65kym7jkt",
    # Polypipe - BBC News
    "c7d65kyk9yrt",
    # IG Group - BBC News
    "c7d65kqy9j3t",
    # Meggitt - BBC News
    "c7d65k8m5kxt",
    # John Laing Group - BBC News
    "c7d65k4dr79t",
    # Renewables Infrastructure Group - BBC News
    "c7d651zyy1xt",
    # IBM - BBC News
    "c77jz3mdqwpt",
    # IAG - BBC News
    "c77jz3mdmy3t",
    # Tesco - BBC News
    "c77jz3mdmlvt",
    # BTG - BBC News
    "c779ee6r7yxt",
    # Booker Group - BBC News
    "c779ee665mwt",
    # Alliance Trust - BBC News
    "c779e88zj2nt",
    # Randgold Resources - BBC News
    "c779e6kl2y5t",
    # Flutter Entertainment - BBC News
    "c779e6gmpzrt",
    # Old Mutual - BBC News
    "c779e6gjd6zt",
    # Hunting - BBC News
    "c734jd19gvkt",
    # DS Smith - BBC News
    "c6y3erpprq9t",
    # Savills - BBC News
    "c6y3erj582qt",
    # Rightmove - BBC News
    "c6y3erj1m4pt",
    # Ted Baker - BBC News
    "c6y3erggy4et",
    # TP ICAP - BBC News
    "c6y3er39zlxt",
    # Melrose Industries - BBC News
    "c6y3ekxnyd6t",
    # P2P Global Investments - BBC News
    "c6y3eknjy61t",
    # Northgate - BBC News
    "c6y3ekn87zqt",
    # JPMorgan Emerging Markets Investment Trust - BBC News
    "c6y3ekjkqnmt",
    # Renishaw - BBC News
    "c6y3e1l946lt",
    # Weir Group - BBC News
    "c6mk28y4dw7t",
    # Persimmon - BBC News
    "c6mk28n8x6kt",
    # United Airlines - BBC News
    "c6mk28llrk7t",
    # Micro Focus - BBC News
    "c6mk2822l94t",
    # Dunelm Group - BBC News
    "c6mk22wymldt",
    # Dignity - BBC News
    "c6mk22wr96kt",
    # Caledonia Investments - BBC News
    "c6mk228z8xlt",
    # CRH - BBC News
    "c5y4pr4me8wt",
    # Cineworld - BBC News
    "c5y4pp57rpyt",
    # Acacia Mining - BBC News
    "c5y4p555e6qt",
    # Vectura Group - BBC News
    "c5x2rqzxdjpt",
    # St. Modwen Properties - BBC News
    "c5x2p78ndqgt",
    # Man Group - BBC News
    "c5x2p4ke9lxt",
    # Murray International Trust - BBC News
    "c5x2p42qr1mt",
    # Moneysupermarket.com - BBC News
    "c5x2p42knryt",
    # Morgan Advanced Materials - BBC News
    "c5x2p428re7t",
    # Monks Investment Trust - BBC News
    "c5x2p428gnkt",
    # Mitchells & Butlers - BBC News
    "c5x2p421yj3t",
    # Rathbone Brothers - BBC News
    "c5x2p1z8x4lt",
    # Genesis Emerging Markets Fund - BBC News
    "c5elzyl8ze7t",
    # GCP Infrastructure Investments - BBC News
    "c5elzyl58xjt",
    # Glencore - BBC News
    "c50znx8v8z4t",
    # PayPal - BBC News
    "c50znx8v8j4t",
    # Alphabet - BBC News
    "c50znx8v421t",
    # Galliford Try - BBC News
    "c48yr0yx42nt",
    # Grafton Group - BBC News
    "c48yr0xgprjt",
    # Hiscox - BBC News
    "c48yr0p2z08t",
    # Derwent London - BBC News
    "c46zqql55r4t",
    # Fidelity European Values - BBC News
    "c46zqqj4ypwt",
    # Card Factory - BBC News
    "c46zqq524e4t",
    # BBA Aviation - BBC News
    "c46zqeqy52et",
    # Bankers Investment Trust - BBC News
    "c46zqeenew5t",
    # Assura - BBC News
    "c46zqddr25et",
    # Marshalls - BBC News
    "c416ndyn2xdt",
    # Playtech - BBC News
    "c416ndm1r9qt",
    # Thomas Cook Group - BBC News
    "c416n3k3156t",
    # Restaurant Group - BBC News
    "c416n3gddg8t",
    # SSP Group - BBC News
    "c416n381d13t",
    # Tritax Big Box REIT - BBC News
    "c416mkqj681t",
    # Lloyds Banking Group - BBC News
    "c40rjmqdww3t",
    # Disney - BBC News
    "c40rjmqdw2vt",
    # Unilever - BBC News
    "c40rjmqdqvlt",
    # Boeing - BBC News
    "c40rjmqd0pgt",
    # Kingfisher - BBC News
    "c40rjmqd0ggt",
    # Sanne Group - BBC News
    "c348jzqj411t",
    # Phoenix Group - BBC News
    "c348jdx1pq9t",
    # Millennium & Copthorne Hotels - BBC News
    "c348jd8984rt",
    # Greencore - BBC News
    "c340rzx790jt",
    # Hikma Pharmaceuticals - BBC News
    "c340rzp8p08t",
    # Ocado - BBC News
    "c302m85q5xjt",
    # Royal Bank of Scotland - BBC News
    "c302m85q5m3t",
    # BAE Systems - BBC News
    "c302m85q57zt",
    # Easyjet - BBC News
    "c302m85q52jt",
    # Barclays - BBC News
    "c302m85q170t",
    # Centrica - BBC News
    "c302m85q0w3t",
    # FDM Group - BBC News
    "c2rnyyjmww6t",
    # Aggreko - BBC News
    "c2rnyvvjjygt",
    # Direct Line Group - BBC News
    "c2rnyqnqvv8t",
    # JPI Media - BBC News
    "c2rnyqkew57t",
    # 3i Group - BBC News
    "c2rnyqdrvqnt",
    # Halma - BBC News
    "c2gze4pm7k4t",
    # Telecom Plus - BBC News
    "c28glxrr4qnt",
    # Safestore - BBC News
    "c28glx6rl3kt",
    # Nostrum Oil & Gas - BBC News
    "c28gldjmjq1t",
    # Jardine Lloyd Thompson - BBC News
    "c28gld9nyzqt",
    # Polar Capital Technology Trust - BBC News
    "c28gld42313t",
    # Petrofac - BBC News
    "c28gld3zeg2t",
    # Associated British Foods - BBC News
    "c207p54m4lnt",
    # Morrisons - BBC News
    "c207p54m4det",
    # Standard Chartered - BBC News
    "c207p54m485t",
    # Tate & Lyle - BBC News
    "c1nxez79n95t",
    # Kier Group - BBC News
    "c1nxedyylz1t",
    # OneSavings Bank - BBC News
    "c1nxedl1j77t",
    # Currys - BBC News
    "c1038wnxnp7t",
    # eBay - BBC News
    "c1038wnxnmpt",
    # General Electric - BBC News
    "c1038wnxezrt",
    # Blackberry - BBC News
    "c008ql15ddgt",
    # ITV - BBC News
    "c008ql151q8t",
    # Next - BBC News
    "c008ql151lwt",
    # Oil - BBC News
    "cmjpj223708t",
    # Gold - BBC News
    "cwjzj55q2p3t",
    # Natural gas - BBC News
    "cxwdwz5d8gxt",
    # Pound Sterling (GBP) - BBC News
    "cx250jmk4e7t",
    # Euro (EUR) - BBC News
    "ce2gz75e8g0t",
    # US Dollar (USD) - BBC News
    "cljevy2yz5lt",
    # Japanese Yen (JPY) - BBC News
    "cleld6gp05et",
    # Coventry City Council - BBC News
    "ckn41gy8p59t",
    # North Northamptonshire Council - BBC News
    "c5nwpzkn523t",
    # Buckinghamshire County Council - BBC News
    "c008ql15d3jt",
    # West Northamptonshire Council - BBC News
    "cxq3k9pj1kqt",
    # Mayor of London - BBC News
    "c7rmp6p1vz1t",
    # London elections 2021 - BBC News
    "c27kz1m3j9mt",
    # Scottish Parliament election 2021 - BBC News
    "c37d28xdn99t",
    # Welsh Parliament election 2021 - BBC News
    "cqwn14k92zwt",
    # England local elections 2021 - BBC News
    "c481drqqzv7t",
    # Mayor of Bristol - BBC News
    "cm24v76zl6rt",
    # Mayor of Doncaster - BBC News
    "c27e3401kdet",
    # Mayor of West Yorkshire - BBC News
    "crx9762gl4pt",
    # England local elections 2019 - BBC News
    "ceeqy0e9894t",
    # Northern Ireland local elections 2019 - BBC News
    "cj736r74vq9t",
    # Wyre Forest District Council - BBC News
    "c95egxg00kpt",
    # Worthing Borough Council - BBC News
    "c95egxge58gt",
    # Worcester City Council - BBC News
    "cxwp9z984xyt",
    # Wokingham Borough Council - BBC News
    "cpr6g3dzwr8t",
    # Woking Borough Council - BBC News
    "c51grzvnevvt",
    # Wirral Metropolitan Borough Council - BBC News
    "cewngre8686t",
    # Winchester City Council - BBC News
    "cz3nmpykrnvt",
    # Wigan Metropolitan Borough Council - BBC News
    "cxwp9znd7k0t",
    # West Oxfordshire District Council - BBC News
    "cwypr9e60edt",
    # West Lancashire Borough Council - BBC News
    "cmex905py9vt",
    # Welwyn Hatfield Borough Council - BBC News
    "cwypr17yndyt",
    # Watford Borough Council - BBC News
    "c82wmng7xpyt",
    # Wandsworth London Borough Council - BBC News
    "cv8k1e8g5dwt",
    # Waltham Forest London Borough Council - BBC News
    "cdyemzy7w0dt",
    # Walsall Metropolitan Borough Council - BBC News
    "cyd02rve9vnt",
    # Wakefield Metropolitan District Council - BBC News
    "c82wmn76d1nt",
    # Tunbridge Wells Borough Council - BBC News
    "c7ry2pm3072t",
    # Trafford Metropolitan Borough Council - BBC News
    "c2n5vw1n224t",
    # Tower Hamlets London Borough Council - BBC News
    "cr5pd6v9p6dt",
    # Thurrock Council - BBC News
    "c2n5vwpp0x7t",
    # Three Rivers District Council - BBC News
    "cz3nmpyrgrmt",
    # Tandridge District Council - BBC News
    "c06zdvnge1zt",
    # Tamworth Borough Council - BBC News
    "cr5pden59kdt",
    # Tameside Metropolitan Borough Council - BBC News
    "cr5pd69r77et",
    # Swindon Borough Council - BBC News
    "c82wmn481ynt",
    # Sutton London Borough Council - BBC News
    "c82wmn28zx5t",
    # Sunderland City Council - BBC News
    "c4e713dvy2wt",
    # Stockport Metropolitan Borough Council - BBC News
    "cn1r2wp78eyt",
    # Stevenage Borough Council - BBC News
    "cz3nm49dx89t",
    # St. Helens Metropolitan Borough Council - BBC News
    "c06zd89x55dt",
    # St Albans City & District Council - BBC News
    "c06zd83769kt",
    # Southwark London Borough Council - BBC News
    "cewngrr2ddyt",
    # Southend-on-Sea Borough Council - BBC News
    "c82wmn4gp01t",
    # South Tyneside Council - BBC News
    "cn1r2wpr38zt",
    # South Lakeland District Council - BBC News
    "cwypryrmyvxt",
    # South Cambridgeshire District Council - BBC News
    "c1v20vnw7n5t",
    # Solihull Metropolitan Borough Council - BBC News
    "c7ry2v3zzz2t",
    # Slough Borough Council - BBC News
    "cewngryvepgt",
    # Sheffield City Council - BBC News
    "c06zd893pd1t",
    # Sefton Metropolitan Borough Council - BBC News
    "cmex9y13vdpt",
    # Sandwell Metropolitan Borough Council - BBC News
    "cdyemzd76ert",
    # Salford City Council - BBC News
    "c82wmn3xr1rt",
    # Rushmoor Borough Council - BBC News
    "cmex9yg23p0t",
    # Runnymede Borough Council - BBC News
    "c51grzv2ep6t",
    # Rugby Borough Council - BBC News
    "c06zd8d3g18t",
    # Rossendale Borough Council - BBC News
    "c82wm9kmynkt",
    # Rochford District Council - BBC News
    "cz3nmpgw3zgt",
    # Rochdale Metropolitan Borough Council - BBC News
    "cv8k1ekkm08t",
    # Richmond upon Thames London Borough Council - BBC News
    "c06zd86my3gt",
    # Reigate and Banstead Borough Council - BBC News
    "c4e714vn4dwt",
    # Redditch Borough Council - BBC News
    "c7ry2v2mez7t",
    # Redbridge London Borough Council - BBC News
    "cv8k1e8x6x4t",
    # Reading Borough Council - BBC News
    "c7ry2vdm586t",
    # Preston City Council - BBC News
    "cmex90p0z3vt",
    # Pendle Borough Council - BBC News
    "cdyem5rexgyt",
    # Oxford City Council - BBC News
    "c95eg29gdp9t",
    # Oldham Council - BBC News
    "c6z8968d08nt",
    # Nuneaton and Bedworth Borough Council - BBC News
    "cr5pd6d7g41t",
    # Norwich City Council - BBC News
    "c95eg26d22yt",
    # North Tyneside Council - BBC News
    "c51gr0gm35pt",
    # North Hertfordshire District Council - BBC News
    "c7ry2v8v7xwt",
    # North East Lincolnshire Council - BBC News
    "cpr6g3e6z15t",
    # Newham London Borough Council - BBC News
    "cmex9y63z2kt",
    # Newcastle under Lyme Council - BBC News
    "c6z89r4r55dt",
    # Newcastle City Council - BBC News
    "c34mxdm59xzt",
    # Mole Valley District Council - BBC News
    "cpr6g3gm81wt",
    # Milton Keynes Council - BBC News
    "c95egx6pve9t",
    # Merton London Borough Council - BBC News
    "cmex9yex6xdt",
    # Manchester City Council - BBC News
    "c7ry2vy7d52t",
    # Maidstone Borough Council - BBC News
    "c06zdv117xxt",
    # Liverpool City Council - BBC News
    "c95egxe339nt",
    # City of Lincoln Council - BBC News
    "cxwp925nzm2t",
    # Lewisham London Borough Council - BBC News
    "cewngrrnky9t",
    # Leeds City Council - BBC News
    "cpr6g37145et",
    # Lambeth London Borough Council - BBC News
    "cmex9yygmvzt",
    # Knowsley Metropolitan Borough Council - BBC News
    "cmex9ydggy3t",
    # Kirklees Council - BBC News
    "cxwp9z34p8zt",
    # Kingston Upon Thames London Borough Council - BBC News
    "cn1r2w6d407t",
    # Kensington and Chelsea London Borough Council - BBC News
    "c82wmnxwn18t",
    # Islington London Borough Council - BBC News
    "cpr6g30ee2rt",
    # Ipswich Borough Council - BBC News
    "cyd025ng43pt",
    # Hyndburn Borough Council - BBC News
    "cg3ndgz6vn3t",
    # Huntingdonshire District Council - BBC News
    "c51gr1rxyr8t",
    # Hounslow London Borough Council - BBC News
    "c1v20ynr140t",
    # Hillingdon London Borough Council - BBC News
    "c7ry2vvenzwt",
    # Havering London Borough Council - BBC News
    "cyd02rr91z8t",
    # Havant Borough Council - BBC News
    "cdyemzpe6d1t",
    # Hastings Borough Council - BBC News
    "c1v20yxy2xvt",
    # Hartlepool Borough Council - BBC News
    "cv8k1ezy9m9t",
    # Hart District Council - BBC News
    "cn1r2w8m645t",
    # Harrow London Borough Council - BBC News
    "c6z8966k3emt",
    # Harrogate Borough Council - BBC News
    "c2n5vx7zw1xt",
    # Harlow District Council - BBC News
    "cz3nmp5y5ggt",
    # Haringey London Borough Council - BBC News
    "ckn41g8zm4pt",
    # Hammersmith and Fulham London Borough Council - BBC News
    "cdyemznv72rt",
    # Halton Borough Council - BBC News
    "cv8k1ezvmg8t",
    # Hackney London Borough Council - BBC News
    "cn1r2wdermgt",
    # Greenwich London Borough Council - BBC News
    "c2n5vwndvv5t",
    # Great Yarmouth Borough Council - BBC News
    "cpr6gnee362t",
    # Gosport Borough Council - BBC News
    "c7ry2v83060t",
    # Gateshead Council - BBC News
    "c4e7135rrr6t",
    # Fareham Borough Council - BBC News
    "cmex9ygmen9t",
    # Exeter City Council - BBC News
    "ckn41gr9d26t",
    # Epping Forest District Council - BBC News
    "c82wmnz23eet",
    # Enfield London Borough Council - BBC News
    "c51gr01kx32t",
    # Elmbridge Borough Council - BBC News
    "cwypr1rx82yt",
    # Eastleigh Borough Council - BBC News
    "c6z896g4m00t",
    # Ealing London Borough Council - BBC News
    "cz3nmp4xwgdt",
    # Dudley Metropolitan Borough Council - BBC News
    "c2n5vw3e1nkt",
    # Daventry District Council - BBC News
    "c06zdv5x905t",
    # Croydon London Borough Council - BBC News
    "cr5pd6e1knkt",
    # Crawley Borough Council - BBC News
    "c51gr0r9r6nt",
    # Craven District Council - BBC News
    "cv8k1pznxw7t",
    # Colchester Borough Council - BBC News
    "c4e713y1wxvt",
    # Wolverhampton City Council - BBC News
    "c7ry2vgwg1pt",
    # Westminster Council - BBC News
    "c7ry2vnx2n5t",
    # Southampton Council - BBC News
    "c34mxdwyr9kt",
    # Portsmouth Council - BBC News
    "c2n5vw68gkpt",
    # Plymouth Council - BBC News
    "c82wmneydegt",
    # Peterborough Council - BBC News
    "c4e713newp7t",
    # Hull Council - BBC News
    "cg3nd2zg937t",
    # Derby City Council - BBC News
    "c1v20ym0z2dt",
    # Chorley Borough Council - BBC News
    "c2n5vx19e7rt",
    # Cherwell District Council - BBC News
    "ckn41dx7dprt",
    # Cheltenham Borough Council - BBC News
    "c6z89r5y0wdt",
    # Castle Point Borough Council - BBC News
    "cz3nmp588gnt",
    # Carlisle City Council - BBC News
    "c82wm2mxrpzt",
    # Cannock Chase Council - BBC News
    "cr5pden698pt",
    # Camden London Borough Council - BBC News
    "ckn41g829e2t",
    # Cambridge City Council - BBC News
    "ckn41n142d2t",
    # Calderdale Council - BBC News
    "c7ry2vg4374t",
    # Bury Metropolitan Borough Council - BBC News
    "c2n5vw38z7vt",
    # Burnley Borough Council - BBC News
    "cv8k1pz74mmt",
    # Broxbourne Borough Council - BBC News
    "c4e713mgrn3t",
    # Bromley London Borough Council - BBC News
    "cwypr193rx1t",
    # Brentwood Borough Council - BBC News
    "cyd02r0dg8rt",
    # Brent London Borough Council - BBC News
    "cewngrr5rmkt",
    # City of Bradford Metropolitan District Council - BBC News
    "c2n5vw3n26nt",
    # Bolton Metropolitan Borough Council - BBC News
    "c82wmn8nz2dt",
    # Blackburn with Darwen Borough Council - BBC News
    "cmex9y5r55pt",
    # Birmingham City Council - BBC News
    "cpr6g35nne1t",
    # Bexley London Borough Council - BBC News
    "c2n5vwne8z1t",
    # Basingstoke and Deane Borough Council - BBC News
    "c1v20y4k60pt",
    # Basildon Borough Council - BBC News
    "c7ry2vg44ykt",
    # Barnsley Metropolitan Borough Council - BBC News
    "cn1r2w32629t",
    # Barnet London Borough Council - BBC News
    "c95egxx8738t",
    # Barking and Dagenham London Borough Council - BBC News
    "c34mxdk2k15t",
    # Amber Valley Borough Council - BBC News
    "cmex9yrk2v8t",
    # Adur District Council - BBC News
    "c6z8969d13mt",
    # England local elections 2018 - BBC News
    "cz3nmp2eyxgt",
    # Buckinghamshire Council - BBC News
    "c8l541jm9pnt",
    # South Northamptonshire Council - BBC News
    "c33p6e694q0t",
    # East Northamptonshire Council - BBC News
    "cjjdnen12lrt",
    # Mayor of Liverpool - BBC News
    "cg699vx7d3et",
    # Mayor of Salford - BBC News
    "c3388lz4l28t",
    # Mayor of North Tyneside - BBC News
    "cpg996d0pzlt",
    # Rotherham Metropolitan Borough Council - BBC News
    "cnjpwmdz92zt",
    # Stroud District Council - BBC News
    "cd63lw8mdpvt",
    # Gloucester City Council - BBC News
    "c6rv64k4n6mt",
    # Purbeck District Council - BBC News
    "c4dmyrl14l9t",
    # Bristol City Council - BBC News
    "cez4j3p4ynet",
    # Warrington Borough Council - BBC News
    "c2jq0m4ezm0t",
    # The UK’s European elections 2019 - BBC News
    "crjeqkdevwvt",
    # European elections 2019 - BBC News
    "c7zzdg3pmgpt",
    # Ards and North Down Borough Council - BBC News
    "cqykv0xmkwdt",
    # Newry City, Mourne and Down District Council - BBC News
    "czmwqn2ne4et",
    # Mid Ulster District Council - BBC News
    "c5xq9w04q72t",
    # Mid and East Antrim Borough Council - BBC News
    "cqykv0x3md4t",
    # Lisburn and Castlereagh City Council - BBC News
    "c0ge2y53wzxt",
    # Fermanagh and Omagh District Council - BBC News
    "cnxkv19pvpgt",
    # Derry City and Strabane District Council - BBC News
    "cgmk73e4ey7t",
    # Causeway Coast and Glens Borough Council - BBC News
    "c7zn73e1le3t",
    # Belfast City Council - BBC News
    "c18230em1n1t",
    # Armagh City, Banbridge and Craigavon Borough Council - BBC News
    "c347gew58gdt",
    # Antrim and Newtownabbey Borough Council - BBC News
    "c4l3n2y73wkt",
    # Folkestone and Hythe District Council - BBC News
    "cgmk7g1732lt",
    # York City Council - BBC News
    "cpzqml8lgpkt",
    # Wyre Council - BBC News
    "cl12w9vmg3pt",
    # Wycombe District Council - BBC News
    "c18k7w37503t",
    # Wychavon District Council - BBC News
    "cl12w9v1zp4t",
    # Windsor and Maidenhead Borough Council - BBC News
    "cgmxyp7mn08t",
    # West Lindsey District Council - BBC News
    "c9041d58yedt",
    # West Devon Borough Council - BBC News
    "ce31z8pky5zt",
    # West Berkshire Council - BBC News
    "cd7dvp1d5gpt",
    # Borough Council of Wellingborough - BBC News
    "c34kq9gk22xt",
    # Wealden District Council - BBC News
    "c9041d54d50t",
    # Waverley Borough Council - BBC News
    "czm0p8qnlv2t",
    # Warwick District Council - BBC News
    "c8yed30qn84t",
    # Vale of White Horse District Council - BBC News
    "c7z58d7wqv4t",
    # Uttlesford District Council - BBC News
    "c7z58d7vywet",
    # Torridge District Council - BBC News
    "c9041d5vev0t",
    # Torbay Council - BBC News
    "cyq4z3w9g41t",
    # Tonbridge and Malling Borough Council - BBC News
    "c5xyng91pnkt",
    # Thanet District Council - BBC News
    "cw7lxw20z9et",
    # Tewkesbury Borough Council - BBC News
    "c9041d5wnp1t",
    # Test Valley Borough Council - BBC News
    "c5xyng90g31t",
    # Tendring District Council - BBC News
    "cvw1lm24dqlt",
    # Telford and Wrekin Borough Council - BBC News
    "cqymn8vdwxqt",
    # Teignbridge District Council - BBC News
    "c34kq9g5ylvt",
    # Swale Borough Council - BBC News
    "czm0p8q8pyqt",
    # Surrey Heath Borough Council - BBC News
    "c34kq9g93q1t",
    # Stratford-on-Avon District Council - BBC News
    "c4lkm7ndzm7t",
    # Stoke-on-Trent City Council - BBC News
    "cd7dvp1xxv5t",
    # Stockton-on-Tees Borough Council - BBC News
    "c18k7w3315qt",
    # Staffordshire Moorlands District Council - BBC News
    "c7z584yyyn5t",
    # Stafford Borough Council - BBC News
    "c0gkw7qq1dzt",
    # Spelthorne Borough Council - BBC News
    "c8yedk5d523t",
    # South Staffordshire Council - BBC News
    "cgmxywqy4wet",
    # South Somerset District Council - BBC News
    "ce31zx2zx2nt",
    # South Ribble Borough Council - BBC News
    "c2dk3q8dyxqt",
    # South Oxfordshire District Council - BBC News
    "c7z584yn8xzt",
    # South Norfolk Council - BBC News
    "ce31zx217wlt",
    # South Kesteven District Council - BBC News
    "c34kqd1e172t",
    # South Holland District Council - BBC News
    "c18k74n05vxt",
    # South Hams District Council - BBC News
    "cw7lxez3w3yt",
    # South Gloucestershire Council - BBC News
    "cx3xvw9k0x8t",
    # South Derbyshire District Council - BBC News
    "c2dk3q8z7zyt",
    # South Bucks District Council - BBC News
    "c2dk3q8ye2kt",
    # Sevenoaks District Council - BBC News
    "c2dk3q8ygpvt",
    # Selby District Council - BBC News
    "cgmxywqnggkt",
    # Sedgemoor District Council - BBC News
    "c4lkmdxg7wnt",
    # Scarborough Borough Council - BBC News
    "cx3xvw9dl17t",
    # Ryedale District Council - BBC News
    "c4lkmdx82g9t",
    # Rutland County Council - BBC News
    "c2dk3q84vxkt",
    # Rushcliffe Borough Council - BBC News
    "c2dk3q8lp27t",
    # Rother District Council - BBC News
    "c4lkmdx14z9t",
    # Richmondshire District Council - BBC News
    "c8yedk51wv2t",
    # Ribble Valley Borough Council - BBC News
    "c2dk3q8v744t",
    # Redcar and Cleveland Borough Council - BBC News
    "c2dk3q82m7lt",
    # Oadby and Wigston Borough Council - BBC News
    "c7z584nenw1t",
    # Nottingham City Council - BBC News
    "c9041g8wxe4t",
    # North West Leicestershire District Council - BBC News
    "ckde2vk95q5t",
    # North Warwickshire Borough Council - BBC News
    "czm0p3w7y02t",
    # North Somerset Council - BBC News
    "c34kqd758vwt",
    # North Norfolk District Council - BBC News
    "cpzqm8k5mx8t",
    # North Lincolnshire Council - BBC News
    "c2dk3qw9247t",
    # North Kesteven District Council - BBC News
    "cl12w4k90q1t",
    # North East Derbyshire District Council - BBC News
    "cqymneke70dt",
    # North Devon Council - BBC News
    "c4lkmd3d8w1t",
    # Newark and Sherwood District Council - BBC News
    "cyq4zg2w03kt",
    # New Forest District Council - BBC News
    "ce31zxkpyqgt",
    # Middlesbrough Borough Council - BBC News
    "c5xyn3yw11kt",
    # Mid Sussex District Council - BBC News
    "ckde2ve5gk8t",
    # Mid Suffolk District Council - BBC News
    "czm0p30kxn0t",
    # Mid Devon District Council - BBC News
    "c4lkmdk537et",
    # Mendip District Council - BBC News
    "cgmxywxg8xlt",
    # Melton Borough Council - BBC News
    "ckde2ve1w21t",
    # Medway Council - BBC News
    "cvw1le1gwv4t",
    # Mansfield District Council - BBC News
    "c2dk3qk41llt",
    # Malvern Hills District Council - BBC News
    "ce31zx1ney8t",
    # Maldon District Council - BBC News
    "ce31zx1y1w0t",
    # Luton Borough Council - BBC News
    "cmlw7pwyv48t",
    # Lichfield District Council - BBC News
    "c34kqdkpxn2t",
    # Lewes District Council - BBC News
    "c4lkmdky3z3t",
    # Leicester City Council - BBC News
    "cgmxywxe9nzt",
    # Lancaster City Council - BBC News
    "cd7dvxd4lxmt",
    # Borough Council of King's Lynn and West Norfolk - BBC News
    "cmlw7pwzvl3t",
    # Horsham District Council - BBC News
    "cmlw7pw8g45t",
    # Hinckley and Bosworth Borough Council - BBC News
    "c34kqdk9qwqt",
    # High Peak Borough Council - BBC News
    "cd7dvxdp9eqt",
    # Hertsmere Borough Council - BBC News
    "c9041g4g1mmt",
    # Herefordshire Council - BBC News
    "c5xyn3y3572t",
    # Harborough District Council - BBC News
    "cd7dvxd1klkt",
    # Hambleton District Council - BBC News
    "cl12w48zm0nt",
    # Guildford Borough Council - BBC News
    "cyq4zgmlnqkt",
    # Gravesham Borough Council - BBC News
    "cl12w48p892t",
    # Gedling Borough Council - BBC News
    "c5xyn3w8mv4t",
    # Fylde Borough Council - BBC News
    "cx3xvwq5z2pt",
    # Forest of Dean District Council - BBC News
    "c18k740mgeet",
    # Fenland District Council - BBC News
    "ckde2vgl84wt",
    # Erewash Borough Council - BBC News
    "ckde2vg8p3nt",
    # Epsom and Ewell Borough Council - BBC News
    "czm0p3n804lt",
    # Eden District Council - BBC News
    "cqymne08vnnt",
    # Eastbourne Borough Council - BBC News
    "czm0p3n381kt",
    # East Staffordshire Borough Council - BBC News
    "ckde2vgm0x5t",
    # East Riding of Yorkshire Council - BBC News
    "c5xyn3w9l3pt",
    # East Lindsey District Council - BBC News
    "cnx73lwyw88t",
    # East Hertfordshire District Council - BBC News
    "cyq4zgkyn1qt",
    # East Hampshire District Council - BBC News
    "c9041gzyzzpt",
    # East Devon District Council - BBC News
    "cvw1ledp44lt",
    # East Cambridgeshire District Council - BBC News
    "c2dk3qz35kgt",
    # Dover District Council - BBC News
    "c2dk3qzwm2vt",
    # Derbyshire Dales District Council - BBC News
    "c9041gz41w7t",
    # Dartford Borough Council - BBC News
    "cpzqm83qglmt",
    # Darlington Borough Council - BBC News
    "cw7lxe13x82t",
    # Dacorum Borough Council - BBC News
    "c5xyn34w1k8t",
    # Cotswold District Council - BBC News
    "cqymneqxp4wt",
    # Copeland Borough Council - BBC News
    "ce31zxge2vlt",
    # Chiltern District Council - BBC News
    "c7z584kg133t",
    # Chichester District Council - BBC News
    "ckde2v5lk2kt",
    # Chesterfield Borough Council - BBC News
    "cx3xvwk47w4t",
    # Cheshire West and Chester Council - BBC News
    "c7z584klwn4t",
    # Cheshire East Council - BBC News
    "cpzqm835vl5t",
    # Chelmsford City Council - BBC News
    "ce31zxg8wx0t",
    # Charnwood Borough Council - BBC News
    "ce31zxg8xy4t",
    # Central Bedfordshire Council - BBC News
    "cvw1ledev3vt",
    # Canterbury City Council - BBC News
    "czm0p3kq544t",
    # Broxtowe Borough Council - BBC News
    "cw7lxedy4g0t",
    # Bromsgrove District Council - BBC News
    "c9041g3n8kyt",
    # Broadland District Council - BBC News
    "c18k74v5m20t",
    # Brighton and Hove City Council - BBC News
    "cmlw7pe3wgmt",
    # Breckland Council - BBC News
    "cgmxywg0pd9t",
    # Braintree District Council - BBC News
    "cpzqm870wmxt",
    # Bracknell Forest Borough Council - BBC News
    "c7z584wxzzlt",
    # Boston Borough Council - BBC News
    "ckde2v04z2wt",
    # Bolsover District Council - BBC News
    "c4lkmd5pwdqt",
    # Blackpool Council - BBC News
    "c18k74v979zt",
    # Blaby District Council - BBC News
    "cyq4zglxnknt",
    # Bedford Borough Council - BBC News
    "c9041g3w3vmt",
    # Bath and North East Somerset Council - BBC News
    "cqymne3d9k9t",
    # Bassetlaw District Council - BBC News
    "c34kqd05n0mt",
    # Barrow Borough Council - BBC News
    "czm0p3lym40t",
    # Babergh District Council - BBC News
    "ckde2v0zg8dt",
    # Aylesbury Vale District Council - BBC News
    "cmlw7p1lpxnt",
    # Ashford Borough Council - BBC News
    "c9041ge8k12t",
    # Ashfield District Council - BBC News
    "cx3xvw0xmymt",
    # Arun District Council - BBC News
    "c0gkw73yz0yt",
    # Allerdale Borough Council - BBC News
    "c0gkgvm4pwgt",
    # West Suffolk Council - BBC News
    "cpzqg374rl1t",
    # Somerset West and Taunton Council - BBC News
    "cjg52102j71t",
    # East Suffolk Council - BBC News
    "czrx0743vknt",
    # Dorset Council - BBC News
    "czrx0741qxjt",
    # Bournemouth, Christchurch and Poole Council - BBC News
    "crx6dnl749jt",
    # Comhairle nan Eilean Siar - BBC News
    "cz4pr2gd5y8t",
    # Suffolk County Council - BBC News
    "cz4pr2gd5xxt",
    # Gwynedd Council - BBC News
    "cz4pr2gd5lxt",
    # South Ayrshire Council - BBC News
    "cywd23g04xlt",
    # Clackmannanshire Council - BBC News
    "cywd23g04vlt",
    # Essex County Council - BBC News
    "cywd23g04mqt",
    # City and County of Swansea Council - BBC News
    "cywd23g04eqt",
    # Midlothian Council - BBC News
    "cx1m7zg0wrqt",
    # Denbighshire County Council - BBC News
    "cx1m7zg0wdvt",
    # Somerset County Council - BBC News
    "cx1m7zg0w4vt",
    # Lancashire County Council - BBC News
    "cwlw3xz01q3t",
    # Isle of Anglesey County Council - BBC News
    "cwlw3xz0183t",
    # East Lothian Council - BBC News
    "cwlw3xz012rt",
    # Rhondda Cynon Taf County Borough Council - BBC News
    "cvenzmgylvdt",
    # East Sussex County Council - BBC News
    "cvenzmgylqdt",
    # Argyll and Bute Council - BBC News
    "cvenzmgyl7rt",
    # Isle of Wight Council - BBC News
    "cvenzmgyl1dt",
    # Shetland Islands Council - BBC News
    "cvenzmgyl0rt",
    # Scottish Borders Council - BBC News
    "crr7mlg0vzlt",
    # Durham County Council - BBC News
    "crr7mlg0vqet",
    # Dorset County Council - BBC News
    "crr7mlg0v4et",
    # Angus Council - BBC News
    "crr7mlg0v3lt",
    # Powys Council - BBC News
    "crr7mlg0v3et",
    # Caerphilly County Borough Council - BBC News
    "cq23pdgvrzmt",
    # Mayor of the Liverpool City Region - BBC News
    "cq23pdgvrxzt",
    # Norfolk County Council - BBC News
    "cq23pdgvremt",
    # Falkirk Council - BBC News
    "cq23pdgvr8zt",
    # Mayor of the West Midlands - BBC News
    "cp7r8vgl2xxt",
    # Carmarthenshire County Council - BBC News
    "cp7r8vgl2qlt",
    # Northamptonshire County Council - BBC News
    "cp7r8vgl2dlt",
    # Glasgow City Council - BBC News
    "cp7r8vgl20xt",
    # Warwickshire County Council - BBC News
    "cnx753jenv8t",
    # Monmouthshire County Council - BBC News
    "cnx753jenp8t",
    # Cambridgeshire County Council - BBC News
    "cnx753jend8t",
    # North Lanarkshire Council - BBC News
    "cnx753jen8jt",
    # Nottinghamshire County Council - BBC News
    "cmj34zmwxr3t",
    # Ceredigion County Council - BBC News
    "cmj34zmwxq3t",
    # Mayor of the West of England - BBC News
    "cmj34zmwxn0t",
    # Highland Council - BBC News
    "cmj34zmwx80t",
    # England local elections 2017 - BBC News
    "cmj34zmwx1lt",
    # West Dunbartonshire Council - BBC News
    "clm1wxp5nz1t",
    # Hampshire County Council - BBC News
    "clm1wxp5nvmt",
    # East Ayrshire Council - BBC News
    "clm1wxp5n81t",
    # Wiltshire Council - BBC News
    "clm1wxp5n2mt",
    # Inverclyde Council - BBC News
    "cjnwl8q4xp7t",
    # Conwy County Borough Council - BBC News
    "cjnwl8q4xm5t",
    # Oxfordshire County Council - BBC News
    "cjnwl8q4x35t",
    # Moray Council - BBC News
    "cg41ylwvxpdt",
    # Flintshire County Council - BBC News
    "cg41ylwvxe8t",
    # Staffordshire County Council - BBC News
    "cg41ylwvx58t",
    # Wales local elections 2017 - BBC News
    "cg41ylwvx45t",
    # Stirling Council - BBC News
    "ce1qrvlexzet",
    # Vale of Glamorgan Council - BBC News
    "ce1qrvlexylt",
    # Hertfordshire County Council - BBC News
    "ce1qrvlexwlt",
    # Dundee City Council - BBC News
    "ce1qrvlexpet",
    # Shropshire Council - BBC News
    "ce1qrvlex5lt",
    # South Lanarkshire Council - BBC News
    "cdl8n2edxz7t",
    # Gloucestershire County Council - BBC News
    "cdl8n2edxwxt",
    # Torfaen County Borough Council - BBC News
    "cdl8n2edxvxt",
    # Dumfries and Galloway Council - BBC News
    "cdl8n2edxp7t",
    # Northumberland County Council - BBC News
    "cdl8n2edx5xt",
    # North Yorkshire County Council - BBC News
    "c8nq32jw8zet",
    # Cardiff Council - BBC News
    "c8nq32jw8xet",
    # Fife Council - BBC News
    "c8nq32jw811t",
    # Mayor of the Tees Valley - BBC News
    "c8nq32jw801t",
    # Derbyshire County Council - BBC News
    "c77jz3mdqnyt",
    # Perth and Kinross Council - BBC News
    "c77jz3mdqlpt",
    # Newport City Council - BBC News
    "c77jz3mdq8yt",
    # Aberdeen City Council - BBC News
    "c77jz3mdq8pt",
    # Worcestershire County Council - BBC News
    "c77jz3mdq5yt",
    # Scotland local elections 2017 - BBC News
    "c50znx8v8m4t",
    # Mayor of Greater Manchester - BBC News
    "c50znx8v4l5t",
    # Bridgend County Borough Council - BBC News
    "c50znx8v4gpt",
    # City of Edinburgh Council - BBC News
    "c50znx8v4d5t",
    # Lincolnshire County Council - BBC News
    "c50znx8v45pt",
    # East Renfrewshire Council - BBC News
    "c40rjmqdwyvt",
    # Blaenau Gwent Council - BBC News
    "c40rjmqdwxmt",
    # Leicestershire County Council - BBC News
    "c40rjmqdwvmt",
    # Mayor of Cambridgeshire & Peterborough - BBC News
    "c40rjmqdwevt",
    # West Sussex County Council - BBC News
    "c302m85q1xdt",
    # Orkney Islands Council - BBC News
    "c302m85q1v0t",
    # Cumbria County Council - BBC News
    "c302m85q1rdt",
    # Neath Port Talbot County Borough Council - BBC News
    "c302m85q1pdt",
    # Wrexham County Borough Council - BBC News
    "c302m85q1p0t",
    # Renfrewshire Council - BBC News
    "c207p54mlrpt",
    # Cornwall Council - BBC News
    "c207p54mlnzt",
    # Pembrokeshire County Council - BBC News
    "c207p54mljzt",
    # Aberdeenshire Council - BBC News
    "c207p54mljpt",
    # Devon County Council - BBC News
    "c207p54ml2zt",
    # West Lothian Council - BBC News
    "c1038wnxevrt",
    # Doncaster Metropolitan Borough Council - BBC News
    "c1038wnxeq1t",
    # Kent County Council - BBC News
    "c1038wnxe71t",
    # East Dunbartonshire Council - BBC News
    "c1038wnxe2rt",
    # Surrey County Council - BBC News
    "c008ql15dxjt",
    # Merthyr Tydfil County Borough Council - BBC News
    "c008ql15djjt",
    # North Ayrshire Council - BBC News
    "c008ql15d7dt"
  ]
