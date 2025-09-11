-- ========================
-- themes.lua (after/plugin)
-- ========================

-- === Theme Plugins Setup ===
require('gruvbox-material').setup({
    italics = true,
    contrast = "hard",
    comments = { italics = true },
    background = { transparent = false },
})

require('everforest').setup({
    background = "hard",
    transparent_background_level = 0,
    italics = true,
    disable_italic_comments = false,
})

-- === Folder & Terminal Colors ===
local function apply_colors()
    local theme = vim.g.colors_name
    local folder_color, bg_color, term_bg

    if theme == "everforest" then
        folder_color = "#a7c080"
        bg_color = "#272E33"       -- for Nvim-tree
        term_bg = "#272E33"        -- for terminal
    elseif theme == "gruvbox-material" then
        folder_color = "#d8a657"
        bg_color = "#1D2021"
        term_bg = "#1D2021"
    else
        folder_color = "#ffffff"
        bg_color = "#000000"
        term_bg = "#000000"
    end

    -- Nvim-tree
    vim.api.nvim_set_hl(0, "NvimTreeFolderIcon", { fg = folder_color })
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderIcon", { fg = folder_color })
    vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = folder_color })
    vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = folder_color })
    vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = bg_color })
    vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = bg_color })

    -- Floating windows (if you use any)
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = bg_color })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = bg_color })

    -- Terminal (ToggleTerm horizontal)
    vim.api.nvim_set_hl(0, "Normal", { bg = term_bg })
end

-- === Load Theme from File ===
local function load_theme()
    local theme_file = vim.fn.expand("~/.config/nvim/current_theme")
    local theme = "gruvbox-material"

    if vim.fn.filereadable(theme_file) == 1 then
        local content = vim.fn.readfile(theme_file)
        if #content > 0 then theme = vim.fn.trim(content[1]) end
    end

    local ok, _ = pcall(vim.cmd.colorscheme, theme)
    if not ok then
        vim.cmd.colorscheme("gruvbox-material")
        vim.notify("Failed to load theme: " .. theme, vim.log.levels.WARN)
    end

    apply_colors()
end

-- === Commands ===
vim.api.nvim_create_user_command("SwitchTheme", function(opts)
    local theme = opts.args
    if theme == "everforest" or theme == "gruvbox-material" then
        vim.cmd("colorscheme " .. theme)
        vim.fn.writefile({theme}, vim.fn.expand("~/.config/nvim/current_theme"))
        apply_colors()
    else
        print("Unknown theme: " .. theme)
    end
end, { nargs = 1 })

vim.api.nvim_create_user_command("ReloadTheme", load_theme, {})

-- === Initialize on Startup ===
load_theme()
