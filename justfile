alias b := build
alias t := test

build:
  @echo "Building..."

# Run all tests
test:
  ./tests/run_tests.sh

# Run a specific test file
test-file file:
  ./tests/run_tests.sh {{file}}

# Run tests with verbose output
test-verbose:
  @echo "Running tests with verbose output..."
  ./tests/run_tests.sh
