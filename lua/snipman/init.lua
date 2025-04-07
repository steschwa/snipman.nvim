local Snippet = require("snipman.snippet")

---@class snipman.Instance
---@field snippetsByFileType table<string, snipman.Snippet[]>
local M = {}

---@class snipman.SetupOpts
---@field snippetsByFileType table<string, table<[string, snipman.SnippetBody]>>

---@param opts snipman.SetupOpts
function M.setup(opts)
	---@type table<string, snipman.Snippet[]>
	local snippetsByFileType = {}
	for filetype, snippets in pairs(opts.snippetsByFileType) do
		if not snippetsByFileType[filetype] then
			snippetsByFileType[filetype] = {}
		end

		for _, snippet_config in ipairs(snippets) do
			local snippet = Snippet.new(snippet_config[1], snippet_config[2])
			table.insert(snippetsByFileType[filetype], snippet)
		end
	end

	M.snippetsByFileType = snippetsByFileType
end

---@return snipman.Snippet[]
function M.get_current_snippets()
	return M.snippetsByFileType[vim.bo.filetype] or {}
end

return M
