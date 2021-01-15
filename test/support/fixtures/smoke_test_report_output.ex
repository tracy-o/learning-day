defmodule Fixtures.SmokeTestReportOutput do
  def with_failures do
    %{
      colors: [enabled: false],
      excluded_counter: 0,
      failed_tests: [
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
          name: :"test SportHomePage /sport against test bruce-belfrage /sport",
          state:
            {:failed,
             [
               {:error,
                %ExUnit.AssertionError{
                  args: :ex_unit_no_meaningful_value,
                  expr:
                    {:assert, [],
                     [
                       {:==, [],
                        [
                          {{:., [], [{:response, [], nil}, :status_code]}, [], []},
                          {:expected_status_code, [], nil}
                        ]}
                     ]},
                  left: 404,
                  message: "Assertion with == failed",
                  right: 200
                },
                [
                  {Support.Smoke.Assertions, :assert_basic_response, 2,
                   [file: 'test/support/smoke/assertions.ex', line: 30]},
                  {Support.Smoke.Assertions, :assert_smoke_response, 4,
                   [file: 'test/support/smoke/assertions.ex', line: 13]},
                  {:"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
                   :"test SportHomePage /sport against test bruce-belfrage /sport", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
            describe: "SportHomePage /sport against test bruce-belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
            platform: Webcore,
            registered: %{},
            route: "/sport",
            spec: "SportHomePage",
            stack: "bruce-belfrage",
            test: :"test SportHomePage /sport against test bruce-belfrage /sport",
            test_type: :test
          },
          time: 340_896
        },
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
          name: :"test SportHomePage /sport against test cedric-belfrage /sport",
          state:
            {:failed,
             [
               {:error,
                %ExUnit.AssertionError{
                  args: :ex_unit_no_meaningful_value,
                  expr:
                    {:assert, [],
                     [
                       {:==, [],
                        [
                          {{:., [], [{:response, [], nil}, :status_code]}, [], []},
                          {:expected_status_code, [], nil}
                        ]}
                     ]},
                  left: 404,
                  message: "Assertion with == failed",
                  right: 200
                },
                [
                  {Support.Smoke.Assertions, :assert_basic_response, 2,
                   [file: 'test/support/smoke/assertions.ex', line: 30]},
                  {Support.Smoke.Assertions, :assert_smoke_response, 4,
                   [file: 'test/support/smoke/assertions.ex', line: 13]},
                  {:"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
                   :"test SportHomePage /sport against test cedric-belfrage /sport", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
            describe: "SportHomePage /sport against test cedric-belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
            platform: Webcore,
            registered: %{},
            route: "/sport",
            spec: "SportHomePage",
            stack: "cedric-belfrage",
            test: :"test SportHomePage /sport against test cedric-belfrage /sport",
            test_type: :test
          },
          time: 343_589
        },
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
          name: :"test SportHomePage /sport against test belfrage /sport",
          state:
            {:failed,
             [
               {:error,
                %ExUnit.AssertionError{
                  args: :ex_unit_no_meaningful_value,
                  expr:
                    {:assert, [],
                     [
                       {:==, [],
                        [
                          {{:., [], [{:response, [], nil}, :status_code]}, [], []},
                          {:expected_status_code, [], nil}
                        ]}
                     ]},
                  left: 404,
                  message: "Assertion with == failed",
                  right: 200
                },
                [
                  {Support.Smoke.Assertions, :assert_basic_response, 2,
                   [file: 'test/support/smoke/assertions.ex', line: 30]},
                  {Support.Smoke.Assertions, :assert_smoke_response, 4,
                   [file: 'test/support/smoke/assertions.ex', line: 13]},
                  {:"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
                   :"test SportHomePage /sport against test belfrage /sport", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
            describe: "SportHomePage /sport against test belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.SportHomePage.14cda76cea8443e89dd9c2be6cd73793",
            platform: Webcore,
            registered: %{},
            route: "/sport",
            spec: "SportHomePage",
            stack: "belfrage",
            test: :"test SportHomePage /sport against test belfrage /sport",
            test_type: :test
          },
          time: 482_501
        }
      ],
      failure_counter: 3,
      fallback_count: 0,
      invalid_counter: 0,
      seed: 231_504,
      skipped_counter: 0,
      slowest: 0,
      test_counter: %{test: 6},
      test_timings: [],
      trace: false,
      width: 80
    }
  end
end
