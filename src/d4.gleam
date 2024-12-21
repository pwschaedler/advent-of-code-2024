//// Solutions to AOC 2024 Day 4.

import gleam/int
import gleam/io
import gleam/list
import gleam/string
import utils

pub fn main() {
  // Part 1
  let puzzle = utils.read_challenge_input(2024, 4) |> string.trim
  puzzle |> solve |> int.to_string |> io.println

  // Part 2
  puzzle |> solve_x |> int.to_string |> io.println
}

/// Type alias for window of characters to evaluate.
type Window =
  List(String)

/// A character and its place in the grid.
type Coordinate =
  #(String, Int, Int)

/// Solve a puzzle by finding "XMAS" in a grid of characters.
pub fn solve(puzzle: String) -> Int {
  parse_windows(puzzle)
  |> list.count(fn(window) {
    case window {
      ["X", "M", "A", "S"] -> True
      _ -> False
    }
  })
}

/// Parse windows of characters from a grid.
fn parse_windows(puzzle: String) -> List(Window) {
  let lines = puzzle |> string.split("\n")
  let chars = lines |> list.map(string.split(_, ""))
  let coords =
    chars
    |> list.index_map(fn(row, i) {
      list.index_map(row, fn(char, j) { #(char, i, j) })
    })
    |> list.flatten

  let horizontal = chars |> list.flat_map(list.window(_, 4))
  let vertical = list.transpose(chars) |> list.flat_map(list.window(_, 4))
  let tlbr = window_tlbr(coords)
  let trbl = window_trbl(coords)

  let windows = list.flatten([horizontal, vertical, tlbr, trbl])
  let reversed = list.map(windows, list.reverse)

  list.flatten([windows, reversed])
}

/// Parse diagonal windows going from top-left to bottom-right.
fn window_tlbr(coords: List(Coordinate)) -> List(Window) {
  list.map(coords, fn(coord: Coordinate) {
    let x0 = coord.1
    let y0 = coord.2
    let matches =
      list.filter(coords, fn(other: Coordinate) {
        let x1 = other.1
        let y1 = other.2
        { x1 == x0 + 1 && y1 == y0 + 1 }
        || { x1 == x0 + 2 && y1 == y0 + 2 }
        || { x1 == x0 + 3 && y1 == y0 + 3 }
      })
    [coord.0, ..list.map(matches, fn(match: Coordinate) { match.0 })]
  })
}

/// Parse diagonal windows going from top-right to bottom-left.
fn window_trbl(coords: List(Coordinate)) -> List(Window) {
  list.map(coords, fn(coord: Coordinate) {
    let x0 = coord.1
    let y0 = coord.2
    let matches =
      list.filter(coords, fn(other: Coordinate) {
        let x1 = other.1
        let y1 = other.2
        { x1 == x0 + 1 && y1 == y0 - 1 }
        || { x1 == x0 + 2 && y1 == y0 - 2 }
        || { x1 == x0 + 3 && y1 == y0 - 3 }
      })
    [coord.0, ..list.map(matches, fn(match: Coordinate) { match.0 })]
  })
}

/// Solve an X-MAS puzzle by finding "MAS" in an X form from a grid
/// of characters.
pub fn solve_x(puzzle: String) -> Int {
  parse_3x3_windows(puzzle)
  |> list.count(fn(window) {
    case window {
      ["M", _, "M", _, "A", _, "S", _, "S"]
      | ["M", _, "S", _, "A", _, "M", _, "S"]
      | ["S", _, "M", _, "A", _, "S", _, "M"]
      | ["S", _, "S", _, "A", _, "M", _, "M"] -> True
      _ -> False
    }
  })
}

/// Parse 3x3 windows of characters from a grid, returned as a flat list.
fn parse_3x3_windows(puzzle: String) -> List(Window) {
  let lines = puzzle |> string.split("\n")
  let chars = lines |> list.map(string.split(_, ""))
  let coords =
    chars
    |> list.index_map(fn(row, i) {
      list.index_map(row, fn(char, j) { #(char, i, j) })
    })
    |> list.flatten

  list.map(coords, fn(coord: Coordinate) {
    let x0 = coord.1
    let y0 = coord.2
    let matches =
      list.filter(coords, fn(other: Coordinate) {
        let x1 = other.1
        let y1 = other.2
        x1 >= x0 && x1 <= x0 + 2 && y1 >= y0 && y1 <= y0 + 2
      })
    list.map(matches, fn(match: Coordinate) { match.0 })
  })
}
