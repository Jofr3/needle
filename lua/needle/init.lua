local cmd = require("needle.cmd")
local mark = require("needle.mark")

local M = {}

function M.setup()
	cmd.setup()
	mark.setup()
end

return M
