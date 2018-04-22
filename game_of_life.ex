# Any live cell with fewer than two live neighbours dies, as if caused by underpopulation.
# Any live cell with two or three live neighbours lives on to the next generation.
# Any live cell with more than three live neighbours dies, as if by overpopulation.
# Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

defmodule Life do
  def neighbours({x, y}) do
    MapSet.new([{x-1, y+1}, {x, y+1}, {x+1, y+1},
                {x-1, y},             {x+1, y},
                {x-1, y-1}, {x, y-1}, {x+1, y-1}])
  end

  def all_neighbours(board) do
    Enum.reduce board, %MapSet{}, fn cell, total ->
      MapSet.union(total, neighbours(cell)) 
    end
  end

  def live_neighbour_count(cell, board) do
    neighbours(cell)
    |> MapSet.intersection(board)
    |> Enum.count
  end

  def alive?(cell, board) do
    MapSet.member?(board, cell)
  end

  def will_live?(true, live_neighbours) when live_neighbours < 2 do
    false
  end

  def will_live?(true, live_neighbours) when live_neighbours == 2 or live_neighbours == 3 do
    true
  end

  def will_live?(true, live_neighbours) when live_neighbours > 3 do
    false
  end

  def will_live?(false, live_neighbours) do
    live_neighbours == 3
  end

  #hard code this just for now
  def board do
    MapSet.new([{1,0}, {1,1}, {1,2}])
  end

  def next_generation(board) do
    Enum.filter all_neighbours(board), fn cell ->
      will_live?(alive?(cell, board), live_neighbour_count(cell, board))
    end
  end
end
