//// Solutions to AOC 2024 Day 3.

import gleam/int
import gleam/io
import gleam/list
import gleam/option
import gleam/regexp
import gleam/result
import gleam/string
import utils

pub fn main() {
  // Part 1
  let memory = utils.read_challenge_input(2024, 3) |> string.trim
  memory |> scan_memory_simple |> int.to_string |> io.println

  // Part 2
  memory |> scan_memory_conditional |> int.to_string |> io.println
}

/// Possible instructions from the memory.
type Instruction {
  Value(value: Int)
  Stop
  Go
}

/// Whether the conditional parser should be adding products.
type Condition {
  CStop
  CGo
}

/// Accumulator for reducing over instructions.
type InstrAcc {
  InstrAcc(acc: Int, condition: Condition)
}

/// Simple parser that adds all found multiplication instructions.
pub fn scan_memory_simple(mem: String) -> Int {
  let assert Ok(re) = regexp.from_string("mul\\((\\d{1,3}),(\\d{1,3})\\)")
  scan_memory(mem, re)
}

/// Conditional parser that can be selectively turned on and off.
pub fn scan_memory_conditional(mem: String) -> Int {
  let assert Ok(re) =
    regexp.from_string("mul\\((\\d{1,3}),(\\d{1,3})\\)|(don't)|(do)")
  scan_memory(mem, re)
}

/// Scan a string of corrupted memory to find multiplication instructions. Sum
/// the products of all valid multiplications.
pub fn scan_memory(mem: String, re: regexp.Regexp) -> Int {
  let acc =
    regexp.scan(re, mem)
    |> list.map(parse_match)
    |> list.fold(InstrAcc(0, CGo), fold_instr)
  acc.acc
}

/// Parse a regex match for the numbers to multiply together.
fn parse_match(match: regexp.Match) -> Instruction {
  let results = option.values(match.submatches)
  case results {
    ["don't"] -> Stop
    ["do"] -> Go
    [_, _] -> {
      list.map(results, int.parse)
      |> result.values
      |> list.fold(1, int.multiply)
      |> Value
    }
    _ -> Value(0)
  }
}

/// Follow conditionals and add products together.
fn fold_instr(acc: InstrAcc, instruction: Instruction) -> InstrAcc {
  case acc.condition, instruction {
    CStop, Go -> InstrAcc(acc.acc, CGo)
    CStop, _ -> acc
    CGo, Stop -> InstrAcc(acc.acc, CStop)
    CGo, Value(a) -> InstrAcc(acc.acc + a, CGo)
    CGo, _ -> acc
  }
}
