-- ========================
-- Ultimate-AutoPair Setup
-- ========================
require("ultimate-autopair").setup({
    check_ts = true,              -- Use Treesitter to improve pairing
    enable_afterquote = true,      -- Automatically insert after quotes
    enable_check_bracket_line = true,
})

-- ========================
-- nvim-surround Setup
-- ========================
require("nvim-surround").setup({
    -- normal_mode = "ys", visual_mode = "S", delete = "ds", change = "cs"
})

-- ========================
-- Comment.nvim Setup
-- ========================
require("Comment").setup({
    ---Add a space b/w comment and the line
    padding = true,
    ---Whether the cursor should stay at its position
    sticky = true,
    ---Lines to be ignored while (un)comment
    ignore = nil,

    toggler = {
        line = "gcc",   -- Toggle line comment
        block = "gbc",  -- Toggle block comment
    },
    opleader = {
        line = "gc",    -- Operator-pending line comment
        block = "gb",   -- Operator-pending block comment
    },
    extra = {
        above = "gcO",  -- Insert comment above
        below = "gco",  -- Insert comment below
        eol = "gcA",    -- Insert comment at end of line
    },
})

-- ========================
-- Tabout Setup
-- ========================
require("tabout").setup({
    tabkey = "<Tab>",             -- key to move forward
    backwards_tabkey = "<S-Tab>", -- key to move backward
    act_as_tab = true,            -- shift content if not inside a pair
    enable_backwards = true,      -- allow shift+tab to move backward
    completion = true,            -- integrate with nvim-cmp
})
