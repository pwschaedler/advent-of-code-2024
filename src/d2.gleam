//// Solutions to AOC 2024 Day 2.

import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils

/// Report containing multiple level readings.
pub type Report {
  Report(levels: List(Int))
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

/// Check if a report is safe.
pub fn is_safe_report(report: Report) -> Bool {
  let pairs =
    report.levels
    |> list.window_by_2
  list.all(pairs, in_safe_range) && is_monotonic(pairs)
}

/// Check if two levels are in a safe range.
pub fn in_safe_range(pair: #(Int, Int)) -> Bool {
  let diff = int.absolute_value(pair.1 - pair.0)
  diff >= 1 && diff <= 3
}

type Monotonicity {
  Unset
  Increasing
  Decreasing
  Mixed
}

/// Check if levels are consistently monotonic (either increasing
/// or decreasing).
pub fn is_monotonic(levels: List(#(Int, Int))) -> Bool {
  let monotonic =
    list.fold(levels, Unset, fn(monotonicity, pair) {
      case monotonicity, pair {
        Unset, pair if pair.1 > pair.0 -> Increasing
        Unset, pair if pair.0 > pair.1 -> Decreasing
        Increasing, pair if pair.0 >= pair.1 -> Mixed
        Increasing, _ -> Increasing
        Decreasing, pair if pair.1 >= pair.0 -> Mixed
        Decreasing, _ -> Decreasing
        Mixed, _ -> Mixed
        _, _ -> Mixed
      }
    })
  case monotonic {
    Increasing | Decreasing -> True
    _ -> False
  }
}

/// Parse string data into Reports.
pub fn parse_reports(data: String) -> List(Report) {
  data
  |> string.split("\n")
  |> list.map(parse_raw_report)
  |> list.map(Report)
}

/// Parse a single raw report.
fn parse_raw_report(report_line: String) -> List(Int) {
  report_line
  |> string.split(" ")
  |> list.map(int.parse)
  |> result.values
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
}
