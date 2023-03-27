Mix.install([
  {:nimble_parsec, "~> 1.1"}
])

#
# defmodule RRuleParser do
#   import NimbleParsec
#
#   # Define parsers for different parts of the RRULE
#   freq_parser = string("FREQ") |> choice([string("SECONDLY"), string("MINUTELY"), string("HOURLY"), string("DAILY"), string("WEEKLY"), string("MONTHLY"), string("YEARLY")])
#
#   integer_parser = integer(min: 0)
#
#   dtstart_parser = string("DTSTART") |> string("=") |> choice([string("DATE-TIME"), string("DATE"), string("PERIOD")])
#
#   interval_parser = string("INTERVAL") |> integer(min: 1)
#
#   count_parser = string("COUNT") |> integer(min: 1)
#
#   until_parser = string("UNTIL") |> choice([string("DATE-TIME"), string("DATE")])
#
#   # Combine all parsers
#   rrule_parser =
#     freq_parser
#     |> optional(seq([string(";"), dtstart_parser]))
#     |> optional(seq([string(";"), interval_parser]))
#     |> optional(seq([string(";"), count_parser]))
#     |> optional(seq([string(";"), until_parser]))
#     |> optional(string(";"))
#     |> end_of_line()
#
#   defparsec(:parse, rrule_parser, debug: true)
# end
#
# {:ok, result, _, _} = RRuleParser.parse("FREQ=DAILY;DTSTART=DATE-TIME;INTERVAL=1;COUNT=10;UNTIL=DATE-TIME")
# IO.inspect(result)  # Check the parsed result
#

#
# defmodule RRuleParser do
#   import NimbleParsec
#
#   # Define parsers for different parts of the RRULE
#   freq_parser = string("FREQ") |> choice([string("SECONDLY"), string("MINUTELY"), string("HOURLY"), string("DAILY"), string("WEEKLY"), string("MONTHLY"), string("YEARLY")])
#
#   integer_parser = integer(min: 0)
#
#   dtstart_parser = string("DTSTART") |> string("=") |> choice([string("DATE-TIME"), string("DATE"), string("PERIOD")])
#
#   interval_parser = string("INTERVAL") |> integer(min: 1)
#
#   count_parser = string("COUNT") |> integer(min: 1)
#
#   until_parser = string("UNTIL") |> choice([string("DATE-TIME"), string("DATE")])
#
#   # Combine all parsers
#   rrule_parser =
#     freq_parser
#     |> optional(seq([string(";"), dtstart_parser]))
#     |> optional(seq([string(";"), interval_parser]))
#     |> optional(seq([string(";"), count_parser]))
#     |> optional(seq([string(";"), until_parser]))
#     |> optional(string(";"))
#     |> eos()
#
#   defparsec(:parse, rrule_parser, debug: true)
# end
# {:ok, result, _, _} = RRuleParser.parse("FREQ=DAILY;DTSTART=DATE-TIME;INTERVAL=1;COUNT=10;UNTIL=DATE-TIME")
# IO.inspect(result)  # Check the parsed result
#

# defmodule DateTimeParser do
#   import NimbleParsec

#   # Define parsers for different parts of the datetime
#   digit = integer(1)
#   # one_of("0123456789")
#   # digit4 = integer(min: 4, max: 4)
#   # digit2 = integer(min: 2, max: 2)

#   digit4 = integer(4)
#   digit2 = integer(2)

#   year_parser = digit4
#   month_parser = digit2
#   day_parser = digit2
#   hour_parser = digit2
#   minute_parser = digit2
#   second_parser = digit2

#   # Combine all parsers
#   datetime_parser =
#     integer(4)
#     |> integer(2)
#     |> integer(2)
#     |> string("T")
#     |> integer(2)
#     |> integer(2)
#     |> integer(2)
#     |> string("Z")
#     |> eos()

#   defparsec(:parse, datetime_parser)
# end

# DateTimeParser.parse("20220623T000000Z")
# |> IO.inspect(label: "dateimt parser ")

defmodule RRuleParser do
  import NimbleParsec

  # Define parsers for different parts of the RRULE
  rrule_parser = string("RRULE")

  freq_parser =
    string("FREQ")
    |> string("=")
    |> choice([
      string("SECONDLY"),
      string("MINUTELY"),
      string("HOURLY"),
      string("DAILY"),
      string("WEEKLY"),
      string("MONTHLY"),
      string("YEARLY")
    ])

  integer_parser = integer(min: 1)

  dtstart_parser =
    string("DTSTART")
    |> string(":")
    |> integer(4)
    |> integer(2)
    |> integer(2)
    |> string("T")
    |> integer(2)
    |> integer(2)
    |> integer(2)
    |> string("Z")

  # |> eos()

  # choice([string("DATE-TIME"), string("DATE"), string("PERIOD")])

  interval_parser = string("INTERVAL") |> string("=") |> integer(min: 1)

  count_parser = string("COUNT") |> integer(min: 1)

  until_parser = string("UNTIL") |> choice([string("DATE-TIME"), string("DATE")])

  # Combine all parsers
  rrule_parser =
    dtstart_parser
    |> optional(concat(string(";"), rrule_parser))
    |> optional(concat(string(":"), freq_parser))
    |> optional(concat(string(";"), interval_parser))
    # |> optional(concat(string(";"), count_parser))
    # |> optional(concat(string(";"), until_parser))
    # |> optional(string(";"))
    |> eos()

  defparsec(:parse, rrule_parser, debug: true)
end

rrule = "DTSTART:20220623T000000Z;RRULE:FREQ=DAILY;INTERVAL=1"
{:ok, result, _, _} = RRuleParser.parse(rrule)
# Check the
IO.inspect(result)
