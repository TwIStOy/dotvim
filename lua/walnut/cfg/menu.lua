module('walnut.cfg.menu', package.seeall)

local vcall = vim.api.nvim_call_function

-- Setup Menu Items

function setup_menu_items()
  require('walnut.pcfg.quickui').update_color()

  vcall('quickui#menu#reset', {})

  -- File
  vcall('quickui#menu#install', {
    '&File', {
      {
        '&Open...',
        [[lua require('walnut.pcfg.leaderf').open_project_root()]],
        'open file under project root',
      },
      { 'Open Recent', 'Leaderf mru', 'open file recently used' },
      { '--', '' },
      { '&Save', 'update', 'update all files' },
      { 'Save All', 'wa', 'force update all files' },
      { '--', '' },
      { 'Save and Quit', 'xall', 'update all changed buffers and exit' },
      { '&Quit', 'quit', 'exit' },
    }, 1
  })

  -- Edit
  vcall('quickui#menu#install', {
    '&Edit', {
    }, 2
  })

  -- View
  vcall('quickui#menu#install', {
    '&View', {
      {
        '&File Explorer\t<F3>',
        [[lua require('walnut.window').fast_forward_to_file_explorer()]],
        'fast forward to file explorer'
      },
      { '&Terminal\t<C-t>', 'ToggleTerm', 'toggle term display' },
      {
        '&Quickfix\ttq',
        [[lua require('walnut.window').toggle_quickfix()]],
        'toggle quickfix window'
      },
      {
        '&Buffers\t<F4>',
        [[call quickui#tools#list_buffer('e')]],
        'list buffers'
      },
      { '--', '' },
      { '&Outlines', 'CocList outline', 'view outlines' },
      { '&Problems', 'CocList diagnostics', 'view diagnostics' },
      { '--', '' },
      { '&Wiki Index', 'VimwikiIndex', 'open wiki index' },
      { 'Wiki Index(new &tab)', 'VimwikiTabIndex', 'open wiki index in new tab' },
      { 'Wiki &Select', 'VimwikiUISelect', 'select wiki index and open it' },
      { 'Diary Wiki Index', 'VimwikiDiaryIndex', 'open diary wiki index' },
      { '&Diary Note', 'VimwikiMakeDiaryNote', 'create or open diary note' },
    }, 3
  })

  vcall('quickui#menu#install', {
    '&Run', {
    }, 4
  })

  -- Terminal
  vcall('quickui#menu#install', {
    '&Terminal', {
      { '&Toggle\t<C-t>', 'ToggleTerm', 'toggle term display' },
      {
        '&Exec',
        [[lua require('walnut.cfg.term').input_cmd_and_exec()]],
        'input command and exec'
      },
    }, 5
  })

  vcall('quickui#menu#install', {
    '&Wiki', {
      { 'Go &Back', 'VimwikiGoBackLink', 'go back to the wiki page you came from' },
      { '&Split Link', 'VimwikiSplitLink 1 1', 'split and follow wiki link' },
      { '&Next Link', 'VimwikiNextLink', 'find next link on the current page' },
      { '&Previous Link', 'VimwikiPrevLink', 'find previous link on the current page' },
      { '&Goto...', 'VimwikiGoto', 'goto or crate new wiki page' },
      { '--', '' },
      { 'Delete Page', 'VimwikiDeleteFile', 'delete the wiki page you are in' },
      { '&Rename page', 'VimwikiRenameFile', 'rename the wiki page you are in' },
      { '2HTML', 'Vimwiki2HTML', 'convert current wiki page to HTML' },
      { 'All2HTML', 'VimwikiAll2HTML', 'convert all wiki pages to HTML' },
      { '--', '' },
      {
        'Rebuild Tags',
        'VimwikiRebuildTags',
        'rebuild the tags metadata file for all wiki files newer than the metadata file'
      },
    }, 6, 'vimwiki'
  })

  -- Help
  vcall('quickui#menu#install', {
    '&Help', {
    }, 10000
  })
end
