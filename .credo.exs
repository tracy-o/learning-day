%{
  configs: [
    %{
      name: "default",
      requires: ["credo/checks/**/*.ex"],
      files: %{
        included: ["lib", "test"],
        excluded: []
      },
      checks: [
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Checks.CustomCheckExample, []},
        {Credo.Checks.PreflightPlatforms, files: %{included: ["lib/belfrage/preflight_transformers/**/*.ex"]}}
      ]
    }
  ]
}
