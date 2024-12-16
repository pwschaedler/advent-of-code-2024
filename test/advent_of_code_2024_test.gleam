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
