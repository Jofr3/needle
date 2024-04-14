local cmd = require('needle.cmd')
local marks = require('needle.marks')

cmd.setup()

local M = {}

function M.setup()
	local group = vim.api.nvim_create_augroup("Needle", { clear = true })

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		pattern = "*",
		callback = function()
            vim.cmd("wshada!")
		end,
	})

	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		pattern = "*",
		callback = function()
            marks.setup_signcol(vim.api.nvim_get_current_buf())
		end,
	})
end

return M
