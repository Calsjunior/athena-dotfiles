return {
    "stevearc/conform.nvim",
    opts = {
        formatters = {
            -- Configure clang-format
            clang_format = {
                prepend_args = { "--style=file" },
            },
            -- Configure stylua for Lua
            stylua = {
                prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
            },
            -- Configure shfmt for shell scripts
            shfmt = {
                prepend_args = { "-i", "4", "-ci" }, -- 4 spaces, switch cases indent
            },
            -- Configure prettier for JS/TS/JSON/etc
            prettier = {
                prepend_args = { "--tab-width", "4", "--use-tabs", "false" },
            },
            -- Configure black for Python
            black = {
                prepend_args = { "--line-length", "100" }, -- Black uses 4 spaces by default
            },
        },
        formatters_by_ft = {
            c = { "clang-format" },
            cpp = { "clang-format" },
            lua = { "stylua" },
            python = { "black" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            json = { "prettier" },
            jsonc = { "prettier" },
            html = { "prettier" },
            css = { "prettier" },
            sh = { "shfmt" },
        },
    },
}
