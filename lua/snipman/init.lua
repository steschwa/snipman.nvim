local Snippet = require("snipman.snippet")

---@alias snipman.SnippetByFileType table<string, table<[string, snipman.SnippetBody]>>

---@class snipman.Instance
---@field snippets_by_ft table<string, snipman.Snippet[]>
local M = {}

---@class snipman.SetupOpts
---@field snippets_by_ft? snipman.SnippetByFileType

---@param opts snipman.SetupOpts
function M.setup(opts)
	---@type table<string, snipman.Snippet[]>
	local snippets_by_ft = {}
	for filetype, snippets in pairs(opts.snippets_by_ft or {}) do
		if not snippets_by_ft[filetype] then
			snippets_by_ft[filetype] = {}
		end

		for _, snippet_config in ipairs(snippets) do
			local snippet = Snippet.new(snippet_config[1], snippet_config[2])
			table.insert(snippets_by_ft[filetype], snippet)
		end
	end

	M.snippets_by_ft = snippets_by_ft
end

---@return snipman.Snippet[]
function M.get_current_snippets()
	return M.snippets_by_ft[vim.bo.filetype] or {}
end

return M
