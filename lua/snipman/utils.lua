local Utils = {}

---@param ... table
---@return table
function Utils.table_merge(...)
	local out = {}

	for _, value in ipairs(...) do
		table.insert(out, value)
	end

	return out
end

return Utils
