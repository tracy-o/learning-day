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
        {Credo.Checks.CustomCheckExample, []}
      ]
    }
  ]
}
