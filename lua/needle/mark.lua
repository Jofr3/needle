local oi = require("needle.oi")
local ui = require("needle.ui")

local M = {}

local mark_chars = "qwertyuiopasdfghjklzxcvbnm"
local chars_value = {}

local needle_data = nil
local current_buffer = nil
local current_marks = nil

function M.setup()
	for i = 1, #mark_chars do
		local char = mark_chars:sub(i, i)
		chars_value[char] = i
	end
end

function M.add_mark()
	if current_buffer == "" then
		return
	end

	current_marks = current_marks or {}

	-- NOT SORTING CORRECLY
	table.sort(current_marks, function(a, b)
		return chars_value[a[1]] < chars_value[b[1]]
	end)

	local current_char = mark_chars:sub(#current_marks + 1, #current_marks + 1)
	table.insert(current_marks, { current_char, vim.api.nvim_win_get_cursor(0)[1] })

	ui.clear_signs()
	ui.load_signs(current_marks, current_buffer)

	current_buffer = current_buffer or vim.api.nvim_buf_get_name(0)
	needle_data[current_buffer] = current_marks
	oi.write_data(needle_data)
end

function M.buf_enter()
	current_buffer = vim.api.nvim_buf_get_name(0)
	if current_buffer == "" then
		return
	end

	ui.clear_signs()

	needle_data = oi.read_data()
	current_marks = needle_data and needle_data[current_buffer] or {}

	local i = 0
	for _ in pairs(current_marks) do
		i = i + 1
	end

	if i ~= 0 then
		ui.load_signs(current_marks, current_buffer)
	else
		needle_data[current_buffer] = current_marks
		oi.write_data(needle_data)
	end
end

return M
