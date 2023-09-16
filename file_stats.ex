defmodule FileSystem do
  @syntax_colors [number: :yellow, atom: :cyan, string: :green, boolean: :magenta, nil: :magenta]

  @doc """
  Get disk stats for all muonted devices which have a corresponding /dev entry
  """
  def get_disks() do
    with {:ok, buf} <- File.read("/proc/mounts") do
      buf
      |> String.split("\n", trim: true)
      |> Enum.filter(&String.starts_with?(&1, "/dev"))
      # |> print("/dev")
      |> Enum.reduce(%{}, fn line, acc ->
        [path | _] = String.split(line, " ", trim: true)

        path = realpath(path)

        keys = [
          # requests      number of read I/Os processed
          "read",
          # requests      number of read I/Os merged with in-queue I/O
          "read_merges",
          # sectors       number of sectors read
          "read_sectors",
          # milliseconds  total wait time for read requests
          "read_ticks",
          # requests      number of write I/Os processed
          "write",
          # requests      number of write I/Os merged with in-queue I/O
          "write_merges",
          # sectors       number of sectors written
          "write_sectors",
          # milliseconds  total wait time for write requests
          "write_ticks",
          # requests      number of I/Os currently in flight
          "in_flight",
          # milliseconds  total time this block device has been active
          "io_ticks",
          # milliseconds  total wait time for all requests
          "time_in_queue",
          # requests      number of discard I/Os processed
          "discard",
          # requests      number of discard I/Os merged with in-queue I/O
          "discard_merges",
          # sectors       number of sectors discarded
          "discard_sectors",
          # milliseconds  total wait time for discard requests
          "discard_ticks"
        ]

        blockdev =
          Path.basename(path)

        # |> print("blockdev")

        syspath = Path.join(["/sys", "class", "block", blockdev])

        buf =
          File.read_link!(syspath)
          |> Path.absname(Path.dirname(syspath))
          |> Path.join("stat")
          |> File.read!()
          |> String.trim()

        parts =
          buf
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)

        vals = Map.new(Enum.zip([keys, parts]))

        Map.put(acc, path, %{
          "write" => %{
            "reqs" => vals["write"],
            "bytes" => vals["write_sectors"] * 512,
            "wait" => vals["write_ticks"]
          },
          "read" => %{
            "reqs" => vals["read"],
            "bytes" => vals["read_sectors"] * 512,
            "wait" => vals["read_ticks"]
          },
          "io_in_flight" => vals["in_flight"],
          "io_delay" => vals["io_ticks"],
          "time_in_queue" => vals["time_in_queue"]
        })
      end)
    end
  end

  defp realpath(path) do
    case File.read_link(path) do
      {:ok, target} ->
        Path.expand(Path.absname(target, Path.dirname(path)))

      # not a link or non-existing
      {:error, _} ->
        path
    end
  end

  defp print(data, val), do: IO.inspect(data, label: val, syntax_colors: @syntax_colors)
end

FileSystem.get_disks()
|> IO.inspect(label: "disk stats")
