defmodule Routes.Specs.ClassicAppNaidheachdan do
  def specification do
%{
      preflight_pipeline: ["ClassicAppsPlatformSelector"],
      specs: [
        %{
          platform: "AppsTrevor",
          examples: ["/content/cps/naidheachdan/59371990", "/content/cps/naidheachdan/front_page", "/content/cps/naidheachdan/dachaigh"]
        },
        %{
          platform: "AppsWalter",
          examples: ["/content/cps/naidheachdan/59371990", "/content/cps/naidheachdan/front_page", "/content/cps/naidheachdan/dachaigh"]
        },
        %{
          platform: "AppsPhilippa",
          examples: ["/content/cps/naidheachdan/59371990", "/content/cps/naidheachdan/front_page", "/content/cps/naidheachdan/dachaigh"]
        }
      ]
    }
  end
end
