local Snippet = require("snipman.snippet")
local SnippetMap = require("snipman.snippet_map")
local FileLoader = require("snipman.file_loader")

---@alias snipman.SnippetInit table<[string, snipman.SnippetBody]>

---@class snipman.Instance
---@field snippets snipman.SnippetMap
---@field loaded_ft table<string>
local M = {
	snippets = SnippetMap.new(),
	loaded_ft = {},
}

---@class snipman.SetupOpts
---@field snippets_by_ft? table<string, snipman.SnippetInit[]>

---@param opts snipman.SetupOpts
function M.setup(opts)
	for filetype, snippets in pairs(opts.snippets_by_ft or {}) do
		M.add_snippets(filetype, snippets)
	end

	vim.api.nvim_create_user_command("SnipmanListBuf", function()
		local ft = vim.bo.filetype
		local ft_snippets = M.snippets:get(ft)

		vim.print(string.format("filetype (%s):", ft))
		if #ft_snippets == 0 then
			vim.print("no snippets configured")
		end
		for i, snippet in ipairs(ft_snippets) do
			vim.print(string.format("\t%d. %s", i, snippet.prefix))
		end

		local all_snippets = M.snippets:get("all")

		vim.print("all filetypes:")
		if #ft_snippets == 0 then
			vim.print("no snippets configured")
		end
		for i, snippet in ipairs(all_snippets) do
			vim.print(string.format("\t%d. %s", i, snippet.prefix))
		end
	end, {})

	vim.api.nvim_create_autocmd("FileType", {
		callback = function()
			M.load(vim.bo.filetype)
		end,
	})

	M.load(vim.bo.filetype)
	M.load("all")
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

---@param filetype string
function M.load(filetype)
	if vim.list_contains(M.loaded_ft, filetype) then
		return
	end

	table.insert(M.loaded_ft, filetype)

	local files = vim.api.nvim_get_runtime_file(string.format("snippets/%s.lua", filetype), true)

	for _, path in ipairs(files) do
		local snippets = FileLoader.load_path(path)
		for _, snippet_init in ipairs(snippets) do
			local snippet = Snippet.new(snippet_init[1], snippet_init[2])
			M.snippets:add(filetype, snippet)
		end
	end
end

return M
