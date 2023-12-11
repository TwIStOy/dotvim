import { isNil } from "@core/vim";

export let minLogLevel = vim.log.levels.INFO;

let _log_file: LuaFile | undefined = undefined;

function _open_log_file() {
  if (isNil(_log_file)) {
    [_log_file] = io.open("/tmp/test.log", "a");

    vim.api.nvim_create_autocmd("VimLeave", {
      callback: () => {
        _log_file?.close();
      },
    });
  }
}

function _log(level: number, fmt: string, ...args: unknown[]) {
  if (level < minLogLevel) return;

  let line = string.format(
    fmt,
    ...args.map((v) => {
      if (isNil(v)) return "nil";
      if (typeof v === "object") {
        let [x] = string.gsub(vim.inspect(v), "\n%s*", " ");
        return x;
      }
      return v;
    })
  );
  let fn = debug.getinfo(3, "n")?.name ?? "??";
  let source = debug.getinfo(3, "S")?.source ?? "??";
  let lineNo = tostring(debug.getinfo(3, "l")?.currentline ?? "??");

  // line = string.format("[%s:%s:%s]: %s", source, fn, lineNo, line);

  _open_log_file();
  if (!isNil(_log_file)) {
    _log_file.write(line + "\n");
    _log_file.flush();
  }
}

export function debug_(fmt: string, ...args: unknown[]) {
  _log(vim.log.levels.DEBUG, fmt, ...args);
}

export function info(fmt: string, ...args: unknown[]) {
  _log(vim.log.levels.INFO, fmt, ...args);
}

export function warn(fmt: string, ...args: unknown[]) {
  _log(vim.log.levels.WARN, fmt, ...args);
}

export function error_(fmt: string, ...args: unknown[]) {
  _log(vim.log.levels.ERROR, fmt, ...args);
}

export function trace(fmt: string, ...args: unknown[]) {
  _log(vim.log.levels.TRACE, fmt, ...args);
}
