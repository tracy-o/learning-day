defmodule Belfrage.Transformers.SportRssFeedsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Transformers.Transformer

  @fabl_feeds [
    # /sport/alpine-skiing
    "4d38153b-987e-4497-b959-8be7c968d4d1",
    # /sport/archery
    "b9a58a01-0c74-8b47-972f-68f922ebd90a",
    # /sport/badminton
    "21c45f67-36da-874e-ab36-02650add8311",
    # /sport/baseball
    "4d62f2ca-861b-4db6-bc36-e2e537031718",
    # /sport/biathlon
    "24c87ae7-78db-449b-b398-ca4237d251e5",
    # /sport/bobsleigh
    "521df978-7583-4e19-ad6d-2a83a595a8a6",
    # /sport/bowls
    "039859a4-51ac-447f-a687-728ee2b34817",
    # /sport/canoeing
    "7e517328-5306-49a4-addb-37a94a2be3bb",
    # /sport/cross-country-skiing
    "a6315c80-6bd3-4be1-a40d-869e49e1a94f",
    # /sport/curling
    "dd4191d5-115d-46b9-8f18-d1da16c6a3e8",
    # /sport/darts
    "869e0ec9-af00-4f2b-82b6-b760d69a4492",
    # /sport/diving
    "d9d6cc4d-79f1-ab49-9c9e-c98d166b99fe",
    # /sport/equestrian
    "b84fd4d8-b7b5-5b45-9f7a-d701c9f3907f",
    # /sport/fencing
    "5a9bba82-5f5e-f343-9df7-48fc6d6a008e",
    # /sport/figure-skating
    "485f8f94-f87e-4513-b133-46a5dfccd428",
    # /sport/freestyle-skiing
    "fe63c304-110f-4fad-b9c7-7d00410abc92",
    # /sport/gymnastics
    "02fb02ee-9e6b-46c3-92e1-db372543facd",
    # /sport/handball
    "3d5e63ec-1f4f-c24c-86ad-fd5d54e014f6",
    # /sport/hockey
    "e681e822-b849-0243-b698-1b9afe3f3858",
    # /sport/ice-hockey
    "59ac9a3a-5a8f-4143-bd71-3268762cefc1",
    # /sport/judo
    "654f550c-0c2d-2341-a8f5-66e3a9ba28ba",
    # /sport/luge
    "d06b1e90-c9fe-4e09-9b4a-e0f285da8920",
    # /sport/modern-pentathlon
    "53accf6c-631b-9140-852a-109fab88d3f8",
    # /sport/nordic-combined
    "fe11a0ff-a7c0-45eb-a9e0-708dddf9bc7d",
    # /sport/rowing
    "452019a5-f0f2-0c47-aa11-42fdcf2ae16b",
    # /sport/rugby-sevens
    "3d556f88-c802-4fcc-9c25-469d2ba7b42a",
    # /sport/sailing
    "d65c5dce-f5e4-4340-931b-16ca1848d092",
    # /sport/shooting
    "eceae071-5f37-0848-acd2-f21e3b2de8ca",
    # /sport/short-track-skating
    "c26d7906-7843-4997-b7d7-f834b82b7919",
    # /sport/skeleton
    "a7b083b7-0d8b-45d8-9f09-54e6432dacb5",
    # /sport/ski-jumping
    "8fdc4c32-3d0c-4814-9d69-3bf1269135df",
    # /sport/snowboarding
    "d5844b24-1e62-4bec-b4e5-bc0e17fe3c8d",
    # /sport/speed-skating
    "b08bbfea-d065-4ef5-b38f-0e034d42534f",
    # /sport/squash
    "5b95d205-6cff-4cf1-8fc9-475b29e17511",
    # /sport/synchronised-swimming
    "bd51d530-f0fb-684e-a305-3f15b7e6d4a1",
    # /sport/table-tennis
    "f21d1a82-e919-b24f-b3fb-8f2f46372f40",
    # /sport/taekwondo
    "69cbc5e2-b228-a143-8085-860c053f44f7",
    # /sport/triathlon
    "c5d39deb-46b8-1e4e-ba2c-5c6e2436b92d",
    # /sport/volleyball
    "c6e2a7ac-2d13-8640-9f98-41f749d94a6e",
    # /sport/water-polo
    "e4d61a41-dba2-7849-a725-d8b445ec3cbc",
    # /sport/weightlifting
    "6b04e406-c181-204b-a2dd-bc20142b9e6a",
    # /sport/wrestling
    "126190f0-5bd7-7346-a739-39a80c01ae23",
    # /sport/football/champions-league
    "1e5c6e40-0b48-cb44-86ae-be47f66aac8a",
    # /sport/football/dutch-eredivisie
    "87d9c2f2-95c4-4db2-915e-e1eead8ce772",
    # /sport/football/europa-league
    "2afbdda7-71d4-544d-bcc6-d9ff50314b2a",
    # /sport/football/french-ligue-one
    "f955deb8-a145-4935-9777-c7a61c61b8bc",
    # /sport/football/german-bundesliga
    "ced5245a-2d24-4f66-b4e5-50e1add74451",
    # /sport/football/italian-serie-a
    "dd7d8ea7-5f0e-47fc-b1ae-dd5b51ec49a6",
    # /sport/football/league-cup
    "f7eeb725-55f4-3542-89ae-f4a4e8bd3c58",
    # /sport/football/league-one
    "030b5eaf-15db-3e4e-bac9-a7789892f436",
    # /sport/football/league-two
    "71d1288c-d1ea-6a4a-bd87-237dbb9e6470",
    # /sport/football/national-league
    "d5e7ede8-a199-804f-9a09-7c91a6df1b96",
    # /sport/football/portuguese-primeira-liga
    "8f8bffd1-91c1-43ad-8dfe-76052aeebb7b",
    # /sport/football/scottish-challenge-cup
    "ed80fd46-3713-d445-9419-de091f8a7223",
    # /sport/football/scottish-championship
    "f9ea64db-238d-2545-95a0-6bdecd52c489",
    # /sport/football/scottish-cup
    "96b7c068-a153-d640-8a37-5cfa8e1eff57",
    # /sport/football/scottish-league-cup
    "7ba0e09d-037f-694f-a73b-4deccbb7fda3",
    # /sport/football/scottish-league-one
    "5af78336-c06e-0b48-83a2-e50e2c14cba6",
    # /sport/football/scottish-league-two
    "7bf5cec0-5a16-2d42-ab3a-bb7137c4ff43",
    # /sport/football/scottish-premiership
    "ebca7141-e8ba-0e40-bba9-d0864e29bc1f",
    # /sport/football/spanish-la-liga
    "992139ad-96bd-4ba9-a1ef-f9b2b8dcb445",
    # /sport/football/us-major-league
    "be8b873f-c307-4a8b-b812-e8df53c9c2d1",
    # /sport/football/welsh-premier-league
    "6a649f34-6934-4464-8b80-a42a0ee7a1bc",
    # /sport/cricket/teams/adelaide-strikers
    "d42eecec-9e6d-41e1-8305-8f99bc70048a",
    # /sport/cricket/teams/adelaide-strikers-women
    "61f05ed2-4928-484d-afbb-cada71fd18a6",
    # /sport/cricket/teams/afghanistan
    "77e5f32b-a1d8-45c3-a2c8-aabaf286537d",
    # /sport/cricket/teams/auckland
    "fda1ebf1-9e79-4d49-b3a6-372b37b522d0",
    # /sport/cricket/teams/australia
    "9d794c09-c573-4a97-9a0e-9518888f19ed",
    # /sport/cricket/teams/australia-women
    "4ee2fb3e-9040-4883-be8e-f12dcfbfa0f7",
    # /sport/cricket/teams/bangladesh
    "65e7e652-4bcc-4d48-a19c-241f58d830ba",
    # /sport/cricket/teams/bangladesh-women
    "16abacdc-2b82-4f20-a9bd-bf58b142cadb",
    # /sport/cricket/teams/barbados-tridents
    "0a5e2376-0495-4e95-acc4-97957362f34a",
    # /sport/cricket/teams/bermuda
    "2091b53c-6104-4c7b-a797-6cb3ff525366",
    # /sport/cricket/teams/brisbane-heat
    "43b8cb70-54e4-4345-b308-f5f334bbc55d",
    # /sport/cricket/teams/brisbane-heat-women
    "2d6f237f-9254-47d7-ac56-8cf87bf6eda9",
    # /sport/cricket/teams/canada
    "d69257ce-bf5a-43dc-8c00-852c98eaf5b8",
    # /sport/cricket/teams/canterbury
    "4f521066-17fa-4bd4-b4e5-0f5f57bbab1b",
    # /sport/cricket/teams/central-districts
    "3207f6bb-a064-4542-8b00-042fc95c4409",
    # /sport/cricket/teams/chennai-super-kings
    "4036b936-03df-4e56-b9b1-de65bcfc3373",
    # /sport/cricket/teams/delhi-daredevils
    "6b74866b-9c75-44d0-8cea-db97165ac181",
    # /sport/cricket/teams/derbyshire
    "311fec37-a12a-46d5-9b6a-f485c7413077",
    # /sport/cricket/teams/durham
    "fe2526f0-d352-4a2f-8b03-9b7b692fd3cd",
    # /sport/cricket/teams/england
    "cd988a73-6c41-4690-b785-c8d3abc2d13c",
    # /sport/cricket/teams/england-lions
    "33791f1b-2d53-4080-bd66-2d27684cfd8f",
    # /sport/cricket/teams/england-u19
    "6f205602-86fe-4942-bf63-88a240095f2c",
    # /sport/cricket/teams/england-women
    "966cc28f-ae31-40f2-b66f-948b56849383",
    # /sport/cricket/teams/essex
    "6d2040e9-3e55-4662-b463-4878c42726da",
    # /sport/cricket/teams/glamorgan
    "f1125cb0-7114-4b36-b5b9-469864464b31",
    # /sport/cricket/teams/gloucestershire
    "7f503ae5-3778-4951-b559-ea30ce7bd167",
    # /sport/cricket/teams/gujarat-lions
    "559571d1-04da-4ce1-b9f2-83da0a3ed593",
    # /sport/cricket/teams/guyana-amazon-warriors
    "30e9f536-fa99-45c5-bf72-ccaead1f54c8",
    # /sport/cricket/teams/hampshire
    "1aa023c9-b945-4bda-8b1c-211f9fe9e05f",
    # /sport/cricket/teams/hobart-hurricanes
    "55252df7-995c-44b0-bfa3-06db9a3d690f",
    # /sport/cricket/teams/hobart-hurricanes-women
    "a2444e3b-2cd8-4dc9-a6a3-691479a50f61",
    # /sport/cricket/teams/hong-kong
    "21f944bb-8fca-41d0-94ab-463310746208",
    # /sport/cricket/teams/india
    "5ec63a0c-4a74-43d4-926c-c75789c078c1",
    # /sport/cricket/teams/india-women
    "39975f00-e00a-46c4-89b9-85424a1b7846",
    # /sport/cricket/teams/ireland
    "9057858a-33bd-425c-891c-a9b072728513",
    # /sport/cricket/teams/ireland-women
    "2111aba1-fe08-4804-b1e0-60f2c2b2e768",
    # /sport/cricket/teams/islamabad-united
    "18527e36-72c0-4aa9-a5d1-be5c5967eab2",
    # /sport/cricket/teams/jamaica-tallawahs
    "4684f16c-e986-4cf5-9627-1400d4cd588b",
    # /sport/cricket/teams/karachi-kings
    "c5c755df-4463-4e68-982b-f3f1dbd35d9b",
    # /sport/cricket/teams/kent
    "4e1cd8c0-ef81-4cea-a005-ba769e3bb2fb",
    # /sport/cricket/teams/kenya
    "5ef06231-8951-4621-a7d0-6d0edffc5237",
    # /sport/cricket/teams/kings-xi-punjab
    "de6801f6-6d87-4cf7-bc33-5f494858df59",
    # /sport/cricket/teams/kolkata-knight-riders
    "d4a190a5-aeec-4499-b27b-579b96ff20a7",
    # /sport/cricket/teams/lahore-qalandars
    "fbd8741e-9ebf-4354-908d-98331bbe15f5",
    # /sport/cricket/teams/lancashire
    "e3056dd5-434c-4391-a2e4-8e02a31645a7",
    # /sport/cricket/teams/lancashire-thunder-women
    "4a783693-13f7-4f75-8c5a-5862a8b2b73b",
    # /sport/cricket/teams/leicestershire
    "6a48e77e-3465-4e35-a94b-dac77299838c",
    # /sport/cricket/teams/loughborough-lightning-women
    "a0823750-7b6f-4434-bfec-7c81e9efc1f5",
    # /sport/cricket/teams/melbourne-renegades
    "faa63b7f-8a98-4ba0-91dc-52f8dc806dcb",
    # /sport/cricket/teams/melbourne-renegades-women
    "621b2801-af9d-4c2b-adfb-1c74f38028b0",
    # /sport/cricket/teams/melbourne-stars
    "ef0e49fd-5f85-4775-bbc6-82199d2b741d",
    # /sport/cricket/teams/melbourne-stars-women
    "8a8af5d8-a4f7-42d9-9e61-4f53555bdeef",
    # /sport/cricket/teams/middlesex
    "c8b2685d-9517-4601-8561-482e2bd67ea9",
    # /sport/cricket/teams/mumbai-indians
    "cc2373e0-829a-4263-b94c-06d92c34b101",
    # /sport/cricket/teams/namibia
    "d847d0eb-8ef3-4621-bc99-1bcb48295d95",
    # /sport/cricket/teams/nepal
    "12ad8c10-085a-46d3-99ba-40ed97f5c95e",
    # /sport/cricket/teams/netherlands
    "1a741adc-d962-473a-b0aa-3548e4fed0b2",
    # /sport/cricket/teams/new-south-wales
    "5678134f-7b08-4bb8-845b-0c7d03b91ebd",
    # /sport/cricket/teams/new-zealand
    "24e14219-8ae2-4ee7-b180-cad9b0d5bfa2",
    # /sport/cricket/teams/new-zealand-women
    "cae8e6d6-18d2-49a1-9318-11ab76a96250",
    # /sport/cricket/teams/northamptonshire
    "25734f16-1a36-42e0-879a-8cd4c3275028",
    # /sport/cricket/teams/northern-districts
    "0c312a56-750b-4cb8-af0a-c030227bd933",
    # /sport/cricket/teams/nottinghamshire
    "2bab7697-c436-4581-87cb-1a9178ad81af",
    # /sport/cricket/teams/oman
    "67e1c4a6-d2de-4b01-9d7b-34ff86b04a83",
    # /sport/cricket/teams/otago
    "7816b022-ae54-4042-8bf5-62532043f7da",
    # /sport/cricket/teams/pakistan
    "28a3cb5b-a2ea-4283-b58e-d72dc48d6034",
    # /sport/cricket/teams/pakistan-women
    "542d5906-4e33-42ce-8fcf-db7b85116546",
    # /sport/cricket/teams/papua-new-guinea
    "953617d1-0829-4db4-9e0c-8112abfdb4c3",
    # /sport/cricket/teams/perth-scorchers
    "8c72fb6a-88db-438c-ab7d-a551cff9fa61",
    # /sport/cricket/teams/perth-scorchers-women
    "2a1dac62-5285-4116-b4a5-bb86ce6cfe49",
    # /sport/cricket/teams/peshawar-zalmi
    "9a8f1bc1-0d17-46cd-b04f-5d38cc9f660a",
    # /sport/cricket/teams/queensland
    "ef678cf2-8683-4724-9475-9edc3a67d18d",
    # /sport/cricket/teams/quetta-gladiators
    "0b49dafc-4533-46ff-b96a-54fc7ecfaa44",
    # /sport/cricket/teams/rajasthan-royals
    "adcfac1c-752f-4ee8-89d5-77491322f0c4",
    # /sport/cricket/teams/rising-pune-supergiants
    "04914a15-13f9-4039-aaa7-cd9d7c84719f",
    # /sport/cricket/teams/royal-challengers-bangalore
    "8eaae83a-62d2-4829-ae7e-f1ff4f826680",
    # /sport/cricket/teams/scotland
    "414600e4-1cf0-429c-831f-81e1b14b9b78",
    # /sport/cricket/teams/somerset
    "3ebf9ee6-6037-4fdb-b00f-cca98c6574a3",
    # /sport/cricket/teams/south-africa
    "565d637f-6fb0-4799-8db8-a001978d2222",
    # /sport/cricket/teams/south-africa-women
    "142c8b42-12bb-43be-8fb2-37c47f289011",
    # /sport/cricket/teams/south-australia
    "af8a77fb-82dd-481d-b485-1e52fe1b925c",
    # /sport/cricket/teams/southern-vipers-women
    "243df71c-9017-4990-b8eb-27830c5dbdd7",
    # /sport/cricket/teams/sri-lanka
    "fe736477-01b6-4020-8b30-36522ac59457",
    # /sport/cricket/teams/sri-lanka-women
    "89739cb4-b331-4a52-990b-1be9578aa1ef",
    # /sport/cricket/teams/st-kitts-and-nevis-patriots
    "fc5621f3-697c-43d1-b7b5-43f61c45a283",
    # /sport/cricket/teams/st-lucia-zouks
    "0a812d7c-fc1d-4910-9375-d95e724a0692",
    # /sport/cricket/teams/sunrisers-hyderabad
    "3a344289-8095-4073-990e-46ba9ec66377",
    # /sport/cricket/teams/surrey
    "90c95587-a1bb-4a6c-bba1-1c4b72502129",
    # /sport/cricket/teams/surrey-stars-women
    "d9f5fc12-532d-4f0d-80e1-aa771bfb583a",
    # /sport/cricket/teams/sussex
    "b86ca75b-7f26-4221-9791-37ddc01660dc",
    # /sport/cricket/teams/sydney-sixers
    "a32be922-6c65-4a90-8c3f-6a8ff035757d",
    # /sport/cricket/teams/sydney-sixers-women
    "7dbe1dcc-b728-4cda-89fe-638f766eb845",
    # /sport/cricket/teams/sydney-thunder
    "fdcabd65-3252-4684-8342-9aa955a2546f",
    # /sport/cricket/teams/sydney-thunder-women
    "6f886524-282a-4a18-9762-1a2a090cab2e",
    # /sport/cricket/teams/tasmania
    "d2dcb973-6c44-49a9-b2df-2c1a6ea3fa5f",
    # /sport/cricket/teams/thailand-women
    "c7b7e55d-8f9a-4eb7-a020-6c968ae17b27",
    # /sport/cricket/teams/trinbago-knight-riders
    "6a12bf64-7c6b-407a-a359-7b2937c3ec48",
    # /sport/cricket/teams/united-arab-emirates
    "5a3060a2-e236-4dbf-8049-86287f369c54",
    # /sport/cricket/teams/united-states
    "c5663352-b1e0-49a5-8a87-b63129b7d066",
    # /sport/cricket/teams/victoria
    "0ea042d0-1533-4725-8bb0-29f7cf8863d4",
    # /sport/cricket/teams/warwickshire
    "87e9eb08-b0b1-4232-a585-3762aea99680",
    # /sport/cricket/teams/wellington
    "7944aea5-cb0d-4eee-87ce-1cec423f458b",
    # /sport/cricket/teams/west-indies
    "bea1cb38-a492-44e9-8c9e-8865e4a2c014",
    # /sport/cricket/teams/west-indies-women
    "2f721877-ba0d-4339-820f-c8dfe1a886db",
    # /sport/cricket/teams/western-australia
    "f0140804-77ef-4f50-b0fd-3cac1462b543",
    # /sport/cricket/teams/western-storm-women
    "62d4e1af-ae4c-401e-a86f-d59d40f23b95",
    # /sport/cricket/teams/worcestershire
    "f0489362-27b3-4200-b0a9-c73c15b9869a",
    # /sport/cricket/teams/yorkshire
    "ae6a1e5a-1636-4e8d-8e0e-fac28430e53e",
    # /sport/cricket/teams/yorkshire-diamonds-women
    "313ec4fc-9a31-4ba7-ac03-9120f3c936ff",
    # /sport/cricket/teams/zimbabwe
    "c645646c-0ca5-46c6-96cd-9eb3d9f278d1",
    # /sport/football/teams/aalborg-bk
    "45338d77-b0de-44ae-9468-6e6f06c06f03",
    # /sport/football/teams/aberdeen
    "de96e227-7e77-974f-aab2-2e37598c5cc2",
    # /sport/football/teams/aberystwyth-town
    "bef52d23-cdda-4d40-9e65-9fe73426745d",
    # /sport/football/teams/accrington-stanley
    "cb19b305-06e8-b74e-aac1-53e0966ec4ac",
    # /sport/football/teams/afc-bournemouth
    "0280e88c-26bd-b24c-882f-ae0e5f4142f2",
    # /sport/football/teams/afc-fylde
    "b0b871f1-1b43-4f92-96fd-6fcad6fa3645",
    # /sport/football/teams/afc-telford-united
    "1da3b5d2-c5d5-48a0-a6c2-e83a29abf99a",
    # /sport/football/teams/afc-wimbledon
    "39885edd-5611-b540-ae3a-43026125bfd8",
    # /sport/football/teams/airbus-uk-broughton
    "836824a5-31fc-9747-bd49-f215cfc01a57",
    # /sport/football/teams/airdrieonians
    "beb634cb-1d91-fb42-a3af-da4754910dff",
    # /sport/football/teams/ajax
    "eb8f2a69-9b31-4be4-93e5-b85985ef5d9d",
    # /sport/football/teams/albania
    "b25761d2-b78b-4d45-8aaf-8f7682d7d394",
    # /sport/football/teams/albion-rovers
    "c2f82556-447b-7249-a2db-bc5106d32f06",
    # /sport/football/teams/aldershot-town
    "6dc681ec-3b9b-2942-9042-f514c00a1f64",
    # /sport/football/teams/alfreton-town
    "fb54f8ca-0d6b-4ff9-b926-e481d6022cce",
    # /sport/football/teams/algeria
    "4f47e77a-218f-47ba-b148-e3493f06943a",
    # /sport/football/teams/alloa-athletic
    "ecf61a12-6be0-3948-8a94-98ede890bf33",
    # /sport/football/teams/altrincham
    "2a279a02-73d7-47ef-ad34-eab3733a91a4",
    # /sport/football/teams/amiens
    "a99bdb90-fee7-4670-a267-7509fd896ace",
    # /sport/football/teams/andorra
    "bdc57f19-3e73-4cd3-a8c1-482136761925",
    # /sport/football/teams/angers
    "76fe976d-dc70-4f4f-8efc-37db9765e982",
    # /sport/football/teams/angola
    "77e9e3c1-bb79-4852-bab2-bb7d6fd0e12b",
    # /sport/football/teams/annan-athletic
    "e93a3145-285d-4940-8018-8bafdc498ff0",
    # /sport/football/teams/anzhi-makhachkala
    "5e8b1267-c6bb-4e0f-b439-87d1871b91ff",
    # /sport/football/teams/apoel-nicosia
    "5a32dca6-5765-4175-b47e-70f1d3b5d604",
    # /sport/football/teams/arbroath
    "4a604f70-d799-fe48-b32d-fc5b1471b2d6",
    # /sport/football/teams/argentina
    "da7ff3fd-eb71-4cf8-abb1-a8d025e9e135",
    # /sport/football/teams/argentina-women
    "cb4f9e02-ca1f-4f25-92b2-24315d47e114",
    # /sport/football/teams/armenia
    "2df22694-ea99-463b-a212-459215bc237b",
    # /sport/football/teams/arsenal
    "c4285a9a-9865-2343-af3a-8653f7b70734",
    # /sport/football/teams/arsenal-ladies
    "468e5402-d118-4ede-86dc-24278ffbecf3",
    # /sport/football/teams/aston-villa
    "9ce8f75f-4dc0-0f46-8e1b-742513527baf",
    # /sport/football/teams/aston-villa-women
    "2f32784c-0ea0-4538-ac64-1fb88e734f13",
    # /sport/football/teams/atalanta
    "c8eec46e-f951-4f14-a9b6-005cc4668c27",
    # /sport/football/teams/athletic-bilbao
    "5f293f87-2335-4b8d-9915-2dd20a8900fd",
    # /sport/football/teams/atletico-madrid
    "7f66e5fb-f7b1-4b84-a592-80a851950fa4",
    # /sport/football/teams/augsburg
    "7cfcb1ff-d667-4592-8398-3594b2e917d3",
    # /sport/football/teams/australia
    "beb68026-a8d4-4e93-a7da-69236e988e18",
    # /sport/football/teams/australia-women
    "a50ceb63-923b-41a8-b602-aa755ce1ec76",
    # /sport/football/teams/austria
    "26a06edb-3080-4853-aeb9-2c57a228837b",
    # /sport/football/teams/austria-u21
    "e5e99be2-b732-4ef1-b097-4141050a048a",
    # /sport/football/teams/austria-women
    "e2821ab9-57f4-4a6b-be09-3091ca53aaac",
    # /sport/football/teams/ayr-united
    "33d68d3d-a0aa-1047-84d0-dc382de3e875",
    # /sport/football/teams/azerbaijan
    "917ff174-9011-4a0d-9262-912fe9b0711b",
    # /sport/football/teams/bahrain
    "44a506ff-224c-488c-b667-ce31bc523d3d",
    # /sport/football/teams/bala-town
    "d32da140-30da-ae4d-9690-fff7c712afb8",
    # /sport/football/teams/bangor-city
    "85fd98dd-2f8f-9e4d-9e6f-416933e7d305",
    # /sport/football/teams/barcelona
    "a6772faa-1ff9-4a9a-bd99-14e6bc25cf9d",
    # /sport/football/teams/barnet
    "78bd2e07-667f-9b48-8941-6d64367babfd",
    # /sport/football/teams/barnsley
    "da76bafe-c659-1345-8448-08ef198f492f",
    # /sport/football/teams/barrow
    "38f33530-7e5c-784c-ac36-ebcda328426b",
    # /sport/football/teams/basel
    "8a9aa962-12eb-4bbb-b86f-451fd31821ef",
    # /sport/football/teams/bastia
    "53021f89-0399-47b0-a355-c81f24677a63",
    # /sport/football/teams/bate-borisov
    "3ee8a36a-d3d8-448c-b2d5-99ed703dcfb3",
    # /sport/football/teams/bath-city
    "1cef20c8-b44f-9a49-890b-bbc13b4141da",
    # /sport/football/teams/bayer-leverkusen
    "be635de8-c92e-47be-a456-68219c8c99a7",
    # /sport/football/teams/bayern-munich
    "d801141d-b1ca-4ef7-80fd-208c00dbae7a",
    # /sport/football/teams/belarus
    "d45ae6d0-2ddd-4c86-bbd5-eaa6862f3afc",
    # /sport/football/teams/belgium
    "03bc2e07-f0ba-4238-9342-15df338d9759",
    # /sport/football/teams/belgium-u21
    "74678291-0500-488e-8114-6cbfae75fcf2",
    # /sport/football/teams/belgium-women
    "86d322c5-9d0c-4c98-8d45-dc129b00e1b9",
    # /sport/football/teams/benevento
    "c794dfb2-9a41-4016-a09c-861240bdf0a3",
    # /sport/football/teams/benfica
    "f4588e7d-319d-4f7a-805c-d1676e822f3f",
    # /sport/football/teams/benin
    "ae29ce6f-ccb5-46e1-9213-73febdb68e59",
    # /sport/football/teams/bermuda
    "c7ebf02e-83e5-4b0f-a546-41041ac4c69e",
    # /sport/football/teams/berwick-rangers
    "90e7c0da-d0f3-934a-9c30-c9418ccb0e88",
    # /sport/football/teams/besiktas
    "c5ba74e2-39cb-424f-be8b-a719cc8bba82",
    # /sport/football/teams/birmingham-city
    "cfd00353-deb5-5b46-9e1c-e22c9f255468",
    # /sport/football/teams/birmingham-city-ladies
    "bb3c3d59-4e0f-4c43-8cfa-30e57d9aa54e",
    # /sport/football/teams/blackburn-rovers
    "34e9d74f-f917-db47-aa4a-c96ab97e301d",
    # /sport/football/teams/blackpool
    "05251295-c015-2e42-839a-efe200441c9d",
    # /sport/football/teams/bolivia
    "f0c139e1-c80c-47d5-92eb-b01cc5ed8937",
    # /sport/football/teams/bologna
    "4c9e70bb-a50f-4aeb-8698-7022295fb178",
    # /sport/football/teams/bolton-wanderers
    "25e5e7ca-004e-d349-8c76-ca86f3adfa7b",
    # /sport/football/teams/bordeaux
    "e21f75b3-7485-4a86-a8fe-5091e1aac64f",
    # /sport/football/teams/boreham-wood
    "60b173a1-3dcc-40b9-8129-e9f900ab777f",
    # /sport/football/teams/borussia-dortmund
    "f76d29fd-ea7c-4880-9b25-cb98acce6185",
    # /sport/football/teams/borussia-moenchengladbach
    "e68504a3-fa4d-45c0-93d4-6e6c7e25f9a5",
    # /sport/football/teams/bosnia-herzegovina
    "e288012f-89ab-429d-9f42-10cf379fb912",
    # /sport/football/teams/bosnia-herzegovina-women
    "c8bc57f3-b1cf-494c-8559-66c033757b3d",
    # /sport/football/teams/bradford-city
    "85eef0da-f836-194f-a2d7-4ce0178278f6",
    # /sport/football/teams/braintree-town
    "6606e72d-d16c-482a-aab8-28d059313e2a",
    # /sport/football/teams/brazil
    "96a45a0e-876a-4b31-b9bc-25a9eb365dc3",
    # /sport/football/teams/brazil-women
    "99ebf80c-4a4b-41a3-97e2-1d2e72b795d7",
    # /sport/football/teams/brechin-city
    "5074d279-989b-5b40-b54b-a6b834b265e5",
    # /sport/football/teams/brentford
    "cf72a7ad-3054-8d4c-a98c-fb0ec5888922",
    # /sport/football/teams/brescia
    "8451bdf1-433f-4706-90f7-6a0589ddc807",
    # /sport/football/teams/brest
    "994fd859-a1f9-496b-9c63-da968d7cae53",
    # /sport/football/teams/brighton-and-hove-albion
    "3d814d88-1f22-d042-a9a6-87fd9216a50a",
    # /sport/football/teams/brighton-and-hove-albion-women
    "8e7ba1de-5aeb-44ea-96cd-da7fca18f067",
    # /sport/football/teams/bristol-city
    "64c75a53-ee2e-3e4e-bd80-b8fa10584123",
    # /sport/football/teams/bristol-city-women
    "fa296a14-9a7a-4a8e-b723-cb23968496c1",
    # /sport/football/teams/bristol-rovers
    "f7f03b3a-9902-8c4f-aa19-4eb4fb121dba",
    # /sport/football/teams/bromley
    "c73ab6a1-a362-4d4c-8413-2f83481ee885",
    # /sport/football/teams/bulgaria
    "5a02e0be-50ad-48cf-a798-73b65bfa2f0c",
    # /sport/football/teams/burkina-faso
    "2443d45d-6a85-43ad-a760-8afdc2b83317",
    # /sport/football/teams/burnley
    "279a3dc2-9195-264d-be3e-2a52bb61d4fe",
    # /sport/football/teams/burton-albion
    "b5732135-be6e-e74b-ab47-fd360ecbc7c0",
    # /sport/football/teams/burundi
    "15a3ccf0-be08-48b7-8779-bc800c868a54",
    # /sport/football/teams/bury
    "4624d7c0-fcab-684d-92f1-23e304d8d879",
    # /sport/football/teams/caen
    "a59b1408-794a-4676-b5c2-5390d6ce8b10",
    # /sport/football/teams/cagliari
    "5257a7f4-b161-41de-a593-028b487e680f",
    # /sport/football/teams/cambridge-united
    "c1d8fb3f-0de9-f145-934f-210757952393",
    # /sport/football/teams/cameroon
    "f14e9a9a-69e4-4737-9b50-d2030e08aa40",
    # /sport/football/teams/cameroon-women
    "0812c485-e35d-4f5a-a76c-0d58019a4b46",
    # /sport/football/teams/canada
    "0892ffb2-7c2c-4f29-a1d0-3c4d7b7898e1",
    # /sport/football/teams/canada-women
    "14b758d8-05e5-4390-a359-cd6686594204",
    # /sport/football/teams/cape-verde
    "a1be965a-bdbd-48b3-89b1-868ff5dd5d9f",
    # /sport/football/teams/cardiff-city
    "bef8a4b5-1ad1-4347-b665-edf581ab7350",
    # /sport/football/teams/carlisle-united
    "73e4de65-4e73-6242-bd9b-fee0578c75fe",
    # /sport/football/teams/carmarthen-town
    "a9f71809-bc55-0846-83cb-bff5ff747c6f",
    # /sport/football/teams/celta-vigo
    "24d188ce-a76f-47f0-abcb-1aa001b0c34a",
    # /sport/football/teams/celtic
    "6d397eab-9d0d-b84a-a746-8062a76649e5",
    # /sport/football/teams/charlton-athletic
    "c7068d17-1330-324a-b2c9-af3c6e0e5d7f",
    # /sport/football/teams/chelsea
    "2acacd19-6609-1840-9c2b-b0820c50d281",
    # /sport/football/teams/chelsea-ladies
    "d216a841-23b2-4e35-87eb-68575475d58a",
    # /sport/football/teams/cheltenham-town
    "e038339b-f929-c640-937a-ba747aa9d3d9",
    # /sport/football/teams/chester
    "47f8c370-3db8-499d-a492-8fe161644283",
    # /sport/football/teams/chesterfield
    "a7b3ebaf-c444-5b4d-8e2a-0b236bc3fdd3",
    # /sport/football/teams/chievo
    "7f79e78a-dc44-4008-9315-ee2c098dbc85",
    # /sport/football/teams/chile
    "021d0bd4-7cca-450b-9960-2fd51cb9dff5",
    # /sport/football/teams/chile-women
    "e33542b2-d303-4f1b-9a59-6dc0b866994f",
    # /sport/football/teams/china
    "80c861fe-d2c0-4fd0-82a9-cd474d33664d",
    # /sport/football/teams/china-women
    "f0c83670-a27d-420e-b063-7b90f4fdce89",
    # /sport/football/teams/chorley
    "1acaa553-3b71-4de4-8ded-a948972c2caf",
    # /sport/football/teams/clyde
    "0d2bccc3-ba40-7741-b741-485ee78acdf2",
    # /sport/football/teams/colchester-united
    "47ba66dc-aa35-2c46-8446-ac85380126a0",
    # /sport/football/teams/colombia
    "1dae0d8b-f96e-474e-b6bd-057a96fa771a",
    # /sport/football/teams/colombia-women
    "2b4fbd52-830f-4f0d-8d85-331a31bfd37a",
    # /sport/football/teams/costa-rica
    "65058c8d-de38-435a-b90f-7c4b5c52d01a",
    # /sport/football/teams/costa-rica-women
    "b0bd3c2b-d025-4bb8-828f-684329bc50fd",
    # /sport/football/teams/cove-rangers
    "32fa443e-dfbc-4a3a-8640-cd7d53470b6b",
    # /sport/football/teams/coventry-city
    "dc90cfcb-42b4-5343-84ee-5f49730557eb",
    # /sport/football/teams/cowdenbeath
    "6ff32eef-0eed-474a-9443-6df2831253fd",
    # /sport/football/teams/crawley-town
    "aba57165-6d8d-3c49-93ea-bbf1e4181c74",
    # /sport/football/teams/crewe-alexandra
    "0af7766e-bf70-3a4a-80f3-82bde862187c",
    # /sport/football/teams/croatia
    "f032f98f-c256-4c2f-8bdc-d2fadf20a65a",
    # /sport/football/teams/croatia-u21
    "64bdc649-db63-4b65-b036-982fdd645dfa",
    # /sport/football/teams/crotone
    "b4473ed2-b6ed-4d70-a0bc-0c6087ffde36",
    # /sport/football/teams/crystal-palace
    "eb21087f-1dd7-fd4e-9816-d89ccff84cca",
    # /sport/football/teams/cska-moscow
    "4c2896c5-85e1-48e5-a6f1-07d59a5d3242",
    # /sport/football/teams/cuba
    "8b176286-1a1f-4e5e-9c6c-f512fc0087f8",
    # /sport/football/teams/curacao
    "51a65d8d-8ab7-4662-b303-5fb89ea4ee59",
    # /sport/football/teams/cyprus
    "e3fc5ae5-2050-439c-98e0-f7d306d5cd70",
    # /sport/football/teams/czech-republic
    "6ed6e732-c8ca-4f4a-9377-76fee24216a4",
    # /sport/football/teams/czech-republic-u21
    "698abaf8-39f9-4c36-8018-832affec28d0",
    # /sport/football/teams/czech-republic-women
    "3e08ee97-bbba-4fcd-a1b6-1c836d284e91",
    # /sport/football/teams/dagenham-and-redbridge
    "c41395c3-d459-a14c-a4dd-11f9d95121fe",
    # /sport/football/teams/darlington
    "c8b9b627-6e1d-a04a-9b8b-f32a181536f3",
    # /sport/football/teams/darmstadt
    "fce24b9e-756c-4620-be0e-e14f5ed70881",
    # /sport/football/teams/dartford
    "92e4b172-987a-40df-9a3b-e8afaf7f81b9",
    # /sport/football/teams/denmark
    "ff9bb350-0bed-4966-9997-704f830d93c5",
    # /sport/football/teams/denmark-u21
    "55d417f1-1471-401c-8412-2b4a5180277e",
    # /sport/football/teams/denmark-women
    "f51bc0e9-34b7-4df5-8c96-4fdae740383f",
    # /sport/football/teams/deportivo-alaves
    "1caed9b2-0d25-42cc-862b-827ae509688e",
    # /sport/football/teams/deportivo-de-la-coruna
    "5925c68c-b131-4593-aa5e-dc6128b23efc",
    # /sport/football/teams/derby-county
    "be304c00-b9fd-8f44-877d-8785f93bc52d",
    # /sport/football/teams/dijon
    "5b2fa9c7-fdd8-4c4e-82cf-ef27f83a0506",
    # /sport/football/teams/doncaster-rovers
    "703ce394-97c5-6e42-a585-bd1eec9cca9a",
    # /sport/football/teams/dover-athletic
    "80db5161-a0d2-46e4-9784-9aeb7a4b9d87",
    # /sport/football/teams/dr-congo
    "22cc4560-596f-41ca-9b44-2f253b69b9c4",
    # /sport/football/teams/dumbarton
    "898f3cbc-2605-ea4e-96cc-b3d186bb7483",
    # /sport/football/teams/dundee
    "28028aab-5b3f-0e41-99dd-bca1c431d27b",
    # /sport/football/teams/dundee-united
    "8a535cd8-2260-1a49-8fb2-62f8e7b54ffc",
    # /sport/football/teams/dunfermline-athletic
    "329aa45b-dcba-3e43-b3a0-ae5cb3220384",
    # /sport/football/teams/dusseldorf
    "77f41f42-507f-4430-91bf-d78d3e8d1c3b",
    # /sport/football/teams/east-fife
    "3d94fcd2-2af0-7941-aedd-c7670238ee20",
    # /sport/football/teams/east-stirlingshire
    "6f30ea40-789b-a147-bdcc-9f17b4e2323f",
    # /sport/football/teams/eastleigh
    "deecd9c9-40fa-479b-b21b-4742de2108c9",
    # /sport/football/teams/ebbsfleet-united
    "d43074fc-1513-43f8-aa35-59b43b60a40b",
    # /sport/football/teams/ecuador
    "375ef1d5-65ab-4549-899e-195f787f9c6c",
    # /sport/football/teams/ecuador-women
    "f09070d0-b710-4ac1-a1f3-10a71a8e41f0",
    # /sport/football/teams/edinburgh-city
    "e0929b77-04c1-4398-8da6-6f97d2276105",
    # /sport/football/teams/egypt
    "55794b4a-e4d5-44e6-af1a-47eea3027e2a",
    # /sport/football/teams/eibar
    "37559593-903e-4762-8720-ece3cf715220",
    # /sport/football/teams/eintracht-frankfurt
    "ff79ba43-5119-4f92-be14-7b2966f21412",
    # /sport/football/teams/el-salvador
    "f5a0b205-c294-40de-9329-a5a88aa74ffa",
    # /sport/football/teams/elgin-city
    "69eec8aa-359c-624d-bb16-1a80f25fad1e",
    # /sport/football/teams/empoli
    "9c4d4d40-2956-4a5b-a8e3-e7274bc2a6db",
    # /sport/football/teams/england
    "611ecd3d-8b08-48d5-aee9-d01e7620d2a4",
    # /sport/football/teams/england-u21
    "189cf0d6-3b98-45d6-9e01-8957b9221d34",
    # /sport/football/teams/england-women
    "b4f0cb7d-ccb3-4b34-afde-e6fe553e9772",
    # /sport/football/teams/eskisehirspor
    "527dd690-8140-4e7c-94b9-de08251fb9fc",
    # /sport/football/teams/espanyol
    "73d6cb10-0fb9-4769-97e9-e3a5748e1ef7",
    # /sport/football/teams/estonia
    "989f1a15-da76-43f0-bf4f-8328c7c555ca",
    # /sport/football/teams/ethiopia
    "c701e5ee-5bc3-4922-a621-d6c51f7477dc",
    # /sport/football/teams/everton
    "48287aac-b015-1d4e-9c4e-9b8abac03789",
    # /sport/football/teams/everton-ladies
    "6649e4cd-e608-4386-a07b-29474e63256e",
    # /sport/football/teams/exeter-city
    "a63810a1-83f2-2348-8758-bfc1613314fe",
    # /sport/football/teams/falkirk
    "e490e57e-9ef9-e940-b08e-6c8b381298e2",
    # /sport/football/teams/faroe-islands
    "aacd7b64-abd7-47cb-a5b6-48f51c3efd0a",
    # /sport/football/teams/fc-copenhagen
    "8fd12169-4587-4fc3-b0d3-8655f7ee1626",
    # /sport/football/teams/fc-porto
    "eb06524e-4f39-4bcf-be75-be162b498d6a",
    # /sport/football/teams/fc-red-bull-salzburg
    "170dbd85-61e3-4278-84b8-01c47d4bfc46",
    # /sport/football/teams/fc-schalke
    "c89459f0-13ad-4cec-8bb4-7f4264683228",
    # /sport/football/teams/finland
    "8781e9b9-250e-4140-8ef2-a5797a9470e3",
    # /sport/football/teams/fiorentina
    "a4cf3728-7b51-4c4e-807e-288635ff45ad",
    # /sport/football/teams/fleetwood-town
    "10ddb0dd-f49b-6d4a-a327-7f1d24805c33",
    # /sport/football/teams/forest-green-rovers
    "3790f140-5444-224e-bf05-ce581dc49b17",
    # /sport/football/teams/forfar-athletic
    "2389e7d4-b6ee-8b42-b430-806fd9a5a7e9",
    # /sport/football/teams/france
    "51bc6665-92bc-4926-8689-969dc76a9d34",
    # /sport/football/teams/france-u21
    "e534df02-1f26-4155-a459-9875cae71f41",
    # /sport/football/teams/france-women
    "dbebf4cf-e131-486f-8abe-f489f40f20b2",
    # /sport/football/teams/freiburg
    "c871db7b-c97b-4e48-8cd4-c43f9cf6cf3b",
    # /sport/football/teams/frosinone
    "9e4e22f6-26ec-471e-b558-4e5d20c27cb1",
    # /sport/football/teams/fulham
    "98c3db4b-498d-7c4b-acb5-d16ffb214f0d",
    # /sport/football/teams/galatasaray
    "206c16b5-5a86-4498-9fbb-33c25c6fef02",
    # /sport/football/teams/gateshead
    "dc0bf7e4-b512-4f45-9a00-1439fa0b50be",
    # /sport/football/teams/genoa
    "cb23fc40-513a-4f0d-a2b7-37494d82b5df",
    # /sport/football/teams/georgia
    "901c84f9-eba9-48af-95ca-8e80e7e81415",
    # /sport/football/teams/germany
    "280cfc54-a128-417c-a74e-b663a7f2f61f",
    # /sport/football/teams/germany-u21
    "b866b757-104e-4990-a3d2-edd38a7d4070",
    # /sport/football/teams/germany-women
    "737be194-6fc5-4e0d-ba2f-eae4024bd8fd",
    # /sport/football/teams/getafe
    "1c1c5511-e83b-46db-b1bf-eceaec937554",
    # /sport/football/teams/ghana
    "1e9a1407-3a98-4940-b782-5abd89ebcce4",
    # /sport/football/teams/gibraltar
    "b12dd6db-c022-4df3-9ea0-025ec69ac61e",
    # /sport/football/teams/gillingham
    "d66791b0-d72a-fc43-b6f7-d7bbf5774ef3",
    # /sport/football/teams/girona
    "bd0bc18e-ceb3-4fb7-b430-3320a953aa1f",
    # /sport/football/teams/gomel
    "5a71eff5-61a9-4e17-bc37-7ba20ad22178",
    # /sport/football/teams/granada
    "572083a0-a1b4-4b58-9178-943a234b1a8d",
    # /sport/football/teams/greece
    "a96d9920-594f-45f2-b2aa-4d3a8b3b6966",
    # /sport/football/teams/greenock-morton
    "b0e4a498-fbda-c74a-81b0-d85e5012dcf1",
    # /sport/football/teams/grimsby-town
    "60fb8a80-77b1-4f4e-8ad8-7c0f22f17d64",
    # /sport/football/teams/guatemala
    "139a4f49-ae9b-44db-a8d8-fe73e3e5c686",
    # /sport/football/teams/guinea
    "19c7835c-7834-455c-89af-4e438ce44d81",
    # /sport/football/teams/guinea-bissau
    "e58bd16f-c135-4d8f-aa05-1e30c82693e7",
    # /sport/football/teams/guingamp
    "d2a528cd-562f-4e95-bb71-6abd02825237",
    # /sport/football/teams/guiseley
    "35311ec6-496b-4890-ba9e-9fe185479eed",
    # /sport/football/teams/guyana
    "b8dbc515-a3a7-4f8d-b03c-aa675a7c2467",
    # /sport/football/teams/haiti
    "7ff4a510-3eee-4ed2-bc1c-c54896127b77",
    # /sport/football/teams/halifax
    "5f9c3b8a-44fe-4d41-ac80-4719b3e3be2a",
    # /sport/football/teams/hamburg
    "f6c5e9b7-220b-4dcc-810d-51fb575510e0",
    # /sport/football/teams/hamilton-academical
    "aad59b59-891c-a54c-bff9-bef648c06766",
    # /sport/football/teams/hannover
    "1945f8c2-773f-49fd-b248-55d5620edd2f",
    # /sport/football/teams/harrogate-town
    "4ca8f2f3-30b4-4d25-b3c5-71ddb6a51372",
    # /sport/football/teams/hartlepool-united
    "b02eddf4-cbf0-ac46-a5f1-4c25ce58306d",
    # /sport/football/teams/havant-and-waterlooville
    "cfaa2839-0fc1-4ac9-80cb-61248a01f1f1",
    # /sport/football/teams/hayes-and-yeading-united
    "f54451db-eebc-304e-9681-7b7d87fd2e1c",
    # /sport/football/teams/heart-of-midlothian
    "76976a76-f9f7-3949-bae4-2daa704aa395",
    # /sport/football/teams/hellas-verona
    "92bae4bd-bdfd-4904-bf36-0276061b46e8",
    # /sport/football/teams/hereford-united
    "75ef8f32-4d03-d84e-b1f5-13c8d42a3ec6",
    # /sport/football/teams/hertha-berlin
    "4fc23804-aa65-46ee-9f68-5ad0044b08dc",
    # /sport/football/teams/hibernian
    "3e6e2f9a-79f9-7546-bf97-31f46ba6cd5a",
    # /sport/football/teams/hoffenheim
    "94ba99ae-aeea-42d3-a6f1-71b6cdac0482",
    # /sport/football/teams/honduras
    "1c2a6788-56b4-4b51-9651-07c830c7e0b5",
    # /sport/football/teams/huddersfield-town
    "843257c2-309c-a749-9888-615bb448f887",
    # /sport/football/teams/huesca
    "5be2b9ad-f9c7-4a3a-a0e8-a9793bf2b12d",
    # /sport/football/teams/hull-city
    "10786d02-d602-084f-bfb5-3198a9bebfe7",
    # /sport/football/teams/hungary
    "af3f9f71-7bb1-4350-906b-db0bcd7c1693",
    # /sport/football/teams/hyde
    "6d6cacec-bfed-4fbf-be52-74869ec6afed",
    # /sport/football/teams/iceland
    "9a53bd9f-90f6-4838-9810-9467992de26b",
    # /sport/football/teams/iceland-women
    "e2c07955-11fd-4881-9eab-09aebff092b6",
    # /sport/football/teams/india
    "8dc0e127-325a-49d5-935b-f74439e3bf03",
    # /sport/football/teams/ingolstadt
    "77f179b4-9c91-4914-9803-767bb0d3d966",
    # /sport/football/teams/inter-milan
    "3447fd88-6593-40f8-8688-143141bd5d22",
    # /sport/football/teams/inverness-caledonian-thistle
    "c2995909-a4ed-bc4d-b659-c56c1dcf65dc",
    # /sport/football/teams/ipswich-town
    "32a71ba8-5632-3e4b-935c-7cfcb99b33a8",
    # /sport/football/teams/iran
    "338af54c-76ea-49dc-ab1d-cf6e3baca684",
    # /sport/football/teams/iraq
    "c900fe7f-2e33-4373-93d3-f94ad1c6b3e1",
    # /sport/football/teams/israel
    "d5b732fe-5a7b-42f5-9d1a-206474349efc",
    # /sport/football/teams/italy
    "18d7cd44-bde2-4b14-97a4-c32f4f17e1c1",
    # /sport/football/teams/italy-u21
    "bcdd3b1e-a131-4940-98a0-d844acf7bb9d",
    # /sport/football/teams/italy-women
    "f99d66eb-dd7d-4297-a7dc-d89a4cc06851",
    # /sport/football/teams/ivory-coast
    "6e18e0db-5746-431f-8e17-c59fd30e36a5",
    # /sport/football/teams/ivory-coast-women
    "db402bd1-a853-4a97-9fc5-47a72e3460c4",
    # /sport/football/teams/jamaica
    "2e6b2604-1b9e-4c6a-97a5-be989bfa46b1",
    # /sport/football/teams/jamaica-women
    "2c896aa3-44f0-4a7d-b2c0-9fe3f6b8a891",
    # /sport/football/teams/japan
    "48e56743-a961-42f7-9e7e-066f19e40c71",
    # /sport/football/teams/japan-women
    "0cada216-2c69-46be-9185-b636c0d755f5",
    # /sport/football/teams/jordan
    "a27fcfcf-0621-4c78-af6c-1db88bb4a901",
    # /sport/football/teams/juventus
    "6f93127a-159a-45d6-a9d0-97d09b38dd66",
    # /sport/football/teams/kazakhstan
    "72d28c1a-7315-40bf-9ca8-04272af97e9d",
    # /sport/football/teams/kenya
    "4e8fccab-5cb1-4354-99fd-79d3c2b16b90",
    # /sport/football/teams/kettering-town
    "859fc11c-e202-b64f-a086-7dba98184dbc",
    # /sport/football/teams/kidderminster-harriers
    "fb692d4a-0fbd-b146-b82e-8ca7eb23b7e6",
    # /sport/football/teams/kilmarnock
    "aabd5eb3-73c0-6b47-a00d-0b0d6531acbc",
    # /sport/football/teams/kings-lynn-town
    "f1d9a9f2-c876-44d6-98a4-9ff2a22c8352",
    # /sport/football/teams/koeln
    "e6f58a46-bd63-4b0a-85a4-e748e9ca22a5",
    # /sport/football/teams/kosovo
    "579919ac-dc79-43cf-bbf0-2940205d44ac",
    # /sport/football/teams/kyrgyzstan
    "5d26691c-05ba-4465-af38-5cfba4865b90",
    # /sport/football/teams/las-palmas
    "44bdad3c-5185-430c-822f-64bad2848b83",
    # /sport/football/teams/latvia
    "74b0025f-2d2d-4e29-94fa-e93a247cbeae",
    # /sport/football/teams/lazio
    "756a1eb5-f8bf-486d-b65d-fc74390b7288",
    # /sport/football/teams/lebanon
    "847c7327-941f-43dd-9406-5b74c5b9c1b6",
    # /sport/football/teams/lecce
    "2e65069d-6333-4d0d-a29e-3ab63b75de6a",
    # /sport/football/teams/leeds-united
    "509d2079-2bf6-e44d-b791-a38bcda66529",
    # /sport/football/teams/leganes
    "2de4dcd0-95df-49f8-8aa8-e6ae96446024",
    # /sport/football/teams/legia-warsaw
    "f1c79ee7-d511-4602-91f5-b4ffafccac5e",
    # /sport/football/teams/leicester-city
    "ff55aea0-83d7-834c-afc0-d21045f561e9",
    # /sport/football/teams/leipzig
    "a67f03d8-c536-4376-ba03-a317053472e7",
    # /sport/football/teams/levante
    "f8af60bf-3adf-4813-8453-8f7f5f699b4b",
    # /sport/football/teams/leyton-orient
    "7851e418-cb7e-844f-813d-881e4ea8cf9b",
    # /sport/football/teams/liechtenstein
    "dfa3dba2-199e-4e2f-94c8-f57306c44396",
    # /sport/football/teams/lille
    "8ef0bba5-fc49-4e7e-9ee3-1dd9e3672824",
    # /sport/football/teams/lincoln-city
    "dae23c89-2b1f-2e46-95dc-67ae27628201",
    # /sport/football/teams/lithuania
    "825aa545-9794-498e-951c-9b85709a3720",
    # /sport/football/teams/liverpool
    "8df31a76-4c22-5b40-9f0d-78b34dfb26fa",
    # /sport/football/teams/liverpool-ladies
    "8ec20806-f955-4164-b955-e93ef9eba79d",
    # /sport/football/teams/livingston
    "bec294ac-1022-ac44-a26b-3b220983fd30",
    # /sport/football/teams/llanelli-town
    "1fc96999-ee3d-5742-a1a6-4e0e0d17ec7b",
    # /sport/football/teams/lorient
    "56c824a4-4fa1-42bf-b787-7b9866c45fef",
    # /sport/football/teams/ludogorets-razgrad
    "457d4979-d90c-4b1d-9c76-f7b8f7236d46",
    # /sport/football/teams/luton-town
    "5fe62cde-d404-8045-be16-ddb66a00d393",
    # /sport/football/teams/luxembourg
    "70a4c626-30a1-45f2-9054-fd772ea45eca",
    # /sport/football/teams/lyon
    "aea2272e-c26d-481f-bd59-614d7c8053d2",
    # /sport/football/teams/macclesfield-town
    "c4ca84fb-af17-8c4e-ac66-a2b5b06aab69",
    # /sport/football/teams/macedonia
    "f6d994e3-d9f8-46e8-b717-6537599190cf",
    # /sport/football/teams/madagascar
    "ad6cc23f-fa33-4c0d-b658-c5e5cdfd75dc",
    # /sport/football/teams/maidenhead-united
    "5c29cdb7-fe47-45b9-b11a-492770884a14",
    # /sport/football/teams/maidstone-united
    "c3c3256c-71c5-483a-84a0-0d868b1db118",
    # /sport/football/teams/mainz
    "498ef63e-ed95-4338-bdcc-a00d950527b4",
    # /sport/football/teams/malaga
    "a6e8cd4b-e80d-4075-8d7c-26f3ccf63eb8",
    # /sport/football/teams/mali
    "113d0cf9-8fc9-48e5-bcb2-514d7b1d2929",
    # /sport/football/teams/mallorca
    "04a7d274-0f82-4ad6-8a12-35da430c6e7e",
    # /sport/football/teams/malmo-ff
    "d7b30b58-9349-4686-95b6-b0c3ba668ca1",
    # /sport/football/teams/malta
    "e35f6388-3716-4d84-b214-75cbf651e9c9",
    # /sport/football/teams/manchester-city
    "4bdbf21d-d1ad-7147-ab08-612cd0dc20b4",
    # /sport/football/teams/manchester-city-women
    "756e0e9e-5d0c-4acf-a681-1475a227acee",
    # /sport/football/teams/manchester-united
    "90d9a818-850b-b64f-9474-79e15a0355b8",
    # /sport/football/teams/manchester-united-women
    "bc7eb531-933a-48e4-ba82-d3784d20118f",
    # /sport/football/teams/mansfield-town
    "407fb29a-fa34-a74e-92c5-dedfa26a2401",
    # /sport/football/teams/maribor
    "61f7b28d-d7f0-471d-a79f-06e154aebc18",
    # /sport/football/teams/marseille
    "31b669ff-ade5-452a-bbd4-3ed7e1f6f88b",
    # /sport/football/teams/martinique
    "765113d8-7fa7-4f55-a461-4b8fe28aba9a",
    # /sport/football/teams/mauritania
    "6ca2bce6-33c0-4bbc-a7f4-029846117372",
    # /sport/football/teams/metalist-kharkiv
    "193417de-5b0a-4bc3-a697-93bff62d23d5",
    # /sport/football/teams/metz
    "7db03a51-1abd-406d-8356-5b37434eb9e8",
    # /sport/football/teams/mexico
    "c297c13f-ce09-499c-ae5f-a660cfb4e13f",
    # /sport/football/teams/mexico-women
    "a6d5a296-915d-4204-9c02-b289415f5812",
    # /sport/football/teams/middlesbrough
    "39a9af5a-c881-a74d-bae7-226ac220df03",
    # /sport/football/teams/milan
    "85f043fe-1346-470c-96dd-d6ed1c0e47a9",
    # /sport/football/teams/millwall
    "aae45535-f9de-0449-9d1f-09e2f5f2a02b",
    # /sport/football/teams/milton-keynes-dons
    "77fd06da-b489-3040-ace3-f8ed4f19d839",
    # /sport/football/teams/moldova
    "102f6e2f-79b5-4841-bab3-63f184ed18d4",
    # /sport/football/teams/monaco
    "b6f551ab-5c37-44b2-b001-ba73285cc958",
    # /sport/football/teams/montenegro
    "f3992f60-5909-4134-9c58-065f030144b1",
    # /sport/football/teams/montpellier
    "fd600554-c07d-407d-b755-8e582e7095c6",
    # /sport/football/teams/montrose
    "bcb5f9e3-776e-e041-9b3b-5d2dedb04e53",
    # /sport/football/teams/morecambe
    "10726d19-2831-7e46-b1a6-e229862729f7",
    # /sport/football/teams/morocco
    "b9d79493-931c-4265-b558-6a7e283d33f6",
    # /sport/football/teams/motherwell
    "11f60fdb-df70-3348-a54d-6a7bcda03b8d",
    # /sport/football/teams/namibia
    "f779d5e7-a35d-461d-8f79-852dc1c4a232",
    # /sport/football/teams/nancy
    "54afd548-7f72-440c-95b0-2534b5685769",
    # /sport/football/teams/nantes
    "eb4c21db-f9a8-444f-882d-f7d82d422adb",
    # /sport/football/teams/napoli
    "a15c7264-b424-4d81-ab5e-93da6ea7cb89",
    # /sport/football/teams/netherlands
    "6d4a2858-462e-4375-b51b-2a4fb480eee2",
    # /sport/football/teams/netherlands-u21
    "5cf42ba7-daad-4dfd-b2ae-e26010e8c9cf",
    # /sport/football/teams/netherlands-women
    "570540a6-b794-4216-8c49-4266bd5e4048",
    # /sport/football/teams/new-saints
    "5336cbc1-2caa-144c-bb78-0ba3b59b19cd",
    # /sport/football/teams/new-zealand-women
    "fbb0b905-fc13-47e1-9f90-42582863dcff",
    # /sport/football/teams/newcastle-united
    "34032412-5e2a-324d-bb3e-d0d4b16df2d4",
    # /sport/football/teams/newport-county
    "646e45c3-4889-1346-92a2-773da1483fc1",
    # /sport/football/teams/newtown
    "ab67a01e-027b-9c4c-971a-c350e98e4667",
    # /sport/football/teams/nicaragua
    "b993e234-b89e-4b39-be4b-e2f6f33199c8",
    # /sport/football/teams/nice
    "08917b83-e64f-4d3b-a475-c3a8399c0e67",
    # /sport/football/teams/niger
    "130164f4-708b-4c58-b845-82cd47465577",
    # /sport/football/teams/nigeria
    "aef9ea59-2f89-4760-a31c-5c319c53d166",
    # /sport/football/teams/nigeria-women
    "83826611-b27a-434b-b566-42b0ed96dda8",
    # /sport/football/teams/nimes
    "7e3205d0-7d76-40f1-8039-21b477a1edaa",
    # /sport/football/teams/north-ferriby-united
    "bb1427ba-fdd5-4d35-ad09-9c8bf30e263f",
    # /sport/football/teams/north-korea
    "cf825117-9051-4230-9086-183c51db99f4",
    # /sport/football/teams/northampton-town
    "f7023361-5d4e-3e48-95cc-61e458eed4bb",
    # /sport/football/teams/northern-ireland
    "c1419a1e-ebc7-4c00-9073-12ed4f0e99de",
    # /sport/football/teams/northern-ireland-u21
    "1a5ced7d-e4df-402d-82cc-b50ada08ee5e",
    # /sport/football/teams/northern-ireland-women
    "955aad1f-c9ab-40a5-b613-9b9c69cdcc46",
    # /sport/football/teams/norway
    "bcfa15f8-4ff0-4cfd-ab0d-40ded48e8f5d",
    # /sport/football/teams/norway-women
    "996c02c9-0e3c-4e2f-9e34-166ac56979fe",
    # /sport/football/teams/norwich-city
    "a700cc4d-72eb-a84d-8d7a-73ce435f6985",
    # /sport/football/teams/nottingham-forest
    "a3785681-0dce-3842-9e55-e83aa7a1aae1",
    # /sport/football/teams/notts-county
    "69ae1e1d-3d11-db4a-9609-283b19d254af",
    # /sport/football/teams/nuneaton-town
    "93441dc1-5d81-4c85-81df-89956b63b4cc",
    # /sport/football/teams/nuremberg
    "21c0c550-b087-4094-98ab-d4eb3a0c5b9c",
    # /sport/football/teams/oldham-athletic
    "661fc640-b304-2d46-bfeb-427505904447",
    # /sport/football/teams/olympiakos
    "70d145c7-d7b2-41dd-8b87-99b3c770a0e0",
    # /sport/football/teams/oman
    "8cebd2da-6db3-41fe-b4be-1b7b906e0cd0",
    # /sport/football/teams/osasuna
    "a3fa3eca-3f05-4fcb-b716-70ac08c77216",
    # /sport/football/teams/oxford-united
    "03e20e1e-61e9-3749-ae53-0bbaa18e9ed9",
    # /sport/football/teams/paderborn
    "d4ef5090-13c2-4dab-bccb-057f79d6a76c",
    # /sport/football/teams/palermo
    "48f9379b-2db4-494e-9790-8ef11649cfa8",
    # /sport/football/teams/palestine
    "3cd9c8e6-0767-449c-b12e-8a95ccae5624",
    # /sport/football/teams/panama
    "a1bf24e8-88ee-4865-9469-aa71c050c414",
    # /sport/football/teams/panathinaikos
    "3d53aaf6-50b6-40af-8f9c-ff105056a9f9",
    # /sport/football/teams/paraguay
    "bf4932d4-aa58-4dfd-8d89-57a09164ba18",
    # /sport/football/teams/paris-st-germain
    "da152cb0-5edd-4d9a-824a-c32e4ebd923b",
    # /sport/football/teams/parma
    "f0131ea9-813f-4fe2-a319-57f8118fc918",
    # /sport/football/teams/partick-thistle
    "4b054c51-dff4-a243-a876-fc6595124b47",
    # /sport/football/teams/partizan-belgrade
    "89353f27-827c-45dc-90f9-33c2077247ab",
    # /sport/football/teams/peru
    "931bc5b4-1859-4572-8001-a4d322057ae0",
    # /sport/football/teams/pescara
    "66149bab-0472-4d1f-8ce0-4fb91aa4fc18",
    # /sport/football/teams/peterborough-united
    "a5ac6cfb-67ff-df4b-bd41-adc3295bc813",
    # /sport/football/teams/peterhead
    "98c8f8a4-b663-cf4e-a8d9-77a32c4d5392",
    # /sport/football/teams/philippines
    "730946c3-4ceb-4fd9-afd7-18a399149346",
    # /sport/football/teams/plymouth-argyle
    "b581d4f3-c869-0a47-88ef-1c78d2d5792f",
    # /sport/football/teams/poland
    "3d119357-390d-458a-b33c-3910532977fd",
    # /sport/football/teams/poland-u21
    "140bcae5-be1d-4018-84bb-46ea902d1c2a",
    # /sport/football/teams/port-vale
    "0ee936e9-92ed-2b44-88d3-9c658b9bfb4a",
    # /sport/football/teams/portsmouth
    "23ec8541-6e72-b447-b75a-2ee1a9856e7c",
    # /sport/football/teams/portugal
    "50e8aed7-1ce9-4784-962f-e61fea038990",
    # /sport/football/teams/portugal-u21
    "23ab0da4-a85d-40e5-84f2-f0ee98013c6d",
    # /sport/football/teams/portugal-women
    "d831cbf4-d930-4a3a-87b6-09ad959f6352",
    # /sport/football/teams/prestatyn-town
    "ccb237ec-9398-5047-a60c-53690eba0ea8",
    # /sport/football/teams/preston-north-end
    "222e1b25-9851-5b46-aa20-a2f9e8591d64",
    # /sport/football/teams/qatar
    "e195f56d-570a-4b10-a871-d1d38e622278",
    # /sport/football/teams/queen-of-the-south
    "491e9338-1549-1e49-b202-b157c149271d",
    # /sport/football/teams/queens-park
    "e870971d-d6e3-504d-888f-d8558d4a4817",
    # /sport/football/teams/queens-park-rangers
    "81f6a64f-def0-0d40-bc3a-36dab5472f64",
    # /sport/football/teams/raith-rovers
    "3c7725e6-ab7c-2a44-b9c8-08f1b39fa95c",
    # /sport/football/teams/rangers
    "5840c45e-73f4-9942-b653-8d7eb8067fc9",
    # /sport/football/teams/rayo-vallecano
    "2905619c-8490-4ec9-a59c-cd25f77f0ef7",
    # /sport/football/teams/reading
    "0838f428-327a-7f41-9bf4-7758710b572b",
    # /sport/football/teams/reading-women
    "6e9b8318-933f-4bc9-8ab9-9d6d907a4afd",
    # /sport/football/teams/real-betis
    "e14e65cd-ea5b-4b41-ad23-922b64b55d05",
    # /sport/football/teams/real-madrid
    "1c9c5c77-4d89-414a-a5df-1f9f1a28d630",
    # /sport/football/teams/real-sociedad
    "a7e6c0fe-09e6-4c0a-8dbd-53341cf2c22f",
    # /sport/football/teams/real-valladolid
    "4dcb7da4-25bd-464b-a038-9a0f3d8a9e84",
    # /sport/football/teams/red-star-belgrade
    "b719bd8e-1c21-425b-ad3c-f9e501cf4ccb",
    # /sport/football/teams/reims
    "8009d1c1-e823-432e-ba5d-41b5db44ec58",
    # /sport/football/teams/rennes
    "4b1d3a19-5e03-43b2-b153-3f58833d8451",
    # /sport/football/teams/republic-of-ireland
    "65e33e6b-ded0-450a-80fb-0c25fe88b5f6",
    # /sport/football/teams/republic-of-ireland-u21
    "2734989c-c101-4dad-b586-6ff44161c925",
    # /sport/football/teams/republic-of-ireland-women
    "5d0f9de5-6f54-4772-b96d-fe015d4c694a",
    # /sport/football/teams/rochdale
    "9284d26e-8e01-db4c-a1dc-1511bf7785fe",
    # /sport/football/teams/roma
    "855796ec-5090-442e-ac5a-b2f0299c26af",
    # /sport/football/teams/romania
    "f1be2537-3c14-40f1-835d-82b4f6507089",
    # /sport/football/teams/romania-u21
    "0e6b4d91-8f3b-4cdc-9e1c-b225ea72dd9b",
    # /sport/football/teams/ross-county
    "88ea67d2-4ee7-ac4c-956a-470565f83cf1",
    # /sport/football/teams/rotherham-united
    "7b4a9601-b913-3849-94d9-e6e734f04259",
    # /sport/football/teams/rsc-anderlecht
    "55e38775-ad97-4248-8209-44b01381d73c",
    # /sport/football/teams/rubin-kazan
    "43cf5c10-1b41-4a31-90c2-5e58ef0a344f",
    # /sport/football/teams/russia
    "a80d80f4-c47e-4417-b1c7-de1af76a03a7",
    # /sport/football/teams/russia-women
    "b0a49f17-cef8-4e08-90ae-e0a6b88c6239",
    # /sport/football/teams/salford-city
    "4ec52ad4-0c85-46aa-b7e8-cd7fdbc3f9dc",
    # /sport/football/teams/salisbury-city
    "1fca9478-87f9-4654-a265-067bd1ce0d8c",
    # /sport/football/teams/sampdoria
    "00358f81-e421-4464-bdc9-ecf2034c822e",
    # /sport/football/teams/san-marino
    "cb31695c-f178-4958-8ac0-5e4e134c840d",
    # /sport/football/teams/sassuolo
    "235e7428-a622-44b5-8161-fedc34aff4ab",
    # /sport/football/teams/saudi-arabia
    "04034025-ab84-4bad-a496-d14fc6df2ded",
    # /sport/football/teams/scotland
    "68c324cd-45c3-42e1-a4fa-3c6b456b7b51",
    # /sport/football/teams/scotland-u21
    "2b787a51-4b7e-4320-a5bd-38209c7b44c3",
    # /sport/football/teams/scotland-women
    "7d32d130-1a59-43cb-95cb-6221ddf89d98",
    # /sport/football/teams/scunthorpe-united
    "7c6e467d-c612-504b-9389-f30226a4b82e",
    # /sport/football/teams/senegal
    "1abbf54b-53a3-4a01-b0a8-c3dd60b431f7",
    # /sport/football/teams/serbia
    "6247858b-4d10-486f-a3d1-a5ac50788a90",
    # /sport/football/teams/serbia-u21
    "37147249-7c10-495c-a877-ae26d5464786",
    # /sport/football/teams/sevilla
    "a66cc19e-e179-45f7-9a9b-8632e2b8c450",
    # /sport/football/teams/shakhtar-donetsk
    "6885eb33-1225-48b9-81b1-abf34b13125b",
    # /sport/football/teams/sheffield-united
    "75f90667-0306-e847-966e-085a11a8f195",
    # /sport/football/teams/sheffield-wednesday
    "3e4539d2-bdb9-e548-b04c-1060ad05fe5a",
    # /sport/football/teams/shrewsbury-town
    "99bd3ab2-7110-be4f-bc12-1152d31ab75f",
    # /sport/football/teams/slovakia
    "4ba212dc-8bc5-4b05-b735-5fd573a6c87c",
    # /sport/football/teams/slovan-bratislava
    "d6835cbe-6201-4fcc-9452-9a216c30d738",
    # /sport/football/teams/slovenia
    "1a59e05e-caf4-4475-920a-274ceef2e8ad",
    # /sport/football/teams/solihull-moors
    "7719652d-4013-4e4d-b5a8-f603e57c8c07",
    # /sport/football/teams/south-africa
    "4acd60e9-8730-49f8-a1f7-2f28de398749",
    # /sport/football/teams/south-africa-women
    "5bc3e1ce-a27e-44f4-a9a3-f2cc4d580369",
    # /sport/football/teams/south-korea
    "50ff6cc4-129e-428a-b936-39618e33f9e6",
    # /sport/football/teams/south-korea-women
    "e2ae4ace-46fd-41e1-aa9e-f459dcfeacdf",
    # /sport/football/teams/southampton
    "6780f83f-a17a-e641-8ec8-226c285a5dbb",
    # /sport/football/teams/southend-united
    "d434ee4d-e0e1-0b49-8251-e3f29e8b5598",
    # /sport/football/teams/southport
    "afc071cb-0a83-1c41-ace5-b361be1ecb0a",
    # /sport/football/teams/spain
    "b9bb453a-a3e2-46b4-9d20-35efa09d72b8",
    # /sport/football/teams/spain-u21
    "84a875c2-b0b7-483c-9c89-5cedd03062e9",
    # /sport/football/teams/spain-women
    "a3fec6ab-00fc-4b8f-bbbf-607610e67841",
    # /sport/football/teams/spal
    "69df1063-8877-4f13-8794-df424d1d2b73",
    # /sport/football/teams/sporting-gijon
    "35db1f47-102f-46e1-b25e-745d39d9145f",
    # /sport/football/teams/sporting-lisbon
    "4a0ddf1a-0b72-4c0d-9758-5c1f3cb54a07",
    # /sport/football/teams/st-etienne
    "d4e4d631-52b4-4354-ad10-2741fb31c8a6",
    # /sport/football/teams/st-johnstone
    "e0bd00b9-6ae5-1e43-af34-71fde286da18",
    # /sport/football/teams/st-mirren
    "7c461293-7845-3e49-a7bf-96b2c3f6de43",
    # /sport/football/teams/standard-liege
    "488a2b3e-c999-4747-9fba-6af709239157",
    # /sport/football/teams/steau-bucharest
    "5018bb5d-fa01-4a46-9d86-8d0b62362a0a",
    # /sport/football/teams/stenhousemuir
    "dea7c3a1-9534-e245-b01f-68741851d2ae",
    # /sport/football/teams/stevenage
    "2784b098-bd1f-a54e-86a5-1fa39a0e0ce4",
    # /sport/football/teams/stirling-albion
    "85740113-82ee-4e4e-bb35-fd546ecd48a7",
    # /sport/football/teams/stockport-county
    "ec2b9d27-3ef5-2649-ab44-7a14cfa1b2a9",
    # /sport/football/teams/stoke-city
    "ff3ad258-564a-3d46-967a-cefa4e65cfea",
    # /sport/football/teams/stranraer
    "92cec538-f1f2-f549-a75e-c95210ed7f7f",
    # /sport/football/teams/strasbourg
    "d1b57dca-f093-45e1-979a-16c14e61012d",
    # /sport/football/teams/sunderland
    "d5a95ba9-efe6-aa4e-afc4-9adc5f786e58",
    # /sport/football/teams/sunderland-ladies
    "9cc38e44-b4c7-45dd-a79e-60a3a0e66d9c",
    # /sport/football/teams/sutton-united
    "a152afdd-8b16-4635-ac48-80117ce891a5",
    # /sport/football/teams/swansea-city
    "98105d9f-b1db-0547-b8c7-581abf30c7e9",
    # /sport/football/teams/sweden
    "3ac8c344-8b15-4324-b772-5e3d52a704fc",
    # /sport/football/teams/sweden-u21
    "29613983-b973-4edb-9403-1636c0d3d10e",
    # /sport/football/teams/sweden-women
    "98964a23-e32e-4ac7-a087-4ecb1b65dbf4",
    # /sport/football/teams/swindon-town
    "ba8fb808-bed3-9f4b-ba49-c164c3d3a12c",
    # /sport/football/teams/switzerland
    "2688d5c1-aa00-4abb-8b3c-345d83ce3538",
    # /sport/football/teams/switzerland-u21
    "32951909-9d14-45b3-a19a-61780f90c89c",
    # /sport/football/teams/switzerland-women
    "5ae1f539-df7e-4d55-84e7-0c1682d8b54b",
    # /sport/football/teams/syria
    "97184f99-0a66-416d-97ca-9f10b2b43cfd",
    # /sport/football/teams/tamworth
    "0e4d1250-73dd-ae4c-801f-99629715dc77",
    # /sport/football/teams/tanzania
    "7b8f9e72-72fa-4bbc-892a-07b675a9b16c",
    # /sport/football/teams/thailand
    "d9b1cfa0-6653-4da5-ad13-f448475ff9c4",
    # /sport/football/teams/thailand-women
    "7149d568-d56e-4a10-b935-91c33af67b59",
    # /sport/football/teams/togo
    "6ea5913c-9f68-41dd-b3ed-8bd7e10cd39f",
    # /sport/football/teams/torino
    "6520ad1c-5219-423e-8192-8051c27aebc6",
    # /sport/football/teams/torquay-united
    "5d6f03d0-e049-2847-9de8-3be1d51653f4",
    # /sport/football/teams/tottenham-hotspur
    "edc20628-9520-044d-92c3-fdec473457be",
    # /sport/football/teams/tottenham-hotspur-women
    "5330f58b-bfaa-447d-8209-4080a33e3412",
    # /sport/football/teams/toulouse
    "b3f48321-d045-448c-ab44-a8facc4cf8e3",
    # /sport/football/teams/tranmere-rovers
    "4573991e-224e-2546-b4fd-6584d1498e23",
    # /sport/football/teams/trinidad-and-tobago
    "b50012cc-99c3-45c9-a290-cb8a90a13e94",
    # /sport/football/teams/troyes
    "42cbc042-1d58-4a46-840a-93137ddc9bf1",
    # /sport/football/teams/truro-city
    "e9d7807d-36d4-4b47-a687-0f29426a32e2",
    # /sport/football/teams/tunisia
    "fb5da161-43c1-4cfc-a24a-9b1d2aa62886",
    # /sport/football/teams/turkey
    "00dceb02-39fb-4fec-98e0-7ab3d00c94e7",
    # /sport/football/teams/turkmenistan
    "74ab21e9-b248-4baa-9140-4609c699ff87",
    # /sport/football/teams/udinese
    "29d5b5a1-08a2-48cc-a0c0-ebefddec861c",
    # /sport/football/teams/uganda
    "56a6f6d6-dd33-42ab-a48f-290219d08235",
    # /sport/football/teams/ukraine
    "af6492fe-1a6e-4066-8410-83fd00f513c7",
    # /sport/football/teams/union-berlin
    "523e12b6-7173-4553-a703-b78fde7f1346",
    # /sport/football/teams/united-arab-emirates
    "282191e5-393a-4424-9ce1-05fc11613b5d",
    # /sport/football/teams/uruguay
    "0690666f-509a-44d4-9505-75d58b99f664",
    # /sport/football/teams/usa
    "77d1e6c2-97a6-450a-904d-21ea66700a53",
    # /sport/football/teams/usa-women
    "ef6c624c-be0b-47a6-9e7c-ac4056b5c27d",
    # /sport/football/teams/uzbekistan
    "332a1140-a097-49dd-8a0c-eb7f50699fb6",
    # /sport/football/teams/valencia
    "5c1494b0-7730-4f45-be11-4ef04d3d4efc",
    # /sport/football/teams/venezuela
    "d4b3bee1-d813-4d59-8c81-0064b5d807b9",
    # /sport/football/teams/vfb-stuttgart
    "a670a2e7-09ce-4ab7-ab2f-03a8678fb295",
    # /sport/football/teams/vietnam
    "44a698f0-304a-42d7-8c58-e503dcba252d",
    # /sport/football/teams/villarreal
    "17551c79-999a-4dfd-9f51-28535182153e",
    # /sport/football/teams/wales
    "4f045458-b81c-48a3-8459-bf5abf7c6b6b",
    # /sport/football/teams/wales-u21
    "01eeebbe-0ac6-4110-9ea8-97053be307c6",
    # /sport/football/teams/wales-women
    "ce446353-4f7a-4229-8768-fd041af9c352",
    # /sport/football/teams/walsall
    "49c1d28f-157a-0940-b73d-29854cdcf810",
    # /sport/football/teams/watford
    "7d1d29cb-dab4-a24f-8600-393be1f354fe",
    # /sport/football/teams/wealdstone
    "695fc803-4c88-4208-a1f2-d5e14897ab44",
    # /sport/football/teams/welling-united
    "0c2fa95a-c5ee-4439-acc7-cb04d996ae89",
    # /sport/football/teams/werder-bremen
    "f3e8f72a-99b1-40a8-a9d6-9e5fbf7c6cfb",
    # /sport/football/teams/west-bromwich-albion
    "7f6edf4a-76f6-4b49-b16b-ff1e232eeb18",
    # /sport/football/teams/west-ham-united
    "1fa3a0d0-1a1d-b24a-84a0-ae4607f2123a",
    # /sport/football/teams/west-ham-united-ladies
    "95f1ce88-80d8-4bdd-b95c-23f60f6b5918",
    # /sport/football/teams/weymouth
    "87b52975-3bc1-43ad-bc64-682e6e434db9",
    # /sport/football/teams/wigan-athletic
    "6db79414-364f-e948-b3cb-5dcf987f799e",
    # /sport/football/teams/woking
    "e37fec1a-e644-4b9a-b4a0-ff7b3acfad56",
    # /sport/football/teams/wolfsburg
    "6abc4a67-af36-4abb-8ec2-669e3575e547",
    # /sport/football/teams/wolverhampton-wanderers
    "b68a1520-32bc-eb42-8dc0-ccc1018e8e8f",
    # /sport/football/teams/wrexham
    "8545dbc3-560f-fd49-8ebe-f0e325253ae9",
    # /sport/football/teams/wycombe-wanderers
    "fe9a73c6-da9e-c247-934e-6b3bbfc8d93d",
    # /sport/football/teams/yemen
    "c27c0133-1c67-4c26-88ab-4b2a3f0cc710",
    # /sport/football/teams/yeovil-town
    "b74aa261-04cb-8845-abf6-bf5648d2ed31",
    # /sport/football/teams/yeovil-town-ladies
    "0b2f0c46-a999-4c12-b0fa-06bb9dfba028",
    # /sport/football/teams/york-city
    "a4dae0b6-d383-1145-83bf-b2c36f3531bb",
    # /sport/football/teams/zambia
    "5c536b5a-c76f-4b77-85b1-9cf8605506b6",
    # /sport/football/teams/zenit-st-petersburg
    "dcae0b28-316c-4dfb-a6a9-cb8f5e49f9fd",
    # /sport/football/teams/zimbabwe
    "1314bba1-65ee-4f2d-8503-23aa45b4b5ad",
    # /sport/rugby-league/teams/castleford
    "663de257-779e-4869-bd68-6c469a984469",
    # /sport/rugby-league/teams/catalans
    "333aa62f-9b65-4bf2-9556-3ae78123c80e",
    # /sport/rugby-league/teams/huddersfield
    "6de13fc0-2217-44f3-b4be-f4727008d7ab",
    # /sport/rugby-league/teams/hull
    "09753e7d-8037-4826-ae66-f3969d0ccb1e",
    # /sport/rugby-league/teams/hull-kr
    "c1416640-7401-4021-8304-34442d9c423a",
    # /sport/rugby-league/teams/leeds
    "0159dce8-645a-4fa3-b73d-f274e808509c",
    # /sport/rugby-league/teams/london-broncos
    "3085a7af-7e24-4c59-aa12-8d8680e60254",
    # /sport/rugby-league/teams/salford
    "0c9641bb-47b3-4e12-83eb-08a9556e0a0c",
    # /sport/rugby-league/teams/st-helens
    "684ea433-99a9-44a0-a2d3-4b5bd1e47114",
    # /sport/rugby-league/teams/wakefield
    "34dcb1f1-59d8-4555-b55d-d1218d113e2d",
    # /sport/rugby-league/teams/warrington
    "7d6a100b-69fc-4702-a53f-ec4312102f65",
    # /sport/rugby-league/teams/widnes
    "a8dbc02d-8119-4541-baf6-0d14cd1ffe41",
    # /sport/rugby-league/teams/wigan
    "71843b1d-acf2-48d2-b7a6-3f72bf4d7ce5",
    # /sport/rugby-union/teams/bath
    "56404727-1f35-46b9-a42b-1408713eb816",
    # /sport/rugby-union/teams/bristol
    "4ee2d754-3f34-43d0-8163-f64e694a565d",
    # /sport/rugby-union/teams/cardiff-blues
    "20ff4730-bad5-46e1-8b06-c20b5b16ff01",
    # /sport/rugby-union/teams/connacht
    "3fd9ec42-fa70-4902-818e-b7574c4cfc60",
    # /sport/rugby-union/teams/edinburgh
    "911c44e6-35cf-4451-8323-678c5a679d1d",
    # /sport/rugby-union/teams/exeter
    "f47d3ef3-b487-48bc-940a-45291d4eb27c",
    # /sport/rugby-union/teams/glasgow
    "64bcbbd3-6c7c-4ee9-87a4-b077bde97dc3",
    # /sport/rugby-union/teams/gloucester
    "b04d768b-f13c-4b50-9098-dc9e3339f887",
    # /sport/rugby-union/teams/harlequins
    "64b44a9a-07f6-4a27-892f-49f74610e7de",
    # /sport/rugby-union/teams/leicester
    "6d6ddae0-12eb-4c7c-a76f-e6a8a3d2025f",
    # /sport/rugby-union/teams/leinster
    "fbc174b2-1fdc-4905-8aa2-536036519848",
    # /sport/rugby-union/teams/london-irish
    "ea45cb53-75a4-4bb7-b9c1-a4eb1a51a2ed",
    # /sport/rugby-union/teams/munster
    "9f2b27b0-641f-4d9a-a400-b9db34e9cdea",
    # /sport/rugby-union/teams/newcastle
    "1345a472-97c2-4f43-8d83-36261ccab1f8",
    # /sport/rugby-union/teams/ng-dragons
    "08449ec0-069c-45ff-a3ac-0c3efccd4ec3",
    # /sport/rugby-union/teams/northampton
    "d4e94988-a6c9-4288-ba18-b82bbf578fc6",
    # /sport/rugby-union/teams/ospreys
    "f475527c-74ba-4005-aee2-c529ab8300b4",
    # /sport/rugby-union/teams/sale
    "246b8eb1-e7a7-4f6d-b9f2-7cfdeb9c8240",
    # /sport/rugby-union/teams/saracens
    "ddd04cdd-783a-411a-b936-1b0e9cde47f8",
    # /sport/rugby-union/teams/scarlets
    "1869157e-8fbc-4689-b2b6-ebc6b2900d5a",
    # /sport/rugby-union/teams/ulster
    "370949ac-c7ce-4d18-b40a-5d89acd88433",
    # /sport/rugby-union/teams/wasps
    "844e6991-c5a1-4efc-98f6-5a307077f45d",
    # /sport/rugby-union/teams/worcester
    "f9bcd500-e383-408f-9177-6d8468d6ae35"
  ]

  def call(rest, struct) do
    if struct.request.path_params["discipline"] in @fabl_feeds do
      struct =
        struct
        |> Struct.add(:private, %{
          platform: Fabl,
          origin: Application.get_env(:belfrage, :fabl_endpoint)
        })
        |> Struct.add(:request, %{
          path: "/fd/rss",
          path_params: %{
            "name" => "rss"
          },
          query_params: %{
            "guid" => struct.request.path_params["discipline"]
          },
          raw_headers: %{
            "ctx-unwrapped" => "1"
          }
        })

      then_do(["CircuitBreaker"], struct)
    else
      then_do(rest, struct)
    end
  end
end
