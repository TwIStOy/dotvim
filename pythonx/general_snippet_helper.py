def foldmarker():
    import vim

    return vim.eval('&foldmarker').split(',')

