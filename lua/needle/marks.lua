local ui = require("needle.ui")

local M = {}

local mark_chars = "qwertyuipasdfghjklzxcvbnm"

local function get_marks()
	local marks = {}

	for mark in mark_chars:gmatch(".") do
		local pos = vim.api.nvim_buf_get_mark(0, mark)
		if pos[1] ~= 0 then
			table.insert(marks, pos)
		end
	end

	return marks
end

function M.clear_marks()
	for mark in mark_chars:gmatch(".") do
		vim.api.nvim_buf_del_mark(0, mark)
	end

    M.setup_signcol()
end

function M.jump_to_mark(mark)
    local pos = vim.api.nvim_buf_get_mark(0, mark)
    if pos[1] ~= 0 then
        vim.api.nvim_win_set_cursor(0, pos)
    end
end

function M.check_marks(pos)
	local current_marks = get_marks()
	for key, mark in ipairs(current_marks) do
        if mark[1] == pos[1] and mark[2] == pos[2] then
            return true
        end
	end
    return false
end

local function sort_marks(marks)
    table.sort(marks, function(a, b)
        if a[1] == b[1] then
            return a[2] < b[2]
        end
        return a[1] < b[1]
    end)

    return marks
end

local function get_mark_signs()
    local marks = get_marks()
    local mark_signs = {}

    for key, mark in ipairs(marks) do
        local char = string.sub(mark_chars, key, key)
        table.insert(mark_signs, { char, mark })
    end

    return mark_signs
end

local function set_marks()
    local marks = sort_marks(get_marks())

	M.clear_marks()

	for key, mark in ipairs(marks) do
        local char = string.sub(mark_chars, key, key)
		vim.api.nvim_buf_set_mark(0, char, mark[1], mark[2], {})
	end

    M.setup_signcol()
end

function M.add_mark()
    if M.check_marks(vim.api.nvim_win_get_cursor(0)) then
        return
    end

	local pos = vim.api.nvim_win_get_cursor(0)
	vim.api.nvim_buf_set_mark(0, "m", pos[1], pos[2], {})

    set_marks()
end

function M.delete_mark()
    local pos = vim.api.nvim_win_get_cursor(0)
    local marks = get_marks()

    for key, mark in ipairs(marks) do
        if mark[1] == pos[1] then
            local char = string.sub(mark_chars, key, key)
            vim.api.nvim_buf_del_mark(0, char)
        end
    end

    set_marks()
end

function M.setup_signcol()
    ui.setup_signcol(get_mark_signs(), vim.api.nvim_get_current_buf())
end

return M
