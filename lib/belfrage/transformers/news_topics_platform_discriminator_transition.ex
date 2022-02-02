defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTransition do
  @moduledoc """
  Alters the Platform for a subset of News Topics IDs that need to be served by Mozart.
  """
  use Belfrage.Transformers.Transformer

  @mozart_live_ids [
    "c50znx8v8y4t", # Amazon - BBC News
    "cyzp91yk1ydt", # GameStop - BBC News
    "c8grzynv1mgt", # Moderna - BBC News
    "cdvdx4l9y4xt", # NatWest Group - BBC News
    "clyeyy6464qt", # EuroStoxx 50 - BBC News
    "c10094dkqkrt", # Lyft - BBC News
    "cwwwewx7rrwt", # Jet Airways - BBC News
    "cj1xj07qx9et", # Asos - BBC News
    "c348jz2lex6t", # Superdry - BBC News
    "cxw7q6wwpy8t", # Smurfit Kappa Group - BBC News
    "cdl70lgvlp1t", # French Connection Group - BBC News
    "cj2700dj78kt", # Boohoo - BBC News
    "cqx75jx9955t", # Bloomsbury Publishing - BBC News
    "crd7jvq987kt", # Patisserie Valerie - BBC News
    "cev9zn0ggzpt", # Aston Martin - BBC News
    "cle48gxn6ynt", # Paragon Banking Group - BBC News
    "c2rnyvlkrwlt", # AA - BBC News
    "c514vpxv5llt", # Reach PLC - BBC News
    "cny6mmxwgwgt", # B&M European Value - BBC News
    "c7zl7v00x15t", # Johnson & Johnson - BBC News
    "c0n69181n53t", # Mothercare - BBC News
    "cgdzn8v44jlt", # Gap - BBC News
    "crem2z954ndt", # Saga - BBC News
    "cq265n8m8qqt", # Segro - BBC News
    "c5ewlerdr0kt", # Worldwide Healthcare Trust - BBC News
    "cyn9wwxgewlt", # FirstGroup - BBC News
    "c23p6mx67v8t", # Frasers Group - BBC News
    "cq04218m929t", # Kellogg Company - BBC News
    "cjqx35j92pet", # Lastminute.com - BBC News
    "cpzz7xmjgvwt", # Jumia - BBC News
    "cwjdyzqwqqwt", # Interserve  - BBC News
    "c2q3k34gnw1t", # AT&T - BBC News
    "c91242yylkzt", # AMD - BBC News
    "c025k7k4ex2t", # Zynga - BBC News
    "czlm1nzpzlvt", # Mulberry - BBC News
    "ce7l82zl978t", # London Stock Exchange Group - BBC News
    "ckm4xm64551t", # Workspace Group - BBC News
    "c11le1kp83mt", # Woodford Patient Capital Trust - BBC News
    "cmleylw141et", # Wizz Air - BBC News
    "cy5m75wwmvwt", # Witan Investment Trust - BBC News
    "c704e0kj142t", # William Hill (bookmaker) - BBC News
    "ce8jr869nwkt", # WH Smith - BBC News
    "c11le1xvm4yt", # Wetherspoons - BBC News
    "cq757713q97t", # SSE Composite - BBC News
    "c55p555ng9gt", # Nikkei 225 - BBC News
    "cq75774n157t", # Hang Seng - BBC News
    "cpglgg6zyd0t", # BSE Sensex - BBC News
    "c4dldd02yp3t", # S&P 500 - BBC News
    "c08k88ey6d5t", # NASDAQ - BBC News
    "clyeyy8851qt", # Dow Jones Industrial Average - BBC News
    "cwjzjjz559yt", # CAC 40 - BBC News
    "c34l44l8d48t", # IBEX 35 - BBC News
    "ckwlwwg6507t", # DAX - BBC News
    "clyeyy6q0g4t", # AEX - BBC News
    "cjl3llgk4k2t", # FTSE 250 - BBC News
    "c9qdqqkgz27t", # FTSE 100 - BBC News
    "czzng315j56t", # Vedanta Resources - BBC News
    "czzn8lxng89t", # IWG - BBC News
    "czzn8le8899t", # Ibstock - BBC News
    "czzn8l7l79rt", # Just Eat Takeaway - BBC News
    "czzn89798d5t", # Spectris - BBC News
    "czv6rrldgw8t", # Bank of Georgia - BBC News
    "czv6rr8ljmyt", # Bodycote - BBC News
    "czv6rr2gzket", # Esure - BBC News
    "czv6reey8l5t", # Ascential - BBC News
    "czv6r8w2vqqt", # Nike, Inc. - BBC News
    "czv6r8rnl9jt", # Merlin Entertainments - BBC News
    "czv6r8qrrrwt", # Bunzl - BBC News
    "czv6r8mnjq8t", # Parkmead Group - BBC News
    "czv6r8m2d49t", # Electronic Arts - BBC News
    "czv6r8gdy58t", # Compass Group - BBC News
    "czv6r87zrd2t", # Rentokil Initial - BBC News
    "czv6r86xgqyt", # ConvaTec - BBC News
    "cz4pr2gdgyyt", # Ford - BBC News
    "cz4pr2gd5w0t", # Coca-Cola - BBC News
    "cz4pr2gd52lt", # AstraZeneca - BBC News
    "cywd23g0ggxt", # Marks & Spencer - BBC News
    "cywd23g0g10t", # Burberry Group - BBC News
    "cywd23g04net", # Diageo - BBC News
    "cywd23g04jlt", # National Grid - BBC News
    "cywd23g04g4t", # McDonald's - BBC News
    "cywd23g041et", # Procter & Gamble - BBC News
    "cyn9ww8w6gvt", # F&C Commercial Property Trust - BBC News
    "cyg1qpmrqg1t", # Shaftesbury - BBC News
    "cyg1qpmgp5kt", # Serco - BBC News
    "cyg1q3xl7n4t", # Inchcape - BBC News
    "cyg1q3m48pkt", # Jupiter Fund Management - BBC News
    "cyg1q3e632zt", # NMC Health - BBC News
    "cxw7qqrw8rlt", # Dairy Crest - BBC News
    "cxw7q6m6wxrt", # Shire (pharmaceutical company) - BBC News
    "cxw7q5vrrkwt", # Antofagasta - BBC News
    "cxw7q5qmw24t", # Johnson Matthey - BBC News
    "cxw7q5nn5rxt", # Informa - BBC News
    "cxw7q57v2vkt", # Ferguson - BBC News
    "cxqe2zpqdl5t", # NewRiver - BBC News
    "cxqe2zjerlxt", # Lancashire Holdings - BBC News
    "cxqe2z8rg7gt", # International Public Partnerships - BBC News
    "cxqe2z6mx3jt", # PZ Cussons - BBC News
    "cx1m7zg0g55t", # General Motors - BBC News
    "cx1m7zg0g3nt", # Goldman Sachs - BBC News
    "cx1m7zg0g0lt", # Exxon Mobil - BBC News
    "cwz4ll584r4t", # Diploma - BBC News
    "cwz4ldqpjp8t", # Delta Airlines - BBC News
    "cwz4ldqgy28t", # Activision Blizzard - BBC News
    "cwz4ldl72yxt", # Intertek - BBC News
    "cwz4ld6vzn2t", # British Land - BBC News
    "cwz4ld4el2jt", # G4S - BBC News
    "cwz4l8xj794t", # 3i Infrastructure - BBC News
    "cwlw3xz0zwet", # BT Group - BBC News
    "cwlw3xz0zqet", # Citigroup - BBC News
    "cvl7nqzxe69t", # RELX Group - BBC News
    "cvl7nqn9pr2t", # Mondi - BBC News
    "cvl7nq7wmq8t", # Experian - BBC News
    "cvl7nnr8zdkt", # Cranswick - BBC News
    "cvl7nndm2v7t", # Essentra - BBC News
    "cvl7nn4ypz7t", # Fidelity China Special Situations - BBC News
    "cvl7nn4qpzqt", # James Fisher & Sons - BBC News
    "cvenzmgygg7t", # Ryanair - BBC News
    "cvenzmgyg0lt", # Microsoft - BBC News
    "crr7mlg0vg2t", # Vodafone - BBC News
    "crr7mlg0v1lt", # Netflix - BBC News
    "crr7mlg0gr3t", # Rio Tinto - BBC News
    "crr7mlg0gqqt", # Apple - BBC News
    "crr7mlg0gdnt", # United Utilities - BBC News
    "crjy5mp1l9kt", # Unite Students - BBC News
    "crjy4rnrgyxt", # Sophos - BBC News
    "crjy4rer173t", # Scottish Investment Trust - BBC News
    "crjy47py3g2t", # Pennon Group - BBC News
    "crjy47ndqymt", # Just Group - BBC News
    "crjy47lg55gt", # Perpetual Income & Growth Investment Trust - BBC News
    "crem2z8xexnt", # IGas Energy - BBC News
    "crem2z2m5wqt", # Mediclinic International - BBC News
    "crem2vvvd6vt", # Aberforth Smaller Companies Trust - BBC News
    "crem2vvjkelt", # Aveva - BBC News
    "crem22ydmkvt", # Finsbury Growth & Income Trust - BBC News
    "crem22wmw9dt", # Euromoney Institutional Investor - BBC News
    "crem22wl58zt", # Drax Group - BBC News
    "crem22w5kz5t", # Domino's Pizza Group - BBC News
    "crem22vmy99t", # Computacenter - BBC News
    "crem22v7742t", # Crest Nicholson - BBC News
    "crem22v5ggpt", # CLS Holdings - BBC News
    "cr07g9zzvn9t", # Halfords - BBC News
    "cql8rjpm187t", # Victrex - BBC News
    "cql8rjkmkq9t", # TR Property Investment Trust - BBC News
    "cql8rj8ppj8t", # UDG Healthcare - BBC News
    "cql8qmr9pret", # Polymetal International - BBC News
    "cql8qmp2expt", # PageGroup - BBC News
    "cql8qmmeq4zt", # JPMorgan American Investment Trust - BBC News
    "cql8qm2dkl5t", # KAZ Minerals - BBC News
    "cql8qm223z2t", # Kennedy-Wilson Holdings - BBC News
    "cq265ly55e9t", # Starbucks - BBC News
    "cq2655n5jwvt", # CYBG - BBC News
    "cq2655lgldnt", # N Brown Group - BBC News
    "cq26554x797t", # Electrocomponents - BBC News
    "cq23pdgvglxt", # Pfizer - BBC News
    "cpd6nx35xpdt", # Syncona - BBC News
    "cpd6njnmzmjt", # Pets at Home - BBC News
    "cpd6nj989nmt", # JD Sports - BBC News
    "cpd6nj666zkt", # National Express - BBC News
    "cpd6nj5yq42t", # Intermediate Capital Group - BBC News
    "cpd6nj4x2get", # IMI - BBC News
    "cp7r8vglgwjt", # Royal Mail - BBC News
    "cp7r8vglgljt", # Morgan Stanley - BBC News
    "cp7r8vgl7pzt", # Sky - BBC News
    "cp7r8vgl27rt", # BP - BBC News
    "cp7dmwr82vnt", # Sage Group - BBC News
    "cp7dmw7pppdt", # abrdn - BBC News
    "cp7dmmlnvrmt", # Evraz - BBC News
    "cp7dm4zwg9vt", # Anglo American - BBC News
    "cp7dm4nmm5kt", # InterContinental Hotels Group - BBC News
    "cp7dm4my2wqt", # Land Securities - BBC News
    "cp7dm4dx4lnt", # Hargreaves Lansdown - BBC News
    "cp7dm484262t", # Bank of America - BBC News
    "cp3mv9mvm2jt", # Genus - BBC News
    "cny6mld4y2xt", # Scottish Mortgage Investment Trust - BBC News
    "cnegp9gn1zdt", # Go-Ahead Group - BBC News
    "cnegp95yp05t", # Hastings Insurance - BBC News
    "cnegp95g5g8t", # Entain - BBC News
    "cmj34zmwxjlt", # Facebook - BBC News
    "cmj34zmwx51t", # Twitter - BBC News
    "cm8m14z754et", # HICL Infrastructure Company - BBC News
    "cm6pmmxdnw2t", # Ferrexpo - BBC News
    "cm6pmmerd28t", # Capita - BBC News
    "cm6pmev6zmnt", # Coca-Cola HBC AG - BBC News
    "cm6pmepplmzt", # GKN - BBC News
    "cm6pmejyklvt", # Ashtead Group - BBC News
    "cm1yx7l98g6t", # Ultra Electronics - BBC News
    "cm1ygzmd3rqt", # Intu Properties - BBC News
    "cm1ygplykydt", # Redrow - BBC News
    "cm1yg8d9yg3t", # Spirax-Sarco Engineering - BBC News
    "cm1yg87ggzyt", # Templeton Emerging Markets Investment Trust - BBC News
    "cljev9pz5g4t", # Hansteen Holdings - BBC News
    "cljev9przz1t", # Greggs - BBC News
    "cljev9pn8zrt", # Great Portland Estates - BBC News
    "cljev9p0r1mt", # Grainger - BBC News
    "cljev9d3nylt", # Hays - BBC News
    "cle48g4j4zxt", # Mercantile Investment Trust - BBC News
    "cle482yzymrt", # Spire Healthcare - BBC News
    "cle482myknet", # TBC Bank - BBC News
    "cle4824zl78t", # Travis Perkins - BBC News
    "cle481xnlndt", # The Rank Group - BBC News
    "cle46m8d471t", # ZPG - BBC News
    "cl86mmjpnqpt", # Internal server error - BBC News
    "cl86mmjl62mt", # Close Brothers Group - BBC News
    "cl86mm2e94dt", # British Empire Trust - BBC News
    "cl86mjkkgn6t", # Whitbread - BBC News
    "cl86mjjp7xxt", # Ashmore Group - BBC News
    "cl86m2y7px6t", # Petrobras - BBC News
    "cl86m2gm2w8t", # Pearson - BBC News
    "cl86m26w75pt", # Fresnillo - BBC News
    "ckr6dxrqll7t", # St. James's Place - BBC News
    "ckr6ddmn7p6t", # Fidessa - BBC News
    "ckr6ddkvljmt", # Bellway - BBC News
    "ckr6dd4lm65t", # Britvic - BBC News
    "ckr6dd46d54t", # Centamin - BBC News
    "ckr6dd2kq9nt", # Dechra Pharmaceuticals - BBC News
    "ckr6d48pk46t", # PepsiCo - BBC News
    "ckgj7945n97t", # Homeserve - BBC News
    "ck835j332p2t", # UBM - BBC News
    "ck832qn4q93t", # LondonMetric Property - BBC News
    "ck832q6yn26t", # McCarthy & Stone - BBC News
    "ck832pnxd18t", # Senior - BBC News
    "cjnwl8q4qvjt", # GlaxoSmithKline - BBC News
    "cjnwl8q4nr3t", # JP Morgan - BBC News
    "cjnr4lxend1t", # UK Commercial Property Trust - BBC News
    "cjnr2zl1x6nt", # TalkTalk Group - BBC News
    "cjnr2z5m4rjt", # Synthomer - BBC News
    "cjnr2yxl7znt", # Redefine International - BBC News
    "cj5pdndw4kdt", # Beazley Group - BBC News
    "cj5pde5nvd9t", # TUI Group - BBC News
    "cj5pddewkwmt", # City of London Investment Trust - BBC News
    "cj5pdd6e24et", # Brewin Dolphin - BBC News
    "cj5pd6v524kt", # American Airlines - BBC News
    "cj5pd6m8zxxt", # HP Inc - BBC News
    "cj5pd6gqk4kt", # Intel - BBC News
    "cj5pd678m8rt", # Carnival Corporation - BBC News
    "cj5pd62qyvkt", # Barratt Developments - BBC News
    "cj5pd62kpe6t", # Admiral Group - BBC News
    "cgzj6dm3gj7t", # Stobart Group - BBC News
    "cgzj67jx17et", # Mitie - BBC News
    "cgzj67jnynkt", # Metro Bank (United Kingdom) - BBC News
    "cgv6llkxlm2t", # Berkeley Group Holdings - BBC News
    "cgv6ll59d9wt", # Cairn Energy - BBC News
    "cgv6ll57nmyt", # Capital & Counties Properties - BBC News
    "cgv6l8v27myt", # Smiths Group - BBC News
    "cgv6l889m9et", # Auto Trader Group - BBC News
    "cgv6l542p65t", # Imperial Brands - BBC News
    "cgv6l44yrnjt", # A.G. Barr - BBC News
    "cg5rv92ljgxt", # Howdens Joinery - BBC News
    "cg41ylwvwqgt", # Groupon - BBC News
    "cewrlqz847yt", # Nvidia - BBC News
    "cewrlqz7xygt", # Berkshire Hathaway Inc. - BBC News
    "cewrlqr7eylt", # Croda International - BBC News
    "cewrlqp59x7t", # WPP - BBC News
    "cewrlqm8ylet", # Wood Group - BBC News
    "cewrlqm4wz5t", # Flybe - BBC News
    "cewrlqj4gnzt", # Reckitt Benckiser - BBC News
    "cewrllvp26xt", # Edinburgh Investment Trust - BBC News
    "cewrllqxln2t", # Big Yellow Group - BBC News
    "cewrll5xjnjt", # Clarkson - BBC News
    "cewrll5nz94t", # Cobham - BBC News
    "cewrl5w94e9t", # Taylor Wimpey - BBC News
    "ceq4ejpkjr7t", # NEX Group - BBC News
    "ceq4ej1yxnnt", # Inmarsat - BBC News
    "ceq4ej1lpn6t", # Investec - BBC News
    "ceq4ej122qet", # IP Group - BBC News
    "ce2gzrplynvt", # Hochschild Mining - BBC News
    "ce2gzrp3gxrt", # Hill & Smith - BBC News
    "ce1qrvlexr1t", # Sainsbury's - BBC News
    "ce1qrvlex71t", # Rolls-Royce Holdings - BBC News
    "ce1qrvlex0et", # Walmart - BBC News
    "ce1qrvlelqqt", # Alibaba - BBC News
    "ce1qrvlel2qt", # Severn Trent - BBC News
    "cdz5gv7pwjkt", # Babcock International - BBC News
    "cdz5ggnw7xdt", # Electra Private Equity - BBC News
    "cdnpj79g404t", # Greencoat UK Wind - BBC News
    "cdl8n2edxj7t", # Aviva - BBC News
    "cdl8n2eden0t", # HSBC - BBC News
    "cdl8n2ededdt", # Santander Group - BBC News
    "cd67er3xjmdt", # RPC Group - BBC News
    "cd67elljy34t", # John Laing Infrastructure Fund - BBC News
    "c9jx7qxqy36t", # Tullow Oil - BBC News
    "c9jx7q942xxt", # Vietnam Enterprise Investments - BBC News
    "c9jx2pd38x1t", # JPMorgan Indian Investment Trust - BBC News
    "c9jx2gd4rrkt", # SIG - BBC News
    "c9jx2g48ngdt", # Rotork - BBC News
    "c9edzzqxmkwt", # Elementis - BBC News
    "c9edzzqxjmet", # Entertainment One - BBC News
    "c9edzzm72xjt", # Countryside Properties - BBC News
    "c9edzmmyplkt", # Balfour Beatty - BBC News
    "c9edzm29jmpt", # RSA Insurance Group - BBC News
    "c9edzkzwx2xt", # Legal & General - BBC News
    "c9edzkwe7xrt", # Stagecoach - BBC News
    "c9edzkvlp2gt", # British American Tobacco - BBC News
    "c9edzkd6qket", # Hammerson - BBC News
    "c8z0l18e9pet", # Greene King - BBC News
    "c8nq32jwnelt", # Royal Dutch Shell - BBC News
    "c8nq32jwjqnt", # SSE - BBC News
    "c8nq32jwjnmt", # Tesla - BBC News
    "c8nq32jwjg0t", # Prudential - BBC News
    "c8l6dpnqy7yt", # Ladbrokes Coral - BBC News
    "c8l6dpkpe99t", # Marston's Brewery - BBC News
    "c8l6dp595lxt", # Indivior - BBC News
    "c8l6dp4lym1t", # Personal Assets Trust - BBC News
    "c8l6dp42444t", # Petra Diamonds - BBC News
    "c8l6d3q4jrrt", # Temple Bar Investment Trust - BBC News
    "c8l6d3n7elxt", # Sirius Minerals - BBC News
    "c8l6d37nld6t", # Riverstone Energy - BBC News
    "c8254yp6lwdt", # Provident Financial - BBC News
    "c8254y52gwwt", # DCC - BBC News
    "c82546rw58gt", # Smith & Nephew - BBC News
    "c82546dy7rwt", # WorldPay - BBC News
    "c825469m8pet", # Schroders - BBC News
    "c7d6y2z7rgdt", # Vesuvius - BBC News
    "c7d65xmmr36t", # RIT Capital Partners - BBC News
    "c7d65x9j4m7t", # Softcat - BBC News
    "c7d65kz8285t", # PayPoint - BBC News
    "c7d65kym7jkt", # Qinetiq - BBC News
    "c7d65kyk9yrt", # Polypipe - BBC News
    "c7d65kqy9j3t", # IG Group - BBC News
    "c7d65k8m5kxt", # Meggitt - BBC News
    "c7d65k4dr79t", # John Laing Group - BBC News
    "c7d651zyy1xt", # Renewables Infrastructure Group - BBC News
    "c77jz3mdqwpt", # IBM - BBC News
    "c77jz3mdmy3t", # IAG - BBC News
    "c77jz3mdmlvt", # Tesco - BBC News
    "c779ee6r7yxt", # BTG - BBC News
    "c779ee665mwt", # Booker Group - BBC News
    "c779e88zj2nt", # Alliance Trust - BBC News
    "c779e6kl2y5t", # Randgold Resources - BBC News
    "c779e6gmpzrt", # Flutter Entertainment - BBC News
    "c779e6gjd6zt", # Old Mutual - BBC News
    "c734jd19gvkt", # Hunting - BBC News
    "c6y3erpprq9t", # DS Smith - BBC News
    "c6y3erj582qt", # Savills - BBC News
    "c6y3erj1m4pt", # Rightmove - BBC News
    "c6y3erggy4et", # Ted Baker - BBC News
    "c6y3er39zlxt", # TP ICAP - BBC News
    "c6y3ekxnyd6t", # Melrose Industries - BBC News
    "c6y3eknjy61t", # P2P Global Investments - BBC News
    "c6y3ekn87zqt", # Northgate - BBC News
    "c6y3ekjkqnmt", # JPMorgan Emerging Markets Investment Trust - BBC News
    "c6y3e1l946lt", # Renishaw - BBC News
    "c6mk28y4dw7t", # Weir Group - BBC News
    "c6mk28n8x6kt", # Persimmon - BBC News
    "c6mk28llrk7t", # United Airlines - BBC News
    "c6mk2822l94t", # Micro Focus - BBC News
    "c6mk22wymldt", # Dunelm Group - BBC News
    "c6mk22wr96kt", # Dignity - BBC News
    "c6mk228z8xlt", # Caledonia Investments - BBC News
    "c5y4pr4me8wt", # CRH - BBC News
    "c5y4pp57rpyt", # Cineworld - BBC News
    "c5y4p555e6qt", # Acacia Mining - BBC News
    "c5x2rqzxdjpt", # Vectura Group - BBC News
    "c5x2p78ndqgt", # St. Modwen Properties - BBC News
    "c5x2p4ke9lxt", # Man Group - BBC News
    "c5x2p42qr1mt", # Murray International Trust - BBC News
    "c5x2p42knryt", # Moneysupermarket.com - BBC News
    "c5x2p428re7t", # Morgan Advanced Materials - BBC News
    "c5x2p428gnkt", # Monks Investment Trust - BBC News
    "c5x2p421yj3t", # Mitchells & Butlers - BBC News
    "c5x2p1z8x4lt", # Rathbone Brothers - BBC News
    "c5elzyl8ze7t", # Genesis Emerging Markets Fund - BBC News
    "c5elzyl58xjt", # GCP Infrastructure Investments - BBC News
    "c50znx8v8z4t", # Glencore - BBC News
    "c50znx8v8j4t", # PayPal - BBC News
    "c50znx8v421t", # Alphabet - BBC News
    "c48yr0yx42nt", # Galliford Try - BBC News
    "c48yr0xgprjt", # Grafton Group - BBC News
    "c48yr0p2z08t", # Hiscox - BBC News
    "c46zqql55r4t", # Derwent London - BBC News
    "c46zqqj4ypwt", # Fidelity European Values - BBC News
    "c46zqq524e4t", # Card Factory - BBC News
    "c46zqeqy52et", # BBA Aviation - BBC News
    "c46zqeenew5t", # Bankers Investment Trust - BBC News
    "c46zqddr25et", # Assura - BBC News
    "c416ndyn2xdt", # Marshalls - BBC News
    "c416ndm1r9qt", # Playtech - BBC News
    "c416n3k3156t", # Thomas Cook Group - BBC News
    "c416n3gddg8t", # Restaurant Group - BBC News
    "c416n381d13t", # SSP Group - BBC News
    "c416mkqj681t", # Tritax Big Box REIT - BBC News
    "c40rjmqdww3t", # Lloyds Banking Group - BBC News
    "c40rjmqdw2vt", # Disney - BBC News
    "c40rjmqdqvlt", # Unilever - BBC News
    "c40rjmqd0pgt", # Boeing - BBC News
    "c40rjmqd0ggt", # Kingfisher - BBC News
    "c348jzqj411t", # Sanne Group - BBC News
    "c348jdx1pq9t", # Phoenix Group - BBC News
    "c348jd8984rt", # Millennium & Copthorne Hotels - BBC News
    "c340rzx790jt", # Greencore - BBC News
    "c340rzp8p08t", # Hikma Pharmaceuticals - BBC News
    "c302m85q5xjt", # Ocado - BBC News
    "c302m85q5m3t", # Royal Bank of Scotland - BBC News
    "c302m85q57zt", # BAE Systems - BBC News
    "c302m85q52jt", # Easyjet - BBC News
    "c302m85q170t", # Barclays - BBC News
    "c302m85q0w3t", # Centrica - BBC News
    "c2rnyyjmww6t", # FDM Group - BBC News
    "c2rnyvvjjygt", # Aggreko - BBC News
    "c2rnyqnqvv8t", # Direct Line Group - BBC News
    "c2rnyqkew57t", # JPI Media - BBC News
    "c2rnyqdrvqnt", # 3i Group - BBC News
    "c2gze4pm7k4t", # Halma - BBC News
    "c28glxrr4qnt", # Telecom Plus - BBC News
    "c28glx6rl3kt", # Safestore - BBC News
    "c28gldjmjq1t", # Nostrum Oil & Gas - BBC News
    "c28gld9nyzqt", # Jardine Lloyd Thompson - BBC News
    "c28gld42313t", # Polar Capital Technology Trust - BBC News
    "c28gld3zeg2t", # Petrofac - BBC News
    "c207p54m4lnt", # Associated British Foods - BBC News
    "c207p54m4det", # Morrisons - BBC News
    "c207p54m485t", # Standard Chartered - BBC News
    "c1nxez79n95t", # Tate & Lyle - BBC News
    "c1nxedyylz1t", # Kier Group - BBC News
    "c1nxedl1j77t", # OneSavings Bank - BBC News
    "c1038wnxnp7t", # Currys - BBC News
    "c1038wnxnmpt", # eBay - BBC News
    "c1038wnxezrt", # General Electric - BBC News
    "c008ql15ddgt", # Blackberry - BBC News
    "c008ql151q8t", # ITV - BBC News
    "c008ql151lwt", # Next - BBC News
    "cmjpj223708t", # Oil - BBC News
    "cwjzj55q2p3t", # Gold - BBC News
    "cxwdwz5d8gxt", # Natural gas - BBC News
    "cx250jmk4e7t", # Pound Sterling (GBP) - BBC News
    "ce2gz75e8g0t", # Euro (EUR) - BBC News
    "cljevy2yz5lt", # US Dollar (USD) - BBC News
    "cleld6gp05et", # Japanese Yen (JPY) - BBC News
    "ckn41gy8p59t", # Coventry City Council - BBC News
    "c5nwpzkn523t", # North Northamptonshire Council - BBC News
    "c008ql15d3jt", # Buckinghamshire County Council - BBC News
    "cxq3k9pj1kqt", # West Northamptonshire Council - BBC News
    "c7rmp6p1vz1t", # Mayor of London - BBC News
    "c27kz1m3j9mt", # London elections 2021 - BBC News
    "c37d28xdn99t", # Scottish Parliament election 2021 - BBC News
    "cqwn14k92zwt", # Welsh Parliament election 2021 - BBC News
    "c481drqqzv7t", # England local elections 2021 - BBC News
    "cm24v76zl6rt", # Mayor of Bristol - BBC News
    "c27e3401kdet", # Mayor of Doncaster - BBC News
    "crx9762gl4pt", # Mayor of West Yorkshire - BBC News
    "ceeqy0e9894t", # England local elections 2019 - BBC News
    "cj736r74vq9t", # Northern Ireland local elections 2019 - BBC News
    "c95egxg00kpt", # Wyre Forest District Council - BBC News
    "c95egxge58gt", # Worthing Borough Council - BBC News
    "cxwp9z984xyt", # Worcester City Council - BBC News
    "cpr6g3dzwr8t", # Wokingham Borough Council - BBC News
    "c51grzvnevvt", # Woking Borough Council - BBC News
    "cewngre8686t", # Wirral Metropolitan Borough Council - BBC News
    "cz3nmpykrnvt", # Winchester City Council - BBC News
    "cxwp9znd7k0t", # Wigan Metropolitan Borough Council - BBC News
    "cwypr9e60edt", # West Oxfordshire District Council - BBC News
    "cmex905py9vt", # West Lancashire Borough Council - BBC News
    "cwypr17yndyt", # Welwyn Hatfield Borough Council - BBC News
    "c82wmng7xpyt", # Watford Borough Council - BBC News
    "cv8k1e8g5dwt", # Wandsworth London Borough Council - BBC News
    "cdyemzy7w0dt", # Waltham Forest London Borough Council - BBC News
    "cyd02rve9vnt", # Walsall Metropolitan Borough Council - BBC News
    "c82wmn76d1nt", # Wakefield Metropolitan District Council - BBC News
    "c7ry2pm3072t", # Tunbridge Wells Borough Council - BBC News
    "c2n5vw1n224t", # Trafford Metropolitan Borough Council - BBC News
    "cr5pd6v9p6dt", # Tower Hamlets London Borough Council - BBC News
    "c2n5vwpp0x7t", # Thurrock Council - BBC News
    "cz3nmpyrgrmt", # Three Rivers District Council - BBC News
    "c06zdvnge1zt", # Tandridge District Council - BBC News
    "cr5pden59kdt", # Tamworth Borough Council - BBC News
    "cr5pd69r77et", # Tameside Metropolitan Borough Council - BBC News
    "c82wmn481ynt", # Swindon Borough Council - BBC News
    "c82wmn28zx5t", # Sutton London Borough Council - BBC News
    "c4e713dvy2wt", # Sunderland City Council - BBC News
    "cn1r2wp78eyt", # Stockport Metropolitan Borough Council - BBC News
    "cz3nm49dx89t", # Stevenage Borough Council - BBC News
    "c06zd89x55dt", # St. Helens Metropolitan Borough Council - BBC News
    "c06zd83769kt", # St Albans City & District Council - BBC News
    "cewngrr2ddyt", # Southwark London Borough Council - BBC News
    "c82wmn4gp01t", # Southend-on-Sea Borough Council - BBC News
    "cn1r2wpr38zt", # South Tyneside Council - BBC News
    "cwypryrmyvxt", # South Lakeland District Council - BBC News
    "c1v20vnw7n5t", # South Cambridgeshire District Council - BBC News
    "c7ry2v3zzz2t", # Solihull Metropolitan Borough Council - BBC News
    "cewngryvepgt", # Slough Borough Council - BBC News
    "c06zd893pd1t", # Sheffield City Council - BBC News
    "cmex9y13vdpt", # Sefton Metropolitan Borough Council - BBC News
    "cdyemzd76ert", # Sandwell Metropolitan Borough Council - BBC News
    "c82wmn3xr1rt", # Salford City Council - BBC News
    "cmex9yg23p0t", # Rushmoor Borough Council - BBC News
    "c51grzv2ep6t", # Runnymede Borough Council - BBC News
    "c06zd8d3g18t", # Rugby Borough Council - BBC News
    "c82wm9kmynkt", # Rossendale Borough Council - BBC News
    "cz3nmpgw3zgt", # Rochford District Council - BBC News
    "cv8k1ekkm08t", # Rochdale Metropolitan Borough Council - BBC News
    "c06zd86my3gt", # Richmond upon Thames London Borough Council - BBC News
    "c4e714vn4dwt", # Reigate and Banstead Borough Council - BBC News
    "c7ry2v2mez7t", # Redditch Borough Council - BBC News
    "cv8k1e8x6x4t", # Redbridge London Borough Council - BBC News
    "c7ry2vdm586t", # Reading Borough Council - BBC News
    "cmex90p0z3vt", # Preston City Council - BBC News
    "cdyem5rexgyt", # Pendle Borough Council - BBC News
    "c95eg29gdp9t", # Oxford City Council - BBC News
    "c6z8968d08nt", # Oldham Council - BBC News
    "cr5pd6d7g41t", # Nuneaton and Bedworth Borough Council - BBC News
    "c95eg26d22yt", # Norwich City Council - BBC News
    "c51gr0gm35pt", # North Tyneside Council - BBC News
    "c7ry2v8v7xwt", # North Hertfordshire District Council - BBC News
    "cpr6g3e6z15t", # North East Lincolnshire Council - BBC News
    "cmex9y63z2kt", # Newham London Borough Council - BBC News
    "c6z89r4r55dt", # Newcastle under Lyme Council - BBC News
    "c34mxdm59xzt", # Newcastle City Council - BBC News
    "cpr6g3gm81wt", # Mole Valley District Council - BBC News
    "c95egx6pve9t", # Milton Keynes Council - BBC News
    "cmex9yex6xdt", # Merton London Borough Council - BBC News
    "c7ry2vy7d52t", # Manchester City Council - BBC News
    "c06zdv117xxt", # Maidstone Borough Council - BBC News
    "c95egxe339nt", # Liverpool City Council - BBC News
    "cxwp925nzm2t", # City of Lincoln Council - BBC News
    "cewngrrnky9t", # Lewisham London Borough Council - BBC News
    "cpr6g37145et", # Leeds City Council - BBC News
    "cmex9yygmvzt", # Lambeth London Borough Council - BBC News
    "cmex9ydggy3t", # Knowsley Metropolitan Borough Council - BBC News
    "cxwp9z34p8zt", # Kirklees Council - BBC News
    "cn1r2w6d407t", # Kingston Upon Thames London Borough Council - BBC News
    "c82wmnxwn18t", # Kensington and Chelsea London Borough Council - BBC News
    "cpr6g30ee2rt", # Islington London Borough Council - BBC News
    "cyd025ng43pt", # Ipswich Borough Council - BBC News
    "cg3ndgz6vn3t", # Hyndburn Borough Council - BBC News
    "c51gr1rxyr8t", # Huntingdonshire District Council - BBC News
    "c1v20ynr140t", # Hounslow London Borough Council - BBC News
    "c7ry2vvenzwt", # Hillingdon London Borough Council - BBC News
    "cyd02rr91z8t", # Havering London Borough Council - BBC News
    "cdyemzpe6d1t", # Havant Borough Council - BBC News
    "c1v20yxy2xvt", # Hastings Borough Council - BBC News
    "cv8k1ezy9m9t", # Hartlepool Borough Council - BBC News
    "cn1r2w8m645t", # Hart District Council - BBC News
    "c6z8966k3emt", # Harrow London Borough Council - BBC News
    "c2n5vx7zw1xt", # Harrogate Borough Council - BBC News
    "cz3nmp5y5ggt", # Harlow District Council - BBC News
    "ckn41g8zm4pt", # Haringey London Borough Council - BBC News
    "cdyemznv72rt", # Hammersmith and Fulham London Borough Council - BBC News
    "cv8k1ezvmg8t", # Halton Borough Council - BBC News
    "cn1r2wdermgt", # Hackney London Borough Council - BBC News
    "c2n5vwndvv5t", # Greenwich London Borough Council - BBC News
    "cpr6gnee362t", # Great Yarmouth Borough Council - BBC News
    "c7ry2v83060t", # Gosport Borough Council - BBC News
    "c4e7135rrr6t", # Gateshead Council - BBC News
    "cmex9ygmen9t", # Fareham Borough Council - BBC News
    "ckn41gr9d26t", # Exeter City Council - BBC News
    "c82wmnz23eet", # Epping Forest District Council - BBC News
    "c51gr01kx32t", # Enfield London Borough Council - BBC News
    "cwypr1rx82yt", # Elmbridge Borough Council - BBC News
    "c6z896g4m00t", # Eastleigh Borough Council - BBC News
    "cz3nmp4xwgdt", # Ealing London Borough Council - BBC News
    "c2n5vw3e1nkt", # Dudley Metropolitan Borough Council - BBC News
    "c06zdv5x905t", # Daventry District Council - BBC News
    "cr5pd6e1knkt", # Croydon London Borough Council - BBC News
    "c51gr0r9r6nt", # Crawley Borough Council - BBC News
    "cv8k1pznxw7t", # Craven District Council - BBC News
    "c4e713y1wxvt", # Colchester Borough Council - BBC News
    "c7ry2vgwg1pt", # Wolverhampton City Council - BBC News
    "c7ry2vnx2n5t", # Westminster Council - BBC News
    "c34mxdwyr9kt", # Southampton Council - BBC News
    "c2n5vw68gkpt", # Portsmouth Council - BBC News
    "c82wmneydegt", # Plymouth Council - BBC News
    "c4e713newp7t", # Peterborough Council - BBC News
    "cg3nd2zg937t", # Hull Council - BBC News
    "c1v20ym0z2dt", # Derby City Council - BBC News
    "c2n5vx19e7rt", # Chorley Borough Council - BBC News
    "ckn41dx7dprt", # Cherwell District Council - BBC News
    "c6z89r5y0wdt", # Cheltenham Borough Council - BBC News
    "cz3nmp588gnt", # Castle Point Borough Council - BBC News
    "c82wm2mxrpzt", # Carlisle City Council - BBC News
    "cr5pden698pt", # Cannock Chase Council - BBC News
    "ckn41g829e2t", # Camden London Borough Council - BBC News
    "ckn41n142d2t", # Cambridge City Council - BBC News
    "c7ry2vg4374t", # Calderdale Council - BBC News
    "c2n5vw38z7vt", # Bury Metropolitan Borough Council - BBC News
    "cv8k1pz74mmt", # Burnley Borough Council - BBC News
    "c4e713mgrn3t", # Broxbourne Borough Council - BBC News
    "cwypr193rx1t", # Bromley London Borough Council - BBC News
    "cyd02r0dg8rt", # Brentwood Borough Council - BBC News
    "cewngrr5rmkt", # Brent London Borough Council - BBC News
    "c2n5vw3n26nt", # City of Bradford Metropolitan District Council - BBC News
    "c82wmn8nz2dt", # Bolton Metropolitan Borough Council - BBC News
    "cmex9y5r55pt", # Blackburn with Darwen Borough Council - BBC News
    "cpr6g35nne1t", # Birmingham City Council - BBC News
    "c2n5vwne8z1t", # Bexley London Borough Council - BBC News
    "c1v20y4k60pt", # Basingstoke and Deane Borough Council - BBC News
    "c7ry2vg44ykt", # Basildon Borough Council - BBC News
    "cn1r2w32629t", # Barnsley Metropolitan Borough Council - BBC News
    "c95egxx8738t", # Barnet London Borough Council - BBC News
    "c34mxdk2k15t", # Barking and Dagenham London Borough Council - BBC News
    "cmex9yrk2v8t", # Amber Valley Borough Council - BBC News
    "c6z8969d13mt", # Adur District Council - BBC News
    "cz3nmp2eyxgt", # England local elections 2018 - BBC News
    "c8l541jm9pnt", # Buckinghamshire Council - BBC News
    "c33p6e694q0t", # South Northamptonshire Council - BBC News
    "cjjdnen12lrt", # East Northamptonshire Council - BBC News
    "cg699vx7d3et", # Mayor of Liverpool - BBC News
    "c3388lz4l28t", # Mayor of Salford - BBC News
    "cpg996d0pzlt", # Mayor of North Tyneside - BBC News
    "cnjpwmdz92zt", # Rotherham Metropolitan Borough Council - BBC News
    "cd63lw8mdpvt", # Stroud District Council - BBC News
    "c6rv64k4n6mt", # Gloucester City Council - BBC News
    "c4dmyrl14l9t", # Purbeck District Council - BBC News
    "cez4j3p4ynet", # Bristol City Council - BBC News
    "c2jq0m4ezm0t", # Warrington Borough Council - BBC News
    "crjeqkdevwvt", # The UK’s European elections 2019 - BBC News
    "c7zzdg3pmgpt", # European elections 2019 - BBC News
    "cqykv0xmkwdt", # Ards and North Down Borough Council - BBC News
    "czmwqn2ne4et", # Newry City, Mourne and Down District Council - BBC News
    "c5xq9w04q72t", # Mid Ulster District Council - BBC News
    "cqykv0x3md4t", # Mid and East Antrim Borough Council - BBC News
    "c0ge2y53wzxt", # Lisburn and Castlereagh City Council - BBC News
    "cnxkv19pvpgt", # Fermanagh and Omagh District Council - BBC News
    "cgmk73e4ey7t", # Derry City and Strabane District Council - BBC News
    "c7zn73e1le3t", # Causeway Coast and Glens Borough Council - BBC News
    "c18230em1n1t", # Belfast City Council - BBC News
    "c347gew58gdt", # Armagh City, Banbridge and Craigavon Borough Council - BBC News
    "c4l3n2y73wkt", # Antrim and Newtownabbey Borough Council - BBC News
    "cgmk7g1732lt", # Folkestone and Hythe District Council - BBC News
    "cpzqml8lgpkt", # York City Council - BBC News
    "cl12w9vmg3pt", # Wyre Council - BBC News
    "c18k7w37503t", # Wycombe District Council - BBC News
    "cl12w9v1zp4t", # Wychavon District Council - BBC News
    "cgmxyp7mn08t", # Windsor and Maidenhead Borough Council - BBC News
    "c9041d58yedt", # West Lindsey District Council - BBC News
    "ce31z8pky5zt", # West Devon Borough Council - BBC News
    "cd7dvp1d5gpt", # West Berkshire Council - BBC News
    "c34kq9gk22xt", # Borough Council of Wellingborough - BBC News
    "c9041d54d50t", # Wealden District Council - BBC News
    "czm0p8qnlv2t", # Waverley Borough Council - BBC News
    "c8yed30qn84t", # Warwick District Council - BBC News
    "c7z58d7wqv4t", # Vale of White Horse District Council - BBC News
    "c7z58d7vywet", # Uttlesford District Council - BBC News
    "c9041d5vev0t", # Torridge District Council - BBC News
    "cyq4z3w9g41t", # Torbay Council - BBC News
    "c5xyng91pnkt", # Tonbridge and Malling Borough Council - BBC News
    "cw7lxw20z9et", # Thanet District Council - BBC News
    "c9041d5wnp1t", # Tewkesbury Borough Council - BBC News
    "c5xyng90g31t", # Test Valley Borough Council - BBC News
    "cvw1lm24dqlt", # Tendring District Council - BBC News
    "cqymn8vdwxqt", # Telford and Wrekin Borough Council - BBC News
    "c34kq9g5ylvt", # Teignbridge District Council - BBC News
    "czm0p8q8pyqt", # Swale Borough Council - BBC News
    "c34kq9g93q1t", # Surrey Heath Borough Council - BBC News
    "c4lkm7ndzm7t", # Stratford-on-Avon District Council - BBC News
    "cd7dvp1xxv5t", # Stoke-on-Trent City Council - BBC News
    "c18k7w3315qt", # Stockton-on-Tees Borough Council - BBC News
    "c7z584yyyn5t", # Staffordshire Moorlands District Council - BBC News
    "c0gkw7qq1dzt", # Stafford Borough Council - BBC News
    "c8yedk5d523t", # Spelthorne Borough Council - BBC News
    "cgmxywqy4wet", # South Staffordshire Council - BBC News
    "ce31zx2zx2nt", # South Somerset District Council - BBC News
    "c2dk3q8dyxqt", # South Ribble Borough Council - BBC News
    "c7z584yn8xzt", # South Oxfordshire District Council - BBC News
    "ce31zx217wlt", # South Norfolk Council - BBC News
    "c34kqd1e172t", # South Kesteven District Council - BBC News
    "c18k74n05vxt", # South Holland District Council - BBC News
    "cw7lxez3w3yt", # South Hams District Council - BBC News
    "cx3xvw9k0x8t", # South Gloucestershire Council - BBC News
    "c2dk3q8z7zyt", # South Derbyshire District Council - BBC News
    "c2dk3q8ye2kt", # South Bucks District Council - BBC News
    "c2dk3q8ygpvt", # Sevenoaks District Council - BBC News
    "cgmxywqnggkt", # Selby District Council - BBC News
    "c4lkmdxg7wnt", # Sedgemoor District Council - BBC News
    "cx3xvw9dl17t", # Scarborough Borough Council - BBC News
    "c4lkmdx82g9t", # Ryedale District Council - BBC News
    "c2dk3q84vxkt", # Rutland County Council - BBC News
    "c2dk3q8lp27t", # Rushcliffe Borough Council - BBC News
    "c4lkmdx14z9t", # Rother District Council - BBC News
    "c8yedk51wv2t", # Richmondshire District Council - BBC News
    "c2dk3q8v744t", # Ribble Valley Borough Council - BBC News
    "c2dk3q82m7lt", # Redcar and Cleveland Borough Council - BBC News
    "c7z584nenw1t", # Oadby and Wigston Borough Council - BBC News
    "c9041g8wxe4t", # Nottingham City Council - BBC News
    "ckde2vk95q5t", # North West Leicestershire District Council - BBC News
    "czm0p3w7y02t", # North Warwickshire Borough Council - BBC News
    "c34kqd758vwt", # North Somerset Council - BBC News
    "cpzqm8k5mx8t", # North Norfolk District Council - BBC News
    "c2dk3qw9247t", # North Lincolnshire Council - BBC News
    "cl12w4k90q1t", # North Kesteven District Council - BBC News
    "cqymneke70dt", # North East Derbyshire District Council - BBC News
    "c4lkmd3d8w1t", # North Devon Council - BBC News
    "cyq4zg2w03kt", # Newark and Sherwood District Council - BBC News
    "ce31zxkpyqgt", # New Forest District Council - BBC News
    "c5xyn3yw11kt", # Middlesbrough Borough Council - BBC News
    "ckde2ve5gk8t", # Mid Sussex District Council - BBC News
    "czm0p30kxn0t", # Mid Suffolk District Council - BBC News
    "c4lkmdk537et", # Mid Devon District Council - BBC News
    "cgmxywxg8xlt", # Mendip District Council - BBC News
    "ckde2ve1w21t", # Melton Borough Council - BBC News
    "cvw1le1gwv4t", # Medway Council - BBC News
    "c2dk3qk41llt", # Mansfield District Council - BBC News
    "ce31zx1ney8t", # Malvern Hills District Council - BBC News
    "ce31zx1y1w0t", # Maldon District Council - BBC News
    "cmlw7pwyv48t", # Luton Borough Council - BBC News
    "c34kqdkpxn2t", # Lichfield District Council - BBC News
    "c4lkmdky3z3t", # Lewes District Council - BBC News
    "cgmxywxe9nzt", # Leicester City Council - BBC News
    "cd7dvxd4lxmt", # Lancaster City Council - BBC News
    "cmlw7pwzvl3t", # Borough Council of King's Lynn and West Norfolk - BBC News
    "cmlw7pw8g45t", # Horsham District Council - BBC News
    "c34kqdk9qwqt", # Hinckley and Bosworth Borough Council - BBC News
    "cd7dvxdp9eqt", # High Peak Borough Council - BBC News
    "c9041g4g1mmt", # Hertsmere Borough Council - BBC News
    "c5xyn3y3572t", # Herefordshire Council - BBC News
    "cd7dvxd1klkt", # Harborough District Council - BBC News
    "cl12w48zm0nt", # Hambleton District Council - BBC News
    "cyq4zgmlnqkt", # Guildford Borough Council - BBC News
    "cl12w48p892t", # Gravesham Borough Council - BBC News
    "c5xyn3w8mv4t", # Gedling Borough Council - BBC News
    "cx3xvwq5z2pt", # Fylde Borough Council - BBC News
    "c18k740mgeet", # Forest of Dean District Council - BBC News
    "ckde2vgl84wt", # Fenland District Council - BBC News
    "ckde2vg8p3nt", # Erewash Borough Council - BBC News
    "czm0p3n804lt", # Epsom and Ewell Borough Council - BBC News
    "cqymne08vnnt", # Eden District Council - BBC News
    "czm0p3n381kt", # Eastbourne Borough Council - BBC News
    "ckde2vgm0x5t", # East Staffordshire Borough Council - BBC News
    "c5xyn3w9l3pt", # East Riding of Yorkshire Council - BBC News
    "cnx73lwyw88t", # East Lindsey District Council - BBC News
    "cyq4zgkyn1qt", # East Hertfordshire District Council - BBC News
    "c9041gzyzzpt", # East Hampshire District Council - BBC News
    "cvw1ledp44lt", # East Devon District Council - BBC News
    "c2dk3qz35kgt", # East Cambridgeshire District Council - BBC News
    "c2dk3qzwm2vt", # Dover District Council - BBC News
    "c9041gz41w7t", # Derbyshire Dales District Council - BBC News
    "cpzqm83qglmt", # Dartford Borough Council - BBC News
    "cw7lxe13x82t", # Darlington Borough Council - BBC News
    "c5xyn34w1k8t", # Dacorum Borough Council - BBC News
    "cqymneqxp4wt", # Cotswold District Council - BBC News
    "ce31zxge2vlt", # Copeland Borough Council - BBC News
    "c7z584kg133t", # Chiltern District Council - BBC News
    "ckde2v5lk2kt", # Chichester District Council - BBC News
    "cx3xvwk47w4t", # Chesterfield Borough Council - BBC News
    "c7z584klwn4t", # Cheshire West and Chester Council - BBC News
    "cpzqm835vl5t", # Cheshire East Council - BBC News
    "ce31zxg8wx0t", # Chelmsford City Council - BBC News
    "ce31zxg8xy4t", # Charnwood Borough Council - BBC News
    "cvw1ledev3vt", # Central Bedfordshire Council - BBC News
    "czm0p3kq544t", # Canterbury City Council - BBC News
    "cw7lxedy4g0t", # Broxtowe Borough Council - BBC News
    "c9041g3n8kyt", # Bromsgrove District Council - BBC News
    "c18k74v5m20t", # Broadland District Council - BBC News
    "cmlw7pe3wgmt", # Brighton and Hove City Council - BBC News
    "cgmxywg0pd9t", # Breckland Council - BBC News
    "cpzqm870wmxt", # Braintree District Council - BBC News
    "c7z584wxzzlt", # Bracknell Forest Borough Council - BBC News
    "ckde2v04z2wt", # Boston Borough Council - BBC News
    "c4lkmd5pwdqt", # Bolsover District Council - BBC News
    "c18k74v979zt", # Blackpool Council - BBC News
    "cyq4zglxnknt", # Blaby District Council - BBC News
    "c9041g3w3vmt", # Bedford Borough Council - BBC News
    "cqymne3d9k9t", # Bath and North East Somerset Council - BBC News
    "c34kqd05n0mt", # Bassetlaw District Council - BBC News
    "czm0p3lym40t", # Barrow Borough Council - BBC News
    "ckde2v0zg8dt", # Babergh District Council - BBC News
    "cmlw7p1lpxnt", # Aylesbury Vale District Council - BBC News
    "c9041ge8k12t", # Ashford Borough Council - BBC News
    "cx3xvw0xmymt", # Ashfield District Council - BBC News
    "c0gkw73yz0yt", # Arun District Council - BBC News
    "c0gkgvm4pwgt", # Allerdale Borough Council - BBC News
    "cpzqg374rl1t", # West Suffolk Council - BBC News
    "cjg52102j71t", # Somerset West and Taunton Council - BBC News
    "czrx0743vknt", # East Suffolk Council - BBC News
    "czrx0741qxjt", # Dorset Council - BBC News
    "crx6dnl749jt", # Bournemouth, Christchurch and Poole Council - BBC News
    "cz4pr2gd5y8t", # Comhairle nan Eilean Siar - BBC News
    "cz4pr2gd5xxt", # Suffolk County Council - BBC News
    "cz4pr2gd5lxt", # Gwynedd Council - BBC News
    "cywd23g04xlt", # South Ayrshire Council - BBC News
    "cywd23g04vlt", # Clackmannanshire Council - BBC News
    "cywd23g04mqt", # Essex County Council - BBC News
    "cywd23g04eqt", # City and County of Swansea Council - BBC News
    "cx1m7zg0wrqt", # Midlothian Council - BBC News
    "cx1m7zg0wdvt", # Denbighshire County Council - BBC News
    "cx1m7zg0w4vt", # Somerset County Council - BBC News
    "cwlw3xz01q3t", # Lancashire County Council - BBC News
    "cwlw3xz0183t", # Isle of Anglesey County Council - BBC News
    "cwlw3xz012rt", # East Lothian Council - BBC News
    "cvenzmgylvdt", # Rhondda Cynon Taf County Borough Council - BBC News
    "cvenzmgylqdt", # East Sussex County Council - BBC News
    "cvenzmgyl7rt", # Argyll and Bute Council - BBC News
    "cvenzmgyl1dt", # Isle of Wight Council - BBC News
    "cvenzmgyl0rt", # Shetland Islands Council - BBC News
    "crr7mlg0vzlt", # Scottish Borders Council - BBC News
    "crr7mlg0vqet", # Durham County Council - BBC News
    "crr7mlg0v4et", # Dorset County Council - BBC News
    "crr7mlg0v3lt", # Angus Council - BBC News
    "crr7mlg0v3et", # Powys Council - BBC News
    "cq23pdgvrzmt", # Caerphilly County Borough Council - BBC News
    "cq23pdgvrxzt", # Mayor of the Liverpool City Region - BBC News
    "cq23pdgvremt", # Norfolk County Council - BBC News
    "cq23pdgvr8zt", # Falkirk Council - BBC News
    "cp7r8vgl2xxt", # Mayor of the West Midlands - BBC News
    "cp7r8vgl2qlt", # Carmarthenshire County Council - BBC News
    "cp7r8vgl2dlt", # Northamptonshire County Council - BBC News
    "cp7r8vgl20xt", # Glasgow City Council - BBC News
    "cnx753jenv8t", # Warwickshire County Council - BBC News
    "cnx753jenp8t", # Monmouthshire County Council - BBC News
    "cnx753jend8t", # Cambridgeshire County Council - BBC News
    "cnx753jen8jt", # North Lanarkshire Council - BBC News
    "cmj34zmwxr3t", # Nottinghamshire County Council - BBC News
    "cmj34zmwxq3t", # Ceredigion County Council - BBC News
    "cmj34zmwxn0t", # Mayor of the West of England - BBC News
    "cmj34zmwx80t", # Highland Council - BBC News
    "cmj34zmwx1lt", # England local elections 2017 - BBC News
    "clm1wxp5nz1t", # West Dunbartonshire Council - BBC News
    "clm1wxp5nvmt", # Hampshire County Council - BBC News
    "clm1wxp5n81t", # East Ayrshire Council - BBC News
    "clm1wxp5n2mt", # Wiltshire Council - BBC News
    "cjnwl8q4xp7t", # Inverclyde Council - BBC News
    "cjnwl8q4xm5t", # Conwy County Borough Council - BBC News
    "cjnwl8q4x35t", # Oxfordshire County Council - BBC News
    "cg41ylwvxpdt", # Moray Council - BBC News
    "cg41ylwvxe8t", # Flintshire County Council - BBC News
    "cg41ylwvx58t", # Staffordshire County Council - BBC News
    "cg41ylwvx45t", # Wales local elections 2017 - BBC News
    "ce1qrvlexzet", # Stirling Council - BBC News
    "ce1qrvlexylt", # Vale of Glamorgan Council - BBC News
    "ce1qrvlexwlt", # Hertfordshire County Council - BBC News
    "ce1qrvlexpet", # Dundee City Council - BBC News
    "ce1qrvlex5lt", # Shropshire Council - BBC News
    "cdl8n2edxz7t", # South Lanarkshire Council - BBC News
    "cdl8n2edxwxt", # Gloucestershire County Council - BBC News
    "cdl8n2edxvxt", # Torfaen County Borough Council - BBC News
    "cdl8n2edxp7t", # Dumfries and Galloway Council - BBC News
    "cdl8n2edx5xt", # Northumberland County Council - BBC News
    "c8nq32jw8zet", # North Yorkshire County Council - BBC News
    "c8nq32jw8xet", # Cardiff Council - BBC News
    "c8nq32jw811t", # Fife Council - BBC News
    "c8nq32jw801t", # Mayor of the Tees Valley - BBC News
    "c77jz3mdqnyt", # Derbyshire County Council - BBC News
    "c77jz3mdqlpt", # Perth and Kinross Council - BBC News
    "c77jz3mdq8yt", # Newport City Council - BBC News
    "c77jz3mdq8pt", # Aberdeen City Council - BBC News
    "c77jz3mdq5yt", # Worcestershire County Council - BBC News
    "c50znx8v8m4t", # Scotland local elections 2017 - BBC News
    "c50znx8v4l5t", # Mayor of Greater Manchester - BBC News
    "c50znx8v4gpt", # Bridgend County Borough Council - BBC News
    "c50znx8v4d5t", # City of Edinburgh Council - BBC News
    "c50znx8v45pt", # Lincolnshire County Council - BBC News
    "c40rjmqdwyvt", # East Renfrewshire Council - BBC News
    "c40rjmqdwxmt", # Blaenau Gwent Council - BBC News
    "c40rjmqdwvmt", # Leicestershire County Council - BBC News
    "c40rjmqdwevt", # Mayor of Cambridgeshire & Peterborough - BBC News
    "c302m85q1xdt", # West Sussex County Council - BBC News
    "c302m85q1v0t", # Orkney Islands Council - BBC News
    "c302m85q1rdt", # Cumbria County Council - BBC News
    "c302m85q1pdt", # Neath Port Talbot County Borough Council - BBC News
    "c302m85q1p0t", # Wrexham County Borough Council - BBC News
    "c207p54mlrpt", # Renfrewshire Council - BBC News
    "c207p54mlnzt", # Cornwall Council - BBC News
    "c207p54mljzt", # Pembrokeshire County Council - BBC News
    "c207p54mljpt", # Aberdeenshire Council - BBC News
    "c207p54ml2zt", # Devon County Council - BBC News
    "c1038wnxevrt", # West Lothian Council - BBC News
    "c1038wnxeq1t", # Doncaster Metropolitan Borough Council - BBC News
    "c1038wnxe71t", # Kent County Council - BBC News
    "c1038wnxe2rt", # East Dunbartonshire Council - BBC News
    "c008ql15dxjt", # Surrey County Council - BBC News
    "c008ql15djjt", # Merthyr Tydfil County Borough Council - BBC News
    "c008ql15d7dt", # North Ayrshire Council - BBC News
  ]

  @mozart_test_ids [
    "c2x6gdkj24kt", # Oil - BBC News
    "cdj5gpy2el9t", # Gold - BBC News
    "cdj5gpyedz6t", # Natural gas - BBC News
    "cg83gy20ynpt", # Pound Sterling (GBP) - BBC News
    "c34v29kj722t", # Euro (EUR) - BBC News
    "crnvl9k9790t", # US Dollar (USD) - BBC News
    "c34v29ky0zkt", # Japanese Yen (JPY) - BBC News
  ]

  def call(
        _rest,
        struct = %Struct{request: %Struct.Request{path_params: %{"id" => id, "slug" => _slug}}}
      )
      when id not in @mozart_live_ids do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => "/news/topics/#{id}",
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  def call(_rest, struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) when id in @mozart_live_ids or id in @mozart_test_ids do
    then(
      ["CircuitBreaker"],
      Struct.add(struct, :private, %{
        platform: MozartNews
      })
    )
  end
end
