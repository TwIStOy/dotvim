import { readFileSync } from "./fs";

function parseOsReleaseFile(): Record<string, string> {
  const content = readFileSync("/etc/os-release");
  let ret: Record<string, string> = {};
  if (!content) {
    return ret;
  }
  const lines = content.split("\n");
  for (const line of lines) {
    const line_content = line.trim();
    if (line_content === "") {
      continue;
    }
    let key = "";
    let value = "";
    for (let i = 0; i < line_content.length; i++) {
      if (line_content[i] === "=") {
        key = line_content.slice(0, i);
        value = line_content.slice(i + 1);
        break;
      }
    }
    if (key === "" || value === "") {
      continue;
    }
    if (value[0] === '"' && value[value.length - 1] === '"') {
      value = value.slice(1, value.length - 1);
    }
    ret[key] = value;
  }
  return ret;
}

export const osRelease = parseOsReleaseFile();
