module('ht.conf.menu', package.seeall)

local call = vim.api.nvim_call_function

local function split_category(category)
  local t = {}
  for str in string.gmatch(category, "([^:]+)") do
    table.insert(t, str)
  end

  if #t == 2 then
    return { t[1], nil, tonumber(t[2]) }
  end
  if #t == 3 then
    return { t[1], nil, tonumber(t[2]), t[3] }
  end
  return { t[1], nil }
end

local function install_menus(menus)
  for category, menu in pairs(menus) do
    local arg = split_category(category)
    arg[2] = menu
    call('quickui#menu#install', arg)
  end
end

local menus = {
  ["&File:1"] = {
    {
      '&Open...\t<leader>e',
      [[lua require('ht.actions.file').OpenProjectRoot()]],
      'open file under project root'
    }, {'Open Recent', 'Leaderf mru', 'open file recently used'}, {'--', ''},
    {'&Save', 'update', 'update all files'},
    {'Save All', 'wa', 'force update all files'}, {'--', ''},
    {'Save and Quit', 'xall', 'update all changed buffers and exit'},
    {'&Quit', 'quit', 'exit'}
  },
  ["&Edit:2"] = {
    {'New &Grep', [[Leaderf rg]], 'grep keyword in project root'},
    {'&Recall Grep', [[Leaderf rg --recall]], 'reopen previous grep context'},
    {'--', ''},
    {'Toggle Line &Comment\tgcc', [[TComment]], 'toggle line comment'},
    {'Toggle &Block Comment\tgcc', [[TCommentBlock]], 'toggle block comment'},
    {'--', ''},
    {'AngryReviewer', [[AngryReviewer]], 'open angry reviewer'},
  },
  ["&View:3"] = {
    {
      '&File Explorer\t<F3>',
      [[lua require('ht.core.window').JumpToFileExplorer()]],
      'fast forward to file explorer'
    }, {'&Terminal\t<C-t>', 'ToggleTerm', 'toggle term display'}, {
      '&Quickfix\ttq', [[lua require('ht.core.window').ToggleQuickfix()]],
      'toggle quickfix window'
    },
    {'&Buffers\t<F4>', [[call quickui#tools#list_buffer('e')]], 'list buffers'},
    {'--', ''}, {'&Outlines', 'SymblosOutline', 'view outlines'},
    {'&Problems', 'TroubleToggle', 'view diagnostics'}, {'--', ''},
    {'&Wiki Index', 'VimwikiIndex', 'open wiki index'},
    {'Wiki Index(new &tab)', 'VimwikiTabIndex', 'open wiki index in new tab'},
    {'Wiki &Select', 'VimwikiUISelect', 'select wiki index and open it'},
    {'Diary Wiki Index', 'VimwikiDiaryIndex', 'open diary wiki index'},
    {'&Diary Note', 'VimwikiMakeDiaryNote', 'create or open diary note'}
  },
  ["&Run:4"] = {
    {'&File Build', 'AsyncTask file-build', 'build current file'},
    {'&Project Build', 'AsyncTask project-build', 'build current project'},
    {'&Upload Binary', 'AsyncTask upload-binary', 'upload binaries'}
  },
  ["&Terminal:5"] = {
    {'&Toggle\t<C-t>', 'ToggleTerm', 'toggle term display'}, {
      '&Exec', [[lua require('ht.actions.term').InputCmdThenExec()]],
      'input command and exec'
    }
  },
  ["&Wiki:6:vimwiki"] = {
    {'Go &Back', 'VimwikiGoBackLink', 'go back to the wiki page you came from'},
    {'&Split Link', 'VimwikiSplitLink 1 1', 'split and follow wiki link'},
    {'&Next Link', 'VimwikiNextLink', 'find next link on the current page'},
    {
      '&Previous Link', 'VimwikiPrevLink',
      'find previous link on the current page'
    }, {'&Goto...', 'VimwikiGoto', 'goto or crate new wiki page'}, {'--', ''},
    {'Delete Page', 'VimwikiDeleteFile', 'delete the wiki page you are in'},
    {'&Rename page', 'VimwikiRenameFile', 'rename the wiki page you are in'},
    {'2HTML', 'Vimwiki2HTML', 'convert current wiki page to HTML'},
    {'All2HTML', 'VimwikiAll2HTML', 'convert all wiki pages to HTML'},
    {'--', ''}, {
      'Rebuild Tags', 'VimwikiRebuildTags',
      'rebuild the tags metadata file for all wiki files newer than the metadata file'
    }
  },
  ['&Git:9999'] = {
    {'&Status', 'CocList --normal gstatus', 'show the working tree status'},
    {'&Stage Chunk', 'CocCommand git.chunkStage', 'stage current chunk'}
  },
  ["&Help:10000"] = {}
}

function SetupMenuItems()
  call('quickui#menu#reset', {})

  install_menus(menus)
end

-- vim: et sw=2 ts=2 fdm=marker

