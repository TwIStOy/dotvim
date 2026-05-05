_: {
  opts = {
    title = false;
    termguicolors = true;
    updatetime = 100;
    redrawtime = 1500;
    timeout = true;
    ttimeout = true;
    ttimeoutlen = 10;
    foldcolumn = "0";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
    splitright = true;
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions";
    number = true;
    relativenumber = true;
    signcolumn = "yes";
    cursorline = true;
    guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,n-v-c:blinkon500-blinkoff500,a:Cursor/lCursor";
    mouse = "a";
    mousemoveevent = true;
    laststatus = 3;
    expandtab = true;
    smartindent = true;
    autoindent = true;
    tabstop = 2;
    shiftwidth = 2;
    showmode = false;
    cmdheight = 1;
    exrc = true;
    wrap = true;
    fillchars = "eob: ";
    scrolloff = 5;
    timeoutlen = 300;
    hidden = true;
    jumpoptions = "stack";
    smoothscroll = true;
    virtualedit = "block";
    backup = false;
    writebackup = false;
    swapfile = false;
  };

  extraConfigLua = ''
    vim.cmd([[set noerrorbells novisualbell t_vb=]])
    vim.cmd.cnoreabbrev("qw", "wq")
    vim.cmd.cnoreabbrev("W", "w")
    vim.cmd.cnoreabbrev("Wq", "wq")
    vim.cmd.cnoreabbrev("WQ", "wq")
  '';
}
