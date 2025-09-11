vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("nvim-tree").setup({
    sort = { sorter = "case_sensitive" },
    view = { width = 30 },
    renderer = { group_empty = true, highlight_git = true, highlight_opened_files = "name" },
    filters = { dotfiles = true },
})
