local Snippet = require("snipman.snippet")

---@class snipman.SnippetMap
---@field snippets_by_ft table<string, snipman.Snippet[]>
---@field loaded_ft table<string>
local SnippetMap = {}

function SnippetMap.new()
	return setmetatable({
		snippets_by_ft = {},
		loaded_ft = {},
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

---@param filetype string
function SnippetMap:load(filetype)
	if vim.list_contains(self.loaded_ft, filetype) then
		return
	end

	table.insert(self.loaded_ft, filetype)

	local config_path = vim.fn.stdpath("config")
	local snippet_file = vim.fs.joinpath(config_path, "snippets", string.format("%s.lua", filetype))

	---@diagnostic disable-next-line: undefined-field
	local stat = vim.uv.fs_stat(snippet_file)
	if not stat or stat.type ~= "file" then
		return
	end

	local exec, err = loadfile(snippet_file)
	if err or not exec then
		return
	end

	local ok, res = pcall(exec)
	if not ok then
		return
	end

	if type(res) ~= "table" then
		return
	end

	for _, snippet_init in ipairs(res) do
		local snippet = Snippet.new(snippet_init[1], snippet_init[2])
		self:add(filetype, snippet)
	end
end

return SnippetMap
