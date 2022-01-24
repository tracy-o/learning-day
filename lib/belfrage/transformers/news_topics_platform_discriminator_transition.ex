defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTransition do
  @moduledoc """
  Alters the Platform and Origin for a subset of News Topics IDs that need to be served by Webcore.
  """
  use Belfrage.Transformers.Transformer

  @mozart_ids [
    "c50znx8v8y4t",
    "cyzp91yk1ydt",
    "c8grzynv1mgt",
    "cdvdx4l9y4xt",
    "clyeyy6464qt",
    "c10094dkqkrt",
    "cwwwewx7rrwt",
    "cj1xj07qx9et",
    "c348jz2lex6t",
    "cxw7q6wwpy8t",
    "cdl70lgvlp1t",
    "cj2700dj78kt",
    "cqx75jx9955t",
    "crd7jvq987kt",
    "cev9zn0ggzpt",
    "cvv4m4mqkymt",
    "czv6reejxqqt",
    "c6y3ekl2323t",
    "cle48gxn6ynt",
    "c2rnyvlkrwlt",
    "c514vpxv5llt",
    "cny6mmxwgwgt",
    "c7zl7v00x15t",
    "c0n69181n53t",
    "cgdzn8v44jlt",
    "czv6rev6mz7t",
    "crem2z954ndt",
    "cq265n8m8qqt",
    "c5ewlerdr0kt",
    "cyn9wwxgewlt",
    "c23p6mx67v8t",
    "cq04218m929t",
    "cjqx35j92pet",
    "cpzz7xmjgvwt",
    "cwjdyzqwqqwt",
    "c2q3k34gnw1t",
    "c91242yylkzt",
    "c025k7k4ex2t",
    "czlm1nzpzlvt",
    "ce7l82zl978t",
    "ckm4xm64551t",
    "c11le1kp83mt",
    "cmleylw141et",
    "cy5m75wwmvwt",
    "c704e0kj142t",
    "ce8jr869nwkt",
    "c11le1xvm4yt",
    "cq757713q97t",
    "c55p555ng9gt",
    "cq75774n157t",
    "cpglgg6zyd0t",
    "c4dldd02yp3t",
    "c08k88ey6d5t",
    "clyeyy8851qt",
    "cwjzjjz559yt",
    "c34l44l8d48t",
    "ckwlwwg6507t",
    "clyeyy6q0g4t",
    "cjl3llgk4k2t",
    "c9qdqqkgz27t",
    "czzng315j56t",
    "czzn8lxng89t",
    "czzn8le8899t",
    "czzn8l7l79rt",
    "czzn89798d5t",
    "czv6rrldgw8t",
    "czv6rr8ljmyt",
    "czv6rr2gzket",
    "czv6reey8l5t",
    "czv6r8w2vqqt",
    "czv6r8rnl9jt",
    "czv6r8qrrrwt",
    "czv6r8mnjq8t",
    "czv6r8m2d49t",
    "czv6r8gdy58t",
    "czv6r87zrd2t",
    "czv6r86xgqyt",
    "cz4pr2gdgyyt",
    "cz4pr2gd5w0t",
    "cz4pr2gd52lt",
    "cywd23g0ggxt",
    "cywd23g0g10t",
    "cywd23g04net",
    "cywd23g04jlt",
    "cywd23g04g4t",
    "cywd23g041et",
    "cyn9ww8w6gvt",
    "cyg1qpmrqg1t",
    "cyg1qpmgp5kt",
    "cyg1q3xl7n4t",
    "cyg1q3m48pkt",
    "cyg1q3e632zt",
    "cxw7qqrw8rlt",
    "cxw7q6m6wxrt",
    "cxw7q5vrrkwt",
    "cxw7q5qmw24t",
    "cxw7q5nn5rxt",
    "cxw7q57v2vkt",
    "cxqe2zpqdl5t",
    "cxqe2zjerlxt",
    "cxqe2z8rg7gt",
    "cxqe2z6mx3jt",
    "cx1m7zg0g55t",
    "cx1m7zg0g3nt",
    "cx1m7zg0g0lt",
    "cwz4ll584r4t",
    "cwz4ldqpjp8t",
    "cwz4ldqgy28t",
    "cwz4ldl72yxt",
    "cwz4ld6vzn2t",
    "cwz4ld4el2jt",
    "cwz4l8xj794t",
    "cwlw3xz0zwet",
    "cwlw3xz0zqet",
    "cvl7nqzxe69t",
    "cvl7nqn9pr2t",
    "cvl7nq7wmq8t",
    "cvl7nnr8zdkt",
    "cvl7nndm2v7t",
    "cvl7nn4ypz7t",
    "cvl7nn4qpzqt",
    "cvenzmgygg7t",
    "cvenzmgyg0lt",
    "crr7mlg0vg2t",
    "crr7mlg0v1lt",
    "crr7mlg0gr3t",
    "crr7mlg0gqqt",
    "crr7mlg0gdnt",
    "crjy5mp1l9kt",
    "crjy4rnrgyxt",
    "crjy4rer173t",
    "crjy47py3g2t",
    "crjy47ndqymt",
    "crjy47lg55gt",
    "crem2z8xexnt",
    "crem2z2m5wqt",
    "crem2vvvd6vt",
    "crem2vvjkelt",
    "crem22ydmkvt",
    "crem22wmw9dt",
    "crem22wl58zt",
    "crem22w5kz5t",
    "crem22vmy99t",
    "crem22v7742t",
    "crem22v5ggpt",
    "cr07g9zzvn9t",
    "cql8rjpm187t",
    "cql8rjkmkq9t",
    "cql8rj8ppj8t",
    "cql8qmr9pret",
    "cql8qmp2expt",
    "cql8qmmeq4zt",
    "cql8qm2dkl5t",
    "cql8qm223z2t",
    "cq265ly55e9t",
    "cq2655n5jwvt",
    "cq2655lgldnt",
    "cq26554x797t",
    "cq23pdgvglxt",
    "cpd6nx35xpdt",
    "cpd6njnmzmjt",
    "cpd6nj989nmt",
    "cpd6nj666zkt",
    "cpd6nj5yq42t",
    "cpd6nj4x2get",
    "cp7r8vglgwjt",
    "cp7r8vglgljt",
    "cp7r8vgl7pzt",
    "cp7r8vgl27rt",
    "cp7dmwr82vnt",
    "cp7dmw7pppdt",
    "cp7dmmlnvrmt",
    "cp7dm4zwg9vt",
    "cp7dm4nmm5kt",
    "cp7dm4my2wqt",
    "cp7dm4dx4lnt",
    "cp7dm484262t",
    "cp3mv9mvm2jt",
    "cny6mld4y2xt",
    "cnegp9gn1zdt",
    "cnegp95yp05t",
    "cnegp95g5g8t",
    "cmj34zmwxjlt",
    "cmj34zmwx51t",
    "cm8m14z754et",
    "cm6pmmxdnw2t",
    "cm6pmmerd28t",
    "cm6pmev6zmnt",
    "cm6pmepplmzt",
    "cm6pmejyklvt",
    "cm1yx7l98g6t",
    "cm1ygzmd3rqt",
    "cm1ygplykydt",
    "cm1yg8d9yg3t",
    "cm1yg87ggzyt",
    "cljev9pz5g4t",
    "cljev9przz1t",
    "cljev9pn8zrt",
    "cljev9p0r1mt",
    "cljev9d3nylt",
    "cle48g4j4zxt",
    "cle482yzymrt",
    "cle482myknet",
    "cle4824zl78t",
    "cle481xnlndt",
    "cle46m8d471t",
    "cl86mmjpnqpt",
    "cl86mmjl62mt",
    "cl86mm2e94dt",
    "cl86mjkkgn6t",
    "cl86mjjp7xxt",
    "cl86m2y7px6t",
    "cl86m2gm2w8t",
    "cl86m26w75pt",
    "ckr6dxrqll7t",
    "ckr6ddmn7p6t",
    "ckr6ddkvljmt",
    "ckr6dd4lm65t",
    "ckr6dd46d54t",
    "ckr6dd2kq9nt",
    "ckr6d48pk46t",
    "ckgj7945n97t",
    "ck835j332p2t",
    "ck832qn4q93t",
    "ck832q6yn26t",
    "ck832pnxd18t",
    "cjnwl8q4qvjt",
    "cjnwl8q4nr3t",
    "cjnr4lxend1t",
    "cjnr2zl1x6nt",
    "cjnr2z5m4rjt",
    "cjnr2yxl7znt",
    "cj5pdndw4kdt",
    "cj5pde5nvd9t",
    "cj5pddewkwmt",
    "cj5pdd6e24et",
    "cj5pd6v524kt",
    "cj5pd6m8zxxt",
    "cj5pd6gqk4kt",
    "cj5pd678m8rt",
    "cj5pd62qyvkt",
    "cj5pd62kpe6t",
    "cgzj6dm3gj7t",
    "cgzj67jx17et",
    "cgzj67jnynkt",
    "cgv6llkxlm2t",
    "cgv6ll59d9wt",
    "cgv6ll57nmyt",
    "cgv6l8v27myt",
    "cgv6l889m9et",
    "cgv6l542p65t",
    "cgv6l44yrnjt",
    "cg5rv92ljgxt",
    "cg41ylwvwqgt",
    "cewrlqz847yt",
    "cewrlqz7xygt",
    "cewrlqr7eylt",
    "cewrlqp59x7t",
    "cewrlqm8ylet",
    "cewrlqm4wz5t",
    "cewrlqj4gnzt",
    "cewrllvp26xt",
    "cewrllqxln2t",
    "cewrll5xjnjt",
    "cewrll5nz94t",
    "cewrl5w94e9t",
    "ceq4ejpkjr7t",
    "ceq4ej1yxnnt",
    "ceq4ej1lpn6t",
    "ceq4ej122qet",
    "ce2gzrplynvt",
    "ce2gzrp3gxrt",
    "ce1qrvlexr1t",
    "ce1qrvlex71t",
    "ce1qrvlex0et",
    "ce1qrvlelqqt",
    "ce1qrvlel2qt",
    "cdz5gv7pwjkt",
    "cdz5ggnw7xdt",
    "cdnpj79g404t",
    "cdl8n2edxj7t",
    "cdl8n2eden0t",
    "cdl8n2ededdt",
    "cd67er3xjmdt",
    "cd67elljy34t",
    "c9jx7qxqy36t",
    "c9jx7q942xxt",
    "c9jx2pd38x1t",
    "c9jx2gd4rrkt",
    "c9jx2g48ngdt",
    "c9edzzqxmkwt",
    "c9edzzqxjmet",
    "c9edzzm72xjt",
    "c9edzmmyplkt",
    "c9edzm29jmpt",
    "c9edzkzwx2xt",
    "c9edzkwe7xrt",
    "c9edzkvlp2gt",
    "c9edzkd6qket",
    "c8z0l18e9pet",
    "c8nq32jwnelt",
    "c8nq32jwjqnt",
    "c8nq32jwjnmt",
    "c8nq32jwjg0t",
    "c8l6dpnqy7yt",
    "c8l6dpkpe99t",
    "c8l6dp595lxt",
    "c8l6dp4lym1t",
    "c8l6dp42444t",
    "c8l6d3q4jrrt",
    "c8l6d3n7elxt",
    "c8l6d37nld6t",
    "c8254yp6lwdt",
    "c8254y52gwwt",
    "c82546rw58gt",
    "c82546dy7rwt",
    "c825469m8pet",
    "c7d6y2z7rgdt",
    "c7d65xmmr36t",
    "c7d65x9j4m7t",
    "c7d65kz8285t",
    "c7d65kym7jkt",
    "c7d65kyk9yrt",
    "c7d65kqy9j3t",
    "c7d65k8m5kxt",
    "c7d65k4dr79t",
    "c7d651zyy1xt",
    "c77jz3mdqwpt",
    "c77jz3mdmy3t",
    "c77jz3mdmlvt",
    "c779ee6r7yxt",
    "c779ee665mwt",
    "c779e88zj2nt",
    "c779e6kl2y5t",
    "c779e6gmpzrt",
    "c779e6gjd6zt",
    "c734jd19gvkt",
    "c6y3erpprq9t",
    "c6y3erj582qt",
    "c6y3erj1m4pt",
    "c6y3erggy4et",
    "c6y3er39zlxt",
    "c6y3ekxnyd6t",
    "c6y3eknjy61t",
    "c6y3ekn87zqt",
    "c6y3ekjkqnmt",
    "c6y3e1l946lt",
    "c6mk28y4dw7t",
    "c6mk28n8x6kt",
    "c6mk28llrk7t",
    "c6mk2822l94t",
    "c6mk22wymldt",
    "c6mk22wr96kt",
    "c6mk228z8xlt",
    "c5y4pr4me8wt",
    "c5y4pp57rpyt",
    "c5y4p555e6qt",
    "c5x2rqzxdjpt",
    "c5x2p78ndqgt",
    "c5x2p4ke9lxt",
    "c5x2p42qr1mt",
    "c5x2p42knryt",
    "c5x2p428re7t",
    "c5x2p428gnkt",
    "c5x2p421yj3t",
    "c5x2p1z8x4lt",
    "c5elzyl8ze7t",
    "c5elzyl58xjt",
    "c50znx8v8z4t",
    "c50znx8v8j4t",
    "c50znx8v421t",
    "c48yr0yx42nt",
    "c48yr0xgprjt",
    "c48yr0p2z08t",
    "c46zqql55r4t",
    "c46zqqj4ypwt",
    "c46zqq524e4t",
    "c46zqeqy52et",
    "c46zqeenew5t",
    "c46zqddr25et",
    "c416ndyn2xdt",
    "c416ndm1r9qt",
    "c416n3k3156t",
    "c416n3gddg8t",
    "c416n381d13t",
    "c416mkqj681t",
    "c40rjmqdww3t",
    "c40rjmqdw2vt",
    "c40rjmqdqvlt",
    "c40rjmqd0pgt",
    "c40rjmqd0ggt",
    "c348jzqj411t",
    "c348jdx1pq9t",
    "c348jd8984rt",
    "c340rzx790jt",
    "c340rzp8p08t",
    "c302m85q5xjt",
    "c302m85q5m3t",
    "c302m85q57zt",
    "c302m85q52jt",
    "c302m85q170t",
    "c302m85q0w3t",
    "c2rnyyjmww6t",
    "c2rnyvvjjygt",
    "c2rnyqnqvv8t",
    "c2rnyqkew57t",
    "c2rnyqdrvqnt",
    "c2gze4pm7k4t",
    "c28glxrr4qnt",
    "c28glx6rl3kt",
    "c28gldjmjq1t",
    "c28gld9nyzqt",
    "c28gld42313t",
    "c28gld3zeg2t",
    "c207p54m4lnt",
    "c207p54m4det",
    "c207p54m485t",
    "c1nxez79n95t",
    "c1nxedyylz1t",
    "c1nxedl1j77t",
    "c1038wnxnp7t",
    "c1038wnxnmpt",
    "c1038wnxezrt",
    "c008ql15ddgt",
    "c008ql151q8t",
    "c008ql151lwt",
    "cmjpj223708t",
    "cwjzj55q2p3t",
    "cxwdwz5d8gxt",
    "cx250jmk4e7t",
    "ce2gz75e8g0t",
    "cljevy2yz5lt",
    "cleld6gp05et",
    "ckn41gy8p59t",
    "c5nwpzkn523t",
    "c008ql15d3jt",
    "cxq3k9pj1kqt",
    "c7rmp6p1vz1t",
    "c27kz1m3j9mt",
    "c37d28xdn99t",
    "cqwn14k92zwt",
    "c481drqqzv7t",
    "cm24v76zl6rt",
    "c27e3401kdet",
    "crx9762gl4pt",
    "ceeqy0e9894t",
    "cj736r74vq9t",
    "c95egxg00kpt",
    "c95egxge58gt",
    "cxwp9z984xyt",
    "cpr6g3dzwr8t",
    "c51grzvnevvt",
    "cewngre8686t",
    "cz3nmpykrnvt",
    "cxwp9znd7k0t",
    "cwypr9e60edt",
    "cmex905py9vt",
    "cwypr17yndyt",
    "c82wmng7xpyt",
    "cv8k1e8g5dwt",
    "cdyemzy7w0dt",
    "cyd02rve9vnt",
    "c82wmn76d1nt",
    "c7ry2pm3072t",
    "c2n5vw1n224t",
    "cr5pd6v9p6dt",
    "c2n5vwpp0x7t",
    "cz3nmpyrgrmt",
    "c06zdvnge1zt",
    "cr5pden59kdt",
    "cr5pd69r77et",
    "c82wmn481ynt",
    "c82wmn28zx5t",
    "c4e713dvy2wt",
    "cn1r2wp78eyt",
    "cz3nm49dx89t",
    "c06zd89x55dt",
    "c06zd83769kt",
    "cewngrr2ddyt",
    "c82wmn4gp01t",
    "cn1r2wpr38zt",
    "cwypryrmyvxt",
    "c1v20vnw7n5t",
    "c7ry2v3zzz2t",
    "cewngryvepgt",
    "c06zd893pd1t",
    "cmex9y13vdpt",
    "cdyemzd76ert",
    "c82wmn3xr1rt",
    "cmex9yg23p0t",
    "c51grzv2ep6t",
    "c06zd8d3g18t",
    "c82wm9kmynkt",
    "cz3nmpgw3zgt",
    "cv8k1ekkm08t",
    "c06zd86my3gt",
    "c4e714vn4dwt",
    "c7ry2v2mez7t",
    "cv8k1e8x6x4t",
    "c7ry2vdm586t",
    "cmex90p0z3vt",
    "cdyem5rexgyt",
    "c95eg29gdp9t",
    "c6z8968d08nt",
    "cr5pd6d7g41t",
    "c95eg26d22yt",
    "c51gr0gm35pt",
    "c7ry2v8v7xwt",
    "cpr6g3e6z15t",
    "cmex9y63z2kt",
    "c6z89r4r55dt",
    "c34mxdm59xzt",
    "cpr6g3gm81wt",
    "c95egx6pve9t",
    "cmex9yex6xdt",
    "c7ry2vy7d52t",
    "c06zdv117xxt",
    "c95egxe339nt",
    "cxwp925nzm2t",
    "cewngrrnky9t",
    "cpr6g37145et",
    "cmex9yygmvzt",
    "cmex9ydggy3t",
    "cxwp9z34p8zt",
    "cn1r2w6d407t",
    "c82wmnxwn18t",
    "cpr6g30ee2rt",
    "cyd025ng43pt",
    "cg3ndgz6vn3t",
    "c51gr1rxyr8t",
    "c1v20ynr140t",
    "c7ry2vvenzwt",
    "cyd02rr91z8t",
    "cdyemzpe6d1t",
    "c1v20yxy2xvt",
    "cv8k1ezy9m9t",
    "cn1r2w8m645t",
    "c6z8966k3emt",
    "c2n5vx7zw1xt",
    "cz3nmp5y5ggt",
    "ckn41g8zm4pt",
    "cdyemznv72rt",
    "cv8k1ezvmg8t",
    "cn1r2wdermgt",
    "c2n5vwndvv5t",
    "cpr6gnee362t",
    "c7ry2v83060t",
    "c4e7135rrr6t",
    "cmex9ygmen9t",
    "ckn41gr9d26t",
    "c82wmnz23eet",
    "c51gr01kx32t",
    "cwypr1rx82yt",
    "c6z896g4m00t",
    "cz3nmp4xwgdt",
    "c2n5vw3e1nkt",
    "c06zdv5x905t",
    "cr5pd6e1knkt",
    "c51gr0r9r6nt",
    "cv8k1pznxw7t",
    "c4e713y1wxvt",
    "c7ry2vgwg1pt",
    "c7ry2vnx2n5t",
    "c34mxdwyr9kt",
    "c2n5vw68gkpt",
    "c82wmneydegt",
    "c4e713newp7t",
    "cg3nd2zg937t",
    "c1v20ym0z2dt",
    "c2n5vx19e7rt",
    "ckn41dx7dprt",
    "c6z89r5y0wdt",
    "cz3nmp588gnt",
    "c82wm2mxrpzt",
    "cr5pden698pt",
    "ckn41g829e2t",
    "ckn41n142d2t",
    "c7ry2vg4374t",
    "c2n5vw38z7vt",
    "cv8k1pz74mmt",
    "c4e713mgrn3t",
    "cwypr193rx1t",
    "cyd02r0dg8rt",
    "cewngrr5rmkt",
    "c2n5vw3n26nt",
    "c82wmn8nz2dt",
    "cmex9y5r55pt",
    "cpr6g35nne1t",
    "c2n5vwne8z1t",
    "c1v20y4k60pt",
    "c7ry2vg44ykt",
    "cn1r2w32629t",
    "c95egxx8738t",
    "c34mxdk2k15t",
    "cmex9yrk2v8t",
    "c6z8969d13mt",
    "cz3nmp2eyxgt",
    "c8l541jm9pnt",
    "c33p6e694q0t",
    "cjjdnen12lrt",
    "cg699vx7d3et",
    "c3388lz4l28t",
    "cpg996d0pzlt",
    "cnjpwmdz92zt",
    "cd63lw8mdpvt",
    "c6rv64k4n6mt",
    "c4dmyrl14l9t",
    "cez4j3p4ynet",
    "c2jq0m4ezm0t",
    "crjeqkdevwvt",
    "c7zzdg3pmgpt",
    "cqykv0xmkwdt",
    "czmwqn2ne4et",
    "c5xq9w04q72t",
    "cqykv0x3md4t",
    "c0ge2y53wzxt",
    "cnxkv19pvpgt",
    "cgmk73e4ey7t",
    "c7zn73e1le3t",
    "c18230em1n1t",
    "c347gew58gdt",
    "c4l3n2y73wkt",
    "cgmk7g1732lt",
    "cpzqml8lgpkt",
    "cl12w9vmg3pt",
    "c18k7w37503t",
    "cl12w9v1zp4t",
    "cgmxyp7mn08t",
    "c9041d58yedt",
    "ce31z8pky5zt",
    "cd7dvp1d5gpt",
    "c34kq9gk22xt",
    "c9041d54d50t",
    "czm0p8qnlv2t",
    "c8yed30qn84t",
    "c7z58d7wqv4t",
    "c7z58d7vywet",
    "c9041d5vev0t",
    "cyq4z3w9g41t",
    "c5xyng91pnkt",
    "cw7lxw20z9et",
    "c9041d5wnp1t",
    "c5xyng90g31t",
    "cvw1lm24dqlt",
    "cqymn8vdwxqt",
    "c34kq9g5ylvt",
    "czm0p8q8pyqt",
    "c34kq9g93q1t",
    "c4lkm7ndzm7t",
    "cd7dvp1xxv5t",
    "c18k7w3315qt",
    "c7z584yyyn5t",
    "c0gkw7qq1dzt",
    "c8yedk5d523t",
    "cgmxywqy4wet",
    "ce31zx2zx2nt",
    "c2dk3q8dyxqt",
    "c7z584yn8xzt",
    "ce31zx217wlt",
    "c34kqd1e172t",
    "c18k74n05vxt",
    "cw7lxez3w3yt",
    "cx3xvw9k0x8t",
    "c2dk3q8z7zyt",
    "c2dk3q8ye2kt",
    "c2dk3q8ygpvt",
    "cgmxywqnggkt",
    "c4lkmdxg7wnt",
    "cx3xvw9dl17t",
    "c4lkmdx82g9t",
    "c2dk3q84vxkt",
    "c2dk3q8lp27t",
    "c4lkmdx14z9t",
    "c8yedk51wv2t",
    "c2dk3q8v744t",
    "c2dk3q82m7lt",
    "c7z584nenw1t",
    "c9041g8wxe4t",
    "ckde2vk95q5t",
    "czm0p3w7y02t",
    "c34kqd758vwt",
    "cpzqm8k5mx8t",
    "c2dk3qw9247t",
    "cl12w4k90q1t",
    "cqymneke70dt",
    "c4lkmd3d8w1t",
    "cyq4zg2w03kt",
    "ce31zxkpyqgt",
    "c5xyn3yw11kt",
    "ckde2ve5gk8t",
    "czm0p30kxn0t",
    "c4lkmdk537et",
    "cgmxywxg8xlt",
    "ckde2ve1w21t",
    "cvw1le1gwv4t",
    "c2dk3qk41llt",
    "ce31zx1ney8t",
    "ce31zx1y1w0t",
    "cmlw7pwyv48t",
    "c34kqdkpxn2t",
    "c4lkmdky3z3t",
    "cgmxywxe9nzt",
    "cd7dvxd4lxmt",
    "cmlw7pwzvl3t",
    "cmlw7pw8g45t",
    "c34kqdk9qwqt",
    "cd7dvxdp9eqt",
    "c9041g4g1mmt",
    "c5xyn3y3572t",
    "cd7dvxd1klkt",
    "cl12w48zm0nt",
    "cyq4zgmlnqkt",
    "cl12w48p892t",
    "c5xyn3w8mv4t",
    "cx3xvwq5z2pt",
    "c18k740mgeet",
    "ckde2vgl84wt",
    "ckde2vg8p3nt",
    "czm0p3n804lt",
    "cqymne08vnnt",
    "czm0p3n381kt",
    "ckde2vgm0x5t",
    "c5xyn3w9l3pt",
    "cnx73lwyw88t",
    "cyq4zgkyn1qt",
    "c9041gzyzzpt",
    "cvw1ledp44lt",
    "c2dk3qz35kgt",
    "c2dk3qzwm2vt",
    "c9041gz41w7t",
    "cpzqm83qglmt",
    "cw7lxe13x82t",
    "c5xyn34w1k8t",
    "cqymneqxp4wt",
    "ce31zxge2vlt",
    "c7z584kg133t",
    "ckde2v5lk2kt",
    "cx3xvwk47w4t",
    "c7z584klwn4t",
    "cpzqm835vl5t",
    "ce31zxg8wx0t",
    "ce31zxg8xy4t",
    "cvw1ledev3vt",
    "czm0p3kq544t",
    "cw7lxedy4g0t",
    "c9041g3n8kyt",
    "c18k74v5m20t",
    "cmlw7pe3wgmt",
    "cgmxywg0pd9t",
    "cpzqm870wmxt",
    "c7z584wxzzlt",
    "ckde2v04z2wt",
    "c4lkmd5pwdqt",
    "c18k74v979zt",
    "cyq4zglxnknt",
    "c9041g3w3vmt",
    "cqymne3d9k9t",
    "c34kqd05n0mt",
    "czm0p3lym40t",
    "ckde2v0zg8dt",
    "cmlw7p1lpxnt",
    "c9041ge8k12t",
    "cx3xvw0xmymt",
    "c0gkw73yz0yt",
    "c0gkgvm4pwgt",
    "cpzqg374rl1t",
    "cjg52102j71t",
    "czrx0743vknt",
    "czrx0741qxjt",
    "crx6dnl749jt",
    "cz4pr2gd5y8t",
    "cz4pr2gd5xxt",
    "cz4pr2gd5lxt",
    "cywd23g04xlt",
    "cywd23g04vlt",
    "cywd23g04mqt",
    "cywd23g04eqt",
    "cx1m7zg0wrqt",
    "cx1m7zg0wdvt",
    "cx1m7zg0w4vt",
    "cwlw3xz01q3t",
    "cwlw3xz0183t",
    "cwlw3xz012rt",
    "cvenzmgylvdt",
    "cvenzmgylqdt",
    "cvenzmgyl7rt",
    "cvenzmgyl1dt",
    "cvenzmgyl0rt",
    "crr7mlg0vzlt",
    "crr7mlg0vqet",
    "crr7mlg0v4et",
    "crr7mlg0v3lt",
    "crr7mlg0v3et",
    "cq23pdgvrzmt",
    "cq23pdgvrxzt",
    "cq23pdgvremt",
    "cq23pdgvr8zt",
    "cp7r8vgl2xxt",
    "cp7r8vgl2qlt",
    "cp7r8vgl2dlt",
    "cp7r8vgl20xt",
    "cnx753jenv8t",
    "cnx753jenp8t",
    "cnx753jend8t",
    "cnx753jen8jt",
    "cmj34zmwxr3t",
    "cmj34zmwxq3t",
    "cmj34zmwxn0t",
    "cmj34zmwx80t",
    "cmj34zmwx1lt",
    "clm1wxp5nz1t",
    "clm1wxp5nvmt",
    "clm1wxp5n81t",
    "clm1wxp5n2mt",
    "cjnwl8q4xp7t",
    "cjnwl8q4xm5t",
    "cjnwl8q4x35t",
    "cg41ylwvxpdt",
    "cg41ylwvxe8t",
    "cg41ylwvx58t",
    "cg41ylwvx45t",
    "ce1qrvlexzet",
    "ce1qrvlexylt",
    "ce1qrvlexwlt",
    "ce1qrvlexpet",
    "ce1qrvlex5lt",
    "cdl8n2edxz7t",
    "cdl8n2edxwxt",
    "cdl8n2edxvxt",
    "cdl8n2edxp7t",
    "cdl8n2edx5xt",
    "c8nq32jw8zet",
    "c8nq32jw8xet",
    "c8nq32jw811t",
    "c8nq32jw801t",
    "c77jz3mdqnyt",
    "c77jz3mdqlpt",
    "c77jz3mdq8yt",
    "c77jz3mdq8pt",
    "c77jz3mdq5yt",
    "c50znx8v8m4t",
    "c50znx8v4l5t",
    "c50znx8v4gpt",
    "c50znx8v4d5t",
    "c50znx8v45pt",
    "c40rjmqdwyvt",
    "c40rjmqdwxmt",
    "c40rjmqdwvmt",
    "c40rjmqdwevt",
    "c302m85q1xdt",
    "c302m85q1v0t",
    "c302m85q1rdt",
    "c302m85q1pdt",
    "c302m85q1p0t",
    "c207p54mlrpt",
    "c207p54mlnzt",
    "c207p54mljzt",
    "c207p54mljpt",
    "c207p54ml2zt",
    "c1038wnxevrt",
    "c1038wnxeq1t",
    "c1038wnxe71t",
    "c1038wnxe2rt",
    "c008ql15dxjt",
    "c008ql15djjt",
    "c008ql15d7dt"
  ]

  def call(
        _rest,
        struct = %Struct{request: %Struct.Request{path_params: %{"id" => id, "slug" => _slug}}}
      )
      when id not in @mozart_ids do
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

  def call(_rest, struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) when id in @mozart_ids do
    then(
      ["CircuitBreaker"],
      Struct.add(struct, :private, %{
        platform: MozartNews
      })
    )
  end
end
