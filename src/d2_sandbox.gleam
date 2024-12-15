// /// Check if a report is safe.
// pub fn is_safe_report(report: Report) -> Bool {
//   let pairs =
//     report.levels
//     |> list.window_by_2
//   let num_pairs = list.length(pairs)
//   let safe_range = list.count(pairs, in_safe_range)
//   let monotonic = list.map(pairs, pair_direction) |> count_most_common_direction
//   safe_range >= num_pairs - 1 && monotonic >= num_pairs - 1
// }

// /// Check if two levels are in a safe range.
// pub fn in_safe_range(pair: #(Int, Int)) -> Bool {
//   let diff = int.absolute_value(pair.1 - pair.0)
//   diff >= 1 && diff <= 3
// }

// pub type Direction {
//   Increasing
//   Decreasing
//   Same
// }

// /// Count the most common direction, whether increasing or decreasing.
// pub fn count_most_common_direction(directions: List(Direction)) -> Int {
//   let inc =
//     list.count(directions, fn(direction) {
//       case direction {
//         Increasing -> True
//         _ -> False
//       }
//     })
//   let dec =
//     list.count(directions, fn(direction) {
//       case direction {
//         Decreasing -> True
//         _ -> False
//       }
//     })
//   int.max(inc, dec)
// }

// /// Determine if a pair of numbers is increasing or decreasing.
// fn pair_direction(pair: #(Int, Int)) -> Direction {
//   case pair {
//     #(first, second) if first < second -> Increasing
//     #(first, second) if first > second -> Decreasing
//     _ -> Same
//   }
// }

// pub fn d2_monotonic_test() {
//   d2.Report([1, 1, 2, 3, 5]).levels
//   |> list.window_by_2
//   |> d2.is_monotonic
//   |> should.be_false

//   d2.Report([1, 2, 3, 5, 5]).levels
//   |> list.window_by_2
//   |> d2.is_monotonic
//   |> should.be_false

//   d2.Report([1, 0, -1, -2, -5, -100]).levels
//   |> list.window_by_2
//   |> d2.is_monotonic
//   |> should.be_true
// }

// /// Check if a report contains safe levels.
// pub fn is_safe_report(report: Report) -> Bool {
//   let level_pairs = list.window_by_2(report.levels)
//   let common_direction = get_common_direction(level_pairs)
//   let safe_pairs =
//     list.map(level_pairs, fn(pair) {
//       level_pair_in_safe_range(pair)
//       && level_pair_in_common_direction(pair, common_direction)
//     })
//   list.length(safe_pairs) == list.length(level_pairs)
// }

// /// Check if a pair of levels are in a safe range.
// pub fn level_pair_in_safe_range(pair: #(Int, Int)) -> Bool {
//   let diff = int.absolute_value(pair.1 - pair.0)
//   diff >= 1 && diff <= 3
// }

// /// Direction of a pair of two numbers.
// pub type Direction {
//   Increasing
//   Decreasing
//   Same
// }

// /// Determine if a given pair is going in the common direction.
// pub fn level_pair_in_common_direction(
//   pair: #(Int, Int),
//   direction: Direction,
// ) -> Bool {
//   let pair_direction = get_pair_direction(pair)
//   pair_direction == direction
// }

// /// Assign a direction to a pair of numbers.
// pub fn get_pair_direction(pair: #(Int, Int)) -> Direction {
//   case pair {
//     #(first, second) if first < second -> Increasing
//     #(first, second) if first > second -> Decreasing
//     _ -> Same
//   }
// }

// /// Find the most common direction in a list of pairs.
// pub fn get_common_direction(pairs: List(#(Int, Int))) -> Direction {
//   let directions = list.map(pairs, get_pair_direction)
//   let inc = list.count(directions, fn(dir) { dir == Increasing })
//   let dec = list.count(directions, fn(dir) { dir == Decreasing })
//   case inc, dec {
//     inc, dec if inc > dec -> Increasing
//     inc, dec if dec > inc -> Decreasing
//     _, _ -> Increasing
//   }
// }
