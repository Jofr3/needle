local ui = require("needle.ui")

local M = {}

local buffer_name = ""
local mark_chars = "qwertyuipasdfghjklzxcvbnm"
local mark_counter = 1

local function get_marks()
    local marks = {}

    for mark in mark_chars:gmatch(".") do
        local pos = vim.api.nvim_buf_get_mark(0, mark)
        if pos[1] ~= 0 then
            table.insert(marks, { mark, pos })
        end
    end

    return marks
end


function M.jump_to_mark(mark)
    local pos = vim.api.nvim_buf_get_mark(0, mark)
    if pos[1] ~= 0 then
        vim.api.nvim_win_set_cursor(0, pos)
    end
end

local function check_marks(marks, pos)
    for i, mark in ipairs(marks) do
        if mark[2][1] == pos[1] then
            return true
        end
    end
    return false
end

function M.clear_marks()
    for mark in mark_chars:gmatch(".") do
        vim.api.nvim_buf_del_mark(0, mark)
    end

    mark_counter = 1
    ui.clear_marks()
    vim.cmd("wshada!")
end

function M.add_mark()
    if not buffer_name then
        print("Can't add mark!")
        return
    end

    if mark_counter == #mark_chars then
        print("Can't add more marks!")
        return
    end

    local marks = get_marks()
    local pos = vim.api.nvim_win_get_cursor(0)
    if check_marks(marks, pos) then
        print("Already a mark in this line!")
        return
    end

    if #marks ~= 0 then
        mark_counter = #marks + 1
    end

    local new_char = string.sub(mark_chars, mark_counter, mark_counter)
    vim.api.nvim_buf_set_mark(0, new_char, pos[1], 0, {})

    table.insert(marks, { new_char, pos })
    table.sort(marks, function(a, b)
        return a[2][1] < b[2][1]
    end)

    for i, mark in ipairs(marks) do
        local char = string.sub(mark_chars, i, i)
        vim.api.nvim_buf_set_mark(0, char, mark[2][1], 0, {})
    end

    local new_marks = get_marks()
    ui.load_marks(new_marks, buffer_name)
    vim.cmd("wshada!")
end

function M.delete_mark()
    local marks = get_marks()

    if #marks == 0 then
        return
    end

    local pos = vim.api.nvim_win_get_cursor(0)
    for i, mark in ipairs(marks) do
        if mark[2][1] == pos[1] then
            local char = string.sub(mark_chars, i, i)
            vim.api.nvim_buf_del_mark(0, char)
            table.remove(marks, i)
            break
        end
    end

    table.sort(marks, function(a, b)
        return a[2][1] < b[2][1]
    end)

    M.clear_marks()

    for i, mark in ipairs(marks) do
        local char = string.sub(mark_chars, i, i)
        vim.api.nvim_buf_set_mark(0, char, mark[2][1], 0, {})
    end

    mark_counter = mark_counter > 1 and mark_counter - 1 or mark_counter
    local new_marks = get_marks()
    ui.load_marks(new_marks, buffer_name)
    vim.cmd("wshada!")
end

local function load_marks(marks)
    ui.clear_marks()
    ui.sign_cache = {}

    table.sort(marks, function(a, b)
        return a[2][1] < b[2][1]
    end)

    for i, mark in ipairs(marks) do
        local char = string.sub(mark_chars, i, i)
        vim.api.nvim_buf_set_mark(0, char, mark[2][1], 0, {})
    end

    local new_marks = get_marks()
    ui.load_marks(new_marks, buffer_name)
end

function M.buf_enter()
    buffer_name = vim.api.nvim_buf_get_name(0)
    if buffer_name == "" then
        return
    end

    local marks = get_marks()
    if #marks ~= 0 then
        mark_counter = #marks + 1
        load_marks(marks)
    end
end

return M
