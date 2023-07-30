local function trim(s)
  return s:match("^()%s*$") and "" or s:match("^%s*(.*%S)")
end

return {
  trim = trim,
}
