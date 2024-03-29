import { Formatter } from "@core/model";

/**
 * Variables will be replaced.
 *
 * $FILENAME
 * $DIRNAME
 */
const ClangFormat = new Formatter({
  name: "clang-format",
  exe: false,
  ft: ["c", "cpp", "cs", "java", "cuda", "proto"],
  opts: {
    args: ["-assume-filename", "$FILENAME"],
    stdin: true,
  },
});

const Stylua = new Formatter({
  name: "stylua",
  exe: false,
  ft: ["lua"],
  opts: {
    args: ["--search-parent-directories", "--stdin-filepath", "$FILENAME", "-"],
    stdin: true,
  },
});

const RustFmt = new Formatter({
  name: "rustfmt",
  exe: false,
  ft: ["rust"],
  opts: {
    args: ["--emit=stdout"],
    stdin: true,
  },
});

const Prettier = new Formatter({
  name: "prettier",
  exe: false,
  ft: [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "css",
    "scss",
    "less",
    "html",
    "json",
    "jsonc",
    "yaml",
    "markdown",
    "markdown.mdx",
    "graphql",
    "handlebars",
  ],
  opts: {
    args: ["--stdin-filepath", "$FILENAME"],
    stdin: true,
  },
});

const Black = new Formatter({
  name: "black",
  exe: false,
  ft: ["python"],
  opts: {
    args: ["--stdin-filename", "$FILENAME", "--quiet", "-"],
    stdin: true,
  },
});

const DartFmt = new Formatter({
  name: "dartfmt",
  exe: {
    command: ["dart"],
  },
  ft: ["dart"],
  opts: {
    args: ["format"],
    stdin: true,
  },
});

const Gersemi = new Formatter({
  name: "gersemi",
  exe: false,
  ft: ["cmake"],
  opts: {
    args: ["-"],
    stdin: true,
  },
});

const Alejandra = new Formatter({
  name: "alejandra",
  exe: false,
  ft: ["nix"],
});

const SwiftFormat = new Formatter({
  name: "swiftformat",
  exe: {
    command: ["/opt/homebrew/bin/swift-format"],
  },
  ft: ["swift"],
  opts: {
    args: ["$FILENAME", "--in-place"],
    stdin: false,
  },
});

export default [
  ClangFormat,
  Stylua,
  RustFmt,
  Prettier,
  Black,
  DartFmt,
  Gersemi,
  Alejandra,
  SwiftFormat,
];
