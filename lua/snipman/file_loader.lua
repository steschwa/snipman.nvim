---@class snipman.FileLoader
---@field loaded_ft table<string>
local FileLoader = {
	loaded_ft = {},
}

---@param path string
---@return table
function FileLoader.load_path(path)
	---@diagnostic disable-next-line: undefined-field
	local stat = vim.uv.fs_stat(path)
	if not stat or stat.type ~= "file" then
		return {}
	end

	local exec, err = loadfile(path)
	if err or not exec then
		return {}
	end

	local ok, res = pcall(exec)
	if not ok then
		return {}
	end
	if type(res) ~= "table" then
		return {}
	end

	return res
end

return FileLoader
