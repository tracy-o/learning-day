defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminator.NewsTopicIds do
  @moduledoc """
  News Topics IDs that need to be served by Mozart.
  """

  @test_ids [
    # Euro (EUR)
    "c34v29kj722t",
    # Gold
    "cdj5gpy2el9t",
    # Japanese Yen (JPY)
    "c34v29ky0zkt",
    # Natural gas
    "cdj5gpyedz6t",
    # Oil
    "c2x6gdkj24kt",
    # Pound Sterling (GBP)
    "cg83gy20ynpt",
    # US Dollar (USD)
    "crnvl9k9790t"
  ]

  @prod_ids [
    # 3i Group
    "c2rnyqdrvqnt",
    # 3i Infrastructure
    "cwz4l8xj794t",
    # A.G. Barr
    "cgv6l44yrnjt",
    # AA
    "c2rnyvlkrwlt",
    # AEX
    "clyeyy6q0g4t",
    # AMD
    "c91242yylkzt",
    # AT&T
    "c2q3k34gnw1t",
    # Aberdeen City Council
    "c77jz3mdq8pt",
    # Aberdeenshire Council
    "c207p54mljpt",
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
    # Adur District Council
    "c6z8969d13mt",
    # Aggreko
    "c2rnyvvjjygt",
    # Aldermore
    "czv6reejxqqt",
    # Alibaba
    "ce1qrvlelqqt",
    # Allerdale Borough Council
    "c0gkgvm4pwgt",
    # Alliance Trust
    "c779e88zj2nt",
    # Alphabet
    "c50znx8v421t",
    # Amazon
    "c50znx8v8y4t",
    # Amber Valley Borough Council
    "cmex9yrk2v8t",
    # American Airlines
    "cj5pd6v524kt",
    # Anglo American
    "cp7dm4zwg9vt",
    # Angus Council
    "crr7mlg0v3lt",
    # Antofagasta
    "cxw7q5vrrkwt",
    # Antrim and Newtownabbey Borough Council
    "c4l3n2y73wkt",
    # Apple
    "crr7mlg0gqqt",
    # Ards and North Down Borough Council
    "cqykv0xmkwdt",
    # Argyll and Bute Council
    "cvenzmgyl7rt",
    # Armagh City, Banbridge and Craigavon Borough Council
    "c347gew58gdt",
    # Arun District Council
    "c0gkw73yz0yt",
    # Ascential
    "czv6reey8l5t",
    # Ashfield District Council
    "cx3xvw0xmymt",
    # Ashford Borough Council
    "c9041ge8k12t",
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
    # Auto Trader Group
    "cgv6l889m9et",
    # Aveva
    "crem2vvjkelt",
    # Aviva
    "cdl8n2edxj7t",
    # Aylesbury Vale District Council
    "cmlw7p1lpxnt",
    # B&M European Value
    "cny6mmxwgwgt",
    # BAE Systems
    "c302m85q57zt",
    # BBA Aviation
    "c46zqeqy52et",
    # BP
    "cp7r8vgl27rt",
    # BSE Sensex
    "cpglgg6zyd0t",
    # BT Group
    "cwlw3xz0zwet",
    # BTG
    "c779ee6r7yxt",
    # Babcock International
    "cdz5gv7pwjkt",
    # Babergh District Council
    "ckde2v0zg8dt",
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
    # Barking and Dagenham London Borough Council
    "c34mxdk2k15t",
    # Barnet London Borough Council
    "c95egxx8738t",
    # Barnsley Metropolitan Borough Council
    "cn1r2w32629t",
    # Barratt Developments
    "cj5pd62qyvkt",
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
    # Beazley Group
    "cj5pdndw4kdt",
    # Bedford Borough Council
    "c9041g3w3vmt",
    # Belfast City Council
    "c18230em1n1t",
    # Bellway
    "ckr6ddkvljmt",
    # Berkeley Group Holdings
    "cgv6llkxlm2t",
    # Berkshire Hathaway Inc.
    "cewrlqz7xygt",
    # Bexley London Borough Council
    "c2n5vwne8z1t",
    # Big Yellow Group
    "cewrllqxln2t",
    # Birmingham City Council
    "cpr6g35nne1t",
    # Blaby District Council
    "cyq4zglxnknt",
    # Blackberry
    "c008ql15ddgt",
    # Blackburn with Darwen Borough Council
    "cmex9y5r55pt",
    # Blackpool Council
    "c18k74v979zt",
    # Blaenau Gwent Council
    "c40rjmqdwxmt",
    # Bloomsbury Publishing
    "cqx75jx9955t",
    # Bodycote
    "czv6rr8ljmyt",
    # Boeing
    "c40rjmqd0pgt",
    # Bolsover District Council
    "c4lkmd5pwdqt",
    # Bolton Metropolitan Borough Council
    "c82wmn8nz2dt",
    # Boohoo
    "cj2700dj78kt",
    # Booker Group
    "c779ee665mwt",
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
    # Brewin Dolphin
    "cj5pdd6e24et",
    # Bridgend County Borough Council
    "c50znx8v4gpt",
    # Brighton and Hove City Council
    "cmlw7pe3wgmt",
    # Bristol City Council
    "cez4j3p4ynet",
    # British American Tobacco
    "c9edzkvlp2gt",
    # British Empire Trust
    "cl86mm2e94dt",
    # British Land
    "cwz4ld6vzn2t",
    # Britvic
    "ckr6dd4lm65t",
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
    # Bunzl
    "czv6r8qrrrwt",
    # Burberry Group
    "cywd23g0g10t",
    # Burnley Borough Council
    "cv8k1pz74mmt",
    # Bury Metropolitan Borough Council
    "c2n5vw38z7vt",
    # CAC 40
    "cwjzjjz559yt",
    # CLS Holdings
    "crem22v5ggpt",
    # CRH
    "c5y4pr4me8wt",
    # CYBG
    "cq2655n5jwvt",
    # Caerphilly County Borough Council
    "cq23pdgvrzmt",
    # Cairn Energy
    "cgv6ll59d9wt",
    # Calderdale Council
    "c7ry2vg4374t",
    # Caledonia Investments
    "c6mk228z8xlt",
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
    # Capita
    "cm6pmmerd28t",
    # Capital & Counties Properties
    "cgv6ll57nmyt",
    # Card Factory
    "c46zqq524e4t",
    # Cardiff Council
    "c8nq32jw8xet",
    # Carlisle City Council
    "c82wm2mxrpzt",
    # Carmarthenshire County Council
    "cp7r8vgl2qlt",
    # Carnival Corporation
    "cj5pd678m8rt",
    # Castle Point Borough Council
    "cz3nmp588gnt",
    # Causeway Coast and Glens Borough Council
    "c7zn73e1le3t",
    # Centamin
    "ckr6dd46d54t",
    # Central Bedfordshire Council
    "cvw1ledev3vt",
    # Centrica
    "c302m85q0w3t",
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
    # Cineworld
    "c5y4pp57rpyt",
    # Citigroup
    "cwlw3xz0zqet",
    # City and County of Swansea Council
    "cywd23g04eqt",
    # City of Bradford Metropolitan District Council
    "c2n5vw3n26nt",
    # City of Edinburgh Council
    "c50znx8v4d5t",
    # City of Lincoln Council
    "cxwp925nzm2t",
    # City of London Investment Trust
    "cj5pddewkwmt",
    # Clackmannanshire Council
    "cywd23g04vlt",
    # Clarkson
    "cewrll5xjnjt",
    # Close Brothers Group
    "cl86mmjl62mt",
    # Cobham
    "cewrll5nz94t",
    # Coca-Cola
    "cz4pr2gd5w0t",
    # Coca-Cola HBC AG
    "cm6pmev6zmnt",
    # Colchester Borough Council
    "c4e713y1wxvt",
    # Comhairle nan Eilean Siar
    "cz4pr2gd5y8t",
    # Compass Group
    "czv6r8gdy58t",
    # Computacenter
    "crem22vmy99t",
    # ConvaTec
    "czv6r86xgqyt",
    # Conwy County Borough Council
    "cjnwl8q4xm5t",
    # Copeland Borough Council
    "ce31zxge2vlt",
    # Cornwall Council
    "c207p54mlnzt",
    # Cotswold District Council
    "cqymneqxp4wt",
    # Countryside Properties
    "c9edzzm72xjt",
    # Coventry City Council
    "ckn41gy8p59t",
    # Cranswick
    "cvl7nnr8zdkt",
    # Craven District Council
    "cv8k1pznxw7t",
    # Crawley Borough Council
    "c51gr0r9r6nt",
    # Crest Nicholson
    "crem22v7742t",
    # Croda International
    "cewrlqr7eylt",
    # Croydon London Borough Council
    "cr5pd6e1knkt",
    # Cumbria County Council
    "c302m85q1rdt",
    # Currys
    "c1038wnxnp7t",
    # DAX
    "ckwlwwg6507t",
    # DCC
    "c8254y52gwwt",
    # DS Smith
    "c6y3erpprq9t",
    # Dacorum Borough Council
    "c5xyn34w1k8t",
    # Dairy Crest
    "cxw7qqrw8rlt",
    # Darlington Borough Council
    "cw7lxe13x82t",
    # Dartford Borough Council
    "cpzqm83qglmt",
    # Daventry District Council
    "c06zdv5x905t",
    # Dechra Pharmaceuticals
    "ckr6dd2kq9nt",
    # Delta Airlines
    "cwz4ldqpjp8t",
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
    # Derwent London
    "c46zqql55r4t",
    # Devon County Council
    "c207p54ml2zt",
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
    # Doncaster Metropolitan Borough Council
    "c1038wnxeq1t",
    # Dorset Council
    "czrx0741qxjt",
    # Dorset County Council
    "crr7mlg0v4et",
    # Dover District Council
    "c2dk3qzwm2vt",
    # Dow Jones Industrial Average
    "clyeyy8851qt",
    # Drax Group
    "crem22wl58zt",
    # Dudley Metropolitan Borough Council
    "c2n5vw3e1nkt",
    # Dumfries and Galloway Council
    "cdl8n2edxp7t",
    # Dundee City Council
    "ce1qrvlexpet",
    # Dunelm Group
    "c6mk22wymldt",
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
    # Easyjet
    "c302m85q52jt",
    # eBay
    "c1038wnxnmpt",
    # Eden District Council
    "cqymne08vnnt",
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
    # Entain
    "cnegp95g5g8t",
    # Entertainment One
    "c9edzzqxjmet",
    # Epping Forest District Council
    "c82wmnz23eet",
    # Epsom and Ewell Borough Council
    "czm0p3n804lt",
    # Erewash Borough Council
    "ckde2vg8p3nt",
    # Essentra
    "cvl7nndm2v7t",
    # Essex County Council
    "cywd23g04mqt",
    # Esure
    "czv6rr2gzket",
    # Euro (EUR)
    "ce2gz75e8g0t",
    # EuroStoxx 50
    "clyeyy6464qt",
    # Euromoney Institutional Investor
    "crem22wmw9dt",
    # European elections 2019
    "c7zzdg3pmgpt",
    # Evraz
    "cp7dmmlnvrmt",
    # Exeter City Council
    "ckn41gr9d26t",
    # Experian
    "cvl7nq7wmq8t",
    # Exxon Mobil
    "cx1m7zg0g0lt",
    # F&C Commercial Property Trust
    "cyn9ww8w6gvt",
    # FDM Group
    "c2rnyyjmww6t",
    # FTSE 100
    "c9qdqqkgz27t",
    # FTSE 250
    "cjl3llgk4k2t",
    # Facebook
    "cmj34zmwxjlt",
    # Falkirk Council
    "cq23pdgvr8zt",
    # Fareham Borough Council
    "cmex9ygmen9t",
    # Fenland District Council
    "ckde2vgl84wt",
    # Ferguson
    "cxw7q57v2vkt",
    # Fermanagh and Omagh District Council
    "cnxkv19pvpgt",
    # Ferrexpo
    "cm6pmmxdnw2t",
    # Fidelity China Special Situations
    "cvl7nn4ypz7t",
    # Fidelity European Values
    "c46zqqj4ypwt",
    # Fidessa
    "ckr6ddmn7p6t",
    # Fife Council
    "c8nq32jw811t",
    # Finsbury Growth & Income Trust
    "crem22ydmkvt",
    # FirstGroup
    "cyn9wwxgewlt",
    # Flintshire County Council
    "cg41ylwvxe8t",
    # Flutter Entertainment
    "c779e6gmpzrt",
    # Flybe
    "cewrlqm4wz5t",
    # Folkestone and Hythe District Council
    "cgmk7g1732lt",
    # Ford
    "cz4pr2gdgyyt",
    # Forest of Dean District Council
    "c18k740mgeet",
    # Frasers Group
    "c23p6mx67v8t",
    # French Connection Group
    "cdl70lgvlp1t",
    # Fresnillo
    "cl86m26w75pt",
    # Fylde Borough Council
    "cx3xvwq5z2pt",
    # G4S
    "cwz4ld4el2jt",
    # GCP Infrastructure Investments
    "c5elzyl58xjt",
    # GDF Suez
    "cvv4m4mqkymt",
    # GKN
    "cm6pmepplmzt",
    # Galliford Try
    "c48yr0yx42nt",
    # GameStop
    "cyzp91yk1ydt",
    # Gap
    "cgdzn8v44jlt",
    # Gateshead Council
    "c4e7135rrr6t",
    # Gedling Borough Council
    "c5xyn3w8mv4t",
    # General Electric
    "c1038wnxezrt",
    # General Motors
    "cx1m7zg0g55t",
    # Genesis Emerging Markets Fund
    "c5elzyl8ze7t",
    # Genus
    "cp3mv9mvm2jt",
    # Glasgow City Council
    "cp7r8vgl20xt",
    # GlaxoSmithKline
    "cjnwl8q4qvjt",
    # Glencore
    "c50znx8v8z4t",
    # Gloucester City Council
    "c6rv64k4n6mt",
    # Gloucestershire County Council
    "cdl8n2edxwxt",
    # Go-Ahead Group
    "cnegp9gn1zdt",
    # Gold
    "cwjzj55q2p3t",
    # Goldman Sachs
    "cx1m7zg0g3nt",
    # Gosport Borough Council
    "c7ry2v83060t",
    # Grafton Group
    "c48yr0xgprjt",
    # Grainger
    "cljev9p0r1mt",
    # Gravesham Borough Council
    "cl12w48p892t",
    # Great Portland Estates
    "cljev9pn8zrt",
    # Great Yarmouth Borough Council
    "cpr6gnee362t",
    # Greencoat UK Wind
    "cdnpj79g404t",
    # Greencore
    "c340rzx790jt",
    # Greene King
    "c8z0l18e9pet",
    # Greenwich London Borough Council
    "c2n5vwndvv5t",
    # Greggs
    "cljev9przz1t",
    # Groupon
    "cg41ylwvwqgt",
    # Guildford Borough Council
    "cyq4zgmlnqkt",
    # Gwynedd Council
    "cz4pr2gd5lxt",
    # HICL Infrastructure Company
    "cm8m14z754et",
    # HP Inc
    "cj5pd6m8zxxt",
    # HSBC
    "cdl8n2eden0t",
    # Hackney London Borough Council
    "cn1r2wdermgt",
    # Halfords
    "cr07g9zzvn9t",
    # Halma
    "c2gze4pm7k4t",
    # Halton Borough Council
    "cv8k1ezvmg8t",
    # Hambleton District Council
    "cl12w48zm0nt",
    # Hammersmith and Fulham London Borough Council
    "cdyemznv72rt",
    # Hammerson
    "c9edzkd6qket",
    # Hampshire County Council
    "clm1wxp5nvmt",
    # Hang Seng
    "cq75774n157t",
    # Hansteen Holdings
    "cljev9pz5g4t",
    # Harborough District Council
    "cd7dvxd1klkt",
    # Hargreaves Lansdown
    "cp7dm4dx4lnt",
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
    # Hastings Insurance
    "cnegp95yp05t",
    # Havant Borough Council
    "cdyemzpe6d1t",
    # Havering London Borough Council
    "cyd02rr91z8t",
    # Hays
    "cljev9d3nylt",
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
    # Hikma Pharmaceuticals
    "c340rzp8p08t",
    # Hill & Smith
    "ce2gzrp3gxrt",
    # Hillingdon London Borough Council
    "c7ry2vvenzwt",
    # Hinckley and Bosworth Borough Council
    "c34kqdk9qwqt",
    # Hiscox
    "c48yr0p2z08t",
    # Hochschild Mining
    "ce2gzrplynvt",
    # Homeserve
    "ckgj7945n97t",
    # Horsham District Council
    "cmlw7pw8g45t",
    # Hounslow London Borough Council
    "c1v20ynr140t",
    # Howdens Joinery
    "cg5rv92ljgxt",
    # Hull Council
    "cg3nd2zg937t",
    # Hunting
    "c734jd19gvkt",
    # Huntingdonshire District Council
    "c51gr1rxyr8t",
    # Hyndburn Borough Council
    "cg3ndgz6vn3t",
    # IAG
    "c77jz3mdmy3t",
    # IBEX 35
    "c34l44l8d48t",
    # IBM
    "c77jz3mdqwpt",
    # IG Group
    "c7d65kqy9j3t",
    # IGas Energy
    "crem2z8xexnt",
    # IMI
    "cpd6nj4x2get",
    # IP Group
    "ceq4ej122qet",
    # ITV
    "c008ql151q8t",
    # IWG
    "czzn8lxng89t",
    # Ibstock
    "czzn8le8899t",
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
    # Internal server error
    "cl86mmjpnqpt",
    # International Public Partnerships
    "cxqe2z8rg7gt",
    # Interserve 
    "cwjdyzqwqqwt",
    # Intertek
    "cwz4ldl72yxt",
    # Intu Properties
    "cm1ygzmd3rqt",
    # Inverclyde Council
    "cjnwl8q4xp7t",
    # Investec
    "ceq4ej1lpn6t",
    # Ipswich Borough Council
    "cyd025ng43pt",
    # Isle of Anglesey County Council
    "cwlw3xz0183t",
    # Isle of Wight Council
    "cvenzmgyl1dt",
    # Islington London Borough Council
    "cpr6g30ee2rt",
    # JD Sports
    "cpd6nj989nmt",
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
    # James Fisher & Sons
    "cvl7nn4qpzqt",
    # Japanese Yen (JPY)
    "cleld6gp05et",
    # Jardine Lloyd Thompson
    "c28gld9nyzqt",
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
    # Kensington and Chelsea London Borough Council
    "c82wmnxwn18t",
    # Kent County Council
    "c1038wnxe71t",
    # Kier Group
    "c1nxedyylz1t",
    # Kingfisher
    "c40rjmqd0ggt",
    # Kingston Upon Thames London Borough Council
    "cn1r2w6d407t",
    # Kirklees Council
    "cxwp9z34p8zt",
    # Knowsley Metropolitan Borough Council
    "cmex9ydggy3t",
    # Ladbrokes Coral
    "c8l6dpnqy7yt",
    # Lambeth London Borough Council
    "cmex9yygmvzt",
    # Lancashire County Council
    "cwlw3xz01q3t",
    # Lancashire Holdings
    "cxqe2zjerlxt",
    # Lancaster City Council
    "cd7dvxd4lxmt",
    # Land Securities
    "cp7dm4my2wqt",
    # Lastminute.com
    "cjqx35j92pet",
    # Leeds City Council
    "cpr6g37145et",
    # Legal & General
    "c9edzkzwx2xt",
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
    # Lloyds Banking Group
    "c40rjmqdww3t",
    # London Stock Exchange Group
    "ce7l82zl978t",
    # London elections 2021
    "c27kz1m3j9mt",
    # LondonMetric Property
    "ck832qn4q93t",
    # Luton Borough Council
    "cmlw7pwyv48t",
    # Lyft
    "c10094dkqkrt",
    # Maidstone Borough Council
    "c06zdv117xxt",
    # Maldon District Council
    "ce31zx1y1w0t",
    # Malvern Hills District Council
    "ce31zx1ney8t",
    # Man Group
    "c5x2p4ke9lxt",
    # Manchester City Council
    "c7ry2vy7d52t",
    # Mansfield District Council
    "c2dk3qk41llt",
    # Marks & Spencer
    "cywd23g0ggxt",
    # Marshalls
    "c416ndyn2xdt",
    # Marston's Brewery
    "c8l6dpkpe99t",
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
    # Mayor of West Yorkshire
    "crx9762gl4pt",
    # Mayor of the Liverpool City Region
    "cq23pdgvrxzt",
    # Mayor of the Tees Valley
    "c8nq32jw801t",
    # Mayor of the West Midlands
    "cp7r8vgl2xxt",
    # Mayor of the West of England
    "cmj34zmwxn0t",
    # McCarthy & Stone
    "ck832q6yn26t",
    # McDonald's
    "cywd23g04g4t",
    # Mediclinic International
    "crem2z2m5wqt",
    # Medway Council
    "cvw1le1gwv4t",
    # Meggitt
    "c7d65k8m5kxt",
    # Melrose Industries
    "c6y3ekxnyd6t",
    # Melton Borough Council
    "ckde2ve1w21t",
    # Mendip District Council
    "cgmxywxg8xlt",
    # Mercantile Investment Trust
    "cle48g4j4zxt",
    # Merlin Entertainments
    "czv6r8rnl9jt",
    # Merthyr Tydfil County Borough Council
    "c008ql15djjt",
    # Merton London Borough Council
    "cmex9yex6xdt",
    # Metro Bank (United Kingdom)
    "cgzj67jnynkt",
    # Micro Focus
    "c6mk2822l94t",
    # Microsoft
    "cvenzmgyg0lt",
    # Mid Devon District Council
    "c4lkmdk537et",
    # Mid Suffolk District Council
    "czm0p30kxn0t",
    # Mid Sussex District Council
    "ckde2ve5gk8t",
    # Mid Ulster District Council
    "c5xq9w04q72t",
    # Mid and East Antrim Borough Council
    "cqykv0x3md4t",
    # Middlesbrough Borough Council
    "c5xyn3yw11kt",
    # Midlothian Council
    "cx1m7zg0wrqt",
    # Millennium & Copthorne Hotels
    "c348jd8984rt",
    # Milton Keynes Council
    "c95egx6pve9t",
    # Mitchells & Butlers
    "c5x2p421yj3t",
    # Mitie
    "cgzj67jx17et",
    # Moderna
    "c8grzynv1mgt",
    # Mole Valley District Council
    "cpr6g3gm81wt",
    # Mondi
    "cvl7nqn9pr2t",
    # Moneysupermarket.com
    "c5x2p42knryt",
    # Monks Investment Trust
    "c5x2p428gnkt",
    # Monmouthshire County Council
    "cnx753jenp8t",
    # Moray Council
    "cg41ylwvxpdt",
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
    # NEX Group
    "ceq4ejpkjr7t",
    # NMC Health
    "cyg1q3e632zt",
    # NatWest Group
    "cdvdx4l9y4xt",
    # National Express
    "cpd6nj666zkt",
    # National Grid
    "cywd23g04jlt",
    # Natural gas
    "cxwdwz5d8gxt",
    # Neath Port Talbot County Borough Council
    "c302m85q1pdt",
    # Netflix
    "crr7mlg0v1lt",
    # New Forest District Council
    "ce31zxkpyqgt",
    # NewRiver
    "cxqe2zpqdl5t",
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
    # Next
    "c008ql151lwt",
    # Nike, Inc.
    "czv6r8w2vqqt",
    # Nikkei 225
    "c55p555ng9gt",
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
    # Northgate
    "c6y3ekn87zqt",
    # Northumberland County Council
    "cdl8n2edx5xt",
    # Norwich City Council
    "c95eg26d22yt",
    # Nostrum Oil & Gas
    "c28gldjmjq1t",
    # Nottingham City Council
    "c9041g8wxe4t",
    # Nottinghamshire County Council
    "cmj34zmwxr3t",
    # Nuneaton and Bedworth Borough Council
    "cr5pd6d7g41t",
    # Nvidia
    "cewrlqz847yt",
    # Oadby and Wigston Borough Council
    "c7z584nenw1t",
    # Ocado
    "c302m85q5xjt",
    # Oil
    "cmjpj223708t",
    # Old Mutual
    "c779e6gjd6zt",
    # Oldham Council
    "c6z8968d08nt",
    # OneSavings Bank
    "c1nxedl1j77t",
    # Orkney Islands Council
    "c302m85q1v0t",
    # Oxford City Council
    "c95eg29gdp9t",
    # Oxfordshire County Council
    "cjnwl8q4x35t",
    # P2P Global Investments
    "c6y3eknjy61t",
    # PZ Cussons
    "cxqe2z6mx3jt",
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
    # Pembrokeshire County Council
    "c207p54mljzt",
    # Pendle Borough Council
    "cdyem5rexgyt",
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
    # Perth and Kinross Council
    "c77jz3mdqlpt",
    # Peterborough Council
    "c4e713newp7t",
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
    # Plymouth Council
    "c82wmneydegt",
    # Polar Capital Technology Trust
    "c28gld42313t",
    # Polymetal International
    "cql8qmr9pret",
    # Polypipe
    "c7d65kyk9yrt",
    # Portsmouth Council
    "c2n5vw68gkpt",
    # Pound Sterling (GBP)
    "cx250jmk4e7t",
    # Powys Council
    "crr7mlg0v3et",
    # Preston City Council
    "cmex90p0z3vt",
    # Procter & Gamble
    "cywd23g041et",
    # Provident Financial
    "c8254yp6lwdt",
    # Prudential
    "c8nq32jwjg0t",
    # Purbeck District Council
    "c4dmyrl14l9t",
    # Qinetiq
    "c7d65kym7jkt",
    # RELX Group
    "cvl7nqzxe69t",
    # RIT Capital Partners
    "c7d65xmmr36t",
    # RPC Group
    "cd67er3xjmdt",
    # RSA Insurance Group
    "c9edzm29jmpt",
    # Randgold Resources
    "c779e6kl2y5t",
    # Rathbone Brothers
    "c5x2p1z8x4lt",
    # Reach PLC
    "c514vpxv5llt",
    # Reading Borough Council
    "c7ry2vdm586t",
    # Reckitt Benckiser
    "cewrlqj4gnzt",
    # Redbridge London Borough Council
    "cv8k1e8x6x4t",
    # Redcar and Cleveland Borough Council
    "c2dk3q82m7lt",
    # Redditch Borough Council
    "c7ry2v2mez7t",
    # Redefine International
    "cjnr2yxl7znt",
    # Redrow
    "cm1ygplykydt",
    # Reigate and Banstead Borough Council
    "c4e714vn4dwt",
    # Renewables Infrastructure Group
    "c7d651zyy1xt",
    # Renfrewshire Council
    "c207p54mlrpt",
    # Renishaw
    "c6y3e1l946lt",
    # Rentokil Initial
    "czv6r87zrd2t",
    # Restaurant Group
    "c416n3gddg8t",
    # Rhondda Cynon Taf County Borough Council
    "cvenzmgylvdt",
    # Ribble Valley Borough Council
    "c2dk3q8v744t",
    # Richmond upon Thames London Borough Council
    "c06zd86my3gt",
    # Richmondshire District Council
    "c8yedk51wv2t",
    # Rightmove
    "c6y3erj1m4pt",
    # Rio Tinto
    "crr7mlg0gr3t",
    # Riverstone Energy
    "c8l6d37nld6t",
    # Rochdale Metropolitan Borough Council
    "cv8k1ekkm08t",
    # Rochford District Council
    "cz3nmpgw3zgt",
    # Rolls-Royce Holdings
    "ce1qrvlex71t",
    # Rossendale Borough Council
    "c82wm9kmynkt",
    # Rother District Council
    "c4lkmdx14z9t",
    # Rotherham Metropolitan Borough Council
    "cnjpwmdz92zt",
    # Rotork
    "c9jx2g48ngdt",
    # Royal Bank of Scotland
    "c302m85q5m3t",
    # Royal Dutch Shell
    "c8nq32jwnelt",
    # Royal Mail
    "cp7r8vglgwjt",
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
    # Ryanair
    "cvenzmgygg7t",
    # Ryedale District Council
    "c4lkmdx82g9t",
    # S&P 500
    "c4dldd02yp3t",
    # SIG
    "c9jx2gd4rrkt",
    # SSE
    "c8nq32jwjqnt",
    # SSE Composite
    "cq757713q97t",
    # SSP Group
    "c416n381d13t",
    # Safestore
    "c28glx6rl3kt",
    # Saga
    "crem2z954ndt",
    # Sage Group
    "cp7dmwr82vnt",
    # Sainsbury's
    "ce1qrvlexr1t",
    # Salford City Council
    "c82wmn3xr1rt",
    # Sandwell Metropolitan Borough Council
    "cdyemzd76ert",
    # Sanne Group
    "c348jzqj411t",
    # Santander Group
    "cdl8n2ededdt",
    # Savills
    "c6y3erj582qt",
    # Scarborough Borough Council
    "cx3xvw9dl17t",
    # Schroders
    "c825469m8pet",
    # Scotland local elections 2017
    "c50znx8v8m4t",
    # Scottish Borders Council
    "crr7mlg0vzlt",
    # Scottish Investment Trust
    "crjy4rer173t",
    # Scottish Mortgage Investment Trust
    "cny6mld4y2xt",
    # Scottish Parliament election 2021
    "c37d28xdn99t",
    # Sedgemoor District Council
    "c4lkmdxg7wnt",
    # Sefton Metropolitan Borough Council
    "cmex9y13vdpt",
    # Segro
    "cq265n8m8qqt",
    # Selby District Council
    "cgmxywqnggkt",
    # Senior
    "ck832pnxd18t",
    # Serco
    "cyg1qpmgp5kt",
    # Sevenoaks District Council
    "c2dk3q8ygpvt",
    # Severn Trent
    "ce1qrvlel2qt",
    # Shaftesbury
    "cyg1qpmrqg1t",
    # Sheffield City Council
    "c06zd893pd1t",
    # Shetland Islands Council
    "cvenzmgyl0rt",
    # Shire (pharmaceutical company)
    "cxw7q6m6wxrt",
    # Shropshire Council
    "ce1qrvlex5lt",
    # Sirius Minerals
    "c8l6d3n7elxt",
    # Sky
    "cp7r8vgl7pzt",
    # Slough Borough Council
    "cewngryvepgt",
    # Smith & Nephew
    "c82546rw58gt",
    # Smiths Group
    "cgv6l8v27myt",
    # Smurfit Kappa Group
    "cxw7q6wwpy8t",
    # Softcat
    "c7d65x9j4m7t",
    # Solihull Metropolitan Borough Council
    "c7ry2v3zzz2t",
    # Somerset County Council
    "cx1m7zg0w4vt",
    # Somerset West and Taunton Council
    "cjg52102j71t",
    # Sophos
    "crjy4rnrgyxt",
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
    # Spectris
    "czzn89798d5t",
    # Spelthorne Borough Council
    "c8yedk5d523t",
    # Spirax-Sarco Engineering
    "cm1yg8d9yg3t",
    # Spire Healthcare
    "cle482yzymrt",
    # St Albans City & District Council
    "c06zd83769kt",
    # St. Helens Metropolitan Borough Council
    "c06zd89x55dt",
    # St. James's Place
    "ckr6dxrqll7t",
    # St. Modwen Properties
    "c5x2p78ndqgt",
    # Stafford Borough Council
    "c0gkw7qq1dzt",
    # Staffordshire County Council
    "cg41ylwvx58t",
    # Staffordshire Moorlands District Council
    "c7z584yyyn5t",
    # Stagecoach
    "c9edzkwe7xrt",
    # Standard Chartered
    "c207p54m485t",
    # Starbucks
    "cq265ly55e9t",
    # Stevenage Borough Council
    "cz3nm49dx89t",
    # Stirling Council
    "ce1qrvlexzet",
    # Stobart Group
    "cgzj6dm3gj7t",
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
    # Superdry
    "c348jz2lex6t",
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
    # Syncona
    "cpd6nx35xpdt",
    # Synthomer
    "cjnr2z5m4rjt",
    # TBC Bank
    "cle482myknet",
    # TP ICAP
    "c6y3er39zlxt",
    # TR Property Investment Trust
    "cql8rjkmkq9t",
    # TUI Group
    "cj5pde5nvd9t",
    # TalkTalk Group
    "cjnr2zl1x6nt",
    # Tameside Metropolitan Borough Council
    "cr5pd69r77et",
    # Tamworth Borough Council
    "cr5pden59kdt",
    # Tandridge District Council
    "c06zdvnge1zt",
    # Tate & Lyle
    "c1nxez79n95t",
    # Taylor Wimpey
    "cewrl5w94e9t",
    # Ted Baker
    "c6y3erggy4et",
    # Teignbridge District Council
    "c34kq9g5ylvt",
    # Telecom Plus
    "c28glxrr4qnt",
    # Telford and Wrekin Borough Council
    "cqymn8vdwxqt",
    # Temple Bar Investment Trust
    "c8l6d3q4jrrt",
    # Templeton Emerging Markets Investment Trust
    "cm1yg87ggzyt",
    # Tendring District Council
    "cvw1lm24dqlt",
    # Tesco
    "c77jz3mdmlvt",
    # Tesla
    "c8nq32jwjnmt",
    # Test Valley Borough Council
    "c5xyng90g31t",
    # Tewkesbury Borough Council
    "c9041d5wnp1t",
    # Thanet District Council
    "cw7lxw20z9et",
    # The Rank Group
    "cle481xnlndt",
    # The Royal Bank of Scotland Group Page
    "czv6rev6mz7t",
    # The UK’s European elections 2019
    "crjeqkdevwvt",
    # Thomas Cook Group
    "c416n3k3156t",
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
    # Travis Perkins
    "cle4824zl78t",
    # Tritax Big Box REIT
    "c416mkqj681t",
    # Tullow Oil
    "c9jx7qxqy36t",
    # Tunbridge Wells Borough Council
    "c7ry2pm3072t",
    # Twitter
    "cmj34zmwx51t",
    # UBM
    "ck835j332p2t",
    # UDG Healthcare
    "cql8rj8ppj8t",
    # UK Commercial Property Trust
    "cjnr4lxend1t",
    # US Dollar (USD)
    "cljevy2yz5lt",
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
    # Uttlesford District Council
    "c7z58d7vywet",
    # Vale of Glamorgan Council
    "ce1qrvlexylt",
    # Vale of White Horse District Council
    "c7z58d7wqv4t",
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
    # WH Smith
    "ce8jr869nwkt",
    # WPP
    "cewrlqp59x7t",
    # Wakefield Metropolitan District Council
    "c82wmn76d1nt",
    # Wales local elections 2017
    "cg41ylwvx45t",
    # Walmart
    "ce1qrvlex0et",
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
    # Weir Group
    "c6mk28y4dw7t",
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
    # Wetherspoons
    "c11le1xvm4yt",
    # Whitbread
    "cl86mjkkgn6t",
    # Wigan Metropolitan Borough Council
    "cxwp9znd7k0t",
    # William Hill (bookmaker)
    "c704e0kj142t",
    # Wiltshire Council
    "clm1wxp5n2mt",
    # Winchester City Council
    "cz3nmpykrnvt",
    # Windsor and Maidenhead Borough Council
    "cgmxyp7mn08t",
    # Wirral Metropolitan Borough Council
    "cewngre8686t",
    # Witan Investment Trust
    "cy5m75wwmvwt",
    # Wizz Air
    "cmleylw141et",
    # Woking Borough Council
    "c51grzvnevvt",
    # Wokingham Borough Council
    "cpr6g3dzwr8t",
    # Wolverhampton City Council
    "c7ry2vgwg1pt",
    # Wood Group
    "cewrlqm8ylet",
    # Woodford Patient Capital Trust
    "c11le1kp83mt",
    # Worcester City Council
    "cxwp9z984xyt",
    # Worcestershire County Council
    "c77jz3mdq5yt",
    # Workspace Group
    "ckm4xm64551t",
    # WorldPay
    "c82546dy7rwt",
    # Worldwide Healthcare Trust
    "c5ewlerdr0kt",
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
    "cpzqml8lgpkt",
    # ZPG
    "cle46m8d471t",
    # Zynga
    "c025k7k4ex2t"
  ]

  def get() do
    case Application.get_env(:belfrage, :production_environment) do
      "test" -> @test_ids
      "live" -> @prod_ids
    end
  end
end
