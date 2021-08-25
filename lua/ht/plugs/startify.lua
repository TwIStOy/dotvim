module('ht.plugs.startify', package.seeall)

function config()
  local left_indent = '   '
  local title_file = os.getenv('HOME') .. '/.dotvim/title.txt'
  local function read_title_file()
    local lines = {}
    for line in io.lines(title_file) do
      vim.list_extend(lines, {left_indent .. line})
    end
    return lines
  end

  local header = read_title_file()
  local max_length = 0
  for i, line in ipairs(header) do
    max_length = math.max(max_length, #line)
  end

  local version_header_line = '[ ht.nvim, last updated: ' ..
                                  require('walnut.version').last_updated_time ..
                                  ' ]'
  local maintainer_header_line =
      '< MAINTAINER: Hawtian Wang(twistoy.wang@gmail.com) >'
  vim.list_extend(header, {''})
  vim.list_extend(header, {
    string.rep(' ', max_length - #version_header_line) .. version_header_line
  })
  vim.list_extend(header, {
    string.rep(' ', max_length - #maintainer_header_line) ..
        maintainer_header_line
  })

  local list_order = {
    {' Recent Files:'}, 'files', {' Project Files:'}, 'dir', {' Sessions:'},
    'sessions', {' Bookmarks:'}, 'bookmarks', {' Commands:'}, 'commands'
  }

  vim.api.nvim_set_var('startify_custom_header', header)
  vim.api.nvim_set_var('startify_list_order', list_order)
end

-- vim: et sw=2 ts=2

