local cond = require("ht.snippets.conditions.conditions")

return {
  all_lines_before_are_all_comments = cond.all_lines_before_match {
    "^%s*//.*$",
    "^%s*$",
  },
}
