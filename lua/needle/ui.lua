local M = {}

M.sign_cache = {}

function M.load_marks(marks, buffer_name)
    vim.opt.signcolumn = "auto"
    vim.fn.sign_unplace("NeedleSigns", { buffer = buffer_name })

    if #marks == 0 then
        return
    end

    for id, mark in ipairs(marks) do
        if not M.sign_cache[mark] then
            vim.fn.sign_define("NeedleMark" .. id, { text = mark[1], texthl = "GruvboxPurple" })
        end

        vim.fn.sign_place(id, "NeedleSigns", "NeedleMark" .. id, buffer_name, { lnum = mark[2][1], priority = 10 })
    end
end

function M.clear_marks()
    vim.fn.sign_undefine()
    vim.fn.sign_unplace("*", { buffer = 0 })

    vim.opt.signcolumn = "auto"
end

return M
