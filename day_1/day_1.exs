defmodule Day1 do
  @moduledoc """
  As the submarine drops below the surface of the ocean, it automatically performs a sonar sweep of the nearby sea floor. On a small screen, the sonar sweep report (your puzzle input) appears: each line is a measurement of the sea floor depth as the sweep looks further and further away from the submarine.

  For example, suppose you had the following report:

  199
  200
  208
  210
  200
  207
  240
  269
  260
  263
  This report indicates that, scanning outward from the submarine, the sonar sweep found depths of 199, 200, 208, 210, and so on.

  The first order of business is to figure out how quickly the depth increases, just so you know what you're dealing with - you never know if the keys will get carried into deeper water by an ocean current or a fish or something.

  To do this, count the number of times a depth measurement increases from the previous measurement. (There is no measurement before the first measurement.) In the example above, the changes are as follows:

  199 (N/A - no previous measurement)
  200 (increased)
  208 (increased)
  210 (increased)
  200 (decreased)
  207 (increased)
  240 (increased)
  269 (increased)
  260 (decreased)
  263 (increased)
  In this example, there are 7 measurements that are larger than the previous measurement.

  How many measurements are larger than the previous measurement?
  """

  def solution1(input_path) do
    input_path
    |> File.stream!()
    |> Enum.reduce({nil, 0}, fn curr, {prev, count} ->
      curr = curr |> String.trim() |> String.to_integer()

      # This comparison works, even when prev is `nil`.
      # The reason for this is because Erlang has an ordering over its data types
      # where integers are less than atoms (`nil` is an atom).
      #
      # See explanation here by Joe Armstrong:
      #
      # source: http://erlang.org/pipermail/erlang-questions/2009-May/043851.html
      #
      # The original reason was that there should be a defined total order
      # over all terms (why? - so that we could write generic sorting
      # algorithms that could order *any* terms).
      #
      # The actual order was based on the idea of "complexity" an integer
      # is "simpler" than an atom. a tuple is simpler than a list and so on..
      #
      # There was no real definition of "simpler" it was more or less the size
      # that an object took
      # in memory (by which measure [], should have been smallest, but is not :-).
      #
      # The actual order is not important - but that a total ordering is well
      # defined is important.

      if curr > prev do
        {curr, count + 1}
      else
        {curr, count}
      end
    end)
  end
end

IO.inspect(Day1.solution1("day_1/input.txt"))
