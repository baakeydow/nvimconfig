-- " ------------------------------------
-- " Neovim LSP
-- " ------------------------------------
-- "
-- " Configure Rust LSP.
-- "
-- " https://github.com/simrat39/rust-tools.nvim#configuration
-- "
require('rust-tools').setup({
    -- rust-tools options
    tools = {
        autoSetHints = true,
        hoverWithActions = true,
        inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "",
            other_hints_prefix = ""
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
    -- https://rust-analyzer.github.io/manual.html#features
    server = {
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importEnforceGranularity = true,
                    importPrefix = "crate"
                },
                cargo = {allFeatures = true},
                checkOnSave = {
                    -- default: `cargo check`
                    command = "clippy"
                }
            },
            inlayHints = {
                lifetimeElisionHints = {enable = true, useParameterNames = true}
            }
        }
    }
})

-- " Configure Golang LSP.
-- "
-- " https://github.com/golang/tools/blob/master/gopls/doc/settings.md
-- " https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
-- " https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
-- " https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
-- " https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
-- " https://www.getman.io/posts/programming-go-in-neovim/
-- "
-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- The following example advertise capabilities to `clangd`.
require'lspconfig'.clangd.setup {capabilities = capabilities}

require('lspconfig').gopls.setup {
    cmd = {'gopls'},
    settings = {
        gopls = {
            analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true
            },
            experimentalPostfixCompletions = true,
            gofumpt = true,
            staticcheck = true,
            usePlaceholders = true
        }
    },
    on_attach = on_attach
}

require'lspconfig'.solang.setup {}
require'lspconfig'.tsserver.setup {}

-- DAP Config

require('dap-go').setup()
require("dapui").setup()
require("neodev").setup({library = {plugins = {"nvim-dap-ui"}, types = true}})

local dap, dapui = require("dap"), require("dapui")

dap.set_log_level('TRACE')

dap.configurations.rust = {
    {
        type = 'rust',
        request = 'launch',
        name = 'Launch',
        program = function()
            return vim.fn.input('Path to executable: ',
                vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        showDisassembly = "never",
        sourceMaps = false,
        args = {"--nocapture"}
    }
}

dap.adapters.rust = {
    type = 'executable',
    command = '/opt/homebrew/Cellar/llvm/16.0.2/bin/lldb-vscode',
    name = 'lldb'
}

dap.adapters['pwa-node'] = {type = 'server', host = '127.0.0.1', port = 45635}

dap.adapters.node2 = {
    type = 'executable',
    command = 'node-debug2-adapter',
    args = {
        vim.fn.stdpath("data") ..
            '/mason/packages/node-debug2-adapter/out/src/nodeDebug.js'
    }
}

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local DEBUGGER_PATH = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug"

require("dap-vscode-js").setup {
    node_path = "node",
    debugger_path = DEBUGGER_PATH,
    -- debugger_cmd = {"js-debug-adapter"},
    adapters = {
        "pwa-node",
        "pwa-chrome",
        "pwa-msedge",
        "node-terminal",
        "pwa-extensionHost"
    } -- which adapters to register in nvim-dap
}

for _, language in ipairs {"typescript", "javascript"} do
    require("dap").configurations[language] = {
        {
            type = 'node2',
            name = 'Launch node2',
            request = 'launch',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
            outFiles = {"${workspaceFolder}/**/*.js"}
        },
        {
            type = 'node2',
            name = 'Attach node2',
            request = 'attach',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal'
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            protocol = 'inspector',
            sourceMaps = true,
            cwd = "${workspaceFolder}"
        },
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}"
        },
        {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {"./node_modules/jest/bin/jest.js", "--runInBand"},
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen"
        },
        {
            request = 'launch',
            name = 'Deno launch',
            type = 'pwa-node',
            program = '${file}',
            cwd = '${workspaceFolder}',
            runtimeExecutable = vim.fn.getenv('HOME') .. '/.deno/bin/deno',
            runtimeArgs = {'run', '--inspect-brk'},
            attachSimplePort = 9229
        },
        {
            request = 'launch',
            name = 'Deno test launch',
            type = 'pwa-node',
            program = '${file}',
            cwd = '${workspaceFolder}',
            runtimeExecutable = vim.fn.getenv('HOME') .. '/.deno/bin/deno',
            runtimeArgs = {'test', '--inspect-brk'},
            attachSimplePort = 9229
        }
    }
end

for _, language in ipairs {"typescriptreact", "javascriptreact"} do
    require("dap").configurations[language] = {
        {
            type = "pwa-chrome",
            name = "Attach - Remote Debugging",
            request = "attach",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = "inspector",
            port = 9222,
            webRoot = "${workspaceFolder}"
        },
        {
            type = "pwa-chrome",
            name = "Launch Chrome",
            request = "launch",
            url = "http://localhost:3000"
        }
    }
end

-- " Setup Completion
-- " https://github.com/hrsh7th/nvim-cmp#recommended-configuration
-- "
local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        ['<Up>'] = cmp.mapping.select_prev_item(),
        ['<Down>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        })
    },
    sources = {
        {name = 'nvim_lsp'},
        {name = 'vsnip'},
        {name = 'path'},
        {name = 'buffer'},
        {name = 'nvim_lsp_signature_help'}
    }
})
