%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib", "test"],
        excluded: ["lib/belfrage_web/route_master.ex", "test/smoke"]
      },
      checks: [
        {Credo.Check.Design.TagTODO, exit_status: 0},
        {Credo.Check.Readability.ModuleDoc, false}
      ]
    }
  ]
}
