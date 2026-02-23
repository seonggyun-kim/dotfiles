vim.pack.add({
  -- Theme
  { src = "shaunsingh/nord.nvim" },

  -- File navigation
  { src = "stevearc/oil.nvim" },
  { src = "nvim-lua/plenary.nvim" },
  { src = "nvim-telescope/telescope.nvim" },
  {
    src = 'https://github.com/nvim-neo-tree/neo-tree.nvim',
    version = vim.version.range('3')
  },

  -- Syntax and utilities
  { src = "https://github.com/tmux-plugins/vim-tmux" },
  { src = "https://github.com/NvChad/nvim-colorizer.lua" },

  -- dependencies
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  -- Terminal
  { src = "akinsho/toggleterm.nvim" },

  -- Syntax highlighting
  { src = "nvim-treesitter/nvim-treesitter",                             build = ":TSUpdate" },

  -- LSP (native Neovim 0.12+)
  { src = "neovim/nvim-lspconfig" },

  -- Document editing
  { src = "lervag/vimtex" },
  { src = "chomosuke/typst-preview.nvim" },
  { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim" },
})

----------------------------------------------------------------
-- Theme configuration
----------------------------------------------------------------
vim.g.nord_contrast = false
vim.g.nord_borders = true
vim.g.nord_disable_background = true
vim.g.nord_italic = false
vim.g.nord_uniform_diff_background = true
vim.g.nord_bold = false

-- Apply theme
require('nord').set()
vim.cmd.colorscheme("nord")

-- Make floating windows transparent
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none' })

----------------------------------------------------------------
-- Oil (file explorer)
----------------------------------------------------------------
require("oil").setup({
  view_options = { show_hidden = true },
  float = {
    padding = 2,
    max_width = 90,
    max_height = 30,
    border = "rounded",
  },
  keymaps = {
    ["<C-c>"] = "actions.close",
    ["<C-h>"] = false,
    ["<C-l>"] = false,
  },
})

----------------------------------------------------------------
-- Telescope (fuzzy finder)
----------------------------------------------------------------
require("telescope").setup({
  defaults = {
    sorting_strategy = "ascending",
    layout_config = { prompt_position = "top" },
  },
  pickers = {
    find_files = {
      find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }
    },
  },
})

----------------------------------------------------------------
-- Treesitter (syntax highlighting)
----------------------------------------------------------------
local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if ok then
  treesitter.setup({
    ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "html",
      "javascript",
      "json",
      "latex",
      "lua",
      "python",
      "tsx",
      "typst",
      "typescript",
    },
    highlight = { enable = true },
    indent = { enable = true },
  })
end

----------------------------------------------------------------
-- ToggleTerm (terminal)
----------------------------------------------------------------
require("toggleterm").setup({
  size = 20,
  open_mapping = [[<c-\>]],
  direction = "horizontal",
  start_in_insert = true,
})

----------------------------------------------------------------
-- Neotree (file tree)
----------------------------------------------------------------
local ok_neotree, neotree = pcall(require, "neo-tree")
if ok_neotree then
  neotree.setup({
    close_if_last_window = true,
    window = {
      width = 30,
      mappings = {
        ["<C-c>"] = "close_window",
        ["h"] = "parent",
        ["l"] = "open",
      },
    },
    filesystem = {
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  })
end

----------------------------------------------------------------
----------------------------------------------------------------
-- Colorizer (color code preview)
----------------------------------------------------------------
local ok_colorizer, colorizer = pcall(require, "colorizer")
if ok_colorizer then
  colorizer.setup({
    filetypes = { "*" },
    user_default_options = {
      RGB = true,      -- #RGB hex codes
      RRGGBB = true,   -- #RRGGBB hex codes
      names = true,    -- "Name" codes like Blue
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      rgb_fn = true,   -- CSS rgb() and rgba() functions
      hsl_fn = true,   -- CSS hsl() and hsla() functions
      css = true,      -- Enable all CSS features
      css_fn = true,   -- Enable all CSS functions
    },
  })
end

----------------------------------------------------------------
-- Render Markdown (inline rendering)
----------------------------------------------------------------
local ok_render, render = pcall(require, "render-markdown")
if ok_render then
  render.setup({
    enabled = false, -- Start disabled, toggle with <leader>mr
  })
end
