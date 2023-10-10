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

defroutefile "Sport" do
  # Vanity URLs

  redirect "/sport/0.app", to: "/sport.app", status: 301
  redirect "/sport/0/*any", to: "/sport/*any", status: 301

  # Sport Optimo Articles
  redirect "/sport/articles", to: "/sport", status: 302
  redirect "/sport/:discipline/articles", to: "/sport/:discipline", status: 302

  handle "/sport/articles/:optimo_id", using: "SportStorytellingPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/sport/articles/:optimo_id.app", using: "SportStorytellingAppPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/sport/articles/:optimo_id.amp", using: "WorldServiceSportArticleAmpPage" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  handle "/sport/:discipline/articles/:optimo_id", using: "SportStorytellingPage" do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportVideos.sports_disciplines_routes, discipline),
      !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
    ]
  end

  handle "/sport/:discipline/articles/:optimo_id.app", using: "SportStorytellingAppPage" do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportVideos.sports_disciplines_routes, discipline),
      !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
    ]
  end

  handle "/sport/:discipline/articles/:optimo_id.amp", using: "WorldServiceSportArticleAmpPage" do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportVideos.sports_disciplines_routes, discipline),
      !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
    ]
  end

  redirect "/sport/amp/:id", to: "/sport/:id.amp", status: 301
  redirect "/sport/amp/:topic/:id", to: "/sport/:topic/:id.amp", status: 301
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

  ## Sport RSS feed redirects - disciplines
  redirect "/sport/alpine-skiing/rss.xml", to: "https://feeds.bbci.co.uk/sport/4d38153b-987e-4497-b959-8be7c968d4d1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/archery/rss.xml", to: "https://feeds.bbci.co.uk/sport/b9a58a01-0c74-8b47-972f-68f922ebd90a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/badminton/rss.xml", to: "https://feeds.bbci.co.uk/sport/21c45f67-36da-874e-ab36-02650add8311/rss.xml", status: 301, ttl: 3600
  redirect "/sport/baseball/rss.xml", to: "https://feeds.bbci.co.uk/sport/4d62f2ca-861b-4db6-bc36-e2e537031718/rss.xml", status: 301, ttl: 3600
  redirect "/sport/biathlon/rss.xml", to: "https://feeds.bbci.co.uk/sport/24c87ae7-78db-449b-b398-ca4237d251e5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/bobsleigh/rss.xml", to: "https://feeds.bbci.co.uk/sport/521df978-7583-4e19-ad6d-2a83a595a8a6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/bowls/rss.xml", to: "https://feeds.bbci.co.uk/sport/039859a4-51ac-447f-a687-728ee2b34817/rss.xml", status: 301, ttl: 3600
  redirect "/sport/canoeing/rss.xml", to: "https://feeds.bbci.co.uk/sport/7e517328-5306-49a4-addb-37a94a2be3bb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cross-country-skiing/rss.xml", to: "https://feeds.bbci.co.uk/sport/a6315c80-6bd3-4be1-a40d-869e49e1a94f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/curling/rss.xml", to: "https://feeds.bbci.co.uk/sport/dd4191d5-115d-46b9-8f18-d1da16c6a3e8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/darts/rss.xml", to: "https://feeds.bbci.co.uk/sport/869e0ec9-af00-4f2b-82b6-b760d69a4492/rss.xml", status: 301, ttl: 3600
  redirect "/sport/diving/rss.xml", to: "https://feeds.bbci.co.uk/sport/d9d6cc4d-79f1-ab49-9c9e-c98d166b99fe/rss.xml", status: 301, ttl: 3600
  redirect "/sport/equestrian/rss.xml", to: "https://feeds.bbci.co.uk/sport/b84fd4d8-b7b5-5b45-9f7a-d701c9f3907f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/fencing/rss.xml", to: "https://feeds.bbci.co.uk/sport/5a9bba82-5f5e-f343-9df7-48fc6d6a008e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/figure-skating/rss.xml", to: "https://feeds.bbci.co.uk/sport/485f8f94-f87e-4513-b133-46a5dfccd428/rss.xml", status: 301, ttl: 3600
  redirect "/sport/freestyle-skiing/rss.xml", to: "https://feeds.bbci.co.uk/sport/fe63c304-110f-4fad-b9c7-7d00410abc92/rss.xml", status: 301, ttl: 3600
  redirect "/sport/gymnastics/rss.xml", to: "https://feeds.bbci.co.uk/sport/02fb02ee-9e6b-46c3-92e1-db372543facd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/handball/rss.xml", to: "https://feeds.bbci.co.uk/sport/3d5e63ec-1f4f-c24c-86ad-fd5d54e014f6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/hockey/rss.xml", to: "https://feeds.bbci.co.uk/sport/e681e822-b849-0243-b698-1b9afe3f3858/rss.xml", status: 301, ttl: 3600
  redirect "/sport/ice-hockey/rss.xml", to: "https://feeds.bbci.co.uk/sport/59ac9a3a-5a8f-4143-bd71-3268762cefc1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/judo/rss.xml", to: "https://feeds.bbci.co.uk/sport/654f550c-0c2d-2341-a8f5-66e3a9ba28ba/rss.xml", status: 301, ttl: 3600
  redirect "/sport/luge/rss.xml", to: "https://feeds.bbci.co.uk/sport/d06b1e90-c9fe-4e09-9b4a-e0f285da8920/rss.xml", status: 301, ttl: 3600
  redirect "/sport/modern-pentathlon/rss.xml", to: "https://feeds.bbci.co.uk/sport/53accf6c-631b-9140-852a-109fab88d3f8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/nordic-combined/rss.xml", to: "https://feeds.bbci.co.uk/sport/fe11a0ff-a7c0-45eb-a9e0-708dddf9bc7d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rowing/rss.xml", to: "https://feeds.bbci.co.uk/sport/452019a5-f0f2-0c47-aa11-42fdcf2ae16b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-sevens/rss.xml", to: "https://feeds.bbci.co.uk/sport/3d556f88-c802-4fcc-9c25-469d2ba7b42a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/sailing/rss.xml", to: "https://feeds.bbci.co.uk/sport/d65c5dce-f5e4-4340-931b-16ca1848d092/rss.xml", status: 301, ttl: 3600
  redirect "/sport/shooting/rss.xml", to: "https://feeds.bbci.co.uk/sport/eceae071-5f37-0848-acd2-f21e3b2de8ca/rss.xml", status: 301, ttl: 3600
  redirect "/sport/short-track-skating/rss.xml", to: "https://feeds.bbci.co.uk/sport/c26d7906-7843-4997-b7d7-f834b82b7919/rss.xml", status: 301, ttl: 3600
  redirect "/sport/skeleton/rss.xml", to: "https://feeds.bbci.co.uk/sport/a7b083b7-0d8b-45d8-9f09-54e6432dacb5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/ski-jumping/rss.xml", to: "https://feeds.bbci.co.uk/sport/8fdc4c32-3d0c-4814-9d69-3bf1269135df/rss.xml", status: 301, ttl: 3600
  redirect "/sport/snowboarding/rss.xml", to: "https://feeds.bbci.co.uk/sport/d5844b24-1e62-4bec-b4e5-bc0e17fe3c8d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/speed-skating/rss.xml", to: "https://feeds.bbci.co.uk/sport/b08bbfea-d065-4ef5-b38f-0e034d42534f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/squash/rss.xml", to: "https://feeds.bbci.co.uk/sport/5b95d205-6cff-4cf1-8fc9-475b29e17511/rss.xml", status: 301, ttl: 3600
  redirect "/sport/synchronised-swimming/rss.xml", to: "https://feeds.bbci.co.uk/sport/bd51d530-f0fb-684e-a305-3f15b7e6d4a1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/table-tennis/rss.xml", to: "https://feeds.bbci.co.uk/sport/f21d1a82-e919-b24f-b3fb-8f2f46372f40/rss.xml", status: 301, ttl: 3600
  redirect "/sport/taekwondo/rss.xml", to: "https://feeds.bbci.co.uk/sport/69cbc5e2-b228-a143-8085-860c053f44f7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/triathlon/rss.xml", to: "https://feeds.bbci.co.uk/sport/c5d39deb-46b8-1e4e-ba2c-5c6e2436b92d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/volleyball/rss.xml", to: "https://feeds.bbci.co.uk/sport/c6e2a7ac-2d13-8640-9f98-41f749d94a6e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/water-polo/rss.xml", to: "https://feeds.bbci.co.uk/sport/e4d61a41-dba2-7849-a725-d8b445ec3cbc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/weightlifting/rss.xml", to: "https://feeds.bbci.co.uk/sport/6b04e406-c181-204b-a2dd-bc20142b9e6a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/wrestling/rss.xml", to: "https://feeds.bbci.co.uk/sport/126190f0-5bd7-7346-a739-39a80c01ae23/rss.xml", status: 301, ttl: 3600

  ## Sport RSS feed redirects - football competitions
  redirect "/sport/football/champions-league/rss.xml", to: "https://feeds.bbci.co.uk/sport/1e5c6e40-0b48-cb44-86ae-be47f66aac8a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/dutch-eredivisie/rss.xml", to: "https://feeds.bbci.co.uk/sport/87d9c2f2-95c4-4db2-915e-e1eead8ce772/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/europa-league/rss.xml", to: "https://feeds.bbci.co.uk/sport/2afbdda7-71d4-544d-bcc6-d9ff50314b2a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/french-ligue-one/rss.xml", to: "https://feeds.bbci.co.uk/sport/f955deb8-a145-4935-9777-c7a61c61b8bc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/german-bundesliga/rss.xml", to: "https://feeds.bbci.co.uk/sport/ced5245a-2d24-4f66-b4e5-50e1add74451/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/italian-serie-a/rss.xml", to: "https://feeds.bbci.co.uk/sport/dd7d8ea7-5f0e-47fc-b1ae-dd5b51ec49a6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/league-cup/rss.xml", to: "https://feeds.bbci.co.uk/sport/f7eeb725-55f4-3542-89ae-f4a4e8bd3c58/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/league-one/rss.xml", to: "https://feeds.bbci.co.uk/sport/030b5eaf-15db-3e4e-bac9-a7789892f436/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/league-two/rss.xml", to: "https://feeds.bbci.co.uk/sport/71d1288c-d1ea-6a4a-bd87-237dbb9e6470/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/national-league/rss.xml", to: "https://feeds.bbci.co.uk/sport/d5e7ede8-a199-804f-9a09-7c91a6df1b96/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/portuguese-primeira-liga/rss.xml", to: "https://feeds.bbci.co.uk/sport/8f8bffd1-91c1-43ad-8dfe-76052aeebb7b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/scottish-challenge-cup/rss.xml", to: "https://feeds.bbci.co.uk/sport/ed80fd46-3713-d445-9419-de091f8a7223/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/scottish-championship/rss.xml", to: "https://feeds.bbci.co.uk/sport/f9ea64db-238d-2545-95a0-6bdecd52c489/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/scottish-cup/rss.xml", to: "https://feeds.bbci.co.uk/sport/96b7c068-a153-d640-8a37-5cfa8e1eff57/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/scottish-league-cup/rss.xml", to: "https://feeds.bbci.co.uk/sport/7ba0e09d-037f-694f-a73b-4deccbb7fda3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/scottish-league-one/rss.xml", to: "https://feeds.bbci.co.uk/sport/5af78336-c06e-0b48-83a2-e50e2c14cba6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/scottish-league-two/rss.xml", to: "https://feeds.bbci.co.uk/sport/7bf5cec0-5a16-2d42-ab3a-bb7137c4ff43/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/scottish-premiership/rss.xml", to: "https://feeds.bbci.co.uk/sport/ebca7141-e8ba-0e40-bba9-d0864e29bc1f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/spanish-la-liga/rss.xml", to: "https://feeds.bbci.co.uk/sport/992139ad-96bd-4ba9-a1ef-f9b2b8dcb445/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/us-major-league/rss.xml", to: "https://feeds.bbci.co.uk/sport/be8b873f-c307-4a8b-b812-e8df53c9c2d1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/welsh-premier-league/rss.xml", to: "https://feeds.bbci.co.uk/sport/6a649f34-6934-4464-8b80-a42a0ee7a1bc/rss.xml", status: 301, ttl: 3600

  ## Sport RSS feed redirects - cricket teams
  redirect "/sport/cricket/teams/adelaide-strikers-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/61f05ed2-4928-484d-afbb-cada71fd18a6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/adelaide-strikers/rss.xml", to: "https://feeds.bbci.co.uk/sport/d42eecec-9e6d-41e1-8305-8f99bc70048a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/afghanistan/rss.xml", to: "https://feeds.bbci.co.uk/sport/77e5f32b-a1d8-45c3-a2c8-aabaf286537d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/auckland/rss.xml", to: "https://feeds.bbci.co.uk/sport/fda1ebf1-9e79-4d49-b3a6-372b37b522d0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/australia-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/4ee2fb3e-9040-4883-be8e-f12dcfbfa0f7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/australia/rss.xml", to: "https://feeds.bbci.co.uk/sport/9d794c09-c573-4a97-9a0e-9518888f19ed/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/bangladesh-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/16abacdc-2b82-4f20-a9bd-bf58b142cadb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/bangladesh/rss.xml", to: "https://feeds.bbci.co.uk/sport/65e7e652-4bcc-4d48-a19c-241f58d830ba/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/barbados-tridents/rss.xml", to: "https://feeds.bbci.co.uk/sport/0a5e2376-0495-4e95-acc4-97957362f34a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/bermuda/rss.xml", to: "https://feeds.bbci.co.uk/sport/2091b53c-6104-4c7b-a797-6cb3ff525366/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/brisbane-heat-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/2d6f237f-9254-47d7-ac56-8cf87bf6eda9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/brisbane-heat/rss.xml", to: "https://feeds.bbci.co.uk/sport/43b8cb70-54e4-4345-b308-f5f334bbc55d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/canada/rss.xml", to: "https://feeds.bbci.co.uk/sport/d69257ce-bf5a-43dc-8c00-852c98eaf5b8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/canterbury/rss.xml", to: "https://feeds.bbci.co.uk/sport/4f521066-17fa-4bd4-b4e5-0f5f57bbab1b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/central-districts/rss.xml", to: "https://feeds.bbci.co.uk/sport/3207f6bb-a064-4542-8b00-042fc95c4409/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/chennai-super-kings/rss.xml", to: "https://feeds.bbci.co.uk/sport/4036b936-03df-4e56-b9b1-de65bcfc3373/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/delhi-daredevils/rss.xml", to: "https://feeds.bbci.co.uk/sport/6b74866b-9c75-44d0-8cea-db97165ac181/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/derbyshire/rss.xml", to: "https://feeds.bbci.co.uk/sport/311fec37-a12a-46d5-9b6a-f485c7413077/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/durham/rss.xml", to: "https://feeds.bbci.co.uk/sport/fe2526f0-d352-4a2f-8b03-9b7b692fd3cd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/england-lions/rss.xml", to: "https://feeds.bbci.co.uk/sport/33791f1b-2d53-4080-bd66-2d27684cfd8f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/england-u19/rss.xml", to: "https://feeds.bbci.co.uk/sport/6f205602-86fe-4942-bf63-88a240095f2c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/england-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/966cc28f-ae31-40f2-b66f-948b56849383/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/england/rss.xml", to: "https://feeds.bbci.co.uk/sport/cd988a73-6c41-4690-b785-c8d3abc2d13c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/essex/rss.xml", to: "https://feeds.bbci.co.uk/sport/6d2040e9-3e55-4662-b463-4878c42726da/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/glamorgan/rss.xml", to: "https://feeds.bbci.co.uk/sport/f1125cb0-7114-4b36-b5b9-469864464b31/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/gloucestershire/rss.xml", to: "https://feeds.bbci.co.uk/sport/7f503ae5-3778-4951-b559-ea30ce7bd167/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/gujarat-lions/rss.xml", to: "https://feeds.bbci.co.uk/sport/559571d1-04da-4ce1-b9f2-83da0a3ed593/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/guyana-amazon-warriors/rss.xml", to: "https://feeds.bbci.co.uk/sport/30e9f536-fa99-45c5-bf72-ccaead1f54c8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/hampshire/rss.xml", to: "https://feeds.bbci.co.uk/sport/1aa023c9-b945-4bda-8b1c-211f9fe9e05f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/hobart-hurricanes-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/a2444e3b-2cd8-4dc9-a6a3-691479a50f61/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/hobart-hurricanes/rss.xml", to: "https://feeds.bbci.co.uk/sport/55252df7-995c-44b0-bfa3-06db9a3d690f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/hong-kong/rss.xml", to: "https://feeds.bbci.co.uk/sport/21f944bb-8fca-41d0-94ab-463310746208/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/india-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/39975f00-e00a-46c4-89b9-85424a1b7846/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/india/rss.xml", to: "https://feeds.bbci.co.uk/sport/5ec63a0c-4a74-43d4-926c-c75789c078c1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/ireland-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/2111aba1-fe08-4804-b1e0-60f2c2b2e768/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/ireland/rss.xml", to: "https://feeds.bbci.co.uk/sport/9057858a-33bd-425c-891c-a9b072728513/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/islamabad-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/18527e36-72c0-4aa9-a5d1-be5c5967eab2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/jamaica-tallawahs/rss.xml", to: "https://feeds.bbci.co.uk/sport/4684f16c-e986-4cf5-9627-1400d4cd588b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/karachi-kings/rss.xml", to: "https://feeds.bbci.co.uk/sport/c5c755df-4463-4e68-982b-f3f1dbd35d9b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/kent/rss.xml", to: "https://feeds.bbci.co.uk/sport/4e1cd8c0-ef81-4cea-a005-ba769e3bb2fb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/kenya/rss.xml", to: "https://feeds.bbci.co.uk/sport/5ef06231-8951-4621-a7d0-6d0edffc5237/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/kings-xi-punjab/rss.xml", to: "https://feeds.bbci.co.uk/sport/de6801f6-6d87-4cf7-bc33-5f494858df59/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/kolkata-knight-riders/rss.xml", to: "https://feeds.bbci.co.uk/sport/d4a190a5-aeec-4499-b27b-579b96ff20a7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/lahore-qalandars/rss.xml", to: "https://feeds.bbci.co.uk/sport/fbd8741e-9ebf-4354-908d-98331bbe15f5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/lancashire-thunder-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/4a783693-13f7-4f75-8c5a-5862a8b2b73b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/lancashire/rss.xml", to: "https://feeds.bbci.co.uk/sport/e3056dd5-434c-4391-a2e4-8e02a31645a7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/leicestershire/rss.xml", to: "https://feeds.bbci.co.uk/sport/6a48e77e-3465-4e35-a94b-dac77299838c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/loughborough-lightning-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/a0823750-7b6f-4434-bfec-7c81e9efc1f5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/melbourne-renegades-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/621b2801-af9d-4c2b-adfb-1c74f38028b0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/melbourne-renegades/rss.xml", to: "https://feeds.bbci.co.uk/sport/faa63b7f-8a98-4ba0-91dc-52f8dc806dcb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/melbourne-stars-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/8a8af5d8-a4f7-42d9-9e61-4f53555bdeef/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/melbourne-stars/rss.xml", to: "https://feeds.bbci.co.uk/sport/ef0e49fd-5f85-4775-bbc6-82199d2b741d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/middlesex/rss.xml", to: "https://feeds.bbci.co.uk/sport/c8b2685d-9517-4601-8561-482e2bd67ea9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/mumbai-indians/rss.xml", to: "https://feeds.bbci.co.uk/sport/cc2373e0-829a-4263-b94c-06d92c34b101/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/namibia/rss.xml", to: "https://feeds.bbci.co.uk/sport/d847d0eb-8ef3-4621-bc99-1bcb48295d95/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/nepal/rss.xml", to: "https://feeds.bbci.co.uk/sport/12ad8c10-085a-46d3-99ba-40ed97f5c95e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/new-south-wales/rss.xml", to: "https://feeds.bbci.co.uk/sport/5678134f-7b08-4bb8-845b-0c7d03b91ebd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/new-zealand-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/cae8e6d6-18d2-49a1-9318-11ab76a96250/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/new-zealand/rss.xml", to: "https://feeds.bbci.co.uk/sport/24e14219-8ae2-4ee7-b180-cad9b0d5bfa2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/northamptonshire/rss.xml", to: "https://feeds.bbci.co.uk/sport/25734f16-1a36-42e0-879a-8cd4c3275028/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/northern-districts/rss.xml", to: "https://feeds.bbci.co.uk/sport/0c312a56-750b-4cb8-af0a-c030227bd933/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/nottinghamshire/rss.xml", to: "https://feeds.bbci.co.uk/sport/2bab7697-c436-4581-87cb-1a9178ad81af/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/oman/rss.xml", to: "https://feeds.bbci.co.uk/sport/67e1c4a6-d2de-4b01-9d7b-34ff86b04a83/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/otago/rss.xml", to: "https://feeds.bbci.co.uk/sport/7816b022-ae54-4042-8bf5-62532043f7da/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/pakistan-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/542d5906-4e33-42ce-8fcf-db7b85116546/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/pakistan/rss.xml", to: "https://feeds.bbci.co.uk/sport/28a3cb5b-a2ea-4283-b58e-d72dc48d6034/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/papua-new-guinea/rss.xml", to: "https://feeds.bbci.co.uk/sport/953617d1-0829-4db4-9e0c-8112abfdb4c3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/perth-scorchers-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/2a1dac62-5285-4116-b4a5-bb86ce6cfe49/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/perth-scorchers/rss.xml", to: "https://feeds.bbci.co.uk/sport/8c72fb6a-88db-438c-ab7d-a551cff9fa61/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/peshawar-zalmi/rss.xml", to: "https://feeds.bbci.co.uk/sport/9a8f1bc1-0d17-46cd-b04f-5d38cc9f660a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/queensland/rss.xml", to: "https://feeds.bbci.co.uk/sport/ef678cf2-8683-4724-9475-9edc3a67d18d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/quetta-gladiators/rss.xml", to: "https://feeds.bbci.co.uk/sport/0b49dafc-4533-46ff-b96a-54fc7ecfaa44/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/rajasthan-royals/rss.xml", to: "https://feeds.bbci.co.uk/sport/adcfac1c-752f-4ee8-89d5-77491322f0c4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/rising-pune-supergiants/rss.xml", to: "https://feeds.bbci.co.uk/sport/04914a15-13f9-4039-aaa7-cd9d7c84719f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/royal-challengers-bangalore/rss.xml", to: "https://feeds.bbci.co.uk/sport/8eaae83a-62d2-4829-ae7e-f1ff4f826680/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/scotland/rss.xml", to: "https://feeds.bbci.co.uk/sport/414600e4-1cf0-429c-831f-81e1b14b9b78/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/somerset/rss.xml", to: "https://feeds.bbci.co.uk/sport/3ebf9ee6-6037-4fdb-b00f-cca98c6574a3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/south-africa-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/142c8b42-12bb-43be-8fb2-37c47f289011/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/south-africa/rss.xml", to: "https://feeds.bbci.co.uk/sport/565d637f-6fb0-4799-8db8-a001978d2222/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/south-australia/rss.xml", to: "https://feeds.bbci.co.uk/sport/af8a77fb-82dd-481d-b485-1e52fe1b925c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/southern-vipers-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/243df71c-9017-4990-b8eb-27830c5dbdd7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/sri-lanka-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/89739cb4-b331-4a52-990b-1be9578aa1ef/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/sri-lanka/rss.xml", to: "https://feeds.bbci.co.uk/sport/fe736477-01b6-4020-8b30-36522ac59457/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/st-kitts-and-nevis-patriots/rss.xml", to: "https://feeds.bbci.co.uk/sport/fc5621f3-697c-43d1-b7b5-43f61c45a283/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/st-lucia-zouks/rss.xml", to: "https://feeds.bbci.co.uk/sport/0a812d7c-fc1d-4910-9375-d95e724a0692/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/sunrisers-hyderabad/rss.xml", to: "https://feeds.bbci.co.uk/sport/3a344289-8095-4073-990e-46ba9ec66377/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/surrey-stars-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/d9f5fc12-532d-4f0d-80e1-aa771bfb583a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/surrey/rss.xml", to: "https://feeds.bbci.co.uk/sport/90c95587-a1bb-4a6c-bba1-1c4b72502129/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/sussex/rss.xml", to: "https://feeds.bbci.co.uk/sport/b86ca75b-7f26-4221-9791-37ddc01660dc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/sydney-sixers-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/7dbe1dcc-b728-4cda-89fe-638f766eb845/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/sydney-sixers/rss.xml", to: "https://feeds.bbci.co.uk/sport/a32be922-6c65-4a90-8c3f-6a8ff035757d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/sydney-thunder-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/6f886524-282a-4a18-9762-1a2a090cab2e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/sydney-thunder/rss.xml", to: "https://feeds.bbci.co.uk/sport/fdcabd65-3252-4684-8342-9aa955a2546f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/tasmania/rss.xml", to: "https://feeds.bbci.co.uk/sport/d2dcb973-6c44-49a9-b2df-2c1a6ea3fa5f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/thailand-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/c7b7e55d-8f9a-4eb7-a020-6c968ae17b27/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/trinbago-knight-riders/rss.xml", to: "https://feeds.bbci.co.uk/sport/6a12bf64-7c6b-407a-a359-7b2937c3ec48/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/united-arab-emirates/rss.xml", to: "https://feeds.bbci.co.uk/sport/5a3060a2-e236-4dbf-8049-86287f369c54/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/united-states/rss.xml", to: "https://feeds.bbci.co.uk/sport/c5663352-b1e0-49a5-8a87-b63129b7d066/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/victoria/rss.xml", to: "https://feeds.bbci.co.uk/sport/0ea042d0-1533-4725-8bb0-29f7cf8863d4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/warwickshire/rss.xml", to: "https://feeds.bbci.co.uk/sport/87e9eb08-b0b1-4232-a585-3762aea99680/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/wellington/rss.xml", to: "https://feeds.bbci.co.uk/sport/7944aea5-cb0d-4eee-87ce-1cec423f458b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/west-indies-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/2f721877-ba0d-4339-820f-c8dfe1a886db/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/west-indies/rss.xml", to: "https://feeds.bbci.co.uk/sport/bea1cb38-a492-44e9-8c9e-8865e4a2c014/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/western-australia/rss.xml", to: "https://feeds.bbci.co.uk/sport/f0140804-77ef-4f50-b0fd-3cac1462b543/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/western-storm-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/62d4e1af-ae4c-401e-a86f-d59d40f23b95/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/worcestershire/rss.xml", to: "https://feeds.bbci.co.uk/sport/f0489362-27b3-4200-b0a9-c73c15b9869a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/yorkshire-diamonds-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/313ec4fc-9a31-4ba7-ac03-9120f3c936ff/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/yorkshire/rss.xml", to: "https://feeds.bbci.co.uk/sport/ae6a1e5a-1636-4e8d-8e0e-fac28430e53e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/cricket/teams/zimbabwe/rss.xml", to: "https://feeds.bbci.co.uk/sport/c645646c-0ca5-46c6-96cd-9eb3d9f278d1/rss.xml", status: 301, ttl: 3600

  ## Sport RSS feed redirects to nice url - cricket teams
  redirect "/sport/1a741adc-d962-473a-b0aa-3548e4fed0b2/rss.xml", to: "https://feeds.bbci.co.uk/sport/cricket/teams/netherlands/rss.xml", status: 301, ttl: 3600

  ## Sport RSS feed redirects - football teams
  redirect "/sport/football/teams/aalborg-bk/rss.xml", to: "https://feeds.bbci.co.uk/sport/45338d77-b0de-44ae-9468-6e6f06c06f03/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/aberdeen/rss.xml", to: "https://feeds.bbci.co.uk/sport/de96e227-7e77-974f-aab2-2e37598c5cc2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/aberystwyth-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/bef52d23-cdda-4d40-9e65-9fe73426745d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/accrington-stanley/rss.xml", to: "https://feeds.bbci.co.uk/sport/cb19b305-06e8-b74e-aac1-53e0966ec4ac/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/afc-bournemouth/rss.xml", to: "https://feeds.bbci.co.uk/sport/0280e88c-26bd-b24c-882f-ae0e5f4142f2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/afc-fylde/rss.xml", to: "https://feeds.bbci.co.uk/sport/b0b871f1-1b43-4f92-96fd-6fcad6fa3645/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/afc-telford-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/1da3b5d2-c5d5-48a0-a6c2-e83a29abf99a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/afc-wimbledon/rss.xml", to: "https://feeds.bbci.co.uk/sport/39885edd-5611-b540-ae3a-43026125bfd8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/airbus-uk-broughton/rss.xml", to: "https://feeds.bbci.co.uk/sport/836824a5-31fc-9747-bd49-f215cfc01a57/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/airdrieonians/rss.xml", to: "https://feeds.bbci.co.uk/sport/beb634cb-1d91-fb42-a3af-da4754910dff/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ajax/rss.xml", to: "https://feeds.bbci.co.uk/sport/eb8f2a69-9b31-4be4-93e5-b85985ef5d9d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/albania/rss.xml", to: "https://feeds.bbci.co.uk/sport/b25761d2-b78b-4d45-8aaf-8f7682d7d394/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/albion-rovers/rss.xml", to: "https://feeds.bbci.co.uk/sport/c2f82556-447b-7249-a2db-bc5106d32f06/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/aldershot-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/6dc681ec-3b9b-2942-9042-f514c00a1f64/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/alfreton-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/fb54f8ca-0d6b-4ff9-b926-e481d6022cce/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/algeria/rss.xml", to: "https://feeds.bbci.co.uk/sport/4f47e77a-218f-47ba-b148-e3493f06943a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/alloa-athletic/rss.xml", to: "https://feeds.bbci.co.uk/sport/ecf61a12-6be0-3948-8a94-98ede890bf33/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/altrincham/rss.xml", to: "https://feeds.bbci.co.uk/sport/2a279a02-73d7-47ef-ad34-eab3733a91a4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/amiens/rss.xml", to: "https://feeds.bbci.co.uk/sport/a99bdb90-fee7-4670-a267-7509fd896ace/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/andorra/rss.xml", to: "https://feeds.bbci.co.uk/sport/bdc57f19-3e73-4cd3-a8c1-482136761925/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/angers/rss.xml", to: "https://feeds.bbci.co.uk/sport/76fe976d-dc70-4f4f-8efc-37db9765e982/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/angola/rss.xml", to: "https://feeds.bbci.co.uk/sport/77e9e3c1-bb79-4852-bab2-bb7d6fd0e12b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/annan-athletic/rss.xml", to: "https://feeds.bbci.co.uk/sport/e93a3145-285d-4940-8018-8bafdc498ff0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/anzhi-makhachkala/rss.xml", to: "https://feeds.bbci.co.uk/sport/5e8b1267-c6bb-4e0f-b439-87d1871b91ff/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/apoel-nicosia/rss.xml", to: "https://feeds.bbci.co.uk/sport/5a32dca6-5765-4175-b47e-70f1d3b5d604/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/arbroath/rss.xml", to: "https://feeds.bbci.co.uk/sport/4a604f70-d799-fe48-b32d-fc5b1471b2d6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/argentina-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/cb4f9e02-ca1f-4f25-92b2-24315d47e114/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/argentina/rss.xml", to: "https://feeds.bbci.co.uk/sport/da7ff3fd-eb71-4cf8-abb1-a8d025e9e135/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/armenia/rss.xml", to: "https://feeds.bbci.co.uk/sport/2df22694-ea99-463b-a212-459215bc237b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/arsenal-ladies/rss.xml", to: "https://feeds.bbci.co.uk/sport/468e5402-d118-4ede-86dc-24278ffbecf3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/arsenal/rss.xml", to: "https://feeds.bbci.co.uk/sport/c4285a9a-9865-2343-af3a-8653f7b70734/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/aston-villa-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/2f32784c-0ea0-4538-ac64-1fb88e734f13/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/aston-villa/rss.xml", to: "https://feeds.bbci.co.uk/sport/9ce8f75f-4dc0-0f46-8e1b-742513527baf/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/atalanta/rss.xml", to: "https://feeds.bbci.co.uk/sport/c8eec46e-f951-4f14-a9b6-005cc4668c27/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/athletic-bilbao/rss.xml", to: "https://feeds.bbci.co.uk/sport/5f293f87-2335-4b8d-9915-2dd20a8900fd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/atletico-madrid/rss.xml", to: "https://feeds.bbci.co.uk/sport/7f66e5fb-f7b1-4b84-a592-80a851950fa4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/augsburg/rss.xml", to: "https://feeds.bbci.co.uk/sport/7cfcb1ff-d667-4592-8398-3594b2e917d3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/australia-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/a50ceb63-923b-41a8-b602-aa755ce1ec76/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/australia/rss.xml", to: "https://feeds.bbci.co.uk/sport/beb68026-a8d4-4e93-a7da-69236e988e18/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/austria-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/e5e99be2-b732-4ef1-b097-4141050a048a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/austria-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/e2821ab9-57f4-4a6b-be09-3091ca53aaac/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/austria/rss.xml", to: "https://feeds.bbci.co.uk/sport/26a06edb-3080-4853-aeb9-2c57a228837b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ayr-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/33d68d3d-a0aa-1047-84d0-dc382de3e875/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/azerbaijan/rss.xml", to: "https://feeds.bbci.co.uk/sport/917ff174-9011-4a0d-9262-912fe9b0711b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bahrain/rss.xml", to: "https://feeds.bbci.co.uk/sport/44a506ff-224c-488c-b667-ce31bc523d3d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bala-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/d32da140-30da-ae4d-9690-fff7c712afb8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bangor-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/85fd98dd-2f8f-9e4d-9e6f-416933e7d305/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/barcelona/rss.xml", to: "https://feeds.bbci.co.uk/sport/a6772faa-1ff9-4a9a-bd99-14e6bc25cf9d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/barnet/rss.xml", to: "https://feeds.bbci.co.uk/sport/78bd2e07-667f-9b48-8941-6d64367babfd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/barnsley/rss.xml", to: "https://feeds.bbci.co.uk/sport/da76bafe-c659-1345-8448-08ef198f492f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/barrow/rss.xml", to: "https://feeds.bbci.co.uk/sport/38f33530-7e5c-784c-ac36-ebcda328426b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/basel/rss.xml", to: "https://feeds.bbci.co.uk/sport/8a9aa962-12eb-4bbb-b86f-451fd31821ef/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bastia/rss.xml", to: "https://feeds.bbci.co.uk/sport/53021f89-0399-47b0-a355-c81f24677a63/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bate-borisov/rss.xml", to: "https://feeds.bbci.co.uk/sport/3ee8a36a-d3d8-448c-b2d5-99ed703dcfb3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bath-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/1cef20c8-b44f-9a49-890b-bbc13b4141da/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bayer-leverkusen/rss.xml", to: "https://feeds.bbci.co.uk/sport/be635de8-c92e-47be-a456-68219c8c99a7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bayern-munich/rss.xml", to: "https://feeds.bbci.co.uk/sport/d801141d-b1ca-4ef7-80fd-208c00dbae7a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/belarus/rss.xml", to: "https://feeds.bbci.co.uk/sport/d45ae6d0-2ddd-4c86-bbd5-eaa6862f3afc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/belgium-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/74678291-0500-488e-8114-6cbfae75fcf2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/belgium-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/86d322c5-9d0c-4c98-8d45-dc129b00e1b9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/belgium/rss.xml", to: "https://feeds.bbci.co.uk/sport/03bc2e07-f0ba-4238-9342-15df338d9759/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/benevento/rss.xml", to: "https://feeds.bbci.co.uk/sport/c794dfb2-9a41-4016-a09c-861240bdf0a3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/benfica/rss.xml", to: "https://feeds.bbci.co.uk/sport/f4588e7d-319d-4f7a-805c-d1676e822f3f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/benin/rss.xml", to: "https://feeds.bbci.co.uk/sport/ae29ce6f-ccb5-46e1-9213-73febdb68e59/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bermuda/rss.xml", to: "https://feeds.bbci.co.uk/sport/c7ebf02e-83e5-4b0f-a546-41041ac4c69e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/berwick-rangers/rss.xml", to: "https://feeds.bbci.co.uk/sport/90e7c0da-d0f3-934a-9c30-c9418ccb0e88/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/besiktas/rss.xml", to: "https://feeds.bbci.co.uk/sport/c5ba74e2-39cb-424f-be8b-a719cc8bba82/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/birmingham-city-ladies/rss.xml", to: "https://feeds.bbci.co.uk/sport/bb3c3d59-4e0f-4c43-8cfa-30e57d9aa54e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/birmingham-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/cfd00353-deb5-5b46-9e1c-e22c9f255468/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/blackburn-rovers/rss.xml", to: "https://feeds.bbci.co.uk/sport/34e9d74f-f917-db47-aa4a-c96ab97e301d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/blackpool/rss.xml", to: "https://feeds.bbci.co.uk/sport/05251295-c015-2e42-839a-efe200441c9d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bolivia/rss.xml", to: "https://feeds.bbci.co.uk/sport/f0c139e1-c80c-47d5-92eb-b01cc5ed8937/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bologna/rss.xml", to: "https://feeds.bbci.co.uk/sport/4c9e70bb-a50f-4aeb-8698-7022295fb178/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bolton-wanderers/rss.xml", to: "https://feeds.bbci.co.uk/sport/25e5e7ca-004e-d349-8c76-ca86f3adfa7b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bordeaux/rss.xml", to: "https://feeds.bbci.co.uk/sport/e21f75b3-7485-4a86-a8fe-5091e1aac64f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/boreham-wood/rss.xml", to: "https://feeds.bbci.co.uk/sport/60b173a1-3dcc-40b9-8129-e9f900ab777f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/borussia-dortmund/rss.xml", to: "https://feeds.bbci.co.uk/sport/f76d29fd-ea7c-4880-9b25-cb98acce6185/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/borussia-moenchengladbach/rss.xml", to: "https://feeds.bbci.co.uk/sport/e68504a3-fa4d-45c0-93d4-6e6c7e25f9a5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bosnia-herzegovina-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/c8bc57f3-b1cf-494c-8559-66c033757b3d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bosnia-herzegovina/rss.xml", to: "https://feeds.bbci.co.uk/sport/e288012f-89ab-429d-9f42-10cf379fb912/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bradford-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/85eef0da-f836-194f-a2d7-4ce0178278f6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/braintree-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/6606e72d-d16c-482a-aab8-28d059313e2a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/brazil-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/99ebf80c-4a4b-41a3-97e2-1d2e72b795d7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/brazil/rss.xml", to: "https://feeds.bbci.co.uk/sport/96a45a0e-876a-4b31-b9bc-25a9eb365dc3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/brechin-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/5074d279-989b-5b40-b54b-a6b834b265e5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/brentford/rss.xml", to: "https://feeds.bbci.co.uk/sport/cf72a7ad-3054-8d4c-a98c-fb0ec5888922/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/brescia/rss.xml", to: "https://feeds.bbci.co.uk/sport/8451bdf1-433f-4706-90f7-6a0589ddc807/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/brest/rss.xml", to: "https://feeds.bbci.co.uk/sport/994fd859-a1f9-496b-9c63-da968d7cae53/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/brighton-and-hove-albion-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/8e7ba1de-5aeb-44ea-96cd-da7fca18f067/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/brighton-and-hove-albion/rss.xml", to: "https://feeds.bbci.co.uk/sport/3d814d88-1f22-d042-a9a6-87fd9216a50a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bristol-city-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/fa296a14-9a7a-4a8e-b723-cb23968496c1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bristol-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/64c75a53-ee2e-3e4e-bd80-b8fa10584123/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bristol-rovers/rss.xml", to: "https://feeds.bbci.co.uk/sport/f7f03b3a-9902-8c4f-aa19-4eb4fb121dba/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bromley/rss.xml", to: "https://feeds.bbci.co.uk/sport/c73ab6a1-a362-4d4c-8413-2f83481ee885/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bulgaria/rss.xml", to: "https://feeds.bbci.co.uk/sport/5a02e0be-50ad-48cf-a798-73b65bfa2f0c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/burkina-faso/rss.xml", to: "https://feeds.bbci.co.uk/sport/2443d45d-6a85-43ad-a760-8afdc2b83317/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/burnley/rss.xml", to: "https://feeds.bbci.co.uk/sport/279a3dc2-9195-264d-be3e-2a52bb61d4fe/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/burton-albion/rss.xml", to: "https://feeds.bbci.co.uk/sport/b5732135-be6e-e74b-ab47-fd360ecbc7c0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/burundi/rss.xml", to: "https://feeds.bbci.co.uk/sport/15a3ccf0-be08-48b7-8779-bc800c868a54/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/bury/rss.xml", to: "https://feeds.bbci.co.uk/sport/4624d7c0-fcab-684d-92f1-23e304d8d879/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/caen/rss.xml", to: "https://feeds.bbci.co.uk/sport/a59b1408-794a-4676-b5c2-5390d6ce8b10/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cagliari/rss.xml", to: "https://feeds.bbci.co.uk/sport/5257a7f4-b161-41de-a593-028b487e680f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cambridge-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/c1d8fb3f-0de9-f145-934f-210757952393/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cameroon-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/0812c485-e35d-4f5a-a76c-0d58019a4b46/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cameroon/rss.xml", to: "https://feeds.bbci.co.uk/sport/f14e9a9a-69e4-4737-9b50-d2030e08aa40/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/canada-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/14b758d8-05e5-4390-a359-cd6686594204/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/canada/rss.xml", to: "https://feeds.bbci.co.uk/sport/0892ffb2-7c2c-4f29-a1d0-3c4d7b7898e1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cape-verde/rss.xml", to: "https://feeds.bbci.co.uk/sport/a1be965a-bdbd-48b3-89b1-868ff5dd5d9f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cardiff-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/bef8a4b5-1ad1-4347-b665-edf581ab7350/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/carlisle-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/73e4de65-4e73-6242-bd9b-fee0578c75fe/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/carmarthen-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/a9f71809-bc55-0846-83cb-bff5ff747c6f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/celta-vigo/rss.xml", to: "https://feeds.bbci.co.uk/sport/24d188ce-a76f-47f0-abcb-1aa001b0c34a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/celtic/rss.xml", to: "https://feeds.bbci.co.uk/sport/6d397eab-9d0d-b84a-a746-8062a76649e5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/charlton-athletic/rss.xml", to: "https://feeds.bbci.co.uk/sport/c7068d17-1330-324a-b2c9-af3c6e0e5d7f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/chelsea-ladies/rss.xml", to: "https://feeds.bbci.co.uk/sport/d216a841-23b2-4e35-87eb-68575475d58a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/chelsea/rss.xml", to: "https://feeds.bbci.co.uk/sport/2acacd19-6609-1840-9c2b-b0820c50d281/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cheltenham-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/e038339b-f929-c640-937a-ba747aa9d3d9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/chester/rss.xml", to: "https://feeds.bbci.co.uk/sport/47f8c370-3db8-499d-a492-8fe161644283/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/chesterfield/rss.xml", to: "https://feeds.bbci.co.uk/sport/a7b3ebaf-c444-5b4d-8e2a-0b236bc3fdd3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/chievo/rss.xml", to: "https://feeds.bbci.co.uk/sport/7f79e78a-dc44-4008-9315-ee2c098dbc85/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/chile-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/e33542b2-d303-4f1b-9a59-6dc0b866994f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/chile/rss.xml", to: "https://feeds.bbci.co.uk/sport/021d0bd4-7cca-450b-9960-2fd51cb9dff5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/china-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/f0c83670-a27d-420e-b063-7b90f4fdce89/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/china/rss.xml", to: "https://feeds.bbci.co.uk/sport/80c861fe-d2c0-4fd0-82a9-cd474d33664d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/chorley/rss.xml", to: "https://feeds.bbci.co.uk/sport/1acaa553-3b71-4de4-8ded-a948972c2caf/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/clyde/rss.xml", to: "https://feeds.bbci.co.uk/sport/0d2bccc3-ba40-7741-b741-485ee78acdf2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/colchester-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/47ba66dc-aa35-2c46-8446-ac85380126a0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/colombia-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/2b4fbd52-830f-4f0d-8d85-331a31bfd37a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/colombia/rss.xml", to: "https://feeds.bbci.co.uk/sport/1dae0d8b-f96e-474e-b6bd-057a96fa771a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/costa-rica-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/b0bd3c2b-d025-4bb8-828f-684329bc50fd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/costa-rica/rss.xml", to: "https://feeds.bbci.co.uk/sport/65058c8d-de38-435a-b90f-7c4b5c52d01a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cove-rangers/rss.xml", to: "https://feeds.bbci.co.uk/sport/32fa443e-dfbc-4a3a-8640-cd7d53470b6b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/coventry-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/dc90cfcb-42b4-5343-84ee-5f49730557eb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cowdenbeath/rss.xml", to: "https://feeds.bbci.co.uk/sport/6ff32eef-0eed-474a-9443-6df2831253fd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/crawley-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/aba57165-6d8d-3c49-93ea-bbf1e4181c74/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/crewe-alexandra/rss.xml", to: "https://feeds.bbci.co.uk/sport/0af7766e-bf70-3a4a-80f3-82bde862187c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/croatia-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/64bdc649-db63-4b65-b036-982fdd645dfa/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/croatia/rss.xml", to: "https://feeds.bbci.co.uk/sport/f032f98f-c256-4c2f-8bdc-d2fadf20a65a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/crotone/rss.xml", to: "https://feeds.bbci.co.uk/sport/b4473ed2-b6ed-4d70-a0bc-0c6087ffde36/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/crystal-palace/rss.xml", to: "https://feeds.bbci.co.uk/sport/eb21087f-1dd7-fd4e-9816-d89ccff84cca/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cska-moscow/rss.xml", to: "https://feeds.bbci.co.uk/sport/4c2896c5-85e1-48e5-a6f1-07d59a5d3242/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cuba/rss.xml", to: "https://feeds.bbci.co.uk/sport/8b176286-1a1f-4e5e-9c6c-f512fc0087f8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/curacao/rss.xml", to: "https://feeds.bbci.co.uk/sport/51a65d8d-8ab7-4662-b303-5fb89ea4ee59/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/cyprus/rss.xml", to: "https://feeds.bbci.co.uk/sport/e3fc5ae5-2050-439c-98e0-f7d306d5cd70/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/czech-republic-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/698abaf8-39f9-4c36-8018-832affec28d0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/czech-republic-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/3e08ee97-bbba-4fcd-a1b6-1c836d284e91/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/czech-republic/rss.xml", to: "https://feeds.bbci.co.uk/sport/6ed6e732-c8ca-4f4a-9377-76fee24216a4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dagenham-and-redbridge/rss.xml", to: "https://feeds.bbci.co.uk/sport/c41395c3-d459-a14c-a4dd-11f9d95121fe/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/darlington/rss.xml", to: "https://feeds.bbci.co.uk/sport/c8b9b627-6e1d-a04a-9b8b-f32a181536f3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/darmstadt/rss.xml", to: "https://feeds.bbci.co.uk/sport/fce24b9e-756c-4620-be0e-e14f5ed70881/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dartford/rss.xml", to: "https://feeds.bbci.co.uk/sport/92e4b172-987a-40df-9a3b-e8afaf7f81b9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/denmark-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/55d417f1-1471-401c-8412-2b4a5180277e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/denmark-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/f51bc0e9-34b7-4df5-8c96-4fdae740383f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/denmark/rss.xml", to: "https://feeds.bbci.co.uk/sport/ff9bb350-0bed-4966-9997-704f830d93c5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/deportivo-alaves/rss.xml", to: "https://feeds.bbci.co.uk/sport/1caed9b2-0d25-42cc-862b-827ae509688e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/deportivo-de-la-coruna/rss.xml", to: "https://feeds.bbci.co.uk/sport/5925c68c-b131-4593-aa5e-dc6128b23efc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/derby-county/rss.xml", to: "https://feeds.bbci.co.uk/sport/be304c00-b9fd-8f44-877d-8785f93bc52d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dijon/rss.xml", to: "https://feeds.bbci.co.uk/sport/5b2fa9c7-fdd8-4c4e-82cf-ef27f83a0506/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/doncaster-rovers/rss.xml", to: "https://feeds.bbci.co.uk/sport/703ce394-97c5-6e42-a585-bd1eec9cca9a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dover-athletic/rss.xml", to: "https://feeds.bbci.co.uk/sport/80db5161-a0d2-46e4-9784-9aeb7a4b9d87/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dr-congo/rss.xml", to: "https://feeds.bbci.co.uk/sport/22cc4560-596f-41ca-9b44-2f253b69b9c4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dumbarton/rss.xml", to: "https://feeds.bbci.co.uk/sport/898f3cbc-2605-ea4e-96cc-b3d186bb7483/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dundee-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/8a535cd8-2260-1a49-8fb2-62f8e7b54ffc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dundee/rss.xml", to: "https://feeds.bbci.co.uk/sport/28028aab-5b3f-0e41-99dd-bca1c431d27b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dunfermline-athletic/rss.xml", to: "https://feeds.bbci.co.uk/sport/329aa45b-dcba-3e43-b3a0-ae5cb3220384/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/dusseldorf/rss.xml", to: "https://feeds.bbci.co.uk/sport/77f41f42-507f-4430-91bf-d78d3e8d1c3b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/east-fife/rss.xml", to: "https://feeds.bbci.co.uk/sport/3d94fcd2-2af0-7941-aedd-c7670238ee20/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/east-stirlingshire/rss.xml", to: "https://feeds.bbci.co.uk/sport/6f30ea40-789b-a147-bdcc-9f17b4e2323f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/eastleigh/rss.xml", to: "https://feeds.bbci.co.uk/sport/deecd9c9-40fa-479b-b21b-4742de2108c9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ebbsfleet-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/d43074fc-1513-43f8-aa35-59b43b60a40b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ecuador-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/f09070d0-b710-4ac1-a1f3-10a71a8e41f0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ecuador/rss.xml", to: "https://feeds.bbci.co.uk/sport/375ef1d5-65ab-4549-899e-195f787f9c6c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/edinburgh-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/e0929b77-04c1-4398-8da6-6f97d2276105/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/egypt/rss.xml", to: "https://feeds.bbci.co.uk/sport/55794b4a-e4d5-44e6-af1a-47eea3027e2a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/eibar/rss.xml", to: "https://feeds.bbci.co.uk/sport/37559593-903e-4762-8720-ece3cf715220/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/eintracht-frankfurt/rss.xml", to: "https://feeds.bbci.co.uk/sport/ff79ba43-5119-4f92-be14-7b2966f21412/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/el-salvador/rss.xml", to: "https://feeds.bbci.co.uk/sport/f5a0b205-c294-40de-9329-a5a88aa74ffa/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/elgin-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/69eec8aa-359c-624d-bb16-1a80f25fad1e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/empoli/rss.xml", to: "https://feeds.bbci.co.uk/sport/9c4d4d40-2956-4a5b-a8e3-e7274bc2a6db/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/england-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/189cf0d6-3b98-45d6-9e01-8957b9221d34/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/england-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/b4f0cb7d-ccb3-4b34-afde-e6fe553e9772/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/england/rss.xml", to: "https://feeds.bbci.co.uk/sport/611ecd3d-8b08-48d5-aee9-d01e7620d2a4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/eskisehirspor/rss.xml", to: "https://feeds.bbci.co.uk/sport/527dd690-8140-4e7c-94b9-de08251fb9fc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/espanyol/rss.xml", to: "https://feeds.bbci.co.uk/sport/73d6cb10-0fb9-4769-97e9-e3a5748e1ef7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/estonia/rss.xml", to: "https://feeds.bbci.co.uk/sport/989f1a15-da76-43f0-bf4f-8328c7c555ca/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ethiopia/rss.xml", to: "https://feeds.bbci.co.uk/sport/c701e5ee-5bc3-4922-a621-d6c51f7477dc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/everton-ladies/rss.xml", to: "https://feeds.bbci.co.uk/sport/6649e4cd-e608-4386-a07b-29474e63256e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/everton/rss.xml", to: "https://feeds.bbci.co.uk/sport/48287aac-b015-1d4e-9c4e-9b8abac03789/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/exeter-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/a63810a1-83f2-2348-8758-bfc1613314fe/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/falkirk/rss.xml", to: "https://feeds.bbci.co.uk/sport/e490e57e-9ef9-e940-b08e-6c8b381298e2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/faroe-islands/rss.xml", to: "https://feeds.bbci.co.uk/sport/aacd7b64-abd7-47cb-a5b6-48f51c3efd0a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/fc-copenhagen/rss.xml", to: "https://feeds.bbci.co.uk/sport/8fd12169-4587-4fc3-b0d3-8655f7ee1626/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/fc-porto/rss.xml", to: "https://feeds.bbci.co.uk/sport/eb06524e-4f39-4bcf-be75-be162b498d6a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/fc-red-bull-salzburg/rss.xml", to: "https://feeds.bbci.co.uk/sport/170dbd85-61e3-4278-84b8-01c47d4bfc46/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/fc-schalke/rss.xml", to: "https://feeds.bbci.co.uk/sport/c89459f0-13ad-4cec-8bb4-7f4264683228/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/finland/rss.xml", to: "https://feeds.bbci.co.uk/sport/8781e9b9-250e-4140-8ef2-a5797a9470e3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/fiorentina/rss.xml", to: "https://feeds.bbci.co.uk/sport/a4cf3728-7b51-4c4e-807e-288635ff45ad/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/fleetwood-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/10ddb0dd-f49b-6d4a-a327-7f1d24805c33/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/forest-green-rovers/rss.xml", to: "https://feeds.bbci.co.uk/sport/3790f140-5444-224e-bf05-ce581dc49b17/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/forfar-athletic/rss.xml", to: "https://feeds.bbci.co.uk/sport/2389e7d4-b6ee-8b42-b430-806fd9a5a7e9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/france-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/e534df02-1f26-4155-a459-9875cae71f41/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/france-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/dbebf4cf-e131-486f-8abe-f489f40f20b2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/france/rss.xml", to: "https://feeds.bbci.co.uk/sport/51bc6665-92bc-4926-8689-969dc76a9d34/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/freiburg/rss.xml", to: "https://feeds.bbci.co.uk/sport/c871db7b-c97b-4e48-8cd4-c43f9cf6cf3b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/frosinone/rss.xml", to: "https://feeds.bbci.co.uk/sport/9e4e22f6-26ec-471e-b558-4e5d20c27cb1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/fulham/rss.xml", to: "https://feeds.bbci.co.uk/sport/98c3db4b-498d-7c4b-acb5-d16ffb214f0d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/galatasaray/rss.xml", to: "https://feeds.bbci.co.uk/sport/206c16b5-5a86-4498-9fbb-33c25c6fef02/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/gateshead/rss.xml", to: "https://feeds.bbci.co.uk/sport/dc0bf7e4-b512-4f45-9a00-1439fa0b50be/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/genoa/rss.xml", to: "https://feeds.bbci.co.uk/sport/cb23fc40-513a-4f0d-a2b7-37494d82b5df/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/georgia/rss.xml", to: "https://feeds.bbci.co.uk/sport/901c84f9-eba9-48af-95ca-8e80e7e81415/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/germany-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/b866b757-104e-4990-a3d2-edd38a7d4070/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/germany-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/737be194-6fc5-4e0d-ba2f-eae4024bd8fd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/germany/rss.xml", to: "https://feeds.bbci.co.uk/sport/280cfc54-a128-417c-a74e-b663a7f2f61f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/getafe/rss.xml", to: "https://feeds.bbci.co.uk/sport/1c1c5511-e83b-46db-b1bf-eceaec937554/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ghana/rss.xml", to: "https://feeds.bbci.co.uk/sport/1e9a1407-3a98-4940-b782-5abd89ebcce4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/gibraltar/rss.xml", to: "https://feeds.bbci.co.uk/sport/b12dd6db-c022-4df3-9ea0-025ec69ac61e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/gillingham/rss.xml", to: "https://feeds.bbci.co.uk/sport/d66791b0-d72a-fc43-b6f7-d7bbf5774ef3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/girona/rss.xml", to: "https://feeds.bbci.co.uk/sport/bd0bc18e-ceb3-4fb7-b430-3320a953aa1f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/gomel/rss.xml", to: "https://feeds.bbci.co.uk/sport/5a71eff5-61a9-4e17-bc37-7ba20ad22178/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/granada/rss.xml", to: "https://feeds.bbci.co.uk/sport/572083a0-a1b4-4b58-9178-943a234b1a8d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/greece/rss.xml", to: "https://feeds.bbci.co.uk/sport/a96d9920-594f-45f2-b2aa-4d3a8b3b6966/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/greenock-morton/rss.xml", to: "https://feeds.bbci.co.uk/sport/b0e4a498-fbda-c74a-81b0-d85e5012dcf1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/grimsby-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/60fb8a80-77b1-4f4e-8ad8-7c0f22f17d64/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/guatemala/rss.xml", to: "https://feeds.bbci.co.uk/sport/139a4f49-ae9b-44db-a8d8-fe73e3e5c686/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/guinea-bissau/rss.xml", to: "https://feeds.bbci.co.uk/sport/e58bd16f-c135-4d8f-aa05-1e30c82693e7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/guinea/rss.xml", to: "https://feeds.bbci.co.uk/sport/19c7835c-7834-455c-89af-4e438ce44d81/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/guingamp/rss.xml", to: "https://feeds.bbci.co.uk/sport/d2a528cd-562f-4e95-bb71-6abd02825237/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/guiseley/rss.xml", to: "https://feeds.bbci.co.uk/sport/35311ec6-496b-4890-ba9e-9fe185479eed/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/guyana/rss.xml", to: "https://feeds.bbci.co.uk/sport/b8dbc515-a3a7-4f8d-b03c-aa675a7c2467/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/haiti/rss.xml", to: "https://feeds.bbci.co.uk/sport/7ff4a510-3eee-4ed2-bc1c-c54896127b77/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/halifax/rss.xml", to: "https://feeds.bbci.co.uk/sport/5f9c3b8a-44fe-4d41-ac80-4719b3e3be2a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hamburg/rss.xml", to: "https://feeds.bbci.co.uk/sport/f6c5e9b7-220b-4dcc-810d-51fb575510e0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hamilton-academical/rss.xml", to: "https://feeds.bbci.co.uk/sport/aad59b59-891c-a54c-bff9-bef648c06766/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hannover/rss.xml", to: "https://feeds.bbci.co.uk/sport/1945f8c2-773f-49fd-b248-55d5620edd2f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/harrogate-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/4ca8f2f3-30b4-4d25-b3c5-71ddb6a51372/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hartlepool-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/b02eddf4-cbf0-ac46-a5f1-4c25ce58306d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/havant-and-waterlooville/rss.xml", to: "https://feeds.bbci.co.uk/sport/cfaa2839-0fc1-4ac9-80cb-61248a01f1f1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hayes-and-yeading-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/f54451db-eebc-304e-9681-7b7d87fd2e1c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/heart-of-midlothian/rss.xml", to: "https://feeds.bbci.co.uk/sport/76976a76-f9f7-3949-bae4-2daa704aa395/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hellas-verona/rss.xml", to: "https://feeds.bbci.co.uk/sport/92bae4bd-bdfd-4904-bf36-0276061b46e8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hereford-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/75ef8f32-4d03-d84e-b1f5-13c8d42a3ec6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hertha-berlin/rss.xml", to: "https://feeds.bbci.co.uk/sport/4fc23804-aa65-46ee-9f68-5ad0044b08dc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hibernian/rss.xml", to: "https://feeds.bbci.co.uk/sport/3e6e2f9a-79f9-7546-bf97-31f46ba6cd5a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hoffenheim/rss.xml", to: "https://feeds.bbci.co.uk/sport/94ba99ae-aeea-42d3-a6f1-71b6cdac0482/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/honduras/rss.xml", to: "https://feeds.bbci.co.uk/sport/1c2a6788-56b4-4b51-9651-07c830c7e0b5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/huddersfield-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/843257c2-309c-a749-9888-615bb448f887/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/huesca/rss.xml", to: "https://feeds.bbci.co.uk/sport/5be2b9ad-f9c7-4a3a-a0e8-a9793bf2b12d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hull-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/10786d02-d602-084f-bfb5-3198a9bebfe7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hungary/rss.xml", to: "https://feeds.bbci.co.uk/sport/af3f9f71-7bb1-4350-906b-db0bcd7c1693/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/hyde/rss.xml", to: "https://feeds.bbci.co.uk/sport/6d6cacec-bfed-4fbf-be52-74869ec6afed/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/iceland-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/e2c07955-11fd-4881-9eab-09aebff092b6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/iceland/rss.xml", to: "https://feeds.bbci.co.uk/sport/9a53bd9f-90f6-4838-9810-9467992de26b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/india/rss.xml", to: "https://feeds.bbci.co.uk/sport/8dc0e127-325a-49d5-935b-f74439e3bf03/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ingolstadt/rss.xml", to: "https://feeds.bbci.co.uk/sport/77f179b4-9c91-4914-9803-767bb0d3d966/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/inter-milan/rss.xml", to: "https://feeds.bbci.co.uk/sport/3447fd88-6593-40f8-8688-143141bd5d22/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/inverness-caledonian-thistle/rss.xml", to: "https://feeds.bbci.co.uk/sport/c2995909-a4ed-bc4d-b659-c56c1dcf65dc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ipswich-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/32a71ba8-5632-3e4b-935c-7cfcb99b33a8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/iran/rss.xml", to: "https://feeds.bbci.co.uk/sport/338af54c-76ea-49dc-ab1d-cf6e3baca684/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/iraq/rss.xml", to: "https://feeds.bbci.co.uk/sport/c900fe7f-2e33-4373-93d3-f94ad1c6b3e1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/israel/rss.xml", to: "https://feeds.bbci.co.uk/sport/d5b732fe-5a7b-42f5-9d1a-206474349efc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/italy-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/bcdd3b1e-a131-4940-98a0-d844acf7bb9d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/italy-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/f99d66eb-dd7d-4297-a7dc-d89a4cc06851/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/italy/rss.xml", to: "https://feeds.bbci.co.uk/sport/18d7cd44-bde2-4b14-97a4-c32f4f17e1c1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ivory-coast-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/db402bd1-a853-4a97-9fc5-47a72e3460c4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ivory-coast/rss.xml", to: "https://feeds.bbci.co.uk/sport/6e18e0db-5746-431f-8e17-c59fd30e36a5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/jamaica-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/2c896aa3-44f0-4a7d-b2c0-9fe3f6b8a891/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/jamaica/rss.xml", to: "https://feeds.bbci.co.uk/sport/2e6b2604-1b9e-4c6a-97a5-be989bfa46b1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/japan-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/0cada216-2c69-46be-9185-b636c0d755f5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/japan/rss.xml", to: "https://feeds.bbci.co.uk/sport/48e56743-a961-42f7-9e7e-066f19e40c71/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/jordan/rss.xml", to: "https://feeds.bbci.co.uk/sport/a27fcfcf-0621-4c78-af6c-1db88bb4a901/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/juventus/rss.xml", to: "https://feeds.bbci.co.uk/sport/6f93127a-159a-45d6-a9d0-97d09b38dd66/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/kazakhstan/rss.xml", to: "https://feeds.bbci.co.uk/sport/72d28c1a-7315-40bf-9ca8-04272af97e9d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/kenya/rss.xml", to: "https://feeds.bbci.co.uk/sport/4e8fccab-5cb1-4354-99fd-79d3c2b16b90/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/kettering-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/859fc11c-e202-b64f-a086-7dba98184dbc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/kidderminster-harriers/rss.xml", to: "https://feeds.bbci.co.uk/sport/fb692d4a-0fbd-b146-b82e-8ca7eb23b7e6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/kilmarnock/rss.xml", to: "https://feeds.bbci.co.uk/sport/aabd5eb3-73c0-6b47-a00d-0b0d6531acbc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/kings-lynn-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/f1d9a9f2-c876-44d6-98a4-9ff2a22c8352/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/koeln/rss.xml", to: "https://feeds.bbci.co.uk/sport/e6f58a46-bd63-4b0a-85a4-e748e9ca22a5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/kosovo/rss.xml", to: "https://feeds.bbci.co.uk/sport/579919ac-dc79-43cf-bbf0-2940205d44ac/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/kyrgyzstan/rss.xml", to: "https://feeds.bbci.co.uk/sport/5d26691c-05ba-4465-af38-5cfba4865b90/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/las-palmas/rss.xml", to: "https://feeds.bbci.co.uk/sport/44bdad3c-5185-430c-822f-64bad2848b83/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/latvia/rss.xml", to: "https://feeds.bbci.co.uk/sport/74b0025f-2d2d-4e29-94fa-e93a247cbeae/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/lazio/rss.xml", to: "https://feeds.bbci.co.uk/sport/756a1eb5-f8bf-486d-b65d-fc74390b7288/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/lebanon/rss.xml", to: "https://feeds.bbci.co.uk/sport/847c7327-941f-43dd-9406-5b74c5b9c1b6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/lecce/rss.xml", to: "https://feeds.bbci.co.uk/sport/2e65069d-6333-4d0d-a29e-3ab63b75de6a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/leeds-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/509d2079-2bf6-e44d-b791-a38bcda66529/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/leganes/rss.xml", to: "https://feeds.bbci.co.uk/sport/2de4dcd0-95df-49f8-8aa8-e6ae96446024/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/legia-warsaw/rss.xml", to: "https://feeds.bbci.co.uk/sport/f1c79ee7-d511-4602-91f5-b4ffafccac5e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/leicester-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/ff55aea0-83d7-834c-afc0-d21045f561e9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/leipzig/rss.xml", to: "https://feeds.bbci.co.uk/sport/a67f03d8-c536-4376-ba03-a317053472e7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/levante/rss.xml", to: "https://feeds.bbci.co.uk/sport/f8af60bf-3adf-4813-8453-8f7f5f699b4b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/leyton-orient/rss.xml", to: "https://feeds.bbci.co.uk/sport/7851e418-cb7e-844f-813d-881e4ea8cf9b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/liechtenstein/rss.xml", to: "https://feeds.bbci.co.uk/sport/dfa3dba2-199e-4e2f-94c8-f57306c44396/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/lille/rss.xml", to: "https://feeds.bbci.co.uk/sport/8ef0bba5-fc49-4e7e-9ee3-1dd9e3672824/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/lincoln-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/dae23c89-2b1f-2e46-95dc-67ae27628201/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/lithuania/rss.xml", to: "https://feeds.bbci.co.uk/sport/825aa545-9794-498e-951c-9b85709a3720/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/liverpool-ladies/rss.xml", to: "https://feeds.bbci.co.uk/sport/8ec20806-f955-4164-b955-e93ef9eba79d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/liverpool/rss.xml", to: "https://feeds.bbci.co.uk/sport/8df31a76-4c22-5b40-9f0d-78b34dfb26fa/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/livingston/rss.xml", to: "https://feeds.bbci.co.uk/sport/bec294ac-1022-ac44-a26b-3b220983fd30/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/llanelli-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/1fc96999-ee3d-5742-a1a6-4e0e0d17ec7b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/lorient/rss.xml", to: "https://feeds.bbci.co.uk/sport/56c824a4-4fa1-42bf-b787-7b9866c45fef/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ludogorets-razgrad/rss.xml", to: "https://feeds.bbci.co.uk/sport/457d4979-d90c-4b1d-9c76-f7b8f7236d46/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/luton-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/5fe62cde-d404-8045-be16-ddb66a00d393/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/luxembourg/rss.xml", to: "https://feeds.bbci.co.uk/sport/70a4c626-30a1-45f2-9054-fd772ea45eca/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/lyon/rss.xml", to: "https://feeds.bbci.co.uk/sport/aea2272e-c26d-481f-bd59-614d7c8053d2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/macclesfield-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/c4ca84fb-af17-8c4e-ac66-a2b5b06aab69/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/macedonia/rss.xml", to: "https://feeds.bbci.co.uk/sport/f6d994e3-d9f8-46e8-b717-6537599190cf/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/madagascar/rss.xml", to: "https://feeds.bbci.co.uk/sport/ad6cc23f-fa33-4c0d-b658-c5e5cdfd75dc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/maidenhead-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/5c29cdb7-fe47-45b9-b11a-492770884a14/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/maidstone-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/c3c3256c-71c5-483a-84a0-0d868b1db118/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/mainz/rss.xml", to: "https://feeds.bbci.co.uk/sport/498ef63e-ed95-4338-bdcc-a00d950527b4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/malaga/rss.xml", to: "https://feeds.bbci.co.uk/sport/a6e8cd4b-e80d-4075-8d7c-26f3ccf63eb8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/mali/rss.xml", to: "https://feeds.bbci.co.uk/sport/113d0cf9-8fc9-48e5-bcb2-514d7b1d2929/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/mallorca/rss.xml", to: "https://feeds.bbci.co.uk/sport/04a7d274-0f82-4ad6-8a12-35da430c6e7e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/malmo-ff/rss.xml", to: "https://feeds.bbci.co.uk/sport/d7b30b58-9349-4686-95b6-b0c3ba668ca1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/malta/rss.xml", to: "https://feeds.bbci.co.uk/sport/e35f6388-3716-4d84-b214-75cbf651e9c9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/manchester-city-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/756e0e9e-5d0c-4acf-a681-1475a227acee/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/manchester-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/4bdbf21d-d1ad-7147-ab08-612cd0dc20b4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/manchester-united-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/bc7eb531-933a-48e4-ba82-d3784d20118f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/manchester-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/90d9a818-850b-b64f-9474-79e15a0355b8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/mansfield-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/407fb29a-fa34-a74e-92c5-dedfa26a2401/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/maribor/rss.xml", to: "https://feeds.bbci.co.uk/sport/61f7b28d-d7f0-471d-a79f-06e154aebc18/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/marseille/rss.xml", to: "https://feeds.bbci.co.uk/sport/31b669ff-ade5-452a-bbd4-3ed7e1f6f88b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/martinique/rss.xml", to: "https://feeds.bbci.co.uk/sport/765113d8-7fa7-4f55-a461-4b8fe28aba9a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/mauritania/rss.xml", to: "https://feeds.bbci.co.uk/sport/6ca2bce6-33c0-4bbc-a7f4-029846117372/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/metalist-kharkiv/rss.xml", to: "https://feeds.bbci.co.uk/sport/193417de-5b0a-4bc3-a697-93bff62d23d5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/metz/rss.xml", to: "https://feeds.bbci.co.uk/sport/7db03a51-1abd-406d-8356-5b37434eb9e8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/mexico-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/a6d5a296-915d-4204-9c02-b289415f5812/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/mexico/rss.xml", to: "https://feeds.bbci.co.uk/sport/c297c13f-ce09-499c-ae5f-a660cfb4e13f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/middlesbrough/rss.xml", to: "https://feeds.bbci.co.uk/sport/39a9af5a-c881-a74d-bae7-226ac220df03/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/milan/rss.xml", to: "https://feeds.bbci.co.uk/sport/85f043fe-1346-470c-96dd-d6ed1c0e47a9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/millwall/rss.xml", to: "https://feeds.bbci.co.uk/sport/aae45535-f9de-0449-9d1f-09e2f5f2a02b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/milton-keynes-dons/rss.xml", to: "https://feeds.bbci.co.uk/sport/77fd06da-b489-3040-ace3-f8ed4f19d839/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/moldova/rss.xml", to: "https://feeds.bbci.co.uk/sport/102f6e2f-79b5-4841-bab3-63f184ed18d4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/monaco/rss.xml", to: "https://feeds.bbci.co.uk/sport/b6f551ab-5c37-44b2-b001-ba73285cc958/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/montenegro/rss.xml", to: "https://feeds.bbci.co.uk/sport/f3992f60-5909-4134-9c58-065f030144b1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/montpellier/rss.xml", to: "https://feeds.bbci.co.uk/sport/fd600554-c07d-407d-b755-8e582e7095c6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/montrose/rss.xml", to: "https://feeds.bbci.co.uk/sport/bcb5f9e3-776e-e041-9b3b-5d2dedb04e53/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/morecambe/rss.xml", to: "https://feeds.bbci.co.uk/sport/10726d19-2831-7e46-b1a6-e229862729f7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/morocco/rss.xml", to: "https://feeds.bbci.co.uk/sport/b9d79493-931c-4265-b558-6a7e283d33f6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/motherwell/rss.xml", to: "https://feeds.bbci.co.uk/sport/11f60fdb-df70-3348-a54d-6a7bcda03b8d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/namibia/rss.xml", to: "https://feeds.bbci.co.uk/sport/f779d5e7-a35d-461d-8f79-852dc1c4a232/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nancy/rss.xml", to: "https://feeds.bbci.co.uk/sport/54afd548-7f72-440c-95b0-2534b5685769/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nantes/rss.xml", to: "https://feeds.bbci.co.uk/sport/eb4c21db-f9a8-444f-882d-f7d82d422adb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/napoli/rss.xml", to: "https://feeds.bbci.co.uk/sport/a15c7264-b424-4d81-ab5e-93da6ea7cb89/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/netherlands-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/5cf42ba7-daad-4dfd-b2ae-e26010e8c9cf/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/netherlands-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/570540a6-b794-4216-8c49-4266bd5e4048/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/netherlands/rss.xml", to: "https://feeds.bbci.co.uk/sport/6d4a2858-462e-4375-b51b-2a4fb480eee2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/new-saints/rss.xml", to: "https://feeds.bbci.co.uk/sport/5336cbc1-2caa-144c-bb78-0ba3b59b19cd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/new-zealand-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/fbb0b905-fc13-47e1-9f90-42582863dcff/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/newcastle-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/34032412-5e2a-324d-bb3e-d0d4b16df2d4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/newport-county/rss.xml", to: "https://feeds.bbci.co.uk/sport/646e45c3-4889-1346-92a2-773da1483fc1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/newtown/rss.xml", to: "https://feeds.bbci.co.uk/sport/ab67a01e-027b-9c4c-971a-c350e98e4667/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nicaragua/rss.xml", to: "https://feeds.bbci.co.uk/sport/b993e234-b89e-4b39-be4b-e2f6f33199c8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nice/rss.xml", to: "https://feeds.bbci.co.uk/sport/08917b83-e64f-4d3b-a475-c3a8399c0e67/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/niger/rss.xml", to: "https://feeds.bbci.co.uk/sport/130164f4-708b-4c58-b845-82cd47465577/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nigeria-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/83826611-b27a-434b-b566-42b0ed96dda8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nigeria/rss.xml", to: "https://feeds.bbci.co.uk/sport/aef9ea59-2f89-4760-a31c-5c319c53d166/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nimes/rss.xml", to: "https://feeds.bbci.co.uk/sport/7e3205d0-7d76-40f1-8039-21b477a1edaa/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/north-ferriby-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/bb1427ba-fdd5-4d35-ad09-9c8bf30e263f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/north-korea/rss.xml", to: "https://feeds.bbci.co.uk/sport/cf825117-9051-4230-9086-183c51db99f4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/northampton-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/f7023361-5d4e-3e48-95cc-61e458eed4bb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/northern-ireland-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/1a5ced7d-e4df-402d-82cc-b50ada08ee5e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/northern-ireland-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/955aad1f-c9ab-40a5-b613-9b9c69cdcc46/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/northern-ireland/rss.xml", to: "https://feeds.bbci.co.uk/sport/c1419a1e-ebc7-4c00-9073-12ed4f0e99de/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/norway-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/996c02c9-0e3c-4e2f-9e34-166ac56979fe/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/norway/rss.xml", to: "https://feeds.bbci.co.uk/sport/bcfa15f8-4ff0-4cfd-ab0d-40ded48e8f5d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/norwich-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/a700cc4d-72eb-a84d-8d7a-73ce435f6985/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nottingham-forest/rss.xml", to: "https://feeds.bbci.co.uk/sport/a3785681-0dce-3842-9e55-e83aa7a1aae1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/notts-county/rss.xml", to: "https://feeds.bbci.co.uk/sport/69ae1e1d-3d11-db4a-9609-283b19d254af/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nuneaton-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/93441dc1-5d81-4c85-81df-89956b63b4cc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/nuremberg/rss.xml", to: "https://feeds.bbci.co.uk/sport/21c0c550-b087-4094-98ab-d4eb3a0c5b9c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/oldham-athletic/rss.xml", to: "https://feeds.bbci.co.uk/sport/661fc640-b304-2d46-bfeb-427505904447/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/olympiakos/rss.xml", to: "https://feeds.bbci.co.uk/sport/70d145c7-d7b2-41dd-8b87-99b3c770a0e0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/oman/rss.xml", to: "https://feeds.bbci.co.uk/sport/8cebd2da-6db3-41fe-b4be-1b7b906e0cd0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/osasuna/rss.xml", to: "https://feeds.bbci.co.uk/sport/a3fa3eca-3f05-4fcb-b716-70ac08c77216/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/oxford-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/03e20e1e-61e9-3749-ae53-0bbaa18e9ed9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/paderborn/rss.xml", to: "https://feeds.bbci.co.uk/sport/d4ef5090-13c2-4dab-bccb-057f79d6a76c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/palermo/rss.xml", to: "https://feeds.bbci.co.uk/sport/48f9379b-2db4-494e-9790-8ef11649cfa8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/palestine/rss.xml", to: "https://feeds.bbci.co.uk/sport/3cd9c8e6-0767-449c-b12e-8a95ccae5624/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/panama/rss.xml", to: "https://feeds.bbci.co.uk/sport/a1bf24e8-88ee-4865-9469-aa71c050c414/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/panathinaikos/rss.xml", to: "https://feeds.bbci.co.uk/sport/3d53aaf6-50b6-40af-8f9c-ff105056a9f9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/paraguay/rss.xml", to: "https://feeds.bbci.co.uk/sport/bf4932d4-aa58-4dfd-8d89-57a09164ba18/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/paris-st-germain/rss.xml", to: "https://feeds.bbci.co.uk/sport/da152cb0-5edd-4d9a-824a-c32e4ebd923b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/parma/rss.xml", to: "https://feeds.bbci.co.uk/sport/f0131ea9-813f-4fe2-a319-57f8118fc918/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/partick-thistle/rss.xml", to: "https://feeds.bbci.co.uk/sport/4b054c51-dff4-a243-a876-fc6595124b47/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/partizan-belgrade/rss.xml", to: "https://feeds.bbci.co.uk/sport/89353f27-827c-45dc-90f9-33c2077247ab/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/peru/rss.xml", to: "https://feeds.bbci.co.uk/sport/931bc5b4-1859-4572-8001-a4d322057ae0/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/pescara/rss.xml", to: "https://feeds.bbci.co.uk/sport/66149bab-0472-4d1f-8ce0-4fb91aa4fc18/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/peterborough-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/a5ac6cfb-67ff-df4b-bd41-adc3295bc813/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/peterhead/rss.xml", to: "https://feeds.bbci.co.uk/sport/98c8f8a4-b663-cf4e-a8d9-77a32c4d5392/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/philippines/rss.xml", to: "https://feeds.bbci.co.uk/sport/730946c3-4ceb-4fd9-afd7-18a399149346/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/plymouth-argyle/rss.xml", to: "https://feeds.bbci.co.uk/sport/b581d4f3-c869-0a47-88ef-1c78d2d5792f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/poland-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/140bcae5-be1d-4018-84bb-46ea902d1c2a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/poland/rss.xml", to: "https://feeds.bbci.co.uk/sport/3d119357-390d-458a-b33c-3910532977fd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/port-vale/rss.xml", to: "https://feeds.bbci.co.uk/sport/0ee936e9-92ed-2b44-88d3-9c658b9bfb4a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/portsmouth/rss.xml", to: "https://feeds.bbci.co.uk/sport/23ec8541-6e72-b447-b75a-2ee1a9856e7c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/portugal-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/23ab0da4-a85d-40e5-84f2-f0ee98013c6d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/portugal-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/d831cbf4-d930-4a3a-87b6-09ad959f6352/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/portugal/rss.xml", to: "https://feeds.bbci.co.uk/sport/50e8aed7-1ce9-4784-962f-e61fea038990/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/prestatyn-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/ccb237ec-9398-5047-a60c-53690eba0ea8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/preston-north-end/rss.xml", to: "https://feeds.bbci.co.uk/sport/222e1b25-9851-5b46-aa20-a2f9e8591d64/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/qatar/rss.xml", to: "https://feeds.bbci.co.uk/sport/e195f56d-570a-4b10-a871-d1d38e622278/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/queen-of-the-south/rss.xml", to: "https://feeds.bbci.co.uk/sport/491e9338-1549-1e49-b202-b157c149271d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/queens-park-rangers/rss.xml", to: "https://feeds.bbci.co.uk/sport/81f6a64f-def0-0d40-bc3a-36dab5472f64/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/queens-park/rss.xml", to: "https://feeds.bbci.co.uk/sport/e870971d-d6e3-504d-888f-d8558d4a4817/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/raith-rovers/rss.xml", to: "https://feeds.bbci.co.uk/sport/3c7725e6-ab7c-2a44-b9c8-08f1b39fa95c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/rangers/rss.xml", to: "https://feeds.bbci.co.uk/sport/5840c45e-73f4-9942-b653-8d7eb8067fc9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/rayo-vallecano/rss.xml", to: "https://feeds.bbci.co.uk/sport/2905619c-8490-4ec9-a59c-cd25f77f0ef7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/reading-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/6e9b8318-933f-4bc9-8ab9-9d6d907a4afd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/reading/rss.xml", to: "https://feeds.bbci.co.uk/sport/0838f428-327a-7f41-9bf4-7758710b572b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/real-betis/rss.xml", to: "https://feeds.bbci.co.uk/sport/e14e65cd-ea5b-4b41-ad23-922b64b55d05/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/real-madrid/rss.xml", to: "https://feeds.bbci.co.uk/sport/1c9c5c77-4d89-414a-a5df-1f9f1a28d630/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/real-sociedad/rss.xml", to: "https://feeds.bbci.co.uk/sport/a7e6c0fe-09e6-4c0a-8dbd-53341cf2c22f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/real-valladolid/rss.xml", to: "https://feeds.bbci.co.uk/sport/4dcb7da4-25bd-464b-a038-9a0f3d8a9e84/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/red-star-belgrade/rss.xml", to: "https://feeds.bbci.co.uk/sport/b719bd8e-1c21-425b-ad3c-f9e501cf4ccb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/reims/rss.xml", to: "https://feeds.bbci.co.uk/sport/8009d1c1-e823-432e-ba5d-41b5db44ec58/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/rennes/rss.xml", to: "https://feeds.bbci.co.uk/sport/4b1d3a19-5e03-43b2-b153-3f58833d8451/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/republic-of-ireland-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/2734989c-c101-4dad-b586-6ff44161c925/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/republic-of-ireland-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/5d0f9de5-6f54-4772-b96d-fe015d4c694a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/republic-of-ireland/rss.xml", to: "https://feeds.bbci.co.uk/sport/65e33e6b-ded0-450a-80fb-0c25fe88b5f6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/rochdale/rss.xml", to: "https://feeds.bbci.co.uk/sport/9284d26e-8e01-db4c-a1dc-1511bf7785fe/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/roma/rss.xml", to: "https://feeds.bbci.co.uk/sport/855796ec-5090-442e-ac5a-b2f0299c26af/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/romania-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/0e6b4d91-8f3b-4cdc-9e1c-b225ea72dd9b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/romania/rss.xml", to: "https://feeds.bbci.co.uk/sport/f1be2537-3c14-40f1-835d-82b4f6507089/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ross-county/rss.xml", to: "https://feeds.bbci.co.uk/sport/88ea67d2-4ee7-ac4c-956a-470565f83cf1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/rotherham-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/7b4a9601-b913-3849-94d9-e6e734f04259/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/rsc-anderlecht/rss.xml", to: "https://feeds.bbci.co.uk/sport/55e38775-ad97-4248-8209-44b01381d73c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/rubin-kazan/rss.xml", to: "https://feeds.bbci.co.uk/sport/43cf5c10-1b41-4a31-90c2-5e58ef0a344f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/russia-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/b0a49f17-cef8-4e08-90ae-e0a6b88c6239/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/russia/rss.xml", to: "https://feeds.bbci.co.uk/sport/a80d80f4-c47e-4417-b1c7-de1af76a03a7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/salford-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/4ec52ad4-0c85-46aa-b7e8-cd7fdbc3f9dc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/salisbury-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/1fca9478-87f9-4654-a265-067bd1ce0d8c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sampdoria/rss.xml", to: "https://feeds.bbci.co.uk/sport/00358f81-e421-4464-bdc9-ecf2034c822e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/san-marino/rss.xml", to: "https://feeds.bbci.co.uk/sport/cb31695c-f178-4958-8ac0-5e4e134c840d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sassuolo/rss.xml", to: "https://feeds.bbci.co.uk/sport/235e7428-a622-44b5-8161-fedc34aff4ab/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/saudi-arabia/rss.xml", to: "https://feeds.bbci.co.uk/sport/04034025-ab84-4bad-a496-d14fc6df2ded/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/scotland-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/2b787a51-4b7e-4320-a5bd-38209c7b44c3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/scotland-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/7d32d130-1a59-43cb-95cb-6221ddf89d98/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/scotland/rss.xml", to: "https://feeds.bbci.co.uk/sport/68c324cd-45c3-42e1-a4fa-3c6b456b7b51/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/scunthorpe-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/7c6e467d-c612-504b-9389-f30226a4b82e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/senegal/rss.xml", to: "https://feeds.bbci.co.uk/sport/1abbf54b-53a3-4a01-b0a8-c3dd60b431f7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/serbia-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/37147249-7c10-495c-a877-ae26d5464786/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/serbia/rss.xml", to: "https://feeds.bbci.co.uk/sport/6247858b-4d10-486f-a3d1-a5ac50788a90/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sevilla/rss.xml", to: "https://feeds.bbci.co.uk/sport/a66cc19e-e179-45f7-9a9b-8632e2b8c450/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/shakhtar-donetsk/rss.xml", to: "https://feeds.bbci.co.uk/sport/6885eb33-1225-48b9-81b1-abf34b13125b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sheffield-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/75f90667-0306-e847-966e-085a11a8f195/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sheffield-wednesday/rss.xml", to: "https://feeds.bbci.co.uk/sport/3e4539d2-bdb9-e548-b04c-1060ad05fe5a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/shrewsbury-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/99bd3ab2-7110-be4f-bc12-1152d31ab75f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/slovakia/rss.xml", to: "https://feeds.bbci.co.uk/sport/4ba212dc-8bc5-4b05-b735-5fd573a6c87c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/slovan-bratislava/rss.xml", to: "https://feeds.bbci.co.uk/sport/d6835cbe-6201-4fcc-9452-9a216c30d738/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/slovenia/rss.xml", to: "https://feeds.bbci.co.uk/sport/1a59e05e-caf4-4475-920a-274ceef2e8ad/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/solihull-moors/rss.xml", to: "https://feeds.bbci.co.uk/sport/7719652d-4013-4e4d-b5a8-f603e57c8c07/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/south-africa-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/5bc3e1ce-a27e-44f4-a9a3-f2cc4d580369/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/south-africa/rss.xml", to: "https://feeds.bbci.co.uk/sport/4acd60e9-8730-49f8-a1f7-2f28de398749/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/south-korea-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/e2ae4ace-46fd-41e1-aa9e-f459dcfeacdf/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/south-korea/rss.xml", to: "https://feeds.bbci.co.uk/sport/50ff6cc4-129e-428a-b936-39618e33f9e6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/southampton/rss.xml", to: "https://feeds.bbci.co.uk/sport/6780f83f-a17a-e641-8ec8-226c285a5dbb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/southend-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/d434ee4d-e0e1-0b49-8251-e3f29e8b5598/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/southport/rss.xml", to: "https://feeds.bbci.co.uk/sport/afc071cb-0a83-1c41-ace5-b361be1ecb0a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/spain-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/84a875c2-b0b7-483c-9c89-5cedd03062e9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/spain-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/a3fec6ab-00fc-4b8f-bbbf-607610e67841/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/spain/rss.xml", to: "https://feeds.bbci.co.uk/sport/b9bb453a-a3e2-46b4-9d20-35efa09d72b8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/spal/rss.xml", to: "https://feeds.bbci.co.uk/sport/69df1063-8877-4f13-8794-df424d1d2b73/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sporting-gijon/rss.xml", to: "https://feeds.bbci.co.uk/sport/35db1f47-102f-46e1-b25e-745d39d9145f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sporting-lisbon/rss.xml", to: "https://feeds.bbci.co.uk/sport/4a0ddf1a-0b72-4c0d-9758-5c1f3cb54a07/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/st-etienne/rss.xml", to: "https://feeds.bbci.co.uk/sport/d4e4d631-52b4-4354-ad10-2741fb31c8a6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/st-johnstone/rss.xml", to: "https://feeds.bbci.co.uk/sport/e0bd00b9-6ae5-1e43-af34-71fde286da18/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/st-mirren/rss.xml", to: "https://feeds.bbci.co.uk/sport/7c461293-7845-3e49-a7bf-96b2c3f6de43/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/standard-liege/rss.xml", to: "https://feeds.bbci.co.uk/sport/488a2b3e-c999-4747-9fba-6af709239157/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/steau-bucharest/rss.xml", to: "https://feeds.bbci.co.uk/sport/5018bb5d-fa01-4a46-9d86-8d0b62362a0a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/stenhousemuir/rss.xml", to: "https://feeds.bbci.co.uk/sport/dea7c3a1-9534-e245-b01f-68741851d2ae/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/stevenage/rss.xml", to: "https://feeds.bbci.co.uk/sport/2784b098-bd1f-a54e-86a5-1fa39a0e0ce4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/stirling-albion/rss.xml", to: "https://feeds.bbci.co.uk/sport/85740113-82ee-4e4e-bb35-fd546ecd48a7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/stockport-county/rss.xml", to: "https://feeds.bbci.co.uk/sport/ec2b9d27-3ef5-2649-ab44-7a14cfa1b2a9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/stoke-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/ff3ad258-564a-3d46-967a-cefa4e65cfea/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/stranraer/rss.xml", to: "https://feeds.bbci.co.uk/sport/92cec538-f1f2-f549-a75e-c95210ed7f7f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/strasbourg/rss.xml", to: "https://feeds.bbci.co.uk/sport/d1b57dca-f093-45e1-979a-16c14e61012d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sunderland-ladies/rss.xml", to: "https://feeds.bbci.co.uk/sport/9cc38e44-b4c7-45dd-a79e-60a3a0e66d9c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sunderland/rss.xml", to: "https://feeds.bbci.co.uk/sport/d5a95ba9-efe6-aa4e-afc4-9adc5f786e58/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sutton-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/a152afdd-8b16-4635-ac48-80117ce891a5/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/swansea-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/98105d9f-b1db-0547-b8c7-581abf30c7e9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sweden-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/29613983-b973-4edb-9403-1636c0d3d10e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sweden-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/98964a23-e32e-4ac7-a087-4ecb1b65dbf4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/sweden/rss.xml", to: "https://feeds.bbci.co.uk/sport/3ac8c344-8b15-4324-b772-5e3d52a704fc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/swindon-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/ba8fb808-bed3-9f4b-ba49-c164c3d3a12c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/switzerland-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/32951909-9d14-45b3-a19a-61780f90c89c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/switzerland-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/5ae1f539-df7e-4d55-84e7-0c1682d8b54b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/switzerland/rss.xml", to: "https://feeds.bbci.co.uk/sport/2688d5c1-aa00-4abb-8b3c-345d83ce3538/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/syria/rss.xml", to: "https://feeds.bbci.co.uk/sport/97184f99-0a66-416d-97ca-9f10b2b43cfd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/tamworth/rss.xml", to: "https://feeds.bbci.co.uk/sport/0e4d1250-73dd-ae4c-801f-99629715dc77/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/tanzania/rss.xml", to: "https://feeds.bbci.co.uk/sport/7b8f9e72-72fa-4bbc-892a-07b675a9b16c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/thailand-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/7149d568-d56e-4a10-b935-91c33af67b59/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/thailand/rss.xml", to: "https://feeds.bbci.co.uk/sport/d9b1cfa0-6653-4da5-ad13-f448475ff9c4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/togo/rss.xml", to: "https://feeds.bbci.co.uk/sport/6ea5913c-9f68-41dd-b3ed-8bd7e10cd39f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/torino/rss.xml", to: "https://feeds.bbci.co.uk/sport/6520ad1c-5219-423e-8192-8051c27aebc6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/torquay-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/5d6f03d0-e049-2847-9de8-3be1d51653f4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/tottenham-hotspur-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/5330f58b-bfaa-447d-8209-4080a33e3412/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/tottenham-hotspur/rss.xml", to: "https://feeds.bbci.co.uk/sport/edc20628-9520-044d-92c3-fdec473457be/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/toulouse/rss.xml", to: "https://feeds.bbci.co.uk/sport/b3f48321-d045-448c-ab44-a8facc4cf8e3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/tranmere-rovers/rss.xml", to: "https://feeds.bbci.co.uk/sport/4573991e-224e-2546-b4fd-6584d1498e23/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/trinidad-and-tobago/rss.xml", to: "https://feeds.bbci.co.uk/sport/b50012cc-99c3-45c9-a290-cb8a90a13e94/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/troyes/rss.xml", to: "https://feeds.bbci.co.uk/sport/42cbc042-1d58-4a46-840a-93137ddc9bf1/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/truro-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/e9d7807d-36d4-4b47-a687-0f29426a32e2/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/tunisia/rss.xml", to: "https://feeds.bbci.co.uk/sport/fb5da161-43c1-4cfc-a24a-9b1d2aa62886/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/turkey/rss.xml", to: "https://feeds.bbci.co.uk/sport/00dceb02-39fb-4fec-98e0-7ab3d00c94e7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/turkmenistan/rss.xml", to: "https://feeds.bbci.co.uk/sport/74ab21e9-b248-4baa-9140-4609c699ff87/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/udinese/rss.xml", to: "https://feeds.bbci.co.uk/sport/29d5b5a1-08a2-48cc-a0c0-ebefddec861c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/uganda/rss.xml", to: "https://feeds.bbci.co.uk/sport/56a6f6d6-dd33-42ab-a48f-290219d08235/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/ukraine/rss.xml", to: "https://feeds.bbci.co.uk/sport/af6492fe-1a6e-4066-8410-83fd00f513c7/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/union-berlin/rss.xml", to: "https://feeds.bbci.co.uk/sport/523e12b6-7173-4553-a703-b78fde7f1346/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/united-arab-emirates/rss.xml", to: "https://feeds.bbci.co.uk/sport/282191e5-393a-4424-9ce1-05fc11613b5d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/uruguay/rss.xml", to: "https://feeds.bbci.co.uk/sport/0690666f-509a-44d4-9505-75d58b99f664/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/usa-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/ef6c624c-be0b-47a6-9e7c-ac4056b5c27d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/usa/rss.xml", to: "https://feeds.bbci.co.uk/sport/77d1e6c2-97a6-450a-904d-21ea66700a53/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/uzbekistan/rss.xml", to: "https://feeds.bbci.co.uk/sport/332a1140-a097-49dd-8a0c-eb7f50699fb6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/valencia/rss.xml", to: "https://feeds.bbci.co.uk/sport/5c1494b0-7730-4f45-be11-4ef04d3d4efc/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/venezuela/rss.xml", to: "https://feeds.bbci.co.uk/sport/d4b3bee1-d813-4d59-8c81-0064b5d807b9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/vfb-stuttgart/rss.xml", to: "https://feeds.bbci.co.uk/sport/a670a2e7-09ce-4ab7-ab2f-03a8678fb295/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/vietnam/rss.xml", to: "https://feeds.bbci.co.uk/sport/44a698f0-304a-42d7-8c58-e503dcba252d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/villarreal/rss.xml", to: "https://feeds.bbci.co.uk/sport/17551c79-999a-4dfd-9f51-28535182153e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/wales-u21/rss.xml", to: "https://feeds.bbci.co.uk/sport/01eeebbe-0ac6-4110-9ea8-97053be307c6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/wales-women/rss.xml", to: "https://feeds.bbci.co.uk/sport/ce446353-4f7a-4229-8768-fd041af9c352/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/wales/rss.xml", to: "https://feeds.bbci.co.uk/sport/4f045458-b81c-48a3-8459-bf5abf7c6b6b/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/walsall/rss.xml", to: "https://feeds.bbci.co.uk/sport/49c1d28f-157a-0940-b73d-29854cdcf810/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/watford/rss.xml", to: "https://feeds.bbci.co.uk/sport/7d1d29cb-dab4-a24f-8600-393be1f354fe/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/wealdstone/rss.xml", to: "https://feeds.bbci.co.uk/sport/695fc803-4c88-4208-a1f2-d5e14897ab44/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/welling-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/0c2fa95a-c5ee-4439-acc7-cb04d996ae89/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/werder-bremen/rss.xml", to: "https://feeds.bbci.co.uk/sport/f3e8f72a-99b1-40a8-a9d6-9e5fbf7c6cfb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/west-bromwich-albion/rss.xml", to: "https://feeds.bbci.co.uk/sport/7f6edf4a-76f6-4b49-b16b-ff1e232eeb18/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/west-ham-united-ladies/rss.xml", to: "https://feeds.bbci.co.uk/sport/95f1ce88-80d8-4bdd-b95c-23f60f6b5918/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/west-ham-united/rss.xml", to: "https://feeds.bbci.co.uk/sport/1fa3a0d0-1a1d-b24a-84a0-ae4607f2123a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/weymouth/rss.xml", to: "https://feeds.bbci.co.uk/sport/87b52975-3bc1-43ad-bc64-682e6e434db9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/wigan-athletic/rss.xml", to: "https://feeds.bbci.co.uk/sport/6db79414-364f-e948-b3cb-5dcf987f799e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/woking/rss.xml", to: "https://feeds.bbci.co.uk/sport/e37fec1a-e644-4b9a-b4a0-ff7b3acfad56/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/wolfsburg/rss.xml", to: "https://feeds.bbci.co.uk/sport/6abc4a67-af36-4abb-8ec2-669e3575e547/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/wolverhampton-wanderers/rss.xml", to: "https://feeds.bbci.co.uk/sport/b68a1520-32bc-eb42-8dc0-ccc1018e8e8f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/wrexham/rss.xml", to: "https://feeds.bbci.co.uk/sport/8545dbc3-560f-fd49-8ebe-f0e325253ae9/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/wycombe-wanderers/rss.xml", to: "https://feeds.bbci.co.uk/sport/fe9a73c6-da9e-c247-934e-6b3bbfc8d93d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/yemen/rss.xml", to: "https://feeds.bbci.co.uk/sport/c27c0133-1c67-4c26-88ab-4b2a3f0cc710/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/yeovil-town-ladies/rss.xml", to: "https://feeds.bbci.co.uk/sport/0b2f0c46-a999-4c12-b0fa-06bb9dfba028/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/yeovil-town/rss.xml", to: "https://feeds.bbci.co.uk/sport/b74aa261-04cb-8845-abf6-bf5648d2ed31/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/york-city/rss.xml", to: "https://feeds.bbci.co.uk/sport/a4dae0b6-d383-1145-83bf-b2c36f3531bb/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/zambia/rss.xml", to: "https://feeds.bbci.co.uk/sport/5c536b5a-c76f-4b77-85b1-9cf8605506b6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/zenit-st-petersburg/rss.xml", to: "https://feeds.bbci.co.uk/sport/dcae0b28-316c-4dfb-a6a9-cb8f5e49f9fd/rss.xml", status: 301, ttl: 3600
  redirect "/sport/football/teams/zimbabwe/rss.xml", to: "https://feeds.bbci.co.uk/sport/1314bba1-65ee-4f2d-8503-23aa45b4b5ad/rss.xml", status: 301, ttl: 3600

  ## Sport RSS feed redirects - rugby league teams
  redirect "/sport/rugby-league/teams/castleford/rss.xml", to: "https://feeds.bbci.co.uk/sport/663de257-779e-4869-bd68-6c469a984469/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/catalans/rss.xml", to: "https://feeds.bbci.co.uk/sport/333aa62f-9b65-4bf2-9556-3ae78123c80e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/huddersfield/rss.xml", to: "https://feeds.bbci.co.uk/sport/6de13fc0-2217-44f3-b4be-f4727008d7ab/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/hull-kr/rss.xml", to: "https://feeds.bbci.co.uk/sport/c1416640-7401-4021-8304-34442d9c423a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/hull/rss.xml", to: "https://feeds.bbci.co.uk/sport/09753e7d-8037-4826-ae66-f3969d0ccb1e/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/leeds/rss.xml", to: "https://feeds.bbci.co.uk/sport/0159dce8-645a-4fa3-b73d-f274e808509c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/london-broncos/rss.xml", to: "https://feeds.bbci.co.uk/sport/3085a7af-7e24-4c59-aa12-8d8680e60254/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/salford/rss.xml", to: "https://feeds.bbci.co.uk/sport/0c9641bb-47b3-4e12-83eb-08a9556e0a0c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/st-helens/rss.xml", to: "https://feeds.bbci.co.uk/sport/684ea433-99a9-44a0-a2d3-4b5bd1e47114/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/wakefield/rss.xml", to: "https://feeds.bbci.co.uk/sport/34dcb1f1-59d8-4555-b55d-d1218d113e2d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/warrington/rss.xml", to: "https://feeds.bbci.co.uk/sport/7d6a100b-69fc-4702-a53f-ec4312102f65/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/widnes/rss.xml", to: "https://feeds.bbci.co.uk/sport/a8dbc02d-8119-4541-baf6-0d14cd1ffe41/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-league/teams/wigan/rss.xml", to: "https://feeds.bbci.co.uk/sport/71843b1d-acf2-48d2-b7a6-3f72bf4d7ce5/rss.xml", status: 301, ttl: 3600

  ## Sport RSS feed redirects - rugby union teams
  redirect "/sport/rugby-union/teams/bath/rss.xml", to: "https://feeds.bbci.co.uk/sport/56404727-1f35-46b9-a42b-1408713eb816/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/bristol/rss.xml", to: "https://feeds.bbci.co.uk/sport/4ee2d754-3f34-43d0-8163-f64e694a565d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/cardiff-blues/rss.xml", to: "https://feeds.bbci.co.uk/sport/20ff4730-bad5-46e1-8b06-c20b5b16ff01/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/connacht/rss.xml", to: "https://feeds.bbci.co.uk/sport/3fd9ec42-fa70-4902-818e-b7574c4cfc60/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/edinburgh/rss.xml", to: "https://feeds.bbci.co.uk/sport/911c44e6-35cf-4451-8323-678c5a679d1d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/exeter/rss.xml", to: "https://feeds.bbci.co.uk/sport/f47d3ef3-b487-48bc-940a-45291d4eb27c/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/glasgow/rss.xml", to: "https://feeds.bbci.co.uk/sport/64bcbbd3-6c7c-4ee9-87a4-b077bde97dc3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/gloucester/rss.xml", to: "https://feeds.bbci.co.uk/sport/b04d768b-f13c-4b50-9098-dc9e3339f887/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/harlequins/rss.xml", to: "https://feeds.bbci.co.uk/sport/64b44a9a-07f6-4a27-892f-49f74610e7de/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/leicester/rss.xml", to: "https://feeds.bbci.co.uk/sport/6d6ddae0-12eb-4c7c-a76f-e6a8a3d2025f/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/leinster/rss.xml", to: "https://feeds.bbci.co.uk/sport/fbc174b2-1fdc-4905-8aa2-536036519848/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/london-irish/rss.xml", to: "https://feeds.bbci.co.uk/sport/ea45cb53-75a4-4bb7-b9c1-a4eb1a51a2ed/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/munster/rss.xml", to: "https://feeds.bbci.co.uk/sport/9f2b27b0-641f-4d9a-a400-b9db34e9cdea/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/newcastle/rss.xml", to: "https://feeds.bbci.co.uk/sport/1345a472-97c2-4f43-8d83-36261ccab1f8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/ng-dragons/rss.xml", to: "https://feeds.bbci.co.uk/sport/08449ec0-069c-45ff-a3ac-0c3efccd4ec3/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/northampton/rss.xml", to: "https://feeds.bbci.co.uk/sport/d4e94988-a6c9-4288-ba18-b82bbf578fc6/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/ospreys/rss.xml", to: "https://feeds.bbci.co.uk/sport/f475527c-74ba-4005-aee2-c529ab8300b4/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/sale/rss.xml", to: "https://feeds.bbci.co.uk/sport/246b8eb1-e7a7-4f6d-b9f2-7cfdeb9c8240/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/saracens/rss.xml", to: "https://feeds.bbci.co.uk/sport/ddd04cdd-783a-411a-b936-1b0e9cde47f8/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/scarlets/rss.xml", to: "https://feeds.bbci.co.uk/sport/1869157e-8fbc-4689-b2b6-ebc6b2900d5a/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/ulster/rss.xml", to: "https://feeds.bbci.co.uk/sport/370949ac-c7ce-4d18-b40a-5d89acd88433/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/wasps/rss.xml", to: "https://feeds.bbci.co.uk/sport/844e6991-c5a1-4efc-98f6-5a307077f45d/rss.xml", status: 301, ttl: 3600
  redirect "/sport/rugby-union/teams/worcester/rss.xml", to: "https://feeds.bbci.co.uk/sport/f9bcd500-e383-408f-9177-6d8468d6ae35/rss.xml", status: 301, ttl: 3600

  ## Sport RSS feeds
  handle "/sport/rss.xml", using: "SportTopicRss"
  handle "/sport/cricket/world-cup/rss.xml", using: "SportTopicRss"
  handle "/sport/cricket/teams/netherlands/rss.xml", using: "SportTopicRss"
  handle "/sport/scotland/rss.xml", using: "SportTopicRss"
  handle "/sport/scotland/shinty/rss.xml", using: "SportTopicRss"
  handle "/sport/football/scottish/rss.xml", using: "SportTopicRss"
  handle "/sport/football/womens/scottish/rss.xml", using: "SportTopicRss"
  handle "/sport/rugby-union/scottish/rss.xml", using: "SportTopicRss"
  handle "/sport/wales/rss.xml", using: "SportTopicRss"
  handle "/sport/football/welsh/rss.xml", using: "SportTopicRss"
  handle "/sport/rugby-union/welsh/rss.xml", using: "SportTopicRss"
  handle "/sport/northern-ireland/rss.xml", using: "SportTopicRss"
  handle "/sport/football/irish/rss.xml", using: "SportTopicRss"
  handle "/sport/rugby-union/irish/rss.xml", using: "SportTopicRss"
  handle "/sport/northern-ireland/gaelic-games/rss.xml", using: "SportTopicRss"
  handle "/sport/northern-ireland/motorbikes/rss.xml", using: "SportTopicRss"
  handle "/sport/football/world-cup/rss.xml", using: "SportTopicRss"
  handle "/sport/disability-sport/rss.xml", using: "SportTopicRss"
  handle "/sport/winter-sports/rss.xml", using: "SportTopicRss"
  handle "/sport/motorsport/rss.xml", using: "SportTopicRss"
  handle "/sport/american-football/rss.xml", using: "SportTopicRss"
  handle "/sport/basketball/rss.xml", using: "SportTopicRss"
  handle "/sport/boxing/rss.xml", using: "SportTopicRss"
  handle "/sport/golf/rss.xml", using: "SportTopicRss"
  handle "/sport/snooker/rss.xml", using: "SportTopicRss"
  handle "/sport/netball/rss.xml", using: "SportTopicRss"
  handle "/sport/mixed-martial-arts/rss.xml", using: "SportTopicRss"
  handle "/sport/rugby-union/english/rss.xml", using: "SportTopicRss"
  handle "/sport/sports-personality/rss.xml", using: "SportTopicRss"
  handle "/sport/football/european/rss.xml", using: "SportTopicRss"
  handle "/sport/football/european-championship/rss.xml", using: "SportTopicRss"
  handle "/sport/football/fa-cup/rss.xml", using: "SportTopicRss"
  handle "/sport/football/premier-league/rss.xml", using: "SportTopicRss"
  handle "/sport/commonwealth-games/rss.xml", using: "SportTopicRss"
  handle "/sport/cricket/rss.xml", using: "SportTopicRss"
  handle "/sport/cricket/video/rss.xml", using: "SportTopicRss"
  handle "/sport/cricket/womens/rss.xml", using: "SportTopicRss"
  handle "/sport/cricket/counties/rss.xml", using: "SportTopicRss"
  handle "/sport/olympics/rss.xml", using: "SportTopicRss"
  handle "/sport/winter-olympics/rss.xml", using: "SportTopicRss"
  handle "/sport/athletics/rss.xml", using: "SportTopicRss"
  handle "/sport/cycling/rss.xml", using: "SportTopicRss"
  handle "/sport/horse-racing/rss.xml", using: "SportTopicRss"
  handle "/sport/swimming/rss.xml", using: "SportTopicRss"
  handle "/sport/:discipline/rss.xml", using: "SportRssGuid"
  handle "/sport/:discipline/:tournament/rss.xml", using: "SportRss"
  handle "/sport/:discipline/:tournament/:year/rss.xml", using: "SportRss"

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
  redirect "/sport/football/conference.app", to: "/sport/football/national-league.app", status: 301
  redirect "/sport/football/conference", to: "/sport/football/national-league", status: 301
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
  redirect "/sport/football/european-championship-qualifying/scores-fixtures.app", to: "/sport/football/european-championship/scores-fixtures.app", status: 301
  redirect "/sport/football/european-championship-qualifying/scores-fixtures", to: "/sport/football/european-championship/scores-fixtures", status: 301
  redirect "/sport/football/european-championship-qualifying/scores-fixtures/:date.app", to: "/sport/football/european-championship/scores-fixtures/:date.app", status: 301
  redirect "/sport/football/european-championship-qualifying/scores-fixtures/:date", to: "/sport/football/european-championship/scores-fixtures/:date", status: 301
  redirect "/sport/football/european-championship-qualifying/table.app", to: "/sport/football/european-championship/table.app", status: 301
  redirect "/sport/football/european-championship-qualifying/table", to: "/sport/football/european-championship/table", status: 301
  redirect "/sport/olympics/rio-2016/video.app", to: "/sport/olympics/video.app", status: 301
  redirect "/sport/olympics/rio-2016/video", to: "/sport/olympics/video", status: 301

  ## Sport unsupported data page redirects handled by Mozart
  handle "/sport/commonwealth-games/home-nations/*any", using: "SportRedirects"
  handle "/sport/commonwealth-games/medals/*any", using: "SportRedirects"
  handle "/sport/commonwealth-games/results/*any", using: "SportRedirects"
  handle "/sport/commonwealth-games/schedule/*any", using: "SportRedirects"
  handle "/sport/commonwealth-games/sports/*any", using: "SportRedirects"
  handle "/sport/football/european-championship/2012/*any", using: "SportRedirects"
  handle "/sport/football/european-championship/2016/*any", using: "SportRedirects"
  handle "/sport/football/european-championship/euro-2016/*any", using: "SportRedirects"
  handle "/sport/football/european-championship/schedule/*any", using: "SportRedirects"
  handle "/sport/olympics/2012/*any", using: "SportRedirects"
  handle "/sport/olympics/2016/*any", using: "SportRedirects"
  handle "/sport/olympics/rio-2016/*any", using: "SportRedirects"
  handle "/sport/paralympics/rio-2016/medals/*any", using: "SportRedirects"
  handle "/sport/paralympics/rio-2016/schedule/*any", using: "SportRedirects"
  handle "/sport/winter-olympics/home-nations/*any", using: "SportRedirects"
  handle "/sport/winter-olympics/medals/*any", using: "SportRedirects"
  handle "/sport/winter-olympics/results/*any", using: "SportRedirects"
  handle "/sport/winter-olympics/schedule/*any", using: "SportRedirects"
  handle "/sport/winter-olympics/sports/*any", using: "SportRedirects"

  ## Sport topic redirects
  redirect "/sport/football/fifa-womens-world-cup", to: "/sport/football/womens-world-cup", status: 302
  redirect "/sport/topics/c9r003qdg5wt", to: "/sport/sustainability", status: 301

  ## Sport Visual Journalism
  handle "/sport/extra/*any", using: "Sport"

  ## Sport SFV - use query string params in example URLs to use live data via Mozart where required
  handle "/sport/av/:id.app", using: "SportVideosAppPage", only_on: "test" do
    return_404 if: !matches?(id, ~r/\A[0-9]{4,9}\z/)
  end
  handle "/sport/av/:id.app", using: "SportMediaAssetPage", only_on: "live"
  handle "/sport/av/:id", using: "SportVideos" do
    return_404 if: !matches?(id, ~r/\A[0-9]{4,9}\z/)
  end

  handle "/sport/av/:discipline/:id.app", using: "SportMediaAssetPage", only_on: "live"

  ## Sport SFV - validate Section(Discipline) and ID
  handle "/sport/av/:discipline/:id.app", using: "SportVideosAppPage", only_on: "test" do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportVideos.sports_disciplines_routes, discipline),
      !matches?(id, ~r/\A[0-9]{4,9}\z/)
    ]
  end
  handle "/sport/av/:discipline/:id", using: "SportVideos" do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportVideos.sports_disciplines_routes, discipline),
      !matches?(id, ~r/\A[0-9]{4,9}\z/)
    ]
  end

  redirect "/sport/videos", to: "/sport", status: 301

  handle "/sport/videos/:optimo_id.app", using: "SportVideosAppPage", only_on: "test" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end
  handle "/sport/videos/:optimo_id", using: "SportVideos" do
    return_404 if: !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
  end

  redirect "/sport/:discipline/videos", to: "/sport/:discipline", status: 301

  handle "/sport/:discipline/videos/:optimo_id.app", using: "SportVideosAppPage", only_on: "test" do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportVideos.sports_disciplines_routes, discipline),
      !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
    ]
  end
  handle "/sport/:discipline/videos/:optimo_id", using: "SportVideos" do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportVideos.sports_disciplines_routes, discipline),
      !String.match?(optimo_id, ~r/^c[abcdefghjklmnpqrstuvwxyz0-9]{10,}o$/)
    ]
  end

  ## Sport Internal Tools - use query string params in example URLs to use live data via Mozart where required
  handle "/sport/internal/football-team-selector/:slug", using: "Sport"
  handle "/sport/internal/player-rater/:event_id", using: "Sport"
  handle "/sport/internal/ranked-list/:slug", using: "Sport"

  ## Sport Alpha Trials
  handle "/sport/alpha/top-4.app", using: "Sport"
  handle "/sport/alpha/top-4", using: "Sport"

  handle "/sport/alpha/basketball/scores-fixtures", using: "SportDataWebcore"
  handle "/sport/alpha/basketball/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end
  handle "/sport/alpha/basketball/:tournament/scores-fixtures", using: "SportDataWebcore"
  handle "/sport/alpha/basketball/:tournament/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end

  handle "/sport/alpha/netball/scores-fixtures", using: "SportDataWebcore"
  handle "/sport/alpha/netball/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end
  handle "/sport/alpha/netball/:tournament/scores-fixtures", using: "SportDataWebcore"
  handle "/sport/alpha/netball/:tournament/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end

  handle "/sport/alpha/:sport/scores-fixtures", using: "SportDataScoresFixturesWebcore"
  handle "/sport/alpha/:sport/scores-fixtures.app", using: "SportDataScoresFixturesWebcore"
  handle "/sport/alpha/:sport/scores-fixtures/:date", using: "SportDataScoresFixturesWebcore" do
    return_404 if: !is_2020s_iso_date?(date) and !is_2020s_iso_month?(date)
  end
  handle "/sport/alpha/:sport/scores-fixtures/:date.app", using: "SportDataScoresFixturesWebcore" do
    return_404 if: !is_2020s_iso_date?(date) and !is_2020s_iso_month?(date)
  end
  handle "/sport/alpha/:sport/:tournament/scores-fixtures", using: "SportDataScoresFixturesWebcore"
  handle "/sport/alpha/:sport/:tournament/scores-fixtures.app", using: "SportDataScoresFixturesWebcore"
  handle "/sport/alpha/:sport/:tournament/scores-fixtures/:date", using: "SportDataScoresFixturesWebcore" do
    return_404 if: !is_2020s_iso_date?(date) and !is_2020s_iso_month?(date)
  end
  handle "/sport/alpha/:sport/:tournament/scores-fixtures/:date.app", using: "SportDataScoresFixturesWebcore" do
    return_404 if: !is_2020s_iso_date?(date) and !is_2020s_iso_month?(date)
  end
  handle "/sport/alpha/:sport/teams/:team/scores-fixtures", using: "SportDataScoresFixturesWebcore"
  handle "/sport/alpha/:sport/teams/:team/scores-fixtures.app", using: "SportDataScoresFixturesWebcore"
  handle "/sport/alpha/:sport/teams/:team/scores-fixtures/:date", using: "SportDataScoresFixturesWebcore" do
    return_404 if: !is_2020s_iso_date?(date) and !is_2020s_iso_month?(date)
  end
  handle "/sport/alpha/:sport/teams/:team/scores-fixtures/:date.app", using: "SportDataScoresFixturesWebcore" do
    return_404 if: !is_2020s_iso_date?(date) and !is_2020s_iso_month?(date)
  end

  redirect "/sport/alpha/football/:tournament/top-scorers/assists", to: "/sport/alpha/football/:tournament/top-scorers#TopAssists", status: 301
  redirect "/sport/alpha/football/:tournament/top-scorers/assists.app", to: "/sport/alpha/football/:tournament/top-scorers.app#TopAssists", status: 301
  redirect "/sport/alpha/football/teams/:team/top-scorers/assists", to: "/sport/alpha/football/teams/:team/top-scorers#TopAssists", status: 301
  redirect "/sport/alpha/football/teams/:team/top-scorers/assists.app", to: "/sport/alpha/football/teams/:team/top-scorers.app#TopAssists", status: 301
  handle "/sport/alpha/football/:tournament/top-scorers", using: "SportDataFootballTopScorersWebcore" do
    return_404 if: !is_slug?(tournament)
  end
  handle "/sport/alpha/football/:tournament/top-scorers.app", using: "SportDataFootballTopScorersWebcore" do
    return_404 if: !is_slug?(tournament)
  end
  handle "/sport/alpha/football/teams/:team/top-scorers", using: "SportDataFootballTopScorersWebcore" do
    return_404 if: !is_slug?(team)
  end
  handle "/sport/alpha/football/teams/:team/top-scorers.app", using: "SportDataFootballTopScorersWebcore" do
    return_404 if: !is_slug?(team)
  end

  ## Sport Embeds Alpha Trials
  handle "/sport/alpha/:sport/sport-embeds-previews/team-selector/:id", using: "SportEmbedsTeamSelector"

  ## Sport Alpha Trials Default
  handle "/sport/alpha/*any", using: "SportAlpha"

  ## Sport Top 4
  handle "/sport/top-4.app", using: "Sport"
  handle "/sport/top-4", using: "Sport"

  ## Sport BBC Live - use query string params in example URLs to use live data via Mozart where required
  ## Smoke test on this route are sometimes flakey

  ### Sport BBC Live - CPS & TIPO - No Discipline
  handle "/sport/live/:asset_id", using: "SportLivePage" do
    return_404 if: [
      !(is_tipo_id?(asset_id) or is_cps_id?(asset_id)),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50),
      !(is_nil(conn.query_params["post"]) or is_asset_guid?(conn.query_params["post"])),
    ]
  end
  handle "/sport/live/:asset_id.app", using: "SportLivePage" do
    return_404 if: [
      !(is_tipo_id?(asset_id) or is_cps_id?(asset_id)),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50),
      !(is_nil(conn.query_params["post"]) or is_asset_guid?(conn.query_params["post"])),
    ]
  end

  ### Sport BBC Live - CPS - No Discipline & Page Number
  handle "/sport/live/:asset_id/page/:page_number", using: "SportLivePage" do
    return_404 if: [
      !is_cps_id?(asset_id),
    ]
  end
  handle "/sport/live/:asset_id/page/:page_number.app", using: "SportLivePage" do
    return_404 if: [
      !is_cps_id?(asset_id),
    ]
  end

  ### Sport BBC Live - CPS - Football Discipline
  handle "/sport/live/football/*any", using: "SportFootballLivePage"

  ### Sport BBC Live - CPS - Discipline
  handle "/sport/live/:discipline/:asset_id/*any", using: "SportLivePage" do
    return_404 if: [
      !is_cps_id?(asset_id),
    ]
  end

  ### Sport BBC Live - TIPO - Football Discipline
  handle "/sport/football/live/:tipo_id", using: "SportWebcoreFootballLivePage" do
    return_404 if: [
      !is_tipo_id?(tipo_id),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50),
      !(is_nil(conn.query_params["post"]) or is_asset_guid?(conn.query_params["post"])),
    ]
  end
  handle "/sport/football/live/:tipo_id.app", using: "SportWebcoreFootballLivePage" do
    return_404 if: [
      !is_tipo_id?(tipo_id),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50),
      !(is_nil(conn.query_params["post"]) or is_asset_guid?(conn.query_params["post"])),
    ]
  end

  ### Sport BBC Live - TIPO - Discipline
  handle "/sport/:discipline/live/:tipo_id", using: "SportWebcoreLivePage" do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportWebcoreLivePage.sports_disciplines_routes, discipline),
      !is_tipo_id?(tipo_id),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50),
      !(is_nil(conn.query_params["post"]) or is_asset_guid?(conn.query_params["post"])),
    ]
  end
  handle "/sport/:discipline/live/:tipo_id.app", using: "SportWebcoreLivePage" do
    return_404 if: [
      !Enum.member?(Routes.Specs.SportWebcoreLivePage.sports_disciplines_routes, discipline),
      !is_tipo_id?(tipo_id),
      !integer_in_range?(conn.query_params["page"] || "1", 1..50),
      !(is_nil(conn.query_params["post"]) or is_asset_guid?(conn.query_params["post"])),
    ]
  end

  ## Sport Misc
  handle "/sport/sitemap.xml", using: "Sport"

  ## Sport Live Guide
  handle "/sport/live-guide.app", using: "SportLiveGuide"
  handle "/sport/live-guide", using: "SportLiveGuide"
  handle "/sport/live-guide/*any", using: "SportLiveGuide"

  ## Sport Video Collections
  handle "/sport/:discipline/video.app", using: "SportMediaAssetPage"
  handle "/sport/cricket/video", using: "SportWebcoreVideoIndexPage"
  handle "/sport/:discipline/video", using: "SportMediaAssetPage"
  handle "/sport/:discipline/:tournament/video.app", using: "SportMediaAssetPage"
  handle "/sport/:discipline/:tournament/video", using: "SportMediaAssetPage"

  ## Sport Vanity Urls
  handle "/sport/all-sports.app", using: "SportStoryPage"
  handle "/sport/all-sports", using: "SportStoryPage"
  handle "/sport/cricket/teams.app", using: "SportStoryPage"
  handle "/sport/cricket/teams", using: "SportStoryPage"
  handle "/sport/football/gossip.app", using: "SportStoryPage"
  handle "/sport/football/gossip", using: "SportStoryPage"
  handle "/sport/football/leagues-cups.app", using: "SportStoryPage"
  handle "/sport/football/leagues-cups", using: "SportStoryPage"
  handle "/sport/football/scottish/gossip.app", using: "SportStoryPage"
  handle "/sport/football/scottish/gossip", using: "SportStoryPage"
  handle "/sport/football/teams.app", using: "SportStoryPage"
  handle "/sport/football/teams", using: "SportStoryPage"
  handle "/sport/football/transfers.app", using: "SportStoryPage"
  handle "/sport/football/transfers", using: "SportStoryPage"
  handle "/sport/my-sport.app", using: "SportStoryPage"
  handle "/sport/my-sport", using: "SportStoryPage"
  handle "/sport/rugby-league/teams.app", using: "SportStoryPage"
  handle "/sport/rugby-league/teams", using: "SportStoryPage"
  handle "/sport/rugby-union/teams.app", using: "SportStoryPage"
  handle "/sport/rugby-union/teams", using: "SportStoryPage"

  ## Sport Manual Indexes
  handle "/sport", using: "SportHomePage"
  handle "/sport/africa", using: "SportIndexPage"
  handle "/sport/american-football", using: "SportWebcoreIndexPage"
  handle "/sport/athletics", using: "SportWebcoreMajorIndexPage"
  handle "/sport/basketball", using: "SportWebcoreIndexPage"
  handle "/sport/boxing", using: "SportWebcoreIndexPage"
  handle "/sport/commonwealth-games", using: "SportWebcoreIndexPage"
  handle "/sport/cricket", using: "SportWebcoreCricketIndexPage"
  handle "/sport/cricket/counties", using: "SportWebcoreCricketIndexPage"
  handle "/sport/cricket/womens", using: "SportWebcoreCricketIndexPage"
  handle "/sport/cycling", using: "SportWebcoreMajorIndexPage"
  handle "/sport/disability-sport", using: "SportWebcoreIndexPage"
  handle "/sport/england", using: "SportHomeNationIndexPage"
  handle "/sport/football", using: "SportFootballIndexPage"
  handle "/sport/football/championship", using: "SportFootballIndexPage"
  handle "/sport/football/european-championship", using: "SportWebcoreFootballSubIndexPage"
  handle "/sport/football/european", using: "SportWebcoreFootballSubIndexPage"
  handle "/sport/football/fa-cup", using: "SportWebcoreFootballSubIndexPage"
  handle "/sport/football/irish", using: "SportWebcoreFootballSubIndexPage"
  handle "/sport/football/premier-league", using: "SportWebcoreFootballSubIndexPage"
  handle "/sport/football/scottish", using: "SportWebcoreFootballSubIndexPage"
  handle "/sport/football/womens/scottish", using: "SportWebcoreFootballSubIndexPage"
  handle "/sport/football/welsh", using: "SportWebcoreFootballSubIndexPage"
  handle "/sport/football/womens", using: "SportFootballIndexPage"
  handle "/sport/football/world-cup", using: "SportWebcoreFootballSubIndexPage"
  handle "/sport/formula1", using: "SportMajorIndexPage"
  handle "/sport/get-inspired", using: "SportIndexPage"
  handle "/sport/get-inspired/activity-guides", using: "SportIndexPage"
  handle "/sport/golf", using: "SportWebcoreIndexPage"
  handle "/sport/horse-racing", using: "SportWebcoreIndexPage"
  handle "/sport/mixed-martial-arts", using: "SportWebcoreIndexPage"
  handle "/sport/motorsport", using: "SportWebcoreIndexPage"
  handle "/sport/netball", using: "SportWebcoreIndexPage"
  handle "/sport/northern-ireland", using: "SportWebcoreNationIndexPage"
  handle "/sport/northern-ireland/gaelic-games", using: "SportWebcoreIndexPage"
  handle "/sport/northern-ireland/motorbikes", using: "SportWebcoreIndexPage"
  handle "/sport/olympics", using: "SportWebcoreIndexPage"
  handle "/sport/rugby-league", using: "SportRugbyIndexPage"
  handle "/sport/rugby-union", using: "SportRugbyIndexPage"
  handle "/sport/rugby-union/english", using: "SportWebcoreIndexPage"
  handle "/sport/rugby-union/irish", using: "SportWebcoreIndexPage"
  handle "/sport/rugby-union/scottish", using: "SportWebcoreIndexPage"
  handle "/sport/rugby-union/welsh", using: "SportWebcoreIndexPage"
  handle "/sport/scotland", using: "SportWebcoreNationIndexPage"
  handle "/sport/scotland/shinty", using: "SportWebcoreIndexPage"
  handle "/sport/snooker", using: "SportWebcoreIndexPage"
  handle "/sport/sports-personality", using: "SportWebcoreIndexPage"
  handle "/sport/swimming", using: "SportWebcoreIndexPage"
  handle "/sport/tennis", using: "SportMajorIndexPage"
  handle "/sport/wales", using: "SportWebcoreNationIndexPage"
  handle "/sport/winter-olympics", using: "SportWebcoreIndexPage"
  handle "/sport/winter-sports", using: "SportWebcoreIndexPage"

  ## Morph (.app) Sport Manual Indexes

  handle "/sport.app", using: "SportMajorIndexPage"
  handle "/sport/africa.app", using: "SportIndexPage"
  handle "/sport/athletics.app", using: "SportMajorIndexPage"
  handle "/sport/commonwealth-games.app", using: "SportIndexPage"
  handle "/sport/cricket.app", using: "SportCricketIndexPage"
  handle "/sport/cricket/counties.app", using: "SportCricketIndexPage"
  handle "/sport/cricket/womens.app", using: "SportCricketIndexPage"
  handle "/sport/cycling.app", using: "SportMajorIndexPage"
  handle "/sport/england.app", using: "SportHomeNationIndexPage"
  handle "/sport/football.app", using: "SportFootballIndexPage"
  handle "/sport/football/championship.app", using: "SportFootballIndexPage"
  handle "/sport/football/womens.app", using: "SportFootballIndexPage"
  handle "/sport/formula1.app", using: "SportMajorIndexPage"
  handle "/sport/get-inspired.app", using: "SportIndexPage"
  handle "/sport/get-inspired/activity-guides.app", using: "SportIndexPage"
  handle "/sport/horse-racing.app", using: "SportIndexPage"
  handle "/sport/olympics.app", using: "SportIndexPage"
  handle "/sport/rugby-league.app", using: "SportRugbyIndexPage"
  handle "/sport/rugby-union.app", using: "SportRugbyIndexPage"
  handle "/sport/swimming.app", using: "SportIndexPage"
  handle "/sport/tennis.app", using: "SportMajorIndexPage"
  handle "/sport/winter-olympics.app", using: "SportIndexPage"

  ## Sport Calendars
  handle "/sport/formula1/calendar.app", using: "SportFormula1DataPage"
  handle "/sport/formula1/calendar/*any", using: "SportFormula1DataPage"
  handle "/sport/horse-racing/calendar.app", using: "SportHorseRacingDataPage"
  handle "/sport/horse-racing/calendar/*any", using: "SportHorseRacingDataPage"
  handle "/sport/:discipline/calendar.app", using: "SportDataPage"
  handle "/sport/:discipline/calendar/*any", using: "SportDataPage"

  ## Sport Fixtures pages
  redirect "/sport/basketball/:tournament/fixtures.app", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/:tournament/fixtures", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/fixtures.app", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/fixtures", to: "/sport/basketball/scores-fixtures", status: 301

  handle "/sport/:discipline/:tournament/fixtures.app", using: "SportDataPage"
  handle "/sport/:discipline/:tournament/fixtures", using: "SportDataPage"
  handle "/sport/:discipline/fixtures.app", using: "SportDataPage"
  handle "/sport/:discipline/fixtures", using: "SportDataPage"

  ## Sport Horse Racing Results
  handle "/sport/horse-racing/:tournament/results.app", using: "SportHorseRacingDataPage"
  handle "/sport/horse-racing/:tournament/results/*any", using: "SportHorseRacingDataPage"

  ## Sport Formula 1 Pages
  redirect "/sport/formula1/standings.app", to: "/sport/formula1/drivers-world-championship/standings.app", status: 302
  redirect "/sport/formula1/standings", to: "/sport/formula1/drivers-world-championship/standings", status: 302
  handle "/sport/formula1/latest.app", using: "SportFormula1DataPage"
  handle "/sport/formula1/latest", using: "SportFormula1DataPage"
  handle "/sport/formula1/results.app", using: "SportFormula1DataPage"
  handle "/sport/formula1/results", using: "SportFormula1DataPage"
  handle "/sport/formula1/:season/results.app", using: "SportFormula1DataPage"
  handle "/sport/formula1/:season/results", using: "SportFormula1DataPage"
  handle "/sport/formula1/:season/:tournament/results.app", using: "SportFormula1DataPage"
  handle "/sport/formula1/:season/:tournament/results", using: "SportFormula1DataPage"
  handle "/sport/formula1/:season/:tournament/results/*any", using: "SportFormula1DataPage"
  handle "/sport/formula1/constructors-world-championship/standings.app", using: "SportFormula1DataPage"
  handle "/sport/formula1/constructors-world-championship/standings", using: "SportFormula1DataPage"
  handle "/sport/formula1/drivers-world-championship/standings.app", using: "SportFormula1DataPage"
  handle "/sport/formula1/drivers-world-championship/standings", using: "SportFormula1DataPage"

  ## Sport Results pages
  redirect "/sport/basketball/:tournament/results.app", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/:tournament/results", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/results.app", to: "/sport/basketball/scores-fixtures", status: 301
  redirect "/sport/basketball/results", to: "/sport/basketball/scores-fixtures", status: 301

  handle "/sport/:discipline/:tournament/results.app", using: "SportDataPage" # flakey /sport/athletics/british-championship/results.app
  handle "/sport/:discipline/:tournament/results", using: "SportDataPage"
  handle "/sport/:discipline/results.app", using: "SportDataPage"
  handle "/sport/:discipline/results", using: "SportDataPage"

  ## Sport Football Scores-Fixtures pages
  handle "/sport/football/scores-fixtures.app", using: "SportFootballMainScoresFixturesDataPageInApps"
  handle "/sport/football/scores-fixtures/:date.app", using: "SportFootballMainScoresFixturesDataPageInApps"
  handle "/sport/football/scores-fixtures/*any", using: "SportFootballMainScoresFixturesDataPage"
  handle "/sport/football/:tournament/scores-fixtures.app", using: "SportFootballScoresFixturesDataPage"
  handle "/sport/football/:tournament/scores-fixtures/*any", using: "SportFootballScoresFixturesDataPage"
  handle "/sport/football/teams/:team/scores-fixtures.app", using: "SportFootballScoresFixturesDataPage"
  handle "/sport/football/teams/:team/scores-fixtures/*any", using: "SportFootballScoresFixturesDataPage"

  ## Sport Basketball Scores-Fixtures pages
  handle "/sport/basketball/scores-fixtures", using: "SportDataWebcore"
  handle "/sport/basketball/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end
  handle "/sport/basketball/:tournament/scores-fixtures", using: "SportDataWebcore"
  handle "/sport/basketball/:tournament/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end

  ## Sport Netball Scores-Fixtures pages
  handle "/sport/netball/scores-fixtures", using: "SportDataWebcore"
  handle "/sport/app-webview/netball/scores-fixtures", using: "SportDataWebcore"
  redirect "/sport/netball/scores-fixtures.app", to: "/sport/app-webview/netball/scores-fixtures", status: 302

  handle "/sport/netball/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end
  handle "/sport/app-webview/netball/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end
  redirect "/sport/netball/scores-fixtures/:date.app", to: "/sport/app-webview/netball/scores-fixtures/:date", status: 302

  handle "/sport/netball/:tournament/scores-fixtures", using: "SportDataWebcore"
  handle "/sport/app-webview/netball/:tournament/scores-fixtures", using: "SportDataWebcore"
  redirect "/sport/netball/:tournament/scores-fixtures.app", to: "/sport/app-webview/netball/:tournament/scores-fixtures", status: 302

  handle "/sport/netball/:tournament/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end
  handle "/sport/app-webview/netball/:tournament/scores-fixtures/:date", using: "SportDataWebcore" do
    return_404 if: !is_2020s_iso_date?(date)
  end
  redirect "/sport/netball/:tournament/scores-fixtures/:date.app", to: "/sport/app-webview/netball/:tournament/scores-fixtures/:date", status: 302

  ## Sport Scores-Fixtures pages
  handle "/sport/:discipline/scores-fixtures.app", using: "SportDataPage"
  handle "/sport/:discipline/scores-fixtures/*any", using: "SportDataPage"
  handle "/sport/:discipline/:tournament/scores-fixtures.app", using: "SportDataPage"
  handle "/sport/:discipline/:tournament/scores-fixtures/*any", using: "SportDataPage"
  handle "/sport/:discipline/teams/:team/scores-fixtures.app", using: "SportDataPage"
  handle "/sport/:discipline/teams/:team/scores-fixtures/*any", using: "SportDataPage"

  ## Sport League Two Table page

  handle "/sport/football/league-two/table.app", using: "SportFootballDataPage"
  handle "/sport/football/league-two/table", using: "SportFootballStandingsTablePage"

  ## Sport Premier League Table page
  handle "/sport/football/premier-league/table.app", using: "SportFootballDataPage"
  handle "/sport/football/premier-league/table", using: "SportFootballPremierLeagueStandingsTablePage"

  ## Sport Football Table pages
  handle "/sport/football/tables.app", using: "SportFootballDataPage"
  handle "/sport/football/tables", using: "SportFootballDataPage"
  handle "/sport/football/:tournament/table.app", using: "SportFootballDataPage"
  handle "/sport/football/:tournament/table", using: "SportFootballDataPage"
  handle "/sport/football/teams/:team/table.app", using: "SportFootballDataPage"
  handle "/sport/football/teams/:team/table", using: "SportFootballDataPage"

  ## Sport Table pages
  handle "/sport/:discipline/tables.app", using: "SportDataPage"
  handle "/sport/:discipline/tables", using: "SportDataPage"
  handle "/sport/:discipline/:tournament/table.app", using: "SportDataPage"
  handle "/sport/:discipline/:tournament/table", using: "SportDataPage"
  handle "/sport/:discipline/teams/:team/table.app", using: "SportDataPage"
  handle "/sport/:discipline/teams/:team/table", using: "SportDataPage"

  ## Sport Cricket Averages
  handle "/sport/cricket/averages.app", using: "SportDataPage"
  handle "/sport/cricket/averages", using: "SportDataPage"
  handle "/sport/cricket/:tournament/averages.app", using: "SportDataPage"
  handle "/sport/cricket/:tournament/averages", using: "SportDataPage"
  handle "/sport/cricket/teams/:team/averages.app", using: "SportDataPage"
  handle "/sport/cricket/teams/:team/averages", using: "SportDataPage"

  ## Sport Football Top-Scorers
  handle "/sport/football/:tournament/top-scorers.app", using: "SportFootballDataPage"
  handle "/sport/football/:tournament/top-scorers", using: "SportFootballDataPage"
  handle "/sport/football/:tournament/top-scorers/assists.app", using: "SportFootballDataPage"
  handle "/sport/football/:tournament/top-scorers/assists", using: "SportFootballDataPage"
  handle "/sport/football/teams/:team/top-scorers.app", using: "SportFootballDataPage"
  handle "/sport/football/teams/:team/top-scorers", using: "SportFootballDataPage"
  handle "/sport/football/teams/:team/top-scorers/assists.app", using: "SportFootballDataPage"
  handle "/sport/football/teams/:team/top-scorers/assists", using: "SportFootballDataPage"

  ## Sport Golf Leaderboard
  handle "/sport/golf/leaderboard.app", using: "SportDataPage"
  handle "/sport/golf/leaderboard", using: "SportDataPage"
  handle "/sport/golf/:tournament/leaderboard.app", using: "SportDataPage"
  handle "/sport/golf/:tournament/leaderboard", using: "SportDataPage"

  ## Sport Tennis Pages
  handle "/sport/tennis/live-scores.app", using: "SportDataPage"
  handle "/sport/tennis/live-scores", using: "SportDataPage"
  handle "/sport/tennis/live-scores/*any", using: "SportDataPage"
  handle "/sport/tennis/order-of-play.app", using: "SportDataPage"
  handle "/sport/tennis/order-of-play", using: "SportDataPage"
  handle "/sport/tennis/order-of-play/*any", using: "SportDataPage"
  handle "/sport/tennis/results/*any", using: "SportDataPage"

  ## Sport Event Data Pages
  handle "/sport/cricket/scorecard/:id.app", using: "SportDataPage"
  handle "/sport/cricket/scorecard/:id", using: "SportDataPage"
  handle "/sport/horse-racing/race/:id.app", using: "SportHorseRacingDataPage"
  handle "/sport/horse-racing/race/:id", using: "SportHorseRacingDataPage"
  handle "/sport/rugby-league/match/:id.app", using: "SportDataPage"
  handle "/sport/rugby-league/match/:id", using: "SportDataPage"
  handle "/sport/rugby-union/match/:id.app", using: "SportDataPage"
  handle "/sport/rugby-union/match/:id", using: "SportDataPage"

  ## Sport Football World Cup
  handle "/sport/football/world-cup/schedule.app", using: "SportFootballGroupsAndSchedule"
  handle "/sport/football/world-cup/schedule", using: "SportFootballGroupsAndSchedule"
  handle "/sport/football/womens-world-cup/schedule.app", using: "SportFootballGroupsAndSchedule"
  handle "/sport/football/womens-world-cup/schedule", using: "SportFootballGroupsAndSchedule"
  # redirect old URLs from previous competitions - e.g., /group-stage, /knockout-stage
  redirect "/sport/football/world-cup/schedule/*any", to: "/sport/football/world-cup/schedule", status: 302

  ## Sport Topics
  handle "/sport/topics/:id", using: "SportTopicPage" do
    return_404 if: [
      !is_tipo_id?(id),
      !integer_in_range?(conn.query_params["page"] || "1", 1..42)
    ]
  end

  handle "/sport/topics-test-blitzball", using: "SportDisciplineTopic", only_on: "test" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/alpine-skiing", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/archery", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/badminton", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/baseball", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/biathlon", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/bobsleigh", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/bowls", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/canoeing", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/cross-country-skiing", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/curling", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/darts", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/diving", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/equestrian", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/fencing", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/figure-skating", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/freestyle-skiing", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/gymnastics", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/handball", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/hockey", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/ice-hockey", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/insight", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/judo", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/karate", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/luge", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/modern-pentathlon", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/nordic-combined", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/rowing", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/rugby-sevens", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/sailing", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/shooting", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/short-track-skating", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/skateboarding", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/skeleton", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/ski-jumping", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/snowboarding", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/speed-skating", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/sport-climbing", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/squash", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/surfing", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/sustainability", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/synchronised-swimming", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/table-tennis", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/taekwondo", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/triathlon", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/volleyball", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/water-polo", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/weightlifting", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/wrestling", using: "SportDisciplineTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  # Sports Team Pages
  handle "/sport/:discipline/teams/:team", using: "SportDisciplineTeamTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/cricket/the-hundred", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/cricket/world-cup", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  handle "/sport/football/champions-league", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/dutch-eredivisie", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/europa-league", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/french-ligue-one", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/german-bundesliga", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/italian-serie-a", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/league-cup", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/league-one", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/league-two", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/national-league", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/portuguese-primeira-liga", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/scottish-challenge-cup", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/scottish-championship", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/scottish-cup", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/scottish-league-cup", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/scottish-league-one", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/scottish-league-two", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/scottish-premiership", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/spanish-la-liga", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/us-major-league", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/welsh-premier-league", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/womens-european-championship", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end
  handle "/sport/football/womens-world-cup", using: "SportDisciplineCompetitionTopic" do
    return_404 if: !integer_in_range?(conn.query_params["page"] || "1", 1..42)
  end

  ## Sport Stories AMP & JSON - use query string params in example URLs to use live data via Mozart
  handle "/sport/:id.amp", using: "SportAmp"
  handle "/sport/:id.json", using: "SportAmp"
  handle "/sport/:discipline/:id.amp", using: "SportAmp"
  handle "/sport/:discipline/:id.json", using: "SportAmp"

  ## Sport Stories - use query string params in example URLs to use live data via Mozart
  handle "/sport/:id.app", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/:id", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/athletics/:id.app", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/athletics/:id", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/cricket/:id.app", using: "SportCricketStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/cricket/:id", using: "SportCricketStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/cycling/:id.app", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/cycling/:id", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/football/:id.app", using: "SportFootballStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/football/:id", using: "SportFootballStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/formula1/:id.app", using: "SportFormula1StoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/formula1/:id", using: "SportFormula1StoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/golf/:id.app", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/golf/:id", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/rugby-league/:id.app", using: "SportRugbyStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/rugby-league/:id", using: "SportRugbyStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/rugby-union/:id.app", using: "SportRugbyStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/rugby-union/:id", using: "SportRugbyStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/tennis/:id.app", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/tennis/:id", using: "SportMajorStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/karate/:id.app", using: "SportArticleAppPage", only_on: "test" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/karate/:id", using: "SportArticlePage", only_on: "test" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/sport-climbing/:id.app", using: "SportArticleAppPage", only_on: "test" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/sport-climbing/:id", using: "SportArticlePage", only_on: "test" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/surfing/:id.app", using: "SportArticleAppPage", only_on: "test" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/surfing/:id", using: "SportArticlePage", only_on: "test" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/volleyball/:id.app", using: "SportArticleAppPage", only_on: "test" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/volleyball/:id", using: "SportArticlePage", only_on: "test" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/:discipline/:id.app", using: "SportStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  handle "/sport/:discipline/:id", using: "SportStoryPage" do
    return_404 if: !is_numeric_cps_id?(id)
  end

  # Sport catch-all
  handle "/sport/*any", using: "Sport"

  no_match()
end
