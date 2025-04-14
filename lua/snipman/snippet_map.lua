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
	---@type snipman.Snippet[]
	local snippets = {}

	local all_snippets = self.snippets_by_ft["all"] or {}
	for _, value in ipairs(all_snippets) do
		table.insert(snippets, value)
	end

	local ft_snippets = self.snippets_by_ft[filetype] or {}
	for _, value in ipairs(ft_snippets) do
		table.insert(snippets, value)
	end

	return snippets
end

return SnippetMap
