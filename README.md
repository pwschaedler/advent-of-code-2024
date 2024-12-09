# Advent of Code 2024

My attempts at AOC 2024 using Gleam. This is my first attempt using Gleam for anything, so the code will likely be messy and unidiomatic.

## Development

```sh
gleam run        # Run the project (generally)
gleam run -m d1  # Run a specific day
gleam test       # Run the tests
```

For requesting challenge input, an environment variable named `AOC_SESSION` is required, either in the environment or via a `.env` file.

Running a given module will print the day's answers to `stdout`. Running `gleam test` will run the challenges over the sample inputs, which are hard-coded into the tests.

## Automation

This repo contains a `utils.gleam` module with functions to automatically pull challenge input for a given day. Requests for input contain a `User-Agent` header with a link to this GitHub repository. Inputs are cached so each input should only be requested once.
