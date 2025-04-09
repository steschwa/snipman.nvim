# snipman.nvim

A simple Neovim plugin to manage [LSP-style](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#snippet_syntax) snippets.

## Features

- Manage LSP-style snippets
- Dynamic snippet body (evaluated at insertion time)
- [blink.cmp](https://github.com/Saghen/blink.cmp) integration

## Installation

To install `snipman.nvim`, you can use your preferred plugin manager. For example, using `lazy.nvim`:

```lua
return {
    "steschwa/snipman.nvim",
    opts = {
        -- see below for the full configuration reference
    }
}
```

## Configuration

Once installed, `snipman.nvim` should be configured with your custom snippets:

```lua
{
    snippets_by_ft = {
        javascript = {
            -- snippets can be plain strings
            {
                "log",
                "console.log($0)"
            },

            -- or custom functions that evaluate at insertion time
            {
                "date",
                function()
                    return string.format("the current date is: %s", os.date())
                end
            },

            -- snippets can even be multi-line for better readability
            {
                "comp",
                {
                    "type $1Props = {}",
                    "",
                    "export function $1(props: $1Props) {",
                    "   $0",
                    "}"
                }
            }

            -- add more snippets as needed
        },

        -- add snippets for other file types
    }
}
```

To actually use the snippets you have to enable the `blink.cmp` integration.
Add the following to your existing `blink.cmp` configuration:

```lua
{
    "saghen/blink.cmp",
    opts = {
        -- your existing blink.cmp configuration ...

        sources = {
            default = { "other-provider-1", "snipman", "other-provider-2" },
            providers = {
                snipman = {
                    name = "Snipman",
                    module = "snipman.blink",
                },
            }
        }
    }
}
```

### Parameters

- `snippets_by_ft` (type: `table<string, snipman.SnippetInit[]>`): A table where each table-key is a filetype (determined by `vim.bo.filetype`)
  and the value is an array of `table<[string, snipman.SnippetBody]>` containing the snippet-trigger as first element and the snippet-body as second.
  The special value `"all"` can be used to add a snippet to all filetypes.
  See [https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#snippet_syntax](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#snippet_syntax)
  for details about the snippet syntax.

<details>
<summary>Types</summary>

```lua
---@class snipman.SetupOpts
---@field snippets_by_ft? table<string, snipman.SnippetInit[]>

---@alias snipman.SnippetInit table<[string, snipman.SnippetBody]>

---@alias snipman.SnippetBody string | string[] | fun():string
```

</details>

## API

- `require("snipman").add_snippets(filetype, snippets)`: add snippets dynamically (make sure `setup` has been called)

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
