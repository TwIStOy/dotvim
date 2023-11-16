export function toIcon(code: string | number) {
  if (typeof code === "string") {
    code = tonumber(`0x${code}`)!;
  }
  if (code <= 0x7f) {
    return string.char(code);
  }
  let t = [];
  if (code <= 0x07ff) {
    t[0] = string.char(bit.bor(0xc0, bit.rshift(code, 6)));
    t[1] = string.char(bit.bor(0x80, bit.band(code, 0x3f)));
  } else if (code <= 0xffff) {
    t[0] = string.char(bit.bor(0xe0, bit.rshift(code, 12)));
    t[1] = string.char(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)));
    t[2] = string.char(bit.bor(0x80, bit.band(code, 0x3f)));
  } else {
    t[0] = string.char(bit.bor(0xf0, bit.rshift(code, 18)));
    t[1] = string.char(bit.bor(0x80, bit.band(bit.rshift(code, 12), 0x3f)));
    t[2] = string.char(bit.bor(0x80, bit.band(bit.rshift(code, 6), 0x3f)));
    t[3] = string.char(bit.bor(0x80, bit.band(code, 0x3f)));
  }
  return table.concat(t);
}
