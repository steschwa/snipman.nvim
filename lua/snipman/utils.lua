local Utils = {}

---@param ... table
---@return table
function Utils.table_merge(...)
	local out = {}

	for _, value in ipairs(...) do
		vim.print(vim.inspect(value))
		table.insert(out, value)
	end

	return out
end

return Utils
