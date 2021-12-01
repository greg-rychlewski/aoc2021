defmodule Day1 do
  @moduledoc false

  @doc """
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
  def part1(input_path) do
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

  @doc """
  Considering every single measurement isn't as useful as you expected: there's just too much noise in the data.

  Instead, consider sums of a three-measurement sliding window. Again considering the above example:

  199  A
  200  A B
  208  A B C
  210    B C D
  200  E   C D
  207  E F   D
  240  E F G
  269    F G H
  260      G H
  263        H
  Start by comparing the first and second three-measurement windows. The measurements in the first window are marked A (199, 200, 208); their sum is 199 + 200 + 208 = 607. The second window is marked B (200, 208, 210); its sum is 618. The sum of measurements in the second window is larger than the sum of the first, so this first comparison increased.

  Your goal now is to count the number of times the sum of measurements in this sliding window increases from the previous sum. So, compare A with B, then compare B with C, then C with D, and so on. Stop when there aren't enough measurements left to create a new three-measurement sum.

  In the above example, the sum of each three-measurement window is as follows:

  A: 607 (N/A - no previous sum)
  B: 618 (increased)
  C: 618 (no change)
  D: 617 (decreased)
  E: 647 (increased)
  F: 716 (increased)
  G: 769 (increased)
  H: 792 (increased)
  In this example, there are 5 sums that are larger than the previous sum.

  Consider sums of a three-measurement sliding window. How many sums are larger than the previous sum?
  """
  def part2(input_path, window_size) do
    input_path
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(window_size, 1, :discard)
    |> Enum.reduce({nil, 0}, fn curr, {prev_sum, count} ->
      curr_sum = Enum.sum(curr)

      if curr_sum > prev_sum do
        {curr_sum, count + 1}
      else
        {curr_sum, count}
      end
    end)
  end
end

IO.inspect(Day1.part1("day_1/input.txt"))
IO.inspect(Day1.part2("day_1/input.txt", 3))
