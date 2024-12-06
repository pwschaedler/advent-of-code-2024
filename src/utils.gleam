//// Helper utilities for all Advent of Code challenges.

import directories
import dot_env
import dot_env/env
import filepath
import gleam/http/request
import gleam/httpc
import gleam/int
import simplifile

/// Read challenge input for a given year and day.
pub fn read_challenge_input(year: Int, day: Int) -> String {
  case read_input_cache(year, day) {
    Ok(data) -> data
    Error(_) -> {
      let data = request_input(year, day)
      write_input_cache(data, year, day)
      data
    }
  }
}

/// Determine cache location for a given year and day.
fn get_cache_location(year: Int, day: Int) -> String {
  let assert Ok(cache_dir) = directories.cache_dir()
  filepath.join(cache_dir, "advent-of-code-2024")
  |> filepath.join(int.to_string(year))
  |> filepath.join(int.to_string(day) <> ".txt")
}

/// Read data from cache.
fn read_input_cache(year: Int, day: Int) -> Result(String, simplifile.FileError) {
  let path = get_cache_location(year, day)
  simplifile.read(path)
}

/// Write data to cache.
fn write_input_cache(data: String, year: Int, day: Int) -> Nil {
  let path = get_cache_location(year, day)
  let assert Ok(Nil) =
    simplifile.create_directory_all(filepath.directory_name(path))
  let assert Ok(Nil) = simplifile.write(path, data)
  Nil
}

/// Request challenge input from the AOC website.
fn request_input(year: Int, day: Int) -> String {
  dot_env.load_default()
  let assert Ok(session) = env.get_string("AOC_SESSION")

  let url =
    "https://adventofcode.com/"
    <> int.to_string(year)
    <> "/day/"
    <> int.to_string(day)
    <> "/input"
  let assert Ok(req) = request.to(url)
  let req =
    req
    |> request.prepend_header(
      "User-Agent",
      "github.com/pwschaedler/advent-of-code-2024",
    )
    |> request.prepend_header("Cookie", "session=" <> session)

  let assert Ok(resp) = httpc.send(req)
  resp.body
}
