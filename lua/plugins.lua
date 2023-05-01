local opts = require("opts")

local plugins = {
    {'github/copilot.vim'}, -- GitHub Copilot uses OpenAI Codex to suggest code and entire functions in real-time right from your editor. 
    {'preservim/nerdtree'}, -- The NERDTree is a file system explorer for the Vim editor.
    {'preservim/nerdcommenter'}, -- Comment functions so powerful—no comment necessary.
    {'ryanoasis/vim-devicons'}, -- Supports plugins such as NERDTree, vim-airline, CtrlP, powerline, denite, unite, lightline.vim, vim-startify, vimfiler, vim-buffet and flagship.
    {'nvim-tree/nvim-web-devicons'}, -- A lua fork of vim-devicons. This plugin provides the same icons as well as colors for each icon.
    {'Xuyuanp/nerdtree-git-plugin'}, -- A plugin of NERDTree showing git status flags.
    {'unkiwii/vim-nerdtree-sync'}, -- A plugin that show the current file on NERDtree
    {'j-hui/fidget.nvim'}, -- Standalone UI for nvim-lsp progress. Eye candy for the impatient.
    {'folke/trouble.nvim'}, -- A pretty list for showing diagnostics, references, telescope results, quickfix and location lists to help you solve all the trouble your code is causing.
    {'hrsh7th/nvim-cmp'}, -- A completion engine plugin for neovim written in Lua. Completion sources are installed from external repositories and "sourced".
    {'hrsh7th/cmp-buffer'}, -- nvim-cmp source for buffer words.
    {'hrsh7th/cmp-path'}, -- nvim-cmp source for filesystem paths.
    {'hrsh7th/cmp-nvim-lsp'}, -- nvim-cmp source for neovim's built-in language server client.
    {'hrsh7th/cmp-nvim-lsp-signature-help'}, -- nvim-cmp source for displaying function signatures with the current parameter emphasized:
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "lspconfigs"
        end
    }, -- Configs for the Nvim LSP client (:help lsp).
    {"williamboman/mason.nvim", opts = opts.mason}, -- Portable package manager for Neovim that runs everywhere Neovim runs. Easily install and manage LSP servers, DAP servers, linters, and formatters.
    {'williamboman/mason-lspconfig.nvim'}, -- mason-lspconfig bridges mason.nvim with the lspconfig plugin - making it easier to use both plugins together.
    {'jay-babu/mason-nvim-dap.nvim'}, -- mason-nvim-dap bridges mason.nvim with the nvim-dap plugin - making it easier to use both plugins together.
    {'hrsh7th/vim-vsnip'}, -- VSCode(LSP)'s snippet feature in vim/nvim.
    {'hrsh7th/vim-vsnip-integ'}, -- Snippet completion/expansion
    {'kosayoda/nvim-lightbulb'}, -- VSCode 💡 for neovim's built-in LSP.
    {'m-demare/hlargs.nvim'}, -- Highlight arguments' definitions and usages, asynchronously, using Treesitter
    {'weilbith/nvim-code-action-menu', build = 'CodeActionMenu'}, -- NeoVim Code Action Menu
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
    {'vim-airline/vim-airline'}, -- Lean & mean status/tabline for vim that's light as air.
    {'vim-airline/vim-airline-themes'}, -- This is the official theme repository for vim-airline
    {
        'yuki-yano/fzf-preview.vim',
        branch = 'release/remote',
        build = ':UpdateRemotePlugins'
    }, -- fzf-preview is a (Neo)vim plugin and coc extension written in TypeScript that provide powerful integration with fzf.
    {'drewtempelmeyer/palenight.vim'}, -- A dark color scheme for Vim/Neovim based off the Material Pale Night color scheme. Much of the work is based on the lovely onedark.vim color scheme.
    {'folke/tokyonight.nvim', branch = 'main'}, -- A dark and light Neovim theme written in Lua ported from the Visual Studio Code TokyoNight theme. Includes extra themes for Kitty, Alacritty, iTerm and Fish.
    {'junegunn/fzf', build = ':call fzf#install()'}, -- fzf is a general-purpose command-line fuzzy finder.
    {'junegunn/fzf.vim'}, -- Things you can do with fzf and Vim.
    {'airblade/vim-gitgutter'}, -- " Show git diff of lines edited
    {'tpope/vim-fugitive'}, -- " :Git
    {'nvim-lua/plenary.nvim'}, -- " All the lua functions I don't want to write twice.
    {"nvim-treesitter/nvim-treesitter", opts = opts.treesitter}, -- The goal of nvim-treesitter is both to provide a simple and easy way to use the interface for tree-sitter in Neovim and to provide some basic functionality
    {'rust-lang/rust.vim'}, -- This is a Vim plugin that provides Rust file detection, syntax highlighting, formatting, Syntastic integration, and more. It requires Vim 8 or higher for full functionality. Some things may not work on earlier versions.
    {'simrat39/rust-tools.nvim'}, -- A plugin to improve your rust experience in neovim.
}

return plugins

