export function getTTY() {
  let [handle] = io.popen("tty 2>/dev/null");
  if (!handle) return null;
  let result = handle.read("*a");
  handle.close();
  result = result?.trim();
  if (result == "") return null;
  return result;
}
