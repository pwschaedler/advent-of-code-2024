//// A simple list zipper data structure. Assumes fixed length.

import gleam/list

pub opaque type Zipper(a) {
  Zipper(prev: List(a), focus: a, next: List(a))
}

/// Construct a zipper from a list of values.
pub fn from_list(list: List(a)) -> Result(Zipper(a), Nil) {
  case list {
    [] -> Error(Nil)
    [first, ..rest] -> Ok(Zipper([], first, rest))
  }
}

/// Move the focus to the next item in the list. Returns `Error(Nil)` if at the
/// end of the zipper.
pub fn next(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper {
    Zipper(_, _, []) -> Error(Nil)
    Zipper(prev, focus, [a, ..next]) -> Ok(Zipper([focus, ..prev], a, next))
  }
}

/// Move the focus to the previous item in the list. Returns `Error(Nil)` if at the
/// start of the zipper.
pub fn prev(zipper: Zipper(a)) -> Result(Zipper(a), Nil) {
  case zipper {
    Zipper([], _, _) -> Error(Nil)
    Zipper([a, ..prev], focus, next) -> Ok(Zipper(prev, a, [focus, ..next]))
  }
}

/// Update the item at the current focus of the zipper with the given value.
pub fn update(zipper: Zipper(a), val: a) -> Zipper(a) {
  Zipper(zipper.prev, val, zipper.next)
}

/// Convert the zipper back to a list.
pub fn to_list(zipper: Zipper(a)) -> List(a) {
  list.flatten([list.reverse(zipper.prev), [zipper.focus], zipper.next])
}

/// Rewind the zipper to the start so the focus is the first value.
fn rewind(zipper: Zipper(a)) -> Zipper(a) {
  case prev(zipper) {
    Ok(z) -> rewind(z)
    Error(_) -> zipper
  }
}

/// Find the given value in a zipper, and return the zipper with that value at
/// the focus.
pub fn find(zipper: Zipper(a), val: a) -> Result(Zipper(a), Nil) {
  let from_start = rewind(zipper)
  find_check(from_start, val)
}

/// Recursive function to find a value in the zipper so we can assume we only
/// need to move forward while searching.
fn find_check(zipper: Zipper(a), val: a) -> Result(Zipper(a), Nil) {
  case zipper {
    Zipper(_, focus, _) if focus == val -> Ok(zipper)
    _ -> {
      case next(zipper) {
        Ok(z) -> find_check(z, val)
        Error(_) -> Error(Nil)
      }
    }
  }
}

/// Replace the first instance of value `a` with the value `b` in the zipper. If
/// `a` is not found in the zipper, return the original zipper.
pub fn replace(zipper: Zipper(t), a: t, b: t) -> Zipper(t) {
  case find(zipper, a) {
    Ok(z) -> update(z, b)
    Error(_) -> zipper
  }
}
