local marks = require("needle.marks")

local M = {}

function M.setup()
	vim.api.nvim_create_user_command("NeedleClearMarks", marks.clear_marks, {})
	vim.api.nvim_create_user_command("NeedleAddMark", marks.add_mark, {})
	vim.api.nvim_create_user_command("NeedleDeleteMark", marks.delete_mark, {})
	vim.api.nvim_create_user_command("NeedleJumpToMark", function(opts)
		marks.jump_to_mark(opts.args)
	end, { nargs = 1 })
end

return M
