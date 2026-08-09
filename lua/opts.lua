local M = {}

-- Parsers to install on the nvim-treesitter `main` branch.
-- (main replaced the old module table: no indent/highlight/rainbow/ensure_installed
--  keys — highlighting is enabled via a FileType autocmd in plugins.lua, and parsers
--  are installed with require("nvim-treesitter").install(...).)
M.treesitter_ensure = {
  "vim", "vimdoc", "graphql", "lua", "http", "html", "css",
  "markdown", "markdown_inline", "python", "javascript", "typescript", "tsx",
  "json", "vue", "svelte", "dockerfile", "go", "gomod", "gowork", "regex",
  "ruby", "rust", "toml", "yaml", "hcl", "c", "zig", "bash", "cmake", "make",
  "latex", -- render-markdown math ($...$ / $$...$$)
}

  M.mason_lsp = {
    automatic_installation = true,
    ensure_installed = {
      "terraformls",
      "graphql",
      "dockerls",
      "prismals",
      "bashls",
      "rust_analyzer",
      "ts_ls",
      "lua_ls",
      "eslint",
      "gopls",
      "cssls",
      "css_variables",
      "html",
      "solang",
      "clangd",
      "graphql",
      "pyright",
      "ruff",
      "markdown_oxide"
    }
  }

  M.obsidian = {
    workspaces = {
      {
        name = "dtksi",
        path = "~/Obsidian_Vault/obsidian-bckp/21times2/",
      },
    },
    -- completion.nvim_cmp removed: the fork now provides completion via the
    -- built-in obsidian-ls LSP server automatically.
    legacy_commands = false, -- use new `Obsidian <subcommand>` form, silence the warning
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
      folder = "Resources/Assets" -- renamed from img_folder
    },
    ui = {
      enable = false,
    },
    -- follow_url_func removed: the fork uses vim.ui.open by default, which on
    -- macOS opens with `open` just like the old jobstart call did.
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
  }

  return M
