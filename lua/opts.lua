local M = {}

M.treesitter = {
    indent = {
        enable = true
        -- disable = {
        --   "python"
        -- },
    },
    build = ":TSUpdate",
    highlight = {enable = true},
    rainbow = {enable = true, extended_mode = true, max_file_lines = nil},
    ensure_installed = {
        "vim",
        "vimdoc",
        "lua",
        "http",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "json",
        "vue",
        "svelte",
        "dockerfile",
        "go",
        "gosum",
        "gomod",
        "gowork",
        "regex",
        "ruby",
        "rust",
        "toml",
        "yaml",
        "hcl",
        "c",
        "zig",
        "bash",
        "c",
        "cmake",
        "make"
    }
}

M.mason = {
    ensure_installed = {
        "rust-analyzer",
        "rustfmt",
        "goimports",
        "gopls",
        "revive",
        "js-debug-adapter",
        "lua-language-server",
        "stylua",
        "css-lsp",
        "html-lsp",
        "typescript-language-server",
        "deno",
        "typescript",
        "javascript",
        "solang",
        "prettier",
        "clangd",
        "clang-format"
    }
}

return M
