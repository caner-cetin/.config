local function open_nvim_tree()
  -- open the tree
  require("nvim-tree.api").tree.open()
end
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })


return {
  {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("go").setup({
      lsp_cfg = false, -- we manually configure lsp above
      lsp_gofumpt = true,
      dap_debug = true,
    })
  end,
  ft = {"go", "gomod"},
  build = ':lua require("go.install").update_all_sync()'
},
  {
    "jose-elias-alvarez/null-ls.nvim", 
    ft = { "go", "lua" },
    opts = function()
      return require "configs.null-ls"   
    end,
  },
  {
  "folke/trouble.nvim",
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>xX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cl",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP Definitions / references / ... (Trouble)",
    },
    {
      "<leader>xL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>xQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
},
  {
  'vyfor/cord.nvim',
  build = ':Cord update',
  editing = function (opts)
      return string.format('Editing %s - %s:%s', opts.filename, opts.cursor_line, opts.cursor_char)
    end,
  lazy = false,
  -- opts = {}
  },
  {
    "kevinhwang91/nvim-ufo",
    event = "VimEnter",
    init = function()
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 100 -- Using ufo provider need a large value
      vim.o.foldlevelstart = 100
      -- vim.o.foldnestmax = 1
      vim.o.foldenable = true
      vim.o.foldmethod = "indent"

      vim.opt.fillchars = {
        fold = " ",
        foldopen = "",
        foldsep = " ",
        foldclose = "",
        stl = " ",
        eob = " ",
      }
    end,
    dependencies = {
      "kevinhwang91/promise-async",
    },
    opts = {
      close_fold_kinds_for_ft = { default = { "imports" } },
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
    },
  },
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
