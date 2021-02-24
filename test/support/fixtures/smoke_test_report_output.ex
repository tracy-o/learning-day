defmodule Fixtures.SmokeTestReportOutput do
  def with_failures do
    %{
      colors: [enabled: false],
      excluded_counter: 0,
      failed_tests: [
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
          name: :"test ScotlandHomePage /scotland against test bruce-belfrage /scotland",
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
                  {:"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
                   :"test ScotlandHomePage /scotland against test bruce-belfrage /scotland", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
            describe: "ScotlandHomePage /scotland against test bruce-belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
            platform: Webcore,
            registered: %{},
            route: "/scotland",
            spec: "ScotlandHomePage",
            stack: "bruce-belfrage",
            test: :"test ScotlandHomePage /scotland against test bruce-belfrage /scotland",
            test_type: :test
          },
          time: 340_896
        },
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
          name: :"test ScotlandHomePage /scotland against test cedric-belfrage /scotland",
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
                  {:"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
                   :"test ScotlandHomePage /scotland against test cedric-belfrage /scotland", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
            describe: "ScotlandHomePage /scotland against test cedric-belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
            platform: Webcore,
            registered: %{},
            route: "/scotland",
            spec: "ScotlandHomePage",
            stack: "cedric-belfrage",
            test: :"test ScotlandHomePage /scotland against test cedric-belfrage /scotland",
            test_type: :test
          },
          time: 343_589
        },
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
          name: :"test ScotlandHomePage /scotland against test belfrage /scotland",
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
                  {:"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
                   :"test ScotlandHomePage /scotland against test belfrage /scotland", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
            describe: "ScotlandHomePage /scotland against test belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.ScotlandHomePage.14cda76cea8443e89dd9c2be6cd73793",
            platform: Webcore,
            registered: %{},
            route: "/scotland",
            spec: "ScotlandHomePage",
            stack: "belfrage",
            test: :"test ScotlandHomePage /scotland against test belfrage /scotland",
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

  def with_exceptions do
    %{
      colors: [enabled: false],
      excluded_counter: 0,
      failed_tests: [
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.Schoolreport.3d13829a85304d2db66bd513bec88a9f",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.Schoolreport.3d13829a85304d2db66bd513bec88a9f",
          name: :"test Schoolreport /schoolreport/*_any against test bruce-belfrage /schoolreport",
          state:
            {:failed,
             [
               {:error, %MachineGun.Error{reason: :econnrefused},
                [
                  {MachineGun, :request!, 5, [file: 'lib/machine_gun.ex', line: 79]},
                  {:"Elixir.Belfrage.SmokeTest.Schoolreport.3d13829a85304d2db66bd513bec88a9f",
                   :"test Schoolreport /schoolreport/*_any against test bruce-belfrage /schoolreport", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.Schoolreport.3d13829a85304d2db66bd513bec88a9f",
            describe: "Schoolreport /schoolreport/*_any against test bruce-belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.Schoolreport.3d13829a85304d2db66bd513bec88a9f",
            platform: MozartNews,
            registered: %{},
            route: "/schoolreport/*_any",
            spec: "Schoolreport",
            stack: "bruce-belfrage",
            test: :"test Schoolreport /schoolreport/*_any against test bruce-belfrage /schoolreport",
            test_type: :test
          },
          time: 1671
        },
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.Weather.e95067fd147240e8a4e5bfbca66724f5",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.Weather.e95067fd147240e8a4e5bfbca66724f5",
          name: :"test Weather /weather/*_any against test bruce-belfrage /weather",
          state:
            {:failed,
             [
               {:error, %{reason: :everything_breaks},
                [
                  {FooBar, :request!, 5, [file: 'lib/foo_bar.ex', line: 79]},
                  {:"Elixir.Belfrage.SmokeTest.Weather.e95067fd147240e8a4e5bfbca66724f5",
                   :"test Weather /weather/*_any against test bruce-belfrage /weather", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.Weather.e95067fd147240e8a4e5bfbca66724f5",
            describe: "Weather /weather/*_any against test bruce-belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.Weather.e95067fd147240e8a4e5bfbca66724f5",
            platform: MozartWeather,
            registered: %{},
            route: "/weather/*_any",
            spec: "Weather",
            stack: "bruce-belfrage",
            test: :"test Weather /weather/*_any against test bruce-belfrage /weather",
            test_type: :test
          },
          time: 56425
        }
      ],
      failure_counter: 2,
      fallback_count: 0,
      invalid_counter: 0,
      seed: 261_252,
      skipped_counter: 0,
      slowest: 0,
      test_counter: %{test: 2},
      test_timings: [],
      trace: false,
      width: 80
    }
  end

  def with_ex_unit_no_meaningful_value do
    %{
      colors: [enabled: false],
      excluded_counter: 0,
      failed_tests: [
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.99ac5ee3baf34556a2b693425144859e",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.99ac5ee3baf34556a2b693425144859e",
          name: :"test WorldServiceTajik /tajik/*_any against test bruce-belfrage /tajik",
          state:
            {:failed,
             [
               {:error,
                %ExUnit.AssertionError{
                  args: :ex_unit_no_meaningful_value,
                  expr: :ex_unit_no_meaningful_value,
                  left: :ex_unit_no_meaningful_value,
                  message: "Expected `location` response header to be set for world service redirect.",
                  right: :ex_unit_no_meaningful_value
                },
                [
                  {Support.Smoke.Assertions, :assert_world_service_redirect, 1,
                   [file: 'test/support/smoke/assertions.ex', line: 37]},
                  {Support.Smoke.Assertions, :assert_smoke_response, 4,
                   [file: 'test/support/smoke/assertions.ex', line: 11]},
                  {:"Elixir.Belfrage.SmokeTest.WorldServiceTajik.99ac5ee3baf34556a2b693425144859e",
                   :"test WorldServiceTajik /tajik/*_any against test bruce-belfrage /tajik", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.99ac5ee3baf34556a2b693425144859e",
            describe: "WorldServiceTajik /tajik/*_any against test bruce-belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.99ac5ee3baf34556a2b693425144859e",
            platform: MozartNews,
            registered: %{},
            route: "/tajik/*_any",
            spec: "WorldServiceTajik",
            stack: "bruce-belfrage",
            test: :"test WorldServiceTajik /tajik/*_any against test bruce-belfrage /tajik",
            test_type: :test
          },
          time: 715_236
        },
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.ede12313852b4b5f8191f619a4a824d5",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.ede12313852b4b5f8191f619a4a824d5",
          name: :"test WorldServiceTajik /tajik.json against test bruce-belfrage /tajik.json",
          state:
            {:failed,
             [
               {:error,
                %ExUnit.AssertionError{
                  args: :ex_unit_no_meaningful_value,
                  expr: :ex_unit_no_meaningful_value,
                  left: :ex_unit_no_meaningful_value,
                  message: "Expected `location` response header to be set for world service redirect.",
                  right: :ex_unit_no_meaningful_value
                },
                [
                  {Support.Smoke.Assertions, :assert_world_service_redirect, 1,
                   [file: 'test/support/smoke/assertions.ex', line: 37]},
                  {Support.Smoke.Assertions, :assert_smoke_response, 4,
                   [file: 'test/support/smoke/assertions.ex', line: 11]},
                  {:"Elixir.Belfrage.SmokeTest.WorldServiceTajik.ede12313852b4b5f8191f619a4a824d5",
                   :"test WorldServiceTajik /tajik.json against test bruce-belfrage /tajik.json", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.ede12313852b4b5f8191f619a4a824d5",
            describe: "WorldServiceTajik /tajik.json against test bruce-belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.ede12313852b4b5f8191f619a4a824d5",
            platform: MozartNews,
            registered: %{},
            route: "/tajik.json",
            spec: "WorldServiceTajik",
            stack: "bruce-belfrage",
            test: :"test WorldServiceTajik /tajik.json against test bruce-belfrage /tajik.json",
            test_type: :test
          },
          time: 345_272
        },
        %ExUnit.Test{
          case: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.914278952621405f970ab754458796b3",
          logs: "",
          module: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.914278952621405f970ab754458796b3",
          name: :"test WorldServiceTajik /tajik.amp against test bruce-belfrage /tajik.amp",
          state:
            {:failed,
             [
               {:error,
                %ExUnit.AssertionError{
                  args: :ex_unit_no_meaningful_value,
                  expr: :ex_unit_no_meaningful_value,
                  left: :ex_unit_no_meaningful_value,
                  message: "Expected `location` response header to be set for world service redirect.",
                  right: :ex_unit_no_meaningful_value
                },
                [
                  {Support.Smoke.Assertions, :assert_world_service_redirect, 1,
                   [file: 'test/support/smoke/assertions.ex', line: 37]},
                  {Support.Smoke.Assertions, :assert_smoke_response, 4,
                   [file: 'test/support/smoke/assertions.ex', line: 11]},
                  {:"Elixir.Belfrage.SmokeTest.WorldServiceTajik.914278952621405f970ab754458796b3",
                   :"test WorldServiceTajik /tajik.amp against test bruce-belfrage /tajik.amp", 1,
                   [file: 'test/smoke/smoke_test.ex', line: 25]}
                ]}
             ]},
          tags: %{
            async: true,
            case: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.914278952621405f970ab754458796b3",
            describe: "WorldServiceTajik /tajik.amp against test bruce-belfrage",
            describe_line: 25,
            file: "/Users/bowerj09/belfrage/test/smoke/smoke_test.ex",
            line: 25,
            module: :"Elixir.Belfrage.SmokeTest.WorldServiceTajik.914278952621405f970ab754458796b3",
            platform: MozartNews,
            registered: %{},
            route: "/tajik.amp",
            spec: "WorldServiceTajik",
            stack: "bruce-belfrage",
            test: :"test WorldServiceTajik /tajik.amp against test bruce-belfrage /tajik.amp",
            test_type: :test
          },
          time: 266_170
        }
      ],
      failure_counter: 3,
      fallback_count: 0,
      invalid_counter: 0,
      seed: 774_314,
      skipped_counter: 0,
      slowest: 0,
      test_counter: %{test: 4},
      test_timings: [],
      trace: false,
      width: 80
    }
  end
end
