Mix.install([
  {:calendar_recurrence, github: "wojtekmach/calendar_recurrence"}
])
alias CalendarRecurrence.RRULE
RRULE.parse("FREQ=DAILY;COUNT=10") |> IO.inspect(label: "minimal example")
RRULE.to_recurrence("FREQ=WEEKLY;COUNT=4;BYDAY=MO,WE", ~D[2018-01-01]) |> Enum.to_list() |> IO.inspect(label: "recurrence rule")

RRULE.to_recurrence("FREQ=DAILY;INTERVAL=1", ~D[2018-01-01]) |> Enum.take(10) |> IO.inspect(label: "recurrence rule real life")
