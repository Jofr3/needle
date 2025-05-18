local M = {}

local signs_cache = {}

function M.clear_signs(current_buffer)
	vim.fn.sign_unplace("NeedleSigns", { buffer = current_buffer })
end

function M.load_signs(marks, chars, buffer_name)
	local keys = {}
	for key, _ in pairs(marks) do
		table.insert(keys, key)
	end

	table.sort(keys)

	for i, key in ipairs(keys) do
		local char = chars[i]

		if not signs_cache[char] then
			signs_cache[char] = true
			vim.fn.sign_define("NeedleMark" .. char, { text = char, texthl = "GruvboxPurple" })
		end

		vim.fn.sign_place(key, "NeedleSigns", "NeedleMark" .. char, buffer_name, { lnum = key, priority = 10000 })
	end
end

return M
