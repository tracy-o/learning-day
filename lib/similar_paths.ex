defmodule SimilarPaths do
  alias Plug.Conn

  def map_similar_routes(routes, %Conn{request_path: req_path}) do
    routes
    |> filter_routes(req_path)
    |> IO.inspect(label: "did you mean")
    |> Enum.map(fn {matcher, _args} ->
      "<a href=" <> matcher <> ">" <> matcher <> "</a>"
    end)
    |> generate_resp_page_404()
  end

  defp filter_routes(routes, path) do
    routes
    |> Enum.map(fn {matcher, args} -> {String.replace(matcher, "/*any", ""), args} end)
    |> Enum.filter(fn {matcher, args} ->
      args[:only_on] != "test" and
        !String.contains?(matcher, ":") and
        !String.equivalent?(path, matcher) and
        Levenshtein.distance(String.downcase(path), matcher) <= 3
    end)
  end

  defp generate_similar_resp(similar_routes) do
    unless Enum.empty?(similar_routes) do
      """
      <!-- Belfrage -->
      <p><b>Did you mean...</b>
      <ul class"similar">#{for route <- similar_routes, do: "<li>" <> route <> "</li>"}</ul>
      </p>
      """
    else
      ""
    end
  end

  defp generate_resp_page_404(similar_routes) do
    """
    <!DOCTYPE html>
    <html lang="en-GB">
      <head>
        <!-- VERSION: 2.4.1 -->
        <title>
      BBC - 404: Not Found
        </title>
        <meta content="text/html;charset=utf-8" http-equiv="Content-Type">
        <meta content="utf-8" http-equiv="encoding">
        <meta content="width=device-width, initial-scale=1, user-scalable=1" name="viewport">
        <meta content="IE=edge,chrome=1" http-equiv="X-UA-Compatible">
        <meta content="noindex, nofollow" name="robots">
        <meta content="width=device-width" name="viewport">
        <meta content="The best of the BBC, with the latest news and sport headlines, weather, TV &amp; radio highlights and much more from across the whole of BBC Online" name="description">
        <link href="https://www.bbc.co.uk/a-z/" rel="index" title="A to Z">
        <link href="https://www.bbc.co.uk/terms/" rel="copyright" title="Terms of Use">
        <link href="https://www.bbc.co.uk/favicon.ico" rel="icon" type="image/x-icon">
        <style media="screen">
          * {
            margin              : 0;
            padding             : 0;
            border              : 0;
            -webkit-box-sizing  : border-box;
            box-sizing          : border-box;
          }
          body,
          html {
            height              : 100%;
          }
          body {
            width               : 100%;
            height              : 100%;
            min-height          : 100vh;
            font-family         : ReithSans, Arial, Helvetica, sans-serif;
            display             : -webkit-box;
            display             : -ms-flexbox;
            display             : flex;
            -webkit-box-orient  : vertical;
            -webkit-box-direction: normal;
            -ms-flex-direction  : column;
            flex-direction      : column;
          }
          ul.similar {
            list-style-type     : none;
            background          : #4945b6;
          }
          a {
            color               : #4945b6;
            text-decoration     : none;
          }
          a:hover,
          a:focus {
            text-decoration     : underline;
          }
          .content {
            -webkit-box-flex    : 1;
            -ms-flex-positive   : 1;
            flex-grow           : 1;
            height              : 100%;
            width               : 100%;
            display             : -webkit-box;
            display             : -ms-flexbox;
            display             : flex;
          }
          .main-content {
            display             : -webkit-box;
            display             : -ms-flexbox;
            display             : flex;
            -webkit-box-align   : center;
            -ms-flex-align      : center;
            align-items         : center;
            -webkit-box-pack    : center;
            -ms-flex-pack       : center;
            justify-content     : center;
            -webkit-box-orient  : vertical;
            -webkit-box-direction: normal;
            -ms-flex-direction  : column;
            flex-direction      : column;
            margin              : 3em 0;
            width               : 100%;
            text-align          : center;
          }
          .center {
            margin              : 0 auto;
            max-width           : 976px;
              /* Same width as BBC home */
            padding             : 0 1em;
          }
          #navigation {
            height              : 100%;
          }
          #navigation>.inner {
            display             : -webkit-box;
            display             : -ms-flexbox;
            display             : flex;
            -webkit-box-orient  : horizontal;
            -webkit-box-direction: normal;
            -ms-flex-direction  : row;
            flex-direction      : row;
            -webkit-box-pack    : justify;
            -ms-flex-pack       : justify;
            justify-content     : space-between;
          }
          #navigation>.inner>.links {
            float               : right;
              /*For IE*/
            padding-top         : .25em;
              /*For IE*/
            display             : -webkit-box;
            display             : -ms-flexbox;
            display             : flex;
            -webkit-box-orient  : horizontal;
            -webkit-box-direction: normal;
            -ms-flex-direction  : row;
            flex-direction      : row;
            -webkit-box-align   : center;
            -ms-flex-align      : center;
            align-items         : center;
          }
          #navigation>.inner>.links>a {
            color               : black;
            text-decoration     : none;
            border-right        : 1px solid #ccc;
            line-height         : 2em;
            padding             : .462em 12px .308em;
            padding-bottom      : 0.308em;
            border-bottom       : .308em solid transparent;
          }
          #navigation>.inner>.links>a:first-child {
            border-left         : 1px solid #ccc;
          }
          .red:hover,
          .red:focus {
            border-bottom       : .308em solid #bb1919 !important;
          }
          .yellow:hover,
          .yellow:focus {
            border-bottom       : .308em solid #ffd230 !important;
          }
          .light-blue:hover,
          .light-blue:focus {
            border-bottom       : .308em solid #8ce !important;
          }
          .dark-blue:hover,
          .dark-blue:focus {
            border-bottom       : .308em solid #007bc7 !important;
          }
          .pink:hover,
          .pink:focus {
            border-bottom       : .308em solid #f54997 !important;
          }
          .black:hover,
          .black:focus {
            border-bottom       : .308em solid #000 !important;
          }
          .orange:hover,
          .orange:focus {
            border-bottom       : .308em solid #ff4900 !important;
          }
          #navigation>.inner>.logo>a>img {
            height              : 24.5px;
          }
          #navigation>.inner>.logo {
            width               : 6em;
            float               : left;
            display             : -webkit-box;
            display             : -ms-flexbox;
            display             : flex;
            -webkit-box-orient  : horizontal;
            -webkit-box-direction: normal;
            -ms-flex-direction  : row;
            flex-direction      : row;
            -webkit-box-align   : center;
            -ms-flex-align      : center;
            align-items         : center;
            padding             : .308em 1em 0 0;
          }
          .header {
            -ms-flex-negative   : 0;
            flex-shrink         : 0
          }
          .nav {
            width               : 100%;
            min-height          : 40px;
            background          : #fff;
            font-size           : 0.80em;
            font-weight         : 700;
          }
          .sub-navigation {
            background          : #4945b6;
            width               : 100%;
          }
          .sub-navigation>.inner {
            padding             : 2.5em 1em;
          }
          .sub-navigation>.inner>.title {
            font-size           : 1.5em;
            color               : #fff;
            font-weight         : 400;
          }
          h1 {
            color               : #333;
            font-size           : 1.2em;
            padding             : .5em;
          }
          .main>.text {
            font-size           : .9em;
            padding             : 0 1em 1em 1em;
            max-width           : 500px;
          }
          .text>p {
            padding             : 0 0 1em 0;
            line-height         : 1.5em;
            color               : #464646;
            position            : relative;
            text-align          : center;
          }
          /* Search */
          .search-container {
            background          : #e4e4e4;
            display             : -webkit-box;
            display             : -ms-flexbox;
            display             : flex;
            height              : 36px;
            -webkit-box-pack    : justify;
            -ms-flex-pack       : justify;
            justify-content     : space-between;
            -webkit-box-align   : center;
            -ms-flex-align      : center;
            align-items         : center;
            margin              : 0 1em 10px 1em;
          }
          input[type=text] {
            height              : 100%;
            padding             : 6px 7px;
            font-size           : 18px;
            border              : none;
            background          : #e4e4e4;
            color               : #333;
            width               : 86%;
          }
          .search-container button {
            height              : 36px;
            width               : 36px;
            background          : #e4e4e4;
            border              : none;
            cursor              : pointer;
            position            : relative;
            -webkit-appearance  : button;
            display             : -webkit-box;
            display             : -ms-flexbox;
            display             : flex;
            -webkit-box-pack    : center;
            -ms-flex-pack       : center;
            justify-content     : center;
            -webkit-box-align   : center;
            -ms-flex-align      : center;
            align-items         : center;
          }
          button span.search-icon {
            background          : url("data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAAAXNSR0IArs4c6QAAAkRJREFUWAntlr9rFEEUx3Nimmh1gYAIMoWSIoSARBBUThs7baws8zeYKqmCYGUn+E+IImiKBOHWSrAQImKhoCOExMZCU4iFxs/3LnvOPWbvZn9wlQ8+7LyZ977zZm/37bWmxts8ITfgOjg4BbJ9+Axb8Aw+QqO2jJrEDxNREYtQ246j8ABSNw7jfpN3D1pQydpkZRCKVhk/QWMGStk00RnENnzO/Aqcg5NHaKw5rcVy9JMcg2R7SKQVesvchQQFxSjW5t9PyO2FXIwkbzJ3IlXgKFY5YRF6Js6naHRNok5TZvN8D+XsGK0sXyy6LpkEnSDlthfp6cR/jKZ6SaGtsxLeNj1Ude0pAqHmRpGgnlJ1uNAeh07F8SOTp2es0L6wElar16uunUEg1NwbJfjLBOs9r2vqKeFz8LNIsFSjKBKJzEu3FcyH42C636m+Ds38+9qZ6VLuaRP9zfgDV5X6gdcfXDZ+FfeqSXpv/IGrArYHXn9wy/hV3Nsm6ZXxh9ymG1EH9fAN0HhhaMeI0zVJVVvxLDqfjNbI0+e1FH2MyrySc4hpM3v6K/km466xz/E7ki6NS2T9JtiGpkK+g4MkU/PIwJ5A/ku4AyrmLKhbdmAN3kAsJ5/zrDtIsjZRGeTJTV09mg6SrM6fUhX8A2KFe+YdJNsykWX+lr8m/ho48NBIEehMzcMqqGF9gAPQx2UXXsBdUC8JzeF4aKwItEqbI8PD/yJG3YmMOzQRc+ziIfw55DuYmDl28qAidHUwcXPsmIGuPfsL/C8pDob3tKcAAAAASUVORK5CYII=") no-repeat;
            width               : 20px;
            height              : 20px;
            background-size     : 20px 20px;
          }
          /* Footer */
          .footer {
            background          : #4c4c4c;
            color               : #fff;
            font-size           : 12px;
            padding             : 1.5em 0;
            position            : relative;
            -ms-flex-negative   : 0;
            flex-shrink         : 0;
          }
          .footer-content>p>a {
            color               : #fff;
            font-weight         : 700;
          }
          .footer>.inner>.link-bar {
            margin              : 0 0 23px 0;
          }
          .footer>.inner>div>.links {
            list-style          : none;
            height              : 100%;
          }
          .footer>.inner>div>.links>li {
            text-decoration     : none;
            font-size           : 12px;
            display             : inline;
            margin              : 10px 19px 0 0;
          }
          .footer>.inner>div>.links>li:last-child {
            margin-right        : 0;
          }
          .footer>.inner>div>.links>li>a {
            color               : #fff;
            display             : inline-block;
          }
          @media only screen and (max-width: 750px) {
            .footer-content {
              padding-top         : 0;
            }
            .footer>.inner>div>.links {
              display             : inherit;
              padding-left        : 0;
            }
            .footer>.inner>div>.links>li {
              display             : inline-block;
            }
          }
          @media only screen and (max-width: 490px) {
            #navigation>.inner>.links>a:nth-of-type(6) {
              display             : none;
            }
          }
          @media only screen and (max-width: 420px) {
            .sub-navigation>.inner {
              padding             : 2em 1em;
            }
            .sub-navigation>.inner>.title {
              font-size           : 1.2em;
            }
            #navigation>.inner>.links>a:nth-of-type(5) {
              display             : none;
            }
          }
          @media only screen and (max-width: 360px) {
            #navigation>.inner>.links>a:nth-of-type(4) {
              display             : none;
            }
          }
          @media only screen and (max-width: 280px) {
            #navigation>.inner>.links>a:nth-of-type(3) {
              display             : none;
            }
          }
          @media only screen and (max-width: 210px) {
            #navigation>.inner>.links>a:nth-of-type(2) {
              display             : none;
            }
          }
          @media only screen and (max-height: 650px) {
            .content {
              display             : block;
            }
          }
          /* Font */
          @font-face {
            font-family
            :

            "ReithSans"
            ;


            src
            :

            url("https://gel.files.bbci.co.uk/r2.302/BBCReithSans_W_Rg.woff2")

            format("woff2")
            ,

            url("https://gel.files.bbci.co.uk/r2.302/BBCReithSans_W_Rg.woff")

            format("woff")
            ;


            font-display
            :

            swap
          }
          @font-face {
            font-family
            :

            "ReithSans"
            ;


            src
            :

            url("https://gel.files.bbci.co.uk/r2.302/BBCReithSans_W_Bd.woff2")

            format("woff2")
            ,

            url("https://gel.files.bbci.co.uk/r2.302/BBCReithSans_W_Bd.woff")

            format("woff")
            ;


            font-display
            :

            swap
            ;


            font-weight
            :

            700
          }
        </style>
      </head>
      <body>
        <div class="header">
          <div class="nav">
            <div id="navigation">
              <div class="center inner">
                <div class="logo">
                  <a href="https://www.bbc.co.uk/" tabindex="1">
                    <img alt="BBC Logo" src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOAAAABACAYAAAADMXsPAAAACXBIWXMAAAsSAAALEgHS3X78AAAEzElEQVR4nO2d4W3bMBCF74r+rzeoN0g6QdwJ6k4Qd4Jmg3iEdII6E9SdIPYEtSdovEEywRUMzo0RWKQsUuLRfB9ApIAChXrVk8i7I8VEJFQxIsIxV8/M0C+C2vV7Z6APAFQLDAhARmBAADICAwKQERgQgIzAgABkBAYEICMwIAAZgQEByAgMCEBGYEAAMgIDApCR9xAfVM6WiJ7eSDAmoo9DyJLSgPdEtIg8x6W2yVACGAL69c8zES2JaOWaiDz6/iIzH+o5JaIPffRQErW5iFCqphe+SNi/oy22v9DPjH6+5gw3S9DXqZ4rWd/MzgFFZCMiMyL6REQ7A10qCuj3grvuryIyEZHY0YXTdOnORUQ/0nSvgCCMu5H0ab410J3iqFi/3+66nWl6OPfbOWNnioiCioi74JmBrhRJhfrdi8hUr9s0g0RBmXmskaUmNiGx3JOcmd2r/7tlQfsA+p3EvQ69i2CoNIQT5Nb3C8y81UCEb8iwqNGA0K8167bmY+aRRjcnOkR3XOnPtf7caFv2+TbtPYrnjp1wnmkgEvV0plE86BfX3HWNWvy9kep5qg7uwTbp8P/hbRbngHeB45uB+lEqteo3D72lNK+30dHEqTm9L0T0wMyrgzdmNBYrYZBAjqNG/XYi4n3wqPlWCZLpVy1+pzUl1oKODPShZM5RP2+OT+d7KcyXHIsGfG46oEJeDNud4qhRv1CSfW7RfGTUgD4xpwP2o1Rq02/rq+nUh47ZyK81A271adWE7xioU79QUMn0Q8dCEGZ3kGtpfHoz8wIBmqPUrl/IgJOB+tGZ3vNYkXmiUZ9V/SXkAaGft00C50+6eiF1M70gV0PHS7z5ugH9XkiaNkiN6TSEVvJPdbEqgH5nRxHLkbS+77MvxA6gX4kUk4gXkZVOqHETdQD62WSo5UizwHq0R20bXzW/Lqlx5/nVT09tAv2iWFueBw4VhBkHRPh/jJl3WtF/NLzsbjBmNi1qD0C/ZvY1nk08Wr5Wi0NQF7FbaQSviej9Pc6Y2vTzLVSmgDmzY3UO6Or2bjzH+9jn45yoSb9Qot30tVoOwjQKW8JeHwaoRb8Lrfc8il6r2TSMZQOGksfrwPHaqUm/UL3njdXor2UDhm6QZKuSz5Sa9PMNt/dvQZNF2ZYNGJo8m1zfZYia9HPDUO9cUPOgKYoRdjVszOvWeDUunWFmrAv0U6N+ob1w9iYcd5wTuo1+v4nIOGVgx1oxtlvPdtdiG3EY8Dg16+fegnPfg4deh6MzZr5RHSZqyv1uAc8HS5xW+u9VX4GroQy4aDEkCm4uS68V/tfpulYE0K8dt8zsrQbao1otcudEBzGgbhng/RRUGzTcXF0SHvqdxMLNB5sqgaxRTDH2wc5W2JSpAxXp54JLf7Tm1TxFGFAjXDBfRyrV7yczL/W7GqlJdk7TBnQ3ju5l8gDznQ70e9nN+q/TIIUR3VtVd8b+maZ7BqKgOjQ6TArvo1L4zHILoF8rXNDpWj9gs/9EdTBopSOHy4OPuCTPnbJuMlMtIsJRAjJDvwgM6HesYuhyqEIFGBAGjAL6xVHityEAOBtgQAAyAgMCkBEYEICMwIAAZAQGBCAjMCAAGYEBAcgIDAhARmBAADICAwKQERgQgFwQ0T+zWRe0kl6iUwAAAABJRU5ErkJggg==">
                  </a>
                </div>
                <div class="links">
                  <a class="dark-blue" href="https://www.bbc.co.uk" tabindex="2">
                    Home
                  </a>
                  <a class="red" href="https://www.bbc.co.uk/news" tabindex="3">
                    News
                  </a>
                  <a class="yellow" href="https://www.bbc.co.uk/sport" tabindex="4">
                    Sport
                  </a>
                  <a class="light-blue" href="https://www.bbc.co.uk/weather" tabindex="5">
                    Weather
                  </a>
                  <a class="pink" href="https://www.bbc.co.uk/iplayer" tabindex="6">
                    iPlayer
                  </a>
                  <a class="orange" href="https://www.bbc.co.uk/sounds" tabindex="7">
                    Sounds
                  </a>
                </div>
              </div>
            </div>
            <div class="sub-navigation">
              <div class="center inner">
                <p class="title">
                  404
                  <strong>
                    Not Found
                  </strong>
                </p>
              </div>
            </div>
          </div>
        </div>
        <!-- Content -->
        <div class="content">
          <div class="main-content">
            <img alt="Two Clangers stare curiously back at the user" src="data:image/gif;base64,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">
            <h1>
        Sorry, we couldn&rsquo;t find that page
            </h1>
            <div class="text">
              <p>
                Check the page address or search for it below.
              </p>
              <form action="https://search.bbc.co.uk/search" class="search-container">
                <input autocapitalize="off" autocomplete="off" autocorrect="off" name="q" placeholder="Search" spellcheck="false" tabindex="8" type="text">
                <button tabindex="9" type="submit">
                  <span class="search-icon">
                  </span>
                </button>
              </form>
              <p>
                <a href="https://www.bbc.co.uk/" tabindex="10">
                  BBC Homepage
                </a>
              </p>
              #{generate_similar_resp(similar_routes)}
            </div>
          </div>
        </div>
        <div class="footer" id="foot">
          <div class="center inner">
            <div class="link-bar">
              <ul class="links">
                <li>
                  <a href="https://www.bbc.co.uk/usingthebbc/terms" tabindex="11">
                    Terms Of Use
                  </a>
                </li>
                <li>
                  <a href="https://www.bbc.co.uk/aboutthebbc" tabindex="12">
                    About the BBC
                  </a>
                </li>
                <li>
                  <a href="https://www.bbc.co.uk/usingthebbc/privacy" tabindex="13">
                    Privacy Policy
                  </a>
                </li>
                <li>
                  <a href="https://www.bbc.co.uk/usingthebbc/cookies" tabindex="14">
                    Cookies
                  </a>
                </li>
                <li>
                  <a href="https://www.bbc.co.uk/accessibility" tabindex="15">
                    Accessibility Help
                  </a>
                </li>
                <li>
                  <a href="https://www.bbc.co.uk/guidance" tabindex="16">
                    Parental Guidance
                  </a>
                </li>
                <li>
                  <a href="https://www.bbc.co.uk/contact" tabindex="17">
                    Contact the BBC
                  </a>
                </li>
                <li>
                  <a href="https://www.bbc.co.uk/bbcnewsletter" tabindex="18">
                    Get Personalised Newsletters
                  </a>
                </li>
              </ul>
            </div>
            <div>
              <div class="footer-content">
                <p>
                  <strong>
                    Copyright &copy; BBC.
                  </strong>
                  The BBC is not responsible for the content of external sites.
                  <a href="https://www.bbc.co.uk/help/web/links/" tabindex="19">
                    Read about our approach to external
                    linking.
                  </a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </body>
    </html>
    """
  end
end
