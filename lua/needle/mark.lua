local oi = require("needle.oi")
local ui = require("needle.ui")

local M = {}

local mark_chars = { "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" }

local needle_data = {}

local current_buffer = nil
local current_marks = {}

function M.add_mark()
	if current_buffer == "" or current_buffer == nil then
		return
	end

	local mark_count = 0
	for _, _ in pairs(current_marks) do
		mark_count = mark_count + 1
	end

	if mark_count == #mark_chars then
		print("Can't add more marks!")
		return
	end

	local position = tostring(vim.api.nvim_win_get_cursor(0)[1])
	if current_marks ~= nil or current_marks ~= {} then
		if current_marks[position] ~= nil then
			return
		end
	end

	current_marks[position] = true

	ui.clear_signs(current_buffer)
	ui.load_signs(current_marks, mark_chars, current_buffer)

	print(current_buffer)
	needle_data[current_buffer] = current_marks
	oi.write_data(needle_data)
end

function M.remove_mark()
	if current_buffer == "" or current_buffer == nil then
		return
	end

	if current_marks == nil or current_marks == {} then
		return
	end

	local position = tostring(vim.api.nvim_win_get_cursor(0)[1])
	current_marks[position] = nil

	ui.clear_signs(current_buffer)
	ui.load_signs(current_marks, mark_chars, current_buffer)

	needle_data[current_buffer] = current_marks
	oi.write_data(needle_data)
end

function M.jump_to_mark(index)
	if mark_chars[tonumber(index)] == nil then
		return
	end

	local positions = {}
	for position, _ in pairs(current_marks) do
		table.insert(positions, position)
	end

	table.sort(positions)

	local position = positions[tonumber(index)]
	if position ~= nil then
		vim.api.nvim_win_set_cursor(0, { tonumber(position), 0 })
	end
end

local function find_next_mark(position, marks)
	local next_mark = nil
	for i = 1, #marks do
		if marks[i] > position and (next_mark == nil or marks[i] < next_mark) then
			next_mark = marks[i]
		end
	end

	return next_mark
end

local function find_prev_mark(position, marks)
	local next_mark = nil
	for i = 1, #marks do
		if marks[i] < position and (next_mark == nil or marks[i] > next_mark) then
			next_mark = marks[i]
		end
	end

	return next_mark
end

function M.jump_to_next()
	if current_buffer == "" or current_buffer == nil then
		return
	end

	if current_marks == nil or current_marks == {} then
		return
	end

	local marks = {}
	for mark, _ in pairs(current_marks) do
		table.insert(marks, tonumber(mark))
	end

	table.sort(marks)

	local position = vim.api.nvim_win_get_cursor(0)[1]
	local next_mark = find_next_mark(position, marks)

	if next_mark ~= nil then
		vim.api.nvim_win_set_cursor(0, { next_mark, 0 })
	end
end

function M.jump_to_prev()
	if current_buffer == "" or current_buffer == nil then
		return
	end

	if current_marks == nil or current_marks == {} then
		return
	end

	local marks = {}
	for mark, _ in pairs(current_marks) do
		table.insert(marks, tonumber(mark))
	end

	table.sort(marks)

	local position = vim.api.nvim_win_get_cursor(0)[1]
	local prev_mark = find_prev_mark(position, marks)

	if prev_mark ~= nil then
		vim.api.nvim_win_set_cursor(0, { prev_mark, 0 })
	end
end

function M.clear_marks()
	if current_buffer == "" or current_buffer == nil then
		return
	end

	if current_marks == nil or current_marks == {} then
		return
	end

  current_marks = {}
	needle_data[current_buffer] = nil

	ui.clear_signs(current_buffer)
	oi.write_data(needle_data)
end

function M.clear_cache()
	for buffer, _ in pairs(needle_data) do
		if needle_data[buffer] == {} then
			needle_data[buffer] = nil
		end
	end

	oi.write_data(needle_data)
end

function M.buf_enter()
	current_buffer = vim.api.nvim_buf_get_name(0)
	if current_buffer == "" then
		return
	end

	ui.clear_signs(current_buffer)

	needle_data = oi.read_data()
	current_marks = needle_data and needle_data[current_buffer] or {}

	if current_marks == {} then
		return
	end

	ui.load_signs(current_marks, mark_chars, current_buffer)
end

function M.update_marks() end

return M
