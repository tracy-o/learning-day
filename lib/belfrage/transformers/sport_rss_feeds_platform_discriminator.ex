defmodule Belfrage.Transformers.SportRssFeedsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Transformers.Transformer

  @fabl_feeds [
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
