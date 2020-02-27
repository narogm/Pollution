defmodule PollutionData do
  @moduledoc """
  Documentation for PollutionData.
  """

  @doc """
  Hello world.

  ## Examples

      iex> PollutionData.hello()
      :world

  """
  def hello do
    "hello"
  end

  def importLInesFromCSV do
    lines = File.read!("pollution.csv") |> String.split("\r\n")
    length(lines)
  end

  def parseLine line do
    [day, time, x, y, pollutionLevel] = String.split(line, ",")
     day = String.split(day, "-") |> Enum.reverse() |> Enum.map(fn x -> elem(Integer.parse(x), 0) end) |> :erlang.list_to_tuple()
    [{day, time}, {x, y}, pollutionLevel]
  end
end
