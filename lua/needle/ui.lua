local M = {}

local sign_group = "NeedleSigns"

local function setup_placehorlders(bufnr)
	local max_lines = vim.api.nvim_buf_line_count(bufnr)

	for i = 1, max_lines do
	    vim.fn.sign_define("PlaceholderSign" .. i, { text = " ", texthl = "GruvboxPurple" })
		vim.fn.sign_place(0, "NeedleSigns", "PlaceholderSign" .. i, bufnr, { lnum = i, priority = 1 })
	end
end

local function def_mark_sign(marks)
	for key, mark in ipairs(marks) do
		vim.fn.sign_define("Mark" .. mark[1], { text = mark[1], texthl = "GruvboxPurple" })
	end
end

local function place_mark_sign(marks, bufnr)
	for key, mark in ipairs(marks) do
        vim.fn.sign_undefine("PlaceholderSign" .. mark[2][1])
		vim.fn.sign_unplace("PlaceholderSign" .. mark[2][1], { buffer = bufnr })
		vim.fn.sign_place(key, sign_group, "Mark" .. mark[1], bufnr, { lnum = mark[2][1], priority = 1 })
	end
end

function M.setup_signcol(marks, bufnr)
	vim.fn.sign_undefine()
	vim.fn.sign_unplace("Mark*", { buffer = bufnr })

	if #marks == 0 then
		vim.opt.signcolumn = "yes:1"
		return
	end

	vim.opt.signcolumn = "yes:2"

	setup_placehorlders(bufnr)
	def_mark_sign(marks)
	place_mark_sign(marks, bufnr)
end

return M
