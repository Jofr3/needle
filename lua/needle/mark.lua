local oi = require("needle.oi")
local ui = require("needle.ui")

local M = {}

local mark_chars = "qwertyuiopasdfghjklzxcvbnm"

local needle_data = nil
local current_buffer = nil
local current_marks = {}

function M.add_mark()
	if current_buffer == "" then
		return
	end

	if #current_marks[1] == #mark_chars then
		print("Can't add more marks!")
		return
	end

	local current_pos = vim.api.nvim_win_get_cursor(0)[1]
	for _, pos in ipairs(current_marks[2]) do
		if current_pos == pos then
			return
		end
	end

	local current_char = mark_chars:sub(#current_marks[1] + 1, #current_marks[1] + 1)
	table.insert(current_marks[1], current_char)
	table.insert(current_marks[2], current_pos)

	table.sort(current_marks[2])

	ui.clear_signs()
	ui.load_signs(current_marks[1], current_marks[2], current_buffer)

	current_buffer = current_buffer or vim.api.nvim_buf_get_name(0)
	needle_data[current_buffer] = current_marks
	oi.write_data(needle_data)
end

function M.remove_mark()
	if current_buffer == "" then
		return
	end

	if #current_marks[1] == 0 then
		return
	end

	local current_pos = vim.api.nvim_win_get_cursor(0)[1]
	for i, pos in ipairs(current_marks[2]) do
		if current_pos == pos then
			table.remove(current_marks[2], i)
		end
	end

	table.sort(current_marks[2])

	local new_chars = {}
	for i = 1, #current_marks[1] - 1, 1 do
		table.insert(new_chars, mark_chars:sub(i, i))
	end

	current_marks[1] = new_chars

	ui.clear_signs()
	ui.load_signs(current_marks[1], current_marks[2], current_buffer)

	current_buffer = current_buffer or vim.api.nvim_buf_get_name(0)
	needle_data[current_buffer] = current_marks
	oi.write_data(needle_data)
end

function M.jump_to_mark(char)
	for i, mark_char in ipairs(current_marks[1]) do
		if mark_char == char then
			vim.api.nvim_win_set_cursor(0, { current_marks[2][i], 0 })
			return
		end
	end
end

function M.jump_to_next()
	local current_pos = vim.api.nvim_win_get_cursor(0)[1]
	for i, pos in ipairs(current_marks[2]) do
		if current_pos == pos and #current_marks[2] ~= i then
			vim.api.nvim_win_set_cursor(0, { current_marks[2][i + 1], 0 })
			return
		end
	end

	for i, pos in ipairs(current_marks[2]) do
		if i == 1 then
			if current_pos > 0 and current_pos < pos then
				vim.api.nvim_win_set_cursor(0, { pos, 0 })
				return
			end
		else
			if current_pos > current_marks[2][i - 1] and current_pos < pos then
				vim.api.nvim_win_set_cursor(0, { pos, 0 })
				return
			end
		end
	end
end

function M.jump_to_prev()
	local current_pos = vim.api.nvim_win_get_cursor(0)[1]
	for i, pos in ipairs(current_marks[2]) do
		if current_pos == pos and i ~= 1 then
			vim.api.nvim_win_set_cursor(0, { current_marks[2][i - 1], 0 })
		end
	end

	for i, pos in ipairs(current_marks[2]) do
		if i ~= 1 then
			if current_pos > current_marks[2][i - 1] and current_pos < pos then
				vim.api.nvim_win_set_cursor(0, { current_marks[2][i - 1], 0 })
				return
			end
		end
	end
end

function M.clear_marks()
	current_marks = { {}, {} }

	current_buffer = current_buffer or vim.api.nvim_buf_get_name(0)
	needle_data[current_buffer] = current_marks

	ui.clear_signs()
	oi.write_data(needle_data)
end

function M.update_marks()
	local buffer_signs = vim.fn.sign_getplaced(current_buffer, { group = "NeedleSigns" })
	local signs = buffer_signs[1]["signs"]

	current_buffer = current_buffer or vim.api.nvim_buf_get_name(0)
	for i, sign in ipairs(signs) do
		local new_pos = sign["lnum"]
		current_marks[2][i] = new_pos
	end

	needle_data[current_buffer] = current_marks
end

function M.save_marks()
	oi.write_data(needle_data)
end

function M.buf_enter()
	current_buffer = vim.api.nvim_buf_get_name(0)
	if current_buffer == "" then
		return
	end

	ui.clear_signs()

	needle_data = oi.read_data()
	current_marks = needle_data and needle_data[current_buffer] or { {}, {} }

	if #current_marks[1] ~= 0 then
		ui.load_signs(current_marks[1], current_marks[2], current_buffer)
	else
		needle_data[current_buffer] = { {}, {} }
		oi.write_data(needle_data)
	end
end

return M
