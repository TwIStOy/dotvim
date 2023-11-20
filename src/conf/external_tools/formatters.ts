import { Formatter } from "@core/model";

/**
 * Variables will be replaced.
 *
 * $FILENAME
 * $DIRNAME
 */
const ClangFormat = new Formatter({
  name: "clang-format",
  exe: {
    masonPkg: "clang-format",
  },
  ft: ["c", "cpp", "cs", "java", "cuda", "proto"],
  opts: {
    args: ["-assume-filename", "$FILENAME"],
    stdin: true,
  },
});

const Stylua = new Formatter({
  name: "stylua",
  exe: {
    masonPkg: "stylua",
  },
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
  exe: {
    masonPkg: "prettier",
  },
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
  exe: {
    masonPkg: "black",
  },
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
  exe: {
    masonPkg: "gersemi",
  },
  ft: ["cmake"],
  opts: {
    args: ["-"],
    stdin: true,
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
];
