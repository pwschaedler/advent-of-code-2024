//// Solutions to AOC 2024 Day 1.

import gleam/int
import gleam/io
import gleam/list
import gleam/regexp
import gleam/string
import utils

/// Parse input text containing columns of integers into lists.
fn parse_columns(text: String) -> List(List(Int)) {
  let assert Ok(re) = regexp.from_string("\\s+")

  text
  |> string.split("\n")
  |> list.map(regexp.split(with: re, content: _))
  |> map_nested(assert_parse_int)
  |> list.transpose
}

/// Apply some function to a nested List.
fn map_nested(list: List(List(a)), func: fn(a) -> b) -> List(List(b)) {
  list.map(list, list.map(_, func))
}

/// Parse a String to an Int but forcefully.
fn assert_parse_int(string: String) -> Int {
  case int.parse(string) {
    Ok(int) -> int
    _ -> panic as "Integer parsing on input failed."
  }
}

/// Find the similarity of a value in a list. A value's similarity is equal to
/// itself times the number of occurrences of that value in the list.
fn similarity(val: Int, list: List(Int)) -> Int {
  list
  |> list.filter(fn(x) { x == val })
  |> list.length
  |> int.multiply(val)
}

pub fn main() {
  // Part 1
  let sorted_cols =
    utils.read_challenge_input(2024, 1)
    |> string.trim
    |> parse_columns
    |> list.map(list.sort(_, int.compare))

  let pair = case sorted_cols {
    [a, b] -> #(a, b)
    _ -> panic as "How did we end up with not two columns?"
  }

  list.map2(pair.0, pair.1, fn(x, y) { int.absolute_value(x - y) })
  |> list.fold(0, int.add)
  |> int.to_string
  |> io.println

  // Part 2
  list.map(pair.0, similarity(_, pair.1))
  |> list.fold(0, int.add)
  |> int.to_string
  |> io.println
}
// const sample = "
// 3   4
// 4   3
// 2   5
// 1   3
// 3   9
// 3   3
// "
