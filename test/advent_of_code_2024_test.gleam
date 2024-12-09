import d2
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn day2_test() {
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

pub fn d2_monotonic_test() {
  d2.Report([1, 1, 2, 3, 5]).levels
  |> list.window_by_2
  |> d2.is_monotonic
  |> should.be_false

  d2.Report([1, 2, 3, 5, 5]).levels
  |> list.window_by_2
  |> d2.is_monotonic
  |> should.be_false

  d2.Report([1, 0, -1, -2, -5, -100]).levels
  |> list.window_by_2
  |> d2.is_monotonic
  |> should.be_true
}
