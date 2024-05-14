local M = {}

local signs_cache = {}

function M.clear_signs()
	vim.fn.sign_unplace("*")
end

function M.load_signs(chars, positions, buffer_name)
	for id, char in ipairs(chars) do
		if not signs_cache[char] then
			signs_cache[char] = true
			vim.fn.sign_define("NeedleMark" .. char, { text = char, texthl = "GruvboxPurple" })
		end
		vim.fn.sign_place(id, "NeedleSigns", "NeedleMark" .. char, buffer_name, { lnum = positions[id], priority = 10 })
	end
end

return M
