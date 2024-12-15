import d2
import gleam/io
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
  |> list.map(d2.dampen)
  |> d2.count_safe_reports
  |> should.equal(4)
}

pub fn unwindow_test() {
  let levels = [1, 2, 3, 4, 5]
  let pairs = list.window_by_2(levels)

  let assert Ok(res) = list.pop(pairs, fn(item) { item.1 == 3 })
  let new_pairs = res.1

  let assert [first, ..rest] = new_pairs
  rest
  |> io.debug
  |> list.fold([first.0, first.1], fn(acc, next) {
    list.flatten([acc, [next.1]])
  })
  |> io.debug
}
