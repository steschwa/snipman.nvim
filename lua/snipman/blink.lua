local Instance = require("snipman")

---@module "blink.cmp"
---@class blink.cmp.Source
local Source = {}

function Source.new()
	return setmetatable({}, { __index = Source })
end

function Source:get_completions(_, callback)
	---@type lsp.CompletionItem[]
	local items = {}

	local snippets = Instance.get_current_snippets()
	for _, snippet in ipairs(snippets) do
		---@type lsp.CompletionItem
		local item = {
			label = snippet.prefix,
			kind = vim.lsp.protocol.CompletionItemKind.Snippet,
			insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet,
			insertText = snippet:evaluate(),
		}

		table.insert(items, item)
	end

	callback({
		items = items,
		is_incomplete_backward = false,
		is_incomplete_forward = false,
	})

	return function() end
end

return Source
