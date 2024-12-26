//// Solutions to AOC 2024 Day 5.

import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils
import zipper

pub fn main() {
  // Part 1
  let input = utils.read_challenge_input(2024, 5)
  input |> sum_good_middle_pages |> int.to_string |> io.println

  // Part 2
  input |> sum_bad_middle_pages |> int.to_string |> io.println
}

/// A single rule where the first page must appear before the second page.
type Rule {
  Rule(first: Int, second: Int)
}

/// A set of pages included in the update.
type Update =
  List(Int)

/// Given a list of rules and page updates, find the sum of the middle pages of
/// updates that follow all rules.
pub fn sum_good_middle_pages(input: String) -> Int {
  let #(raw_rules, raw_updates) = separate_sections(input)
  let rules = parse_rules(raw_rules)
  let updates = parse_updates(raw_updates)

  updates
  |> list.filter(check_rules(_, rules))
  |> list.map(middle_page)
  |> list.fold(0, int.add)
}

/// Split input into rules and updates.
fn separate_sections(input: String) -> #(String, String) {
  case string.split(input, "\n\n") {
    [raw_rules, raw_updates] -> #(raw_rules, raw_updates)
    _ -> #("", "")
  }
}

/// Parse rules from text input.
fn parse_rules(raw_rules: String) -> List(Rule) {
  raw_rules
  |> string.split("\n")
  |> list.map(string.split(_, "|"))
  |> list.map(list.map(_, int.parse))
  |> list.map(result.values)
  |> list.filter_map(fn(list) {
    case list {
      [first, second] -> Ok(Rule(first, second))
      _ -> Error(Nil)
    }
  })
}

/// Parse updates from text rules.
fn parse_updates(raw_updates: String) -> List(Update) {
  raw_updates
  |> string.split("\n")
  |> list.map(string.split(_, ","))
  |> list.map(list.map(_, int.parse))
  |> list.map(result.values)
}

/// Check an update to ensure it follows all given rules.
fn check_rules(update: Update, rules: List(Rule)) -> Bool {
  let relevant_rules =
    list.filter(rules, fn(rule) {
      list.contains(update, rule.first) && list.contains(update, rule.second)
    })

  update
  |> list.combination_pairs
  |> list.all(pair_passes_all_rules(_, relevant_rules))
}

/// Check a single pair of pages to ensure it follows all given rules.
fn pair_passes_all_rules(pair: #(Int, Int), rules: List(Rule)) -> Bool {
  rules |> list.all(pair_passes_rule(pair, _))
}

/// Check a single pair of pages to ensure it follows a single rule.
fn pair_passes_rule(pair: #(Int, Int), rule: Rule) -> Bool {
  pair.0 != rule.second || pair.1 != rule.first
}

/// Determine the middle page of an update.
fn middle_page(update: Update) -> Int {
  case update {
    [] -> 0
    _ ->
      list.take(update, list.length(update) / 2 + 1)
      |> list.last
      |> result.unwrap(0)
  }
}

/// Given a list of rules and page updates, find the sum of the middle pages of
/// updates that do not follow rules and must be reordered.
pub fn sum_bad_middle_pages(input: String) -> Int {
  let #(raw_rules, raw_updates) = separate_sections(input)
  let rules = parse_rules(raw_rules)
  let updates = parse_updates(raw_updates)

  updates
  |> list.filter(fn(update) { !check_rules(update, rules) })
  |> list.map(fix_order(_, rules))
  |> list.map(middle_page)
  |> list.fold(0, int.add)
}

/// Fix the order of an update to follow rules.
fn fix_order(update: Update, rules: List(Rule)) -> Update {
  case check_rules(update, rules) {
    True -> update
    False -> update |> swap_pass(rules) |> fix_order(rules)
  }
}

/// Do a single pass over an update listing swapping misordered pages when
/// encountered. Multiple passes may be required to properly order an update.
fn swap_pass(update: Update, rules: List(Rule)) -> Update {
  let failing_rule = find_failing_rule(update, rules)
  let zipper = zipper.from_list(update)
  let zipper =
    result.map(zipper, zipper.replace(
      _,
      failing_rule.first,
      failing_rule.second,
    ))
  let zipper =
    result.map(zipper, zipper.replace(
      _,
      failing_rule.second,
      failing_rule.first,
    ))
  case zipper {
    Ok(z) -> zipper.to_list(z)
    Error(_) -> []
  }
}

/// Determine the failing rule for an update.
fn find_failing_rule(update: Update, rules: List(Rule)) -> Rule {
  let relevant_rules =
    list.filter(rules, fn(rule) {
      list.contains(update, rule.first) && list.contains(update, rule.second)
    })

  update
  |> list.combination_pairs
  |> list.find(fn(pair) { !pair_passes_all_rules(pair, relevant_rules) })
  |> fn(res) {
    case res {
      Ok(#(first, second)) -> Rule(second, first)
      Error(_) -> panic as "Shouldn't get here."
    }
  }
}
