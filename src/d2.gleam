//// Solutions to AOC 2024 Day 2.

import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/pair
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

/// Remove the first level from the report that would cause it to be unsafe.
pub fn dampen(report: Report) -> Report {
  io.debug("=====")
  io.debug(report)
  let pairs = report.levels |> list.window_by_2
  let new_pairs = origo(pairs)
  Report(unwindow_by_2(new_pairs))
  // let safety_res = list.fold(pairs, SafeAcc(Same, 0), reduce_safeness)
  // case safety_res.direction, safety_res.err_count > 1 {
  //   Same, _ -> False
  //   _, True -> False
  //   _, _ -> True
  // }
}

type SafeAcc {
  SafeAcc(direction: Direction, err_count: Int)
}

fn reduce_safeness(acc: SafeAcc, pair: #(Level, Level)) -> SafeAcc {
  let pair_direction = pair_dir(pair)
  let diff_err = !safe_diff(pair)
  let dir_err =
    bool.exclusive_nor(acc.direction == Same, acc.direction == pair_direction)
  let next_dir = case acc.direction, pair_direction {
    Same, Same -> Same
    Same, other -> other
    existing, _ -> existing
  }
  let err_count = case diff_err || dir_err {
    True -> acc.err_count + 1
    False -> acc.err_count
  }
  io.debug(SafeAcc(next_dir, err_count))
  SafeAcc(next_dir, err_count)
}

type PopListAcc {
  PopListAcc(return_list: List(#(Level, Level)))
}

type SafeDirAcc {
  SafeDirAcc(direction: Direction)
}

/// Kinda a pop-fold-until
fn origo(list: List(#(Level, Level))) -> List(#(Level, Level)) {
  let badmap = list.map_fold(list, SafeDirAcc(Same), fold_unsafe)
  let popres = case
    list.pop(badmap.1, fn(a: #(#(Level, Level), Bool)) { a.1 == True })
  {
    Ok(res) -> list.map(res.1, pair.first)
    Error(Nil) -> list
  }
}

fn fold_unsafe(
  acc: SafeDirAcc,
  pair: #(Level, Level),
) -> #(SafeDirAcc, #(#(Level, Level), Bool)) {
  let pair_direction = pair_dir(pair)
  let diff_err = !safe_diff(pair)
  let dir_err =
    bool.exclusive_nor(acc.direction == Same, acc.direction == pair_direction)
  let next_dir = case acc.direction, pair_direction {
    Same, Same -> Same
    Same, other -> other
    existing, _ -> existing
  }
  #(SafeDirAcc(next_dir), #(pair, diff_err || dir_err))
}

/// Unwindow a list of pair tuples into a single list.
pub fn unwindow_by_2(pairs: List(#(val, val))) -> List(val) {
  case pairs {
    [first, ..rest] ->
      list.fold(rest, [first.0, first.1], fn(acc, next) {
        list.flatten([acc, [next.1]])
      })
    [] -> []
  }
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
  // 585

  // Part 2
  reports
  |> list.map(dampen)
  |> count_safe_reports
  |> int.to_string
  |> io.println
}
