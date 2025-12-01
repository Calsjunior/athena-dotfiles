local api = vim.api

-- Don't auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Restore terminal clear
vim.api.nvim_create_autocmd("TermEnter", {
    callback = function(ev)
        vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = ev.buf, nowait = true })
    end,
})

-- Fix lazygit terminal escape key override
vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        local bufname = vim.api.nvim_buf_get_name(0)

        -- Check if it's lazygit terminal
        if bufname:match("lazygit") then
            vim.keymap.set("t", "<Esc>", "<Esc>", { buffer = true, nowait = true })
        else
            vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = true })
        end
    end,
})

-- Auto activate python env if detected
local function activate_venv()
    local venv_paths = {
        vim.fn.getcwd() .. "/venv",
        vim.fn.getcwd() .. "/.venv",
        vim.fn.getcwd() .. "/env",
    }

    for _, path in ipairs(venv_paths) do
        local python_path = path .. "/bin/python"
        if vim.fn.executable(python_path) == 1 then
            vim.env.VIRTUAL_ENV = path
            vim.env.PATH = path .. "/bin:" .. vim.env.PATH
            vim.notify("🐍 Activated: " .. vim.fn.fnamemodify(path, ":t"))
            return true
        end
    end
    return false
end
vim.api.nvim_create_autocmd("DirChanged", { callback = activate_venv })

-- Auto indent after closing attribute tags
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "html", "htmldjango", "xml", "javascriptreact", "typescriptreact" },
    callback = function()
        vim.keymap.set("i", "<CR>", function()
            -- If blink.cmp is active, let it handle <CR>
            local ok, blink_cmp = pcall(require, "blink.cmp")
            if ok and blink_cmp.is_visible and blink_cmp.is_visible() then
                blink_cmp.accept()
                return ""
            end

            local line = vim.api.nvim_get_current_line()
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            local before = line:sub(1, col)
            local after = line:sub(col + 1)

            -- Check if between tags: >|</
            if before:match(">$") and after:match("^</") then
                return "<CR><Esc>O"
            end

            -- Normal enter
            return "<CR>"
        end, { buffer = true, expr = true, desc = "Smart enter for HTML tags" })
    end,
})

-- Fix python's stupid indents
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "python" },
    callback = function()
        vim.bo.indentexpr = "v:lua.LazyVim.treesitter.indentexpr()"
        -- vim.bo.indentexpr = "nvim_treesitter#indent()"
        vim.bo.autoindent = true
        vim.bo.smartindent = false
    end,
})
