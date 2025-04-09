---@class snipman.SnippetMap
---@field snippets_by_ft table<string, snipman.Snippet[]>
local SnippetMap = {}

function SnippetMap.new()
	return setmetatable({
		snippets_by_ft = {},
	}, { __index = SnippetMap })
end

---@param filetype string
---@param snippet snipman.Snippet
function SnippetMap:add(filetype, snippet)
	if not self.snippets_by_ft[filetype] then
		self.snippets_by_ft[filetype] = {}
	end

	table.insert(self.snippets_by_ft[filetype], snippet)
end

---@param filetype string
---@return snipman.Snippet[]
function SnippetMap:get(filetype)
	local ft_snippets = self.snippets_by_ft[filetype] or {}
	local all_snippets = self.snippets_by_ft["all"] or {}

	return {
		unpack(all_snippets),
		unpack(ft_snippets),
	}
end

return SnippetMap
