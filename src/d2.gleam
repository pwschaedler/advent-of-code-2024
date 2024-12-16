//// Solutions to AOC 2024 Day 2.

import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/result
import gleam/string
import utils

/// An individual level reading.
pub type Level =
  Int

/// Report containing multiple level readings.
pub type Report {
  Report(levels: List(Level))
}

/// Count how many reports contain a safe listing of levels. Safe reports
/// consist only of monotonically increasing or decreasing levels. Consecutive
/// levels must differ by at least one and at most three.
pub fn count_safe_reports(reports: List(Report)) -> Int {
  reports
  |> list.map(is_safe_report)
  |> list.map(bool.to_int)
  |> list.fold(0, int.add)
}

/// Determine if an individual report is safe.
pub fn is_safe_report(report: Report) -> Bool {
  all_safe_diff(report.levels) && safe_monotonicity(report.levels)
}

/// Check if all levels are a safe distance apart.
pub fn all_safe_diff(levels: List(Level)) -> Bool {
  levels
  |> list.window_by_2
  |> list.all(safe_diff)
}

/// Check if a single pair of levels is a safe distance.
pub fn safe_diff(pair: #(Level, Level)) -> Bool {
  let diff = int.absolute_value(pair.1 - pair.0)
  diff >= 1 && diff <= 3
}

/// The direction of a pair of levels.
pub type Direction {
  Increasing
  Decreasing
  Same
}

/// Check if a list of levels follows the same monotonicity.
pub fn safe_monotonicity(levels: List(Level)) -> Bool {
  all_inc(levels) || all_dec(levels)
}

/// Check if all levels are increasing.
pub fn all_inc(levels: List(Level)) -> Bool {
  levels
  |> list.window_by_2
  |> list.all(pair_inc)
}

/// Check if all levels are decreasing.
pub fn all_dec(levels: List(Level)) -> Bool {
  levels
  |> list.window_by_2
  |> list.all(pair_dec)
}

/// Check the direction of a given pair of levels.
pub fn pair_dir(pair: #(Level, Level)) -> Direction {
  case pair {
    #(a, b) if a < b -> Increasing
    #(a, b) if a > b -> Decreasing
    _ -> Same
  }
}

/// Check if a pair of levels is increasing.
pub fn pair_inc(pair: #(Level, Level)) -> Bool {
  case pair_dir(pair) {
    Increasing -> True
    _ -> False
  }
}

/// Check if a pair of levels is decreasing.
pub fn pair_dec(pair: #(Level, Level)) -> Bool {
  case pair_dir(pair) {
    Decreasing -> True
    _ -> False
  }
}

// Everything below is for part two, and technically this could cover the part
// one section as well. But not gonna lie I still don't really understand how
// this works, this is very inspired by hints (solutions) on Reddit and Github.
// See:
// - https://www.reddit.com/r/adventofcode/comments/1h4rhtl/comment/m00xlm5/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
// - https://github.com/edoannunziata/jardin/blob/master/aoc24/AdventOfCode24.ipynb

/// Determine if a report is safe with tolerance.
pub fn report_is_safe(report: Report, tolerance: Int) -> Bool {
  let levels = [None, ..list.map(report.levels, Some)]
  case levels {
    [] | [_] -> True
    levels ->
      dir_safe(levels, tolerance, inc_diff)
      || dir_safe(levels, tolerance, dec_diff)
  }
}

/// Check if a list of levels is safe given a directional difference function.
pub fn dir_safe(
  list: List(Option(Int)),
  tolerance: Int,
  diff_fn: fn(Int) -> Bool,
) -> Bool {
  case tolerance >= 0, list {
    False, _ -> False
    _, [] | _, [_] -> True
    _, [a, b, ..rest] ->
      case a, b {
        None, b ->
          dir_safe([b, ..rest], tolerance, diff_fn)
          || dir_safe([a, ..rest], tolerance - 1, diff_fn)
        Some(a), Some(b) ->
          { diff_fn(b - a) && dir_safe([Some(b), ..rest], tolerance, diff_fn) }
          || dir_safe([Some(a), ..rest], tolerance - 1, diff_fn)
        _, _ -> False
      }
  }
}

/// Check for incremental difference.
pub fn inc_diff(diff: Int) -> Bool {
  diff >= 1 && diff <= 3
}

/// Check for decremental difference.
pub fn dec_diff(diff: Int) -> Bool {
  diff <= -1 && diff >= -3
}

/// Parse string data into Reports.
pub fn parse_reports(data: String) -> List(Report) {
  data
  |> string.split("\n")
  |> list.map(parse_raw_report)
}

/// Parse a single raw report.
fn parse_raw_report(report_line: String) -> Report {
  report_line
  |> string.split(" ")
  |> list.map(int.parse)
  |> result.values
  |> Report
}

pub fn main() {
  // Part 1
  let reports =
    utils.read_challenge_input(2024, 2)
    |> string.trim
    |> parse_reports

  reports
  |> count_safe_reports
  |> int.to_string
  |> io.println

  // Part 2
  reports
  |> list.count(report_is_safe(_, 1))
  |> int.to_string
  |> io.println
}
