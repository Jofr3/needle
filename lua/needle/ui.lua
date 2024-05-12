local M = {}

local signs_cache = {}

function M.clear_signs()
	vim.fn.sign_unplace("*")
end

function M.load_signs(marks, buffer_name)
	for id, mark in ipairs(marks) do
		if not signs_cache[mark[1]] then
			signs_cache[mark[1]] = true
			vim.fn.sign_define("NeedleMark" .. mark[1], { text = mark[1], texthl = "GruvboxPurple" })
		end
		vim.fn.sign_place(id, "NeedleSigns", "NeedleMark" .. mark[1], buffer_name, { lnum = mark[2], priority = 10 })
	end
end

return M
