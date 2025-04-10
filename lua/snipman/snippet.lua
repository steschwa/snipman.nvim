---@alias snipman.SnippetBody string | string[] | fun():string

---@class snipman.Snippet
---@field prefix string
---@field body snipman.SnippetBody
local Snippet = {}

---@param prefix string
---@param body snipman.SnippetBody
function Snippet.new(prefix, body)
	return setmetatable({
		prefix = prefix,
		body = body,
	}, { __index = Snippet })
end

---@return string
function Snippet:evaluate()
	local snippet = self:to_string()
	return vim.trim(snippet)
end

---@return string
function Snippet:to_string()
	if type(self.body) == "string" then
		local body = self.body --[[@as string]]
		return body
	end

	if type(self.body) == "table" then
		local body = self.body --[[@as table<string>]]
		return table.concat(body, "\n")
	end

	if type(self.body) == "function" then
		return self.body()
	end

	return ""
end

return Snippet
