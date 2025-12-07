# -*- Elixir -*-

defmodule Day7 do
  def at(map, x, y) do
    elem(elem(map, y), x)
  end

  def uniq([], acc) do
    acc
  end

  def uniq([[x, y, v] | rest], acc) do
    uniq(
      rest,
      case Enum.any?(acc, fn [ax, ay, _] -> x == ax and y == ay end) do
        true -> Enum.map(acc, fn [ax, ay, av] -> case [x, y, v] do
                                                   [^ax, ^ay, _] -> [x, y, v+av]
                                                   _             -> [ax, ay, av]
                                                 end
                              end)
        _    -> acc ++ [[x, y, v]]
      end)
  end

  def uniq(lst) do
    uniq(lst, [])
  end

  def traverse(maxy, splits, [[_, y | _] | _] = beams, sacc) when y < maxy do
    with {sacc, acc} <- Enum.reduce(
           beams,
           {sacc, []},
           fn [x, y, v], {s, a} ->
             case Enum.filter(splits, fn [sx, sy] -> sx == x and sy == y+1 end) do
               [] -> { s,   a ++ [[x, y+1, v]] }
               _  -> { s+1, a ++ [[x-1, y+1, v], [x+1, y+1, v]]}
             end
           end)
      do
      traverse(maxy, splits, uniq(acc), sacc)
    end
  end

  def traverse(_maxy, _splits, beams, sacc) do
    { Enum.reduce(beams, 0, fn [_, _, v], acc -> v + acc end), sacc }
  end

  def traverse(maxy, splits, beams) do
    traverse(maxy, splits, beams, 0)
  end

  def find(map, it, x, y) when x < tuple_size(elem(map, 0)) and y < tuple_size(map) do
    case at(map, x, y) do
      ^it -> [[x, y]]
      _   -> []
    end ++ find(map, it, x+1, y)
  end

  def find(map, it, _x, y) when y < tuple_size(map) do
    find(map, it, 0, y+1)
  end

  def find(_map, _it, _x, _y) do
    []
  end

  def find(map, it) do
    find(map, it, 0, 0)
  end

  def solve(map) do
    with splits   <- find(map, ?^),
         beams    <- Enum.map(find(map, ?S), fn x -> x ++ [1] end),
         {p2, p1} <- traverse(tuple_size(map), splits, beams) do
      IO.puts("p1: " <> to_string(p1))
      IO.puts("p2: " <> to_string(p2))
    end
  end

  def main() do
    with {:ok, input} <- File.read("input") do
      input
      |> String.split("\n")
      |> Enum.map(fn s ->
        s
        |> String.to_charlist
        |> List.to_tuple
      end)
      |> List.to_tuple()
      |> solve
    end
  end
end

Day7.main()
