local opts = require("opts")

local plugins = {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
      workspaces = {
        {
          name = "dtksi",
          path = "~/Obsidian_Vault/obsidian-bckp/21times2/",
        },
      },
      completion = {
        nvim_cmp = true,
      },
      daily_notes = {
        folder = "Daily",
        template = "daily.md",
        default_tags = { "daily-nvim" },
      },
      templates = {
        folder = "~/Obsidian_Vault/obsidian-bckp/21times2/TOOLZ/Templates",
      },
      notes_subdir = "📮INBOX📮",
      new_notes_location = "notes_subdir",
      open_notes_in = "vsplit",
      attachments = {
        img_folder = "Resources/Assets"
      },
      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        vim.fn.jobstart({"open", url})  -- Mac OS
        -- vim.fn.jobstart({"xdg-open", url})  -- linux
      end,
      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "fzf-lua",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        note_mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
        tag_mappings = {
          -- Add tag(s) to current note.
          tag_note = "<C-x>",
          -- Insert a tag at the current location.
          insert_tag = "<C-l>",
        },
      },
    },
  }, --- A Neovim plugin for writing and navigating Obsidian vaults, written in Lua.
  {
    'saecki/crates.nvim',
    tag = 'stable',
    config = function()
      require('crates').setup()
    end,
  }, -- A neovim plugin that helps managing crates.io dependencies.
  {'rmagatti/auto-session'}, -- A small automated session manager for Neovim.
  {'github/copilot.vim'}, -- GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor.
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    opts = {
      debug = true, -- Enable debugging
      -- See Configuration section for rest
    },
    -- See Commands section for default commands if you want to lazy load on them
  }, -- Copilot Chat for Neovim
  {'preservim/nerdtree'}, -- The NERDTree is a file system explorer for the Vim editor.
  {'preservim/nerdcommenter'}, -- Comment functions so powerful—no comment necessary.
  {'ryanoasis/vim-devicons'}, -- Supports plugins such as NERDTree, vim-airline, CtrlP, powerline, denite, unite, lightline.vim, vim-startify, vimfiler, vim-buffet and flagship.
  {'nvim-tree/nvim-web-devicons'}, -- A lua fork of vim-devicons. This plugin provides the same icons as well as colors for each icon.
  {'Xuyuanp/nerdtree-git-plugin'}, -- A plugin of NERDTree showing git status flags.
  {'unkiwii/vim-nerdtree-sync'}, -- A plugin that show the current file on NERDtree
  {'j-hui/fidget.nvim', tag = 'legacy'}, -- Standalone UI for nvim-lsp progress. Eye candy for the impatient.
  {'norcalli/nvim-colorizer.lua'}, -- A high-performance color highlighter for Neovim which has no external dependencies! Written in performant Luajit.
  {'folke/trouble.nvim', cmd = 'Trouble'}, -- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists to help you solve all the trouble your code is causing.
  {'hrsh7th/nvim-cmp'}, -- A completion engine plugin for neovim written in Lua. Completion sources are installed from external repositories and "sourced".
  {'hrsh7th/cmp-buffer'}, -- nvim-cmp source for buffer words.
  {'hrsh7th/cmp-path'}, -- nvim-cmp source for filesystem paths.
  {'hrsh7th/cmp-nvim-lsp'}, -- nvim-cmp source for neovim's built-in language server client.
  {'hrsh7th/cmp-nvim-lsp-signature-help'}, -- nvim-cmp source for displaying function signatures with the current parameter emphasized:
  { "nvim-neotest/nvim-nio" }, -- A library for asynchronous IO in Neovim, inspired by the asyncio library in Python. The library focuses on providing both common asynchronous primitives and asynchronous APIs for Neovim's core.
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "lspconfigs"
    end
  }, -- Configs for the Nvim LSP client (:help lsp).
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "ibhagwan/fzf-lua",              -- required => Improved FZF => https://github.com/ibhagwan/fzf-lua
    },
    config = true
  }, -- An interactive and powerful Git interface for Neovim, inspired by Magit
  {"williamboman/mason.nvim", opts = opts.mason}, -- Portable package manager for Neovim that runs everywhere Neovim runs. Easily install and manage LSP servers, DAP servers, linters, and formatters.
  {'williamboman/mason-lspconfig.nvim'}, -- mason-lspconfig bridges mason.nvim with the lspconfig plugin - making it easier to use both plugins together.
  {'jay-babu/mason-nvim-dap.nvim'}, -- mason-nvim-dap bridges mason.nvim with the nvim-dap plugin - making it easier to use both plugins together.
  {'hrsh7th/vim-vsnip'}, -- VSCode(LSP)'s snippet feature in vim/nvim.
  {'hrsh7th/vim-vsnip-integ'}, -- Snippet completion/expansion
  {'kosayoda/nvim-lightbulb'}, -- VSCode 💡 for neovim's built-in LSP.
  {'m-demare/hlargs.nvim'}, -- Highlight arguments' definitions and usages, asynchronously, using Treesitter
  --{'weilbith/nvim-code-action-menu', build = 'CodeActionMenu'}, -- Deprecated NeoVim Code Action Menu  
  {'mfussenegger/nvim-dap'}, -- Debug Adapter Protocol client implementation for Neovim
  {'rcarriga/nvim-dap-ui'}, -- A UI for nvim-dap which provides a good out of the box configuration.
  {'leoluz/nvim-dap-go'}, -- An extension for nvim-dap providing configurations for launching go debugger (delve) and debugging individual tests.
  {'folke/neodev.nvim'}, -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  {'mxsdev/nvim-dap-vscode-js'}, -- nvim-dap adapter for vscode-js-debug.
  {'iamcco/markdown-preview.nvim', build = 'cd app && yarn install'}, -- Preview markdown on your modern browser with synchronised scrolling and flexible configuration
  {
    "microsoft/vscode-js-debug",
    opt = true,
    build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out"
  }, -- This is a DAP-based JavaScript debugger. It debugs Node.js, Chrome, Edge, WebView2, VS Code extensions, and more. It has been the default JavaScript debugger in Visual Studio Code since 1.46, and is gradually rolling out in Visual Studio proper.
  {'fatih/vim-go'}, -- This plugin adds Go language support for Vim
  {"catppuccin/nvim", name = "catppuccin"}, -- This port of Catppuccin is special because it was the first one and the one that originated the project itself.
  {'mg979/vim-visual-multi', branch = 'master'}, -- It's called vim-visual-multi in analogy with visual-block, but the plugin works mostly from normal mode.
  {'gpanders/editorconfig.nvim'}, -- Add support for .editorconfig file
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }
  }, -- A blazing fast and easy to configure Neovim statusline written in Lua.
  {
    'yuki-yano/fzf-preview.vim',
    branch = 'release/remote',
    build = ':UpdateRemotePlugins'
  }, -- fzf-preview is a (Neo)vim plugin and coc extension written in TypeScript that provide powerful integration with fzf.
  {'drewtempelmeyer/palenight.vim'}, -- A dark color scheme for Vim/Neovim based off the Material Pale Night color scheme. Much of the work is based on the lovely onedark.vim color scheme.
  {'folke/tokyonight.nvim', branch = 'main'}, -- A dark and light Neovim theme written in Lua ported from the Visual Studio Code TokyoNight theme. Includes extra themes for Kitty, Alacritty, iTerm and Fish.
  { "ellisonleao/gruvbox.nvim", priority = 1000 }, -- Gruvbox Material
  {'junegunn/fzf', build = ':call fzf#install()'}, -- fzf is a general-purpose command-line fuzzy finder.
  {'junegunn/fzf.vim'}, -- Things you can do with fzf and Vim.
  {'airblade/vim-gitgutter'}, -- " Show git diff of lines edited
  {'tpope/vim-fugitive'}, -- " :Git
  {'tpope/vim-surround'}, -- Surround.vim is all about "surroundings": parentheses, brackets, quotes, XML tags, and more.
  {'nvim-lua/plenary.nvim'}, -- " All the lua functions I don't want to write twice.
  {"nvim-treesitter/nvim-treesitter", opts = opts.treesitter}, -- The goal of nvim-treesitter is both to provide a simple and easy way to use the interface for tree-sitter in Neovim and to provide some basic functionality
  {'rust-lang/rust.vim'}, -- This is a Vim plugin that provides Rust file detection, syntax highlighting, formatting, Syntastic integration, and more. It requires Vim 8 or higher for full functionality. Some things may not work on earlier versions.
  {'simrat39/rust-tools.nvim'} -- A plugin to improve your rust experience in neovim.
}

return plugins

