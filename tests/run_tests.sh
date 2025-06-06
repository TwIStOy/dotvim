#!/bin/bash

DOTVIM_DIR="$(git rev-parse --show-toplevel)"

nvim_t() {
    nvim -u "$DOTVIM_DIR/tests/minit.lua" -c "set runtimepath+=$DOTVIM_DIR" "$@"
}

if [ -n "$1" ]; then
  nvim_t --headless -c "lua require('plenary.busted').run('$1')" -c "qa!"
else
  nvim_t --headless -c "lua require'plenary.test_harness'.test_directory( 'tests/', { minimal_init = './tests/minit.lua' })" -c "qa!"
fi