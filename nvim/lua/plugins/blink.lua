return {
    "saghen/blink.cmp",
    opts = {
        completion = {
            accept = { auto_brackets = { enabled = false } },
            list = {
                max_items = 5, -- shrink the popup
            },
            menu = {
                auto_show = false, -- don't auto popup, trigger manually
            },
        },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
            transform_items = function(_, items)
                return items
            end,
            min_keyword_length = 3,
        },
        keymap = {
            preset = "default",
            ["<C-CR>"] = { "show", "show_documentation", "hide_documentation" },

            -- Override Tab to prioritize blink.cmp when menu is visible
            ["<Tab>"] = {
                function(cmp)
                    if cmp.is_visible() then
                        return cmp.select_next()
                    else
                        -- Fallback to default Tab behavior
                        return false
                    end
                end,
                "fallback",
            },
            ["<S-Tab>"] = {
                function(cmp)
                    if cmp.is_visible() then
                        return cmp.select_prev()
                    else
                        return false
                    end
                end,
                "fallback",
            },

            -- Accept completion
            ["<CR>"] = { "accept", "fallback" },

            -- Close menu
            ["<C-e>"] = { "hide" },
            ["<Esc>"] = { "hide", "fallback" },
        },
    },
}
