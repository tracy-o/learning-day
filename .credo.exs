%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib", "test"],
        excluded: ["test/smoke"]
      },
      checks: [
        {Credo.Check.Design.TagTODO, exit_status: 0},
        {Credo.Check.Readability.ModuleDoc, false},
        {Credo.Check.Warning.ApplicationConfigInModuleAttribute, false},

        # Not supported by Elixir 1.9.1
        {Credo.Check.Refactor.MapInto, false},
        {Credo.Check.Warning.LazyLogging, false}
      ]
    }
  ]
}
