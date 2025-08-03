---@class snipman.SnippetMap
---@field snippets_by_ft table<string, snipman.Snippet[]>
---@field snippets_for_all snipman.Snippet[]
local SnippetMap = {}

function SnippetMap.new()
	return setmetatable({
		snippets_by_ft = {},
		snippets_for_all = {},
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

---@param snippet snipman.Snippet
function SnippetMap:add_all(snippet)
	table.insert(self.snippets_for_all, snippet)
end

---@param filetype string
---@return snipman.Snippet[]
function SnippetMap:get_for_ft(filetype)
	---@type snipman.Snippet[]
	local snippets = {}

	for _, value in ipairs(self.snippets_for_all) do
		table.insert(snippets, value)
	end

	local ft_snippets = self.snippets_by_ft[filetype] or {}
	for _, value in ipairs(ft_snippets) do
		table.insert(snippets, value)
	end

	return snippets
end

---@return snipman.Snippet[]
function SnippetMap:get_for_all()
	return self.snippets_for_all
end

return SnippetMap
