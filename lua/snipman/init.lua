local Snippet = require("snipman.snippet")

---@alias snipman.SnippetByFileType table<string, table<[string, snipman.SnippetBody]>>

---@class snipman.SnippetByFileTypeBuilder
---@field snippets_by_ft snipman.SnippetByFileType
local SnippetByFileTypeBuilder = {}

function SnippetByFileTypeBuilder.new()
	return setmetatable({
		snippets_by_ft = {},
	}, { __index = SnippetByFileTypeBuilder })
end

---@param filetype string
---@param snippet snipman.Snippet
function SnippetByFileTypeBuilder:add(filetype, snippet)
	if not self.snippets_by_ft[filetype] then
		self.snippets_by_ft[filetype] = {}
	end

	table.insert(self.snippets_by_ft[filetype], snippet)
end

function SnippetByFileTypeBuilder:build()
	return self.snippets_by_ft
end

---@class snipman.Instance
---@field snippets_by_ft table<string, snipman.Snippet[]>
local M = {}

---@class snipman.SetupOpts
---@field snippets_by_ft? snipman.SnippetByFileType

---@param opts snipman.SetupOpts
function M.setup(opts)
	local builder = SnippetByFileTypeBuilder.new()

	for filetype, snippets in pairs(opts.snippets_by_ft or {}) do
		for _, snippet_config in ipairs(snippets) do
			local snippet = Snippet.new(snippet_config[1], snippet_config[2])
			builder:add(filetype, snippet)
		end
	end

	M.snippets_by_ft = builder:build()
end

---@return snipman.Snippet[]
function M.get_current_snippets()
	return M.snippets_by_ft[vim.bo.filetype] or {}
end

return M
