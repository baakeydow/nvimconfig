vim.g.mapleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

local plugins = require("plugins")
require("lazy").setup(plugins)

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-nvim-dap").setup()
require("fidget").setup()
require('hlargs').setup()

-- Easier movement between split windows CTRL + {h, j, k, l}
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', {})
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', {})
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', {})
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', {})

vim.api.nvim_set_keymap('', '<S-Right>', '<C-w><Right>', {})
vim.api.nvim_set_keymap('', '<S-Left>', '<C-w><Left>', {})
vim.api.nvim_set_keymap('', '<S-Up>', '<C-w><Up>', {})
vim.api.nvim_set_keymap('', '<S-Down>', '<C-w><Down>', {})

local autocmd = vim.api.nvim_create_autocmd
-- dont list quickfix buffers
autocmd("FileType", {
    pattern = "qf",
    callback = function()
        vim.opt_local.buflisted = false
    end
})

vim.api.nvim_exec([[
  highlight CopilotSuggestion guifg=#555555 ctermfg=8
]], false)

vim.api.nvim_exec([[
  :call airline#extensions#tabline#enable()
]], false)

-- Delete empty space from the end of lines on every save
vim.cmd([[autocmd BufWritePre * :%s/\s\+$//e]])

-- Trigger `autoread` when files changes on disk
vim.cmd(
    [[autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * ++nested if mode() !~# '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif]])

-- Notification after file change
vim.cmd([[
  autocmd FileChangedShellPost *
    \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
]])

-- Force highlight on buffer enter
vim.cmd([[
  autocmd BufEnter * TSBufEnable highlight
]])

-- Restore zoom
vim.cmd([[
  augroup restorezoom
      au WinEnter * silent! :call ToggleZoom(v:false)
  augroup END
]])

-- Toggle Nerdtree
vim.api.nvim_set_keymap('n', '<C-g>', ':NERDTreeToggle<CR>', {})

-- Toggle zoom
vim.api.nvim_set_keymap("n", "<Leader>=", ":call ToggleZoom(v:true)<CR>",
    {noremap = true, silent = true})

-- Easy tab switching
for i = 1, 9 do
    vim.api.nvim_set_keymap("n", "<leader>" .. i, i .. "gt", {noremap = true})
end

-- New Tab
vim.api.nvim_set_keymap("n", "<leader>t", ":tabnew<CR>",
    {noremap = true, silent = true})

-- Vertical Split
vim.api.nvim_set_keymap("n", "<leader>\\", ":vsplit<CR>",
    {noremap = true, silent = true})

-- Horizontal Split
vim.api.nvim_set_keymap("n", "<leader>n", "<c-w>n", {noremap = true})

-- Open available Buffers
vim.api.nvim_set_keymap("n", "<leader>o", ":Buffers<CR>",
    {noremap = true, silent = true})

-- Open available Git files
vim.api.nvim_set_keymap("n", "<leader>g", ":GFiles<CR>",
    {noremap = true, silent = true})

-- Open recent files
vim.api.nvim_set_keymap("n", "<leader>h", ":History<CR>",
    {noremap = true, silent = true})

-- Open recent commands
vim.api.nvim_set_keymap("n", "<leader>H", ":History:<CR>",
    {noremap = true, silent = true})

-- Preview Project files
vim.api.nvim_set_keymap("n", "<leader>f", ":FzfPreviewProjectFiles<CR>",
    {noremap = true, silent = true})

-- FZF
vim.api.nvim_set_keymap("n", "<leader>F", ":FZF<CR>",
    {noremap = true, silent = true})

-- Search in all Project files
vim.api.nvim_set_keymap("n", "<leader>v", ":Ag<CR>",
    {noremap = true, silent = true})

-- NEXT/PREV Buffer
vim.api.nvim_set_keymap("n", "<leader>]", ":bnext<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<leader>[", ":bprevious<CR>",
    {noremap = true, silent = true})

-- CLOSE current Buffer without closing window
vim.api.nvim_set_keymap("n", "<leader>d", ":new<BAR>bd#<BAR>bp<CR>",
    {noremap = true, silent = true})

-- CLOSE buffer
vim.api.nvim_set_keymap("n", "<leader>c", ":bdelete<CR>",
    {noremap = true, silent = true})

-- FORCE CLOSE current window
vim.api.nvim_set_keymap("n", "<leader>x", "<c-w>c", {noremap = true})

-- Git blame
vim.api.nvim_set_keymap("n", "gb", ":Git blame<CR>",
    {noremap = true, silent = true})

-- Zoom current buffer
vim.cmd([[
  function! ToggleZoom(zoom)
    if exists("t:restore_zoom") && (a:zoom == v:true || t:restore_zoom.win != winnr())
        exec t:restore_zoom.cmd
        unlet t:restore_zoom
    elseif a:zoom
        let t:restore_zoom = { 'win': winnr(), 'cmd': winrestcmd() }
        exec "normal \<C-W>\|\<C-W>_"
    endif
  endfunction
]])

-- Python Settings
vim.cmd([[
  autocmd FileType python set softtabstop=4
  autocmd FileType python set tabstop=4
  autocmd FileType python set autoindent
  autocmd FileType python set expandtab
  autocmd FileType python set textwidth=80
  autocmd FileType python set smartindent
  autocmd FileType python set shiftwidth=4
  autocmd FileType python map <buffer> <F2> :w<CR>:exec '! python' shellescape(@%, 1)<CR>
  autocmd FileType python imap <buffer> <F2> <esc>:w<CR>:exec '! python' shellescape(@%, 1)<CR>
]])

-- Toggle Breakpoint
vim.api.nvim_set_keymap("n", "ldb", ":DapToggleBreakpoint<CR>",
    {noremap = true, silent = true})

-- Start debugging
vim.api.nvim_set_keymap("n", "ldc", ":DapContinue<CR>",
    {noremap = true, silent = true})

-- Start debugging
vim.api.nvim_set_keymap("n", "ldk", ":DapTerminate<CR>",
    {noremap = true, silent = true})

-- Configure LSP code navigation shortcuts
vim.api.nvim_set_keymap("n", "lgd", "<cmd>lua vim.lsp.buf.definition()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "lgk", "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "lgi", "<cmd>lua vim.lsp.buf.implementation()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "lgc", "<cmd>lua vim.lsp.buf.incoming_calls()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "lgt",
    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "lgr", "<cmd>lua vim.lsp.buf.references()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "lgn", "<cmd>lua vim.lsp.buf.rename()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "lgs",
    "<cmd>lua vim.lsp.buf.document_symbol()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "lgw",
    "<cmd>lua vim.lsp.buf.workspace_symbol()<CR>",
    {noremap = true, silent = true})

-- Replaced LSP implementation with code action plugin...
vim.api.nvim_set_keymap("n", "lga", "<cmd>CodeActionMenu<CR>",
    {noremap = true, silent = true})

vim.api.nvim_set_keymap("n", "[x", "<cmd>lua vim.diagnostic.goto_prev()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "]x", "<cmd>lua vim.diagnostic.goto_next()<CR>",
    {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "]s", "<cmd>lua vim.diagnostic.show()<CR>",
    {noremap = true, silent = true})

-- Replaced LSP implementation with trouble plugin...
vim.api.nvim_set_keymap("n", "<space>q", "<cmd>Trouble<CR>",
    {noremap = true, silent = true})

vim.cmd.colorscheme "catppuccin-mocha" -- same as vim.cmd('colorscheme catppuccin-mocha')

-- Automatically reload files when they change on disk
vim.cmd('set autoread')

-- Height of the command-line window
vim.cmd('set cmdheight=1')

-- Highlight on yank
vim.cmd(
    "au TextYankPost * silent! lua vim.highlight.on_yank {higroup='IncSearch', timeout=2:50}")

-- Incremental live completion
vim.cmd('set incsearch')

vim.cmd('set t_Co=256')

-- vim.g['airline#extensions#tmuxline#enabled'] = 0
vim.g['airline#extensions#tabline#enabled'] = 1
vim.g.rustfmt_autosave = 1
vim.g.airline_statusline_ontop = 0
vim.g.ruby_host_prog = 'rvm system do neovim-ruby-host'
vim.g.termdebugger = "rust-gdb"
vim.g.NERDTreeShowHidden = 1
vim.g.NERDTreeQuitOnOpen = 0
vim.g.webdevicons_enable = 1
vim.g.webdevicons_enable_nerdtree = 1
vim.g.nerdtree_sync_cursorline = 1
vim.g.airline_theme = 'ayu_dark'
vim.g.code_action_menu_window_border = 'single'
vim.g.webdevicons_enable = 1
vim.g.webdevicons_enable_nerdtree = 1
vim.g.airline_powerline_fonts = 1
vim.opt.shortmess:append "sI"
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = false
vim.opt.smartindent = false
vim.opt.cindent = false
vim.opt.indentexpr = ''
vim.opt.guifont = 'Hack Regular Nerd Font Complete:h12'
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.backspace = "indent,eol,start"
vim.opt.list = true
vim.opt.wildmenu = true
vim.opt.encoding = "utf-8"
vim.opt.termencoding = "utf-8"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.ruler = true
vim.opt.title = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showcmd = true
vim.opt.expandtab = true
vim.opt.showmatch = true
vim.opt.mouse = "a"
vim.opt.ttyfast = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.lazyredraw = true
vim.opt.updatetime = 300
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4

-- Allow copy and paste from system clipboard
vim.opt.clipboard = "unnamed"

-- No indent on paste
vim.opt.pastetoggle = "<F2>"
vim.api.nvim_set_keymap("n", "<F2>", ":set invpaste paste?<CR>",
    {noremap = true, silent = true})
vim.opt.pastetoggle = "<F2>"

vim.opt.showmode = true
