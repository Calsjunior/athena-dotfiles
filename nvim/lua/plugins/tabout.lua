return {
    {
        "abecodes/tabout.nvim",
        lazy = false,
        config = function()
            require("tabout").setup({
                tabkey = "<Tab>",
                backwards_tabkey = "<S-Tab>",
                act_as_tab = true,
                act_as_shift_tab = false,
                default_tab = "<C-t>",
                default_shift_tab = "<C-d>",
                completion = false,
                tabouts = {
                    { open = "'", close = "'" },
                    { open = '"', close = '"' },
                    { open = "", close = "" },
                    { open = "(", close = ")" },
                    { open = "[", close = "]" },
                    { open = "{", close = "}" },
                    { open = "<", close = ">" },
                },
                ignore_beginning = true,
                exclude = {},
            })
        end,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        event = "InsertCharPre",
        priority = 1000,
    },
}
