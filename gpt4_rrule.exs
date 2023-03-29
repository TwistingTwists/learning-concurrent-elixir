Mix.install([
  {:nimble_parsec, "~> 1.1"},
  {:timex, "~> 3.0"}
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

defmodule Helpers do
  def pad_leading(x) do
    case String.length(x) do
      4 -> x
      n when n < 2 -> String.pad_leading(x, 2, "0")
    end
  end
end

defmodule RRuleParser do
  import NimbleParsec
  import Helpers

  # Define parsers for different parts of the RRULE
  rrule_parser = ignore(string("RRULE"))

  freq_parser =
    string("FREQ")
    |> ignore(string("="))
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
    ignore(string("DTSTART"))
    |> ignore(string(":"))
    |> integer(4)
    |> integer(2)
    |> integer(2)
    |> string("T")
    |> integer(2)
    |> integer(2)
    |> integer(2)
    |> string("Z")
    |> reduce({Enum, :map_join, ["", &pad_leading/1]})

  # |> eos()

  # choice([string("DATE-TIME"), string("DATE"), string("PERIOD")])

  interval_parser = ignore(string("INTERVAL")) |> ignore(string("=")) |> integer(min: 1)

  count_parser = ignore(string("COUNT")) |> integer(min: 1)

  until_parser = ignore(string("UNTIL")) |> choice([string("DATE-TIME"), string("DATE")])

  # Combine all parsers
  rrule_parser =
    dtstart_parser
    |> optional(concat(ignore(string(";")), rrule_parser))
    |> optional(concat(ignore(string(":")), freq_parser))
    |> optional(concat(ignore(string(";")), interval_parser))
    |> optional(concat(ignore(string(";")), count_parser))
    # |> optional(concat(string(";"), until_parser))
    |> optional(string(";"))
    |> eos()

  defparsec(:parse, rrule_parser, debug: true)
end

# this works.
rrule = "DTSTART:20220623T000000Z;RRULE:FREQ=DAILY;INTERVAL=1"
{:ok, result, _, _, _, _} = RRuleParser.parse(rrule)
# Check the
IO.inspect(result, label: "only rrule")

defmodule RRuleProcessor do
  @moduledoc """
  A basic RRule processor that calculates the next occurrence based on the parsed RRULE.
  """

  # For simplicity, let's assume the parsed RRULE contains only the required fields.
  def next_occurrence(dtstart, freq, interval \\ 1) do
    case freq do
      "SECONDLY" ->
        dtstart |> add_seconds(interval)

      "MINUTELY" ->
        dtstart |> add_minutes(interval)

      "HOURLY" ->
        dtstart |> add_hours(interval)

      "DAILY" ->
        dtstart |> add_days(interval)

      "WEEKLY" ->
        dtstart |> add_weeks(interval)

      "MONTHLY" ->
        dtstart |> add_months(interval)

      "YEARLY" ->
        dtstart |> add_years(interval)

      _ ->
        {:error, "Invalid frequency"}
    end
  end

  # Helper functions to add time intervals
  defp add_seconds(datetime, seconds) do
    datetime |> Timex.shift(seconds: seconds)
  end

  defp add_minutes(datetime, minutes) do
    datetime |> Timex.shift(minutes: minutes)
  end

  defp add_hours(datetime, hours) do
    datetime |> Timex.shift(hours: hours)
  end

  defp add_days(datetime, days) do
    datetime |> Timex.shift(days: days)
  end

  defp add_weeks(datetime, weeks) do
    datetime |> Timex.shift(weeks: weeks)
  end

  defp add_months(datetime, months) do
    datetime |> Timex.shift(months: months)
  end

  defp add_years(datetime, years) do
    datetime |> Timex.shift(years: years)
  end
end

rrule2 = "DTSTART:20220101T000000Z;RRULE:FREQ=DAILY;INTERVAL=2"
{:ok, result, _, _, _, _} = RRuleParser.parse(rrule2) |> IO.inspect(label: "RRULE2")
# [year, month, day, hr, minute, second, "FREQ", freq, "INTERVAL", interval] = result
parsed_date = hd(result)

dtstart =
  Timex.parse!(parsed_date, "{ISO:Basic:Z}")
  |> IO.inspect(label: "parsed date from timex")

# next_event =
#   RRuleProcessor.next_occurrence(dtstart, parsed_freq, parsed_interval)
#   |> IO.inspect(label: "next events")
