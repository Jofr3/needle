local mark = require("needle.mark")

local M = {}

local group = vim.api.nvim_create_augroup("Needle", { clear = true })

local function auto_cmds()
	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		pattern = "*",
		callback = function()
			mark.buf_enter()
		end,
	})
end

local function user_cmds()
	-- vim.api.nvim_create_user_command("NeedlePrintFilename", mark.print_filename, {})
end

function M.setup()
	user_cmds()
	auto_cmds()
end

return M
