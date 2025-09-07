local opts = require("opts")

-- Neovim LSP Configuration
-- 
-- This configuration follows the KISS (Keep It Simple, Stupid) principle:
-- 1. Mason automatically installs language servers listed in opts.mason_lsp.ensure_installed
-- 2. Mason-lspconfig bridges Mason with nvim-lspconfig
-- 3. Each server is explicitly configured below (automatic_enable = false prevents duplicates)
-- 4. Most servers use default settings with nvim-cmp capabilities
-- 5. Some servers (Rust, Python, Go) have custom configurations for enhanced features

-- Setup Mason for package management
require("mason").setup()

-- Setup mason-lspconfig (auto-installs servers but doesn't enable them)
local mason_lsp_config = vim.tbl_extend("force", opts.mason_lsp, {
  automatic_enable = false  -- We configure servers manually below
})
require("mason-lspconfig").setup(mason_lsp_config)

-- Setup LSP servers
local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Go Language Server
-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
-- https://github.com/golang/tools/blob/master/gopls/doc/analyzers.md
-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md#neovim
lspconfig.gopls.setup {
    capabilities = capabilities,
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
    }
}

-- C/C++
lspconfig.clangd.setup { capabilities = capabilities }

-- Web Development Servers
lspconfig.cssls.setup{ capabilities = capabilities }          -- CSS
lspconfig.css_variables.setup{ capabilities = capabilities }  -- CSS Variables
lspconfig.html.setup{ capabilities = capabilities }           -- HTML
lspconfig.ts_ls.setup{ capabilities = capabilities }          -- TypeScript/JavaScript (renamed from tsserver)
lspconfig.eslint.setup{ capabilities = capabilities }         -- ESLint
lspconfig.graphql.setup{ capabilities = capabilities }        -- GraphQL
lspconfig.prismals.setup{ capabilities = capabilities }       -- Prisma ORM

-- Infrastructure & Scripting
lspconfig.terraformls.setup{ capabilities = capabilities }    -- Terraform
lspconfig.dockerls.setup{ capabilities = capabilities }       -- Docker
lspconfig.bashls.setup{ capabilities = capabilities }         -- Bash
lspconfig.lua_ls.setup{ capabilities = capabilities }         -- Lua

-- Blockchain
lspconfig.solang.setup{ capabilities = capabilities }         -- Solidity
-- Python Development (Ruff + Pyright for comprehensive support)
-- Ruff handles linting and formatting, Pyright handles type checking and navigation
lspconfig.ruff.setup{
  capabilities = capabilities,
  on_attach = function(client, _)
    -- Disable hover in favor of Pyright
    client.server_capabilities.hoverProvider = false
    -- Disable definition capabilities (Pyright handles these)
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.declarationProvider = false
  end,
  init_options = {
    settings = {
      args = { "--line-length=100" }
    }
  }
}
-- Pyright for Python type checking and navigation
lspconfig.pyright.setup{
  capabilities = capabilities,
  settings = {
    pyright = {
      disableOrganizeImports = true,  -- Using Ruff for this
      disableTaggedHints = true,
    },
    python = {
      analysis = {
        diagnosticSeverityOverrides = {
          -- Avoid duplicate diagnostics from Ruff
          reportUnusedVariable = "none",
          reportUnusedImport = "none"
        },
        typeCheckingMode = "basic",
        useLibraryCodeForTypes = true
      }
    }
  }
}

-- Rust Language Server (using rust-tools.nvim for enhanced features)
-- https://github.com/simrat39/rust-tools.nvim#configuration
-- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
-- https://rust-analyzer.github.io/manual.html#features
require('rust-tools').setup({
  tools = {
    autoSetHints = true,
    hoverWithActions = true,
    inlay_hints = {
      show_parameter_hints = true,
      parameter_hints_prefix = "",
      other_hints_prefix = ""
    }
  },
  server = {
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importEnforceGranularity = true,
          importPrefix = "crate"
        },
        cargo = { features = 'all' },
        checkOnSave = { command = "clippy" }
      },
      inlayHints = {
        lifetimeElisionHints = { enable = true, useParameterNames = true }
      }
    }
  }
})

-- Copilot Chat
require("CopilotChat").setup {
  debug = true
}

-- DAP Config

require('dap-go').setup {
    -- Additional dap configurations can be added.
    -- dap_configurations accepts a list of tables where each entry
    -- represents a dap configuration. For more details do:
    -- :help dap-configuration
    dap_configurations = {
        {
            -- Must be "go" or it will be ignored by the plugin
            type = "go",
            name = "Attach remote (dap-go)",
            mode = "remote",
            request = "attach"
        }
    },
    -- delve configurations
    delve = {
        -- time to wait for delve to initialize the debug session.
        -- default to 20 seconds
        initialize_timeout_sec = 20,
        -- a string that defines the port to start delve debugger.
        -- default to string "${port}" which instructs nvim-dap
        -- to start the process in a random available port
        port = "${port}"
    }
}
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
        args = {"-d -l=debug --nocapture"}
    },
    {
        type = 'rust',
        request = 'attach',
        name = 'Attach',
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

dap.adapters.chrome = {
    type = "executable",
    command = "node",
    args = {
        vim.fn.stdpath("data") ..
        "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js"
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
    set_log_level = "TRACE",
    -- debugger_cmd = {"js-debug-adapter"},
    adapters = {
        "node",
        "chrome",
        "pwa-node",
        "pwa-chrome",
        "pwa-msedge",
        "node-terminal",
        "pwa-extensionHost"
    } -- which adapters to register in nvim-dap
}

for _, language in ipairs {
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "vue"
} do

require("dap").configurations[language] = {
    { -- sanofi-pqr v0
            type = 'pwa-node',
            trace = true,
            request = 'attach',
            --request = 'launch',
            protocol = "inspector",
            name = '(genair) Debug Nest Framework',
            args = {"${workspaceFolder}/projects/core-api/src/main.ts"},
            envFile = "${workspaceFolder}/projects/core-api/.env",
            rootPath = "${workspaceFolder}/projects/core-api",
            path = "${workspaceFolder}/projects/core-api",
            cwd = "${workspaceFolder}/projects/core-api",
            localRoot = "${workspaceFolder}/projects/core-api",
            --runtimeExecutable = "npm",
            --runtimeArgs = {
              --"run",
              --"start:debug",
            --},
            resolveSourceMapLocations = {
                "${workspaceFolder}/projects/core-api/dist/**",
                "!**/node_modules/**"
            },
            skipFiles = { '<node_internals>/**' },
            outFiles = {"${workspaceFolder}/projects/core-api/dist/**"},
            host = "127.0.0.1",
            port = 9229,
            autoAttachChildProcesses = true,
            restart = true,
            sourceMaps = true,
            stopOnEntry = true,
            console = "integratedTerminal",
        },
        { -- working conf for nest
            type = 'node2',
            request = 'launch',
            name = '(working) Debug Nest Framework',
            args = {"${workspaceFolder}/projects/tpa-core-api/src/main.ts"},
            envFile = "${workspaceFolder}/.env",
            runtimeExecutable = "yarn",
            runtimeArgs = {
                "run",
                "start:debug",
                "--",
                "--inspect-brk"
            },
            port = 9229,
            autoAttachChildProcesses = true,
            restart = true,
            sourceMaps = true,
            stopOnEntry = false,
            --console = "integratedTerminal",
        },
        { -- launch node 2
            type = 'node2',
            name = 'node2 Launch',
            request = 'launch',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
            outFiles = {"${workspaceFolder}/**/*.js"},
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            }
        },
        { -- attach node 2
            type = 'node2',
            name = 'node2 Attach',
            request = 'attach',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            console = 'integratedTerminal',
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            }
        },

        --

        { -- launch chrome 3000
            type = "pwa-chrome",
            name = "pwa-chrome Launch 3000",
            request = "launch",
            sourceMaps = true,
            trace = true,
            url = "http://localhost:3000",
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            }
        },
        { -- launch pwa-chrome 8080
            type = "pwa-chrome",
            name = "pwa-chrome Launch 8080",
            request = "launch",
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            trace = true,
            url = "http://localhost:8080",
            webRoot = "${workspaceFolder}/application",
            resolveSourceMapLocations = {
                "${workspaceFolder}/application/**",
                "!**/node_modules/**"
            }
        },
        { -- attach pwa-chrome 8080
            type = "pwa-chrome",
            name = "pwa-chrome Attach 8080",
            request = "attach",
            program = "${file}",
            cwd = vim.fn.getcwd(),
            protocol = "inspector",
            sourceMaps = true,
            trace = true,
            port = 9222,
            url = "http://localhost:8080",
            webRoot = "${workspaceFolder}",
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            }
        },
        { -- select pid
            type = "pwa-node",
            request = "attach",
            name = "pwa-node Attach Program (select pid)",
            --cwd = vim.fn.getcwd(),
            cwd = "${workspaceFolder}",
            processId = require("dap.utils").pick_process,
            skipFiles = { '<node_internals>/**' },
            outFiles = {"${workspaceFolder}/**"},
            resolveSourceMapLocations = {
                "${workspaceFolder}/dist/**",
                "!**/node_modules/**"
            },
            autoAttachChildProcesses = true,
            restart = true,
            sourceMaps = true,
            stopOnEntry = true,
        },
        { -- launch pwa-node
            type = "pwa-node",
            request = "launch",
            name = "pwa-node Launch file",
            program = "${file}",
            protocol = 'inspector',
            sourceMaps = true,
            cwd = "${workspaceFolder}",
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            }
        },
        { -- attach pwa-node
            type = "pwa-node",
            request = "attach",
            name = "pwa-node Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}"
        },
        { -- jest
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
        { -- launc Nextjs
            type = "pwa-node",
            name = "Next.js launch: debug server-side",
            request = "launch",
            command = "pnpm dev"
        },
        { -- Nextjs
            type = "pwa-chrome",
            -- type = "chrome",
            name = "Next.js launch: debug client-side",
            request = "launch",
            command = "pnpm dev",
            url = "http://localhost:3000",
            autoAttachChildProcesses = true,
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            }
        },
        { -- Nextjs
            type = "pwa-chrome",
            -- type = "chrome",
            -- type = "node-terminal",
            name = "Next.js launch: debug full stack",
            cwd = "${workspaceFolder}/src/app",
            autoAttachChildProcesses = true,
            request = "launch",
            command = "pnpm dev",
            -- program = "${file}",
            -- webRoot = "${workspaceFolder}",
            sourceMaps = true,
            -- protocol = "inspector",
            -- skipFiles = {'<node_internals>/**'},
            -- console = 'integratedTerminal',
            resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            },
            serverReadyAction = {
                pattern = "started server on .+, url: (https?://.+)",
                uriFormat = "%s",
                action = "debugWithChrome"
            },
            url = "http://localhost:3000"
        },
        { -- Deno
            type = 'pwa-node',
            request = 'launch',
            name = 'Deno launch',
            program = '${file}',
            cwd = '${workspaceFolder}',
            runtimeExecutable = vim.fn.getenv('HOME') .. '/.deno/bin/deno',
            runtimeArgs = {'run', '--inspect-brk'},
            attachSimplePort = 9229
        },
        { -- Deno
            type = 'pwa-node',
            request = 'launch',
            name = 'Deno test launch',
            program = '${file}',
            cwd = '${workspaceFolder}',
            runtimeExecutable = vim.fn.getenv('HOME') .. '/.deno/bin/deno',
            runtimeArgs = {'test', '--inspect-brk'},
            attachSimplePort = 9229
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

