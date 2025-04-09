local Snippet = require("snipman.snippet")
local SnippetMap = require("snipman.snippet_map")

---@alias snipman.SnippetInit table<[string, snipman.SnippetBody]>

---@class snipman.Instance
---@field snippets snipman.SnippetMap
local M = {}

---@class snipman.SetupOpts
---@field snippets_by_ft? table<string, snipman.SnippetInit[]>

---@param opts snipman.SetupOpts
function M.setup(opts)
	M.snippets = SnippetMap.new()

	for filetype, snippets in pairs(opts.snippets_by_ft or {}) do
		M.add_snippets(filetype, snippets)
	end
end

---@param filetype string
---@param snippets snipman.SnippetInit[]
function M.add_snippets(filetype, snippets)
	for _, snippet_init in ipairs(snippets) do
		local snippet = Snippet.new(snippet_init[1], snippet_init[2])
		M.snippets:add(filetype, snippet)
	end
end

---@return snipman.Snippet[]
function M.get_current_snippets()
	return M.snippets:get(vim.bo.filetype)
end

return M
