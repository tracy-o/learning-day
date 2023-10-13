defmodule Routes.Specs.ClassicAppMundo do
  def specification do
    %{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/mundo/vert-cap-59223070?createdBy=mundo&language=es", "/content/cps/mundo/noticias-59340165?createdBy=mundo&language=es"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/mundo/vert-cap-59223070?createdBy=mundo&language=es", "/content/cps/mundo/noticias-59340165?createdBy=mundo&language=es"]

        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/mundo/vert-cap-59223070?createdBy=mundo&language=es", "/content/cps/mundo/noticias-59340165?createdBy=mundo&language=es"]
        }
      ]
    }
  end
end
