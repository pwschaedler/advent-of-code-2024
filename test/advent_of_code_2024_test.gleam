//// Tests for sample input given in problem prompts.

import d2
import d3
import d4
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

pub fn d2p1_test() {
  "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"
  |> d2.parse_reports
  |> d2.count_safe_reports
  |> should.equal(2)
}

pub fn d2p2_test() {
  "7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"
  |> d2.parse_reports
  |> list.count(d2.report_is_safe(_, 1))
  |> should.equal(4)
}

pub fn d2p2_personal_test() {
  "9 1 2 3 4
1 2 6 4 5
1 6 2 4 5
9 6 7 8 9"
  |> d2.parse_reports
  |> list.count(d2.report_is_safe(_, 1))
  |> should.equal(4)
}

pub fn d3p1_test() {
  "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  |> d3.scan_memory_simple
  |> should.equal(161)
}

pub fn d3p2_test() {
  "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  |> d3.scan_memory_conditional
  |> should.equal(48)
}

pub fn d4p1_test() {
  "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"
  |> d4.solve
  |> should.equal(18)
}

pub fn d4p2_test() {
  "MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX"
  |> d4.solve_x
  |> should.equal(9)
}
