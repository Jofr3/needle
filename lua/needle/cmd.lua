local mark = require("needle.mark")

local M = {}

local mark_chars = "qwertyuiopasdfghjklzxcvbn"

local group = vim.api.nvim_create_augroup("Needle", { clear = true })

local function auto_cmds()
	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		pattern = "*",
		callback = function()
			mark.buf_enter()
		end,
	})

	vim.api.nvim_create_autocmd({ "BufLeave", "VimLeavePre" }, {
		group = group,
		pattern = "*",
		callback = function()
			mark.save_marks()
		end,
	})

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = group,
		pattern = "*",
		callback = function()
			mark.update_marks()
		end,
	})
end

local function user_cmds()
	vim.api.nvim_create_user_command("NeedleAddMark", mark.add_mark, {})
	vim.api.nvim_create_user_command("NeedleRemoveMark", mark.remove_mark, {})
	vim.api.nvim_create_user_command("NeedleClearMarks", mark.clear_marks, {})
	vim.api.nvim_create_user_command("NeedleJumpToMark", function(opts)
		mark.jump_to_mark(opts.args)
	end, { nargs = 1 })
end

local function mapings_cmds()
	vim.api.nvim_set_keymap(
		"n",
		"M",
		"<cmd>:lua require('needle.mark').add_mark()<cr>",
		{ noremap = true, silent = true }
	)

	vim.api.nvim_set_keymap(
		"n",
		"dm",
		"<cmd>:lua require('needle.mark').remove_mark()<cr>",
		{ noremap = true, silent = true }
	)

	vim.api.nvim_set_keymap(
		"n",
		"dM",
		"<cmd>:lua require('needle.mark').clear_marks()<cr>",
		{ noremap = true, silent = true }
	)

	for char in mark_chars:gmatch(".") do
		vim.api.nvim_set_keymap(
			"n",
			"m" .. char,
			"<cmd>:lua require('needle.mark').jump_to_mark('" .. char .. "')<cr>",
			{ noremap = true, silent = true }
		)
	end

	vim.api.nvim_set_keymap(
		"n",
		"m[",
		"<cmd>:lua require('needle.mark').jump_to_next()<cr>",
		{ noremap = true, silent = true }
	)

	vim.api.nvim_set_keymap(
		"n",
		"m]",
		"<cmd>:lua require('needle.mark').jump_to_prev()<cr>",
		{ noremap = true, silent = true }
	)
end

function M.setup()
	user_cmds()
	auto_cmds()
	mapings_cmds()
end

return M
