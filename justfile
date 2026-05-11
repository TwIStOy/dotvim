alias b := build
alias t := test

build:
  @echo "Building..."
  @nix build .# --accept-flake-config --extra-experimental-features flakes --extra-experimental-features nix-command

ubuntu-install:
  @echo "Installing..."
  @nix profile install . --accept-flake-config --extra-experimental-features flakes --extra-experimental-features nix-command

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
