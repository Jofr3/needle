local file_path = vim.fn.stdpath("data") .. "/needle.json"

local M = {}

function M.read_data()
	local file = io.open(file_path, "r")
	if file then
		local output = file:read("*a")
		file:close()
		if output ~= "" then
			return vim.json.decode(output)
		end
	end
	return {}
end

function M.write_data(data)
	local file = io.open(file_path, "w")
	if file then
		local input = vim.json.encode(data)
		file:write(input)
		file:close()
	end
end

return M
