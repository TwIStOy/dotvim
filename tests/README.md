# dotvim.commons Test Suite

This directory contains comprehensive test cases for the `dotvim.commons` module and its submodules, using Neovim builtin utilities and plenary.nvim.

## Test Structure

```
test/
├── spec/
│   └── commons/
│       ├── init_spec.lua      - Tests for the main commons module
│       ├── fn_spec.lua        - Tests for dotvim.commons.fn module
│       ├── vim_spec.lua       - Tests for dotvim.commons.vim module
│       ├── validator_spec.lua - Tests for dotvim.commons.validator module
│       └── lsp_spec.lua       - Tests for dotvim.commons.lsp module
├── run_tests.lua              - Test runner that imports all test modules
├── plenary_config.lua         - Configuration for plenary.nvim test runner
└── README.md                  - This documentation
```

All test files are organized under `test/spec/commons/` for better structure and maintainability.

## Running Tests

### Method 1: Using the shell script (Recommended)

```bash
# Navigate to the dotvim directory
cd ~/.dotvim

# Run all tests with automatic exit (may require Ctrl+C after completion)
./test/run_tests.sh
```

### Method 2: Using plenary.nvim directly (with manual exit)

```bash
# Navigate to the dotvim directory
cd ~/.dotvim

# Run all tests (press Ctrl+C after tests complete)
nvim --headless --noplugin -u NONE -c "lua package.path=package.path..';/Users/wanghaot/.dotvim/?.lua;/Users/wanghaot/.dotvim/lua/?.lua'; require('plenary.test_harness').test_directory('test/spec/')" 

# Run specific test file  
nvim --headless -c "PlenaryBustedFile test/spec/commons/init_spec.lua" +qall
```

### Method 3: Quick single command (requires manual exit)

```bash
# Run all tests in one command (press Ctrl+C after completion)
cd ~/.dotvim && nvim --headless --noplugin -u NONE -S test/run_and_exit.lua
```

### Method 4: Using nvim Lua command (Interactive)

From within Neovim:

```lua
-- Run all tests
:lua require("plenary.test_harness").test_directory("test/spec/", { on_exit = function() vim.cmd("qall!") end })

-- Run specific test
:lua require("plenary.test_harness").test_file("test/spec/commons/init_spec.lua", { on_exit = function() vim.cmd("qall!") end })
```

### Method 5: Manual loading and execution (Interactive)

```lua
-- Load test runner
:lua require("test.run_tests")

-- Or load individual test files
:lua require("test.spec.commons.init_spec")
```

## Test Coverage

The test suite covers:

### `dotvim.commons`
- `array_values_to_lookup()` function with various input types
- Error handling for invalid inputs
- Edge cases (empty arrays, mixed types)

### `dotvim.commons.fn`
- `invoke_once()` - Function memoization and single execution
- `require_and()` - Conditional module loading with callbacks  
- `bind()` - Partial function application with argument binding

### `dotvim.commons.vim`
- `preserve_cursor_position()` - Cursor position restoration
- `buf_get_var()` - Buffer variable retrieval with error handling
- `get_exactly_keymap()` - Exact keymap matching across modes

### `dotvim.commons.validator`
- `is_array()` - Array validation with optional element validators
- `all()` - Composite validator creation and chaining

### `dotvim.commons.lsp`
- `on_lsp_attach()` - LSP attach event handling and callback registration

## Dependencies

- Neovim (builtin `vim` global and APIs)
- plenary.nvim for the test framework (`describe`, `it`, `assert`)

## Notes

- Tests use basic assertions (`assert(condition)`) and `pcall()` for error testing
- Some tests create temporary buffers/windows and clean them up
- LSP tests simulate events using `nvim_exec_autocmds`
- Tests are designed to be independent and not affect global state

## Debugging Tests

To debug failing tests:

1. Run individual test files to isolate issues
2. Add `print()` statements for debugging
3. Use `:messages` to see test output in Neovim
4. Check for proper cleanup of resources (buffers, keymaps, etc.)

## Contributing

When adding new functions to `dotvim.commons`:

1. Add corresponding test cases in the appropriate `test/spec/commons/*_spec.lua` file
2. Follow the existing test patterns and naming conventions
3. Include tests for both success and error cases
4. Test edge cases and boundary conditions
5. Ensure tests clean up any resources they create
6. Update the test runner in `run_tests.lua` if adding new test modules
