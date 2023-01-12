defmodule BelfrageWeb.Plugs.VanityDomainRedirector do
  import Plug.Conn

  # Vanity urls
  @redirects %{
    "www.bbcafaanoromoo.com" => "https://www.bbc.com/afaanoromoo",
    "www.bbcafrique.com" => "https://www.bbc.com/afrique",
    "m.bbcafrique.com" => "https://www.bbc.com/afrique",
    "bbcafrique.com" => "https://www.bbc.com/afrique",
    "www.bbcamharic.com" => "https://www.bbc.com/amharic",
    "bbcamharic.com" => "https://www.bbc.com/amharic",
    "www.bbcarabic.com" => "https://www.bbc.com/arabic",
    "m.bbcarabic.com" => "https://www.bbc.com/arabic",
    "bbcarabic.com" => "https://www.bbc.com/arabic",
    "www.bbcazeri.com" => "https://www.bbc.com/azeri",
    "m.bbcazeri.com" => "https://www.bbc.com/azeri",
    "bbcazeri.com" => "https://www.bbc.com/azeri",
    "www.bbcbengali.com" => "https://www.bbc.com/bengali",
    "m.bbcbengali.com" => "https://www.bbc.com/bengali",
    "bbcbengali.com" => "https://www.bbc.com/bengali",
    "www.bbcburmese.com" => "https://www.bbc.com/burmese",
    "m.bbcburmese.com" => "https://www.bbc.com/burmese",
    "bbcburmese.com" => "https://www.bbc.com/burmese",
    "www.bbcgahuza.com" => "https://www.bbc.com/gahuza",
    "m.bbcgahuza.com" => "https://www.bbc.com/gahuza",
    "bbcgahuza.com" => "https://www.bbc.com/gahuza",
    "www.bbcgujarati.com" => "https://www.bbc.com/gujarati",
    "m.bbcgujarati.com" => "https://www.bbc.com/gujarati",
    "bbcgujarati.com" => "https://www.bbc.com/gujarati",
    "www.bbchausa.com" => "https://www.bbc.com/hausa",
    "m.bbchausa.com" => "https://www.bbc.com/hausa",
    "bbchausa.com" => "https://www.bbc.com/hausa",
    "www.bbchindi.com" => "https://www.bbc.com/hindi",
    "m.bbchindi.com" => "https://www.bbc.com/hindi",
    "bbchindi.com" => "https://www.bbc.com/hindi",
    "www.bbcigbo.com" => "https://www.bbc.com/igbo",
    "bbcigbo.com" => "https://www.bbc.com/igbo",
    "www.bbcindonesia.com" => "https://www.bbc.com/indonesia",
    "bbcindonesia.com" => "https://www.bbc.com/indonesia",
    "www.bbckorean.com" => "https://www.bbc.com/korean",
    "bbckorean.com" => "https://www.bbc.com/korean",
    "www.bbckyrgyz.com" => "https://www.bbc.com/kyrgyz",
    "m.bbckyrgyz.com" => "https://www.bbc.com/kyrgyz",
    "bbckyrgyz.com" => "https://www.bbc.com/kyrgyz",
    "www.bbcmarathi.com" => "https://www.bbc.com/marathi",
    "bbcmarathi.com" => "https://www.bbc.com/marathi",
    "www.bbcmundo.com" => "https://www.bbc.com/mundo",
    "m.bbcmundo.com" => "https://www.bbc.com/mundo",
    "bbcmundo.com" => "https://www.bbc.com/mundo",
    "www.bbcnepali.com" => "https://www.bbc.com/nepali",
    "m.bbcnepali.com" => "https://www.bbc.com/nepali",
    "bbcnepali.com" => "https://www.bbc.com/nepali",
    "www.bbcpashto.com" => "https://www.bbc.com/pashto",
    "m.bbcpashto.com" => "https://www.bbc.com/pashto",
    "bbcpashto.com" => "https://www.bbc.com/pashto",
    "www.bbcpersian.com" => "https://www.bbc.com/persian",
    "m.bbcpersian.com" => "https://www.bbc.com/persian",
    "bbcpersian.com" => "https://www.bbc.com/persian",
    "www.bbcpidgin.com" => "https://www.bbc.com/pidgin",
    "bbcpidgin.com" => "https://www.bbc.com/pidgin",
    "www.bbcportuguese.com" => "https://www.bbc.com/portuguese",
    "m.bbcportuguese.com" => "https://www.bbc.com/portuguese",
    "bbcportuguese.com" => "https://www.bbc.com/portuguese",
    "www.bbcbrasil.com" => "https://www.bbc.com/portuguese",
    "m.bbcbrasil.com" => "https://www.bbc.com/portuguese",
    "bbcbrasil.com" => "https://www.bbc.com/portuguese",
    "www.bbcpunjabi.com" => "https://www.bbc.com/punjabi",
    "bbcpunjabi.com" => "https://www.bbc.com/punjabi",
    "www.bbcrussian.com" => "https://www.bbc.com/russian",
    "m.bbcrussian.com" => "https://www.bbc.com/russian",
    "bbcrussian.com" => "https://www.bbc.com/russian",
    "www.bbcsinhala.com" => "https://www.bbc.com/sinhala",
    "m.bbcsinhala.com" => "https://www.bbc.com/sinhala",
    "bbcsinhala.com" => "https://www.bbc.com/sinhala",
    "www.bbcserbian.com" => "https://www.bbc.com/serbian",
    "bbcserbian.com" => "https://www.bbc.com/serbian",
    "www.bbcsomali.com" => "https://www.bbc.com/somali",
    "m.bbcsomali.com" => "https://www.bbc.com/somali",
    "bbcsomali.com" => "https://www.bbc.com/somali",
    "www.bbcswahili.com" => "https://www.bbc.com/swahili",
    "m.bbcswahili.com" => "https://www.bbc.com/swahili",
    "bbcswahili.com" => "https://www.bbc.com/swahili",
    "www.bbctajik.com" => "https://www.bbc.com/tajik",
    "bbctajik.com" => "https://www.bbc.com/tajik",
    "www.bbctamil.com" => "https://www.bbc.com/tamil",
    "m.bbctamil.com" => "https://www.bbc.com/tamil",
    "bbctamil.com" => "https://www.bbc.com/tamil",
    "www.bbctelugu.com" => "https://www.bbc.com/telugu",
    "bbctelugu.com" => "https://www.bbc.com/telugu",
    "www.bbcthai.com" => "https://www.bbc.com/thai",
    "m.bbcthai.com" => "https://www.bbc.com/thai",
    "bbcthai.com" => "https://www.bbc.com/thai",
    "www.bbctigrinya.com" => "https://www.bbc.com/tigrinya",
    "bbctigrinya.com" => "https://www.bbc.com/tigrinya",
    "www.bbcturkce.com" => "https://www.bbc.com/turkce",
    "m.bbcturkce.com" => "https://www.bbc.com/turkce",
    "bbcturkce.com" => "https://www.bbc.com/turkce",
    "www.bbcukchina.com" => "https://www.bbc.com/ukchina",
    "m.bbcukchina.com" => "https://www.bbc.com/ukchina",
    "bbcukchina.com" => "https://www.bbc.com/ukchina",
    "www.bbcukrainian.com" => "https://www.bbc.com/ukrainian",
    "m.bbcukrainian.com" => "https://www.bbc.com/ukrainian",
    "bbcukrainian.com" => "https://www.bbc.com/ukrainian",
    "www.bbcurdu.com" => "https://www.bbc.com/urdu",
    "m.bbcurdu.com" => "https://www.bbc.com/urdu",
    "bbcurdu.com" => "https://www.bbc.com/urdu",
    "www.bbcuzbek.com" => "https://www.bbc.com/uzbek",
    "m.bbcuzbek.com" => "https://www.bbc.com/uzbek",
    "bbcuzbek.com" => "https://www.bbc.com/uzbek",
    "www.bbcvietnamese.com" => "https://www.bbc.com/vietnamese",
    "m.bbcvietnamese.com" => "https://www.bbc.com/vietnamese",
    "bbcvietnamese.com" => "https://www.bbc.com/vietnamese",
    "www.bbcyoruba.com" => "https://www.bbc.com/yoruba",
    "bbcyoruba.com" => "https://www.bbc.com/yoruba",
    "www.bbczhongwen.com" => "https://www.bbc.com/zhongwen",
    "m.bbczhongwen.com" => "https://www.bbc.com/zhongwen",
    "bbczhongwen.com" => "https://www.bbc.com/zhongwen",
    "www.bbcasiapacific.com" => "https://www.bbc.com/news/world/asia",
    "m.bbcasiapacific.com" => "https://www.bbc.com/news/world/asia",
    "bbcasiapacific.com" => "https://www.bbc.com/news/world/asia",
    "www.bbcsouthasia.com" => "https://www.bbc.com/news/world/asia",
    "m.bbcsouthasia.com" => "https://www.bbc.com/news/world/asia",
    "bbcsouthasia.com" => "https://www.bbc.com/news/world/asia"
  }

  def init(opts), do: opts

  def call(conn = %{host: host}, _opts) when is_map_key(@redirects, host) do
    redirect(conn)
  end

  def call(conn, _opts) do
    conn
  end

  defp redirect(conn) do
    conn
    |> put_resp_header("location", @redirects[conn.host] <> set_location(conn))
    |> put_resp_header("via", "1.1 Belfrage")
    |> put_resp_header("server", "Belfrage")
    |> put_resp_header("x-bbc-no-scheme-rewrite", "1")
    |> put_resp_header("req-svc-chain", conn.private.bbc_headers.req_svc_chain)
    |> put_resp_header("cache-control", "public, stale-while-revalidate=10, max-age=60")
    |> put_resp_header("vary", "x-bbc-edge-scheme")
    |> send_resp(302, "")
    |> halt()
  end

  def set_location(_conn = %{request_path: nil}), do: ""
  def set_location(_conn = %{request_path: "/"}), do: ""
  def set_location(_conn = %{request_path: request_path}), do: request_path
end
