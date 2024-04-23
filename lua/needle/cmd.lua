local marks = require("needle.marks")

local M = {}

local group = vim.api.nvim_create_augroup("Needle", { clear = true })

local function auto_cmds()
    vim.api.nvim_create_autocmd("BufEnter", {
        group = group,
        pattern = "*",
        callback = function()
            marks.buf_enter()
        end,
    })
end

function M.setup()
    auto_cmds()
end

return M
