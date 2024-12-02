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
    automatic_installation = true,
    ensure_installed = {
      "vim",
      "vimdoc",
      "graphql",
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
    }
  }

  M.obsidian = {
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
    ui = {
      enable = false,
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
  }

  return M
