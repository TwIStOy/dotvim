export function randv4(): string {
  let template = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx";
  let [res, _] = string.gsub(template, "[xy]", (c) => {
    let v = c == "x" ? math.random(0, 0xf) : math.random(8, 0xb);
    return string.format("%x", v);
  });
  return res;
}
