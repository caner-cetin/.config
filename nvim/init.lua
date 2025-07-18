vim.g.mapleader = " "
vim.g.maplocalleader = " "

local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "installing mini.nvim" | redraw')
	local clone_cmd = { "git", "clone", "--filter=blob:none", "https://github.com/echasnovski/mini.nvim", mini_path }
	vim.fn.system(clone_cmd)
end
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
now(function()
	require("mini.basics").setup()
	require("mini.statusline").setup()
	require("mini.pick").setup()
	require("mini.completion").setup()
	require("mini.icons").setup()
	require("mini.bufremove").setup()

	vim.keymap.set("n", "<leader>bd", function()
		require("mini.bufremove").delete(0, true)
	end, { desc = "delete buffer" })

	vim.keymap.set("n", "<leader>bD", function()
		require("mini.bufremove").delete(0, true)
	end, { desc = "force delete buffer" })

	require("mini.tabline").setup({
		show_icons = true,
	})
end)
later(function()
	require("mini.pairs").setup()
	require("mini.surround").setup()
	require("mini.comment").setup()
	require("mini.indentscope").setup()
	require("mini.jump2d").setup()
	require("mini.cursorword").setup()
	require("mini.notify").setup()
	require("mini.snippets").setup()
	require("mini.animate").setup()
	require("mini.sessions").setup()
end)

add("neovim/nvim-lspconfig")
add("williamboman/mason.nvim")
add("williamboman/mason-lspconfig.nvim")
add("nvim-treesitter/nvim-treesitter")
add("folke/trouble.nvim")
later(function()
	require("mason").setup()
	local lspconfig = require("lspconfig")
	lspconfig.gopls.setup({})
	lspconfig.pyright.setup({})
	lspconfig.ts_ls.setup({})
	lspconfig.lua_ls.setup({})
	lspconfig.harper_ls.setup({})
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(event)
			local opts = { buffer = event.buf }
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
			vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		end,
	})
	require("trouble").setup({})

	vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", opts)
	vim.keymap.set("n", "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", opts)
end)

add("ray-x/go.nvim")
add("ray-x/guihua.lua")
later(function()
	require("go").setup({
		goimport = "gopls",
		fillstruct = "gopls",
		trouble = false,
		luasnip = false,
	})
end)
add("stevearc/conform.nvim")
later(function()
	require("conform").setup({
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			go = { "gopls" },
		},
	})
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*",
		callback = function()
			require("conform").format()
		end,
	})
end)

add("folke/which-key.nvim")
later(function()
	require("which-key").setup({
		delay = 500,
		preset = "modern",
	})
end)
add({
	source = "nvim-neo-tree/neo-tree.nvim",
	depends = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
})
later(function()
	require("neo-tree").setup({
		filesystem = {
			filtered_items = {
				visible = true,
				hide_dotfiles = false,
				hide_gitignored = true,
			},
		},
	})
end)

add({
	source = "nvim-telescope/telescope.nvim",
	depends = { "nvim-lua/plenary.nvim" },
})
later(function()
	local telescope = require("telescope.builtin")
	vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "telescope find files" })
	vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "telescope live grep" })
	vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "telescope buffers" })
	vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "telescope help" })
end)
add("cameron-wags/rainbow_csv.nvim")
later(function()
	require("rainbow_csv").setup()
end)
add("MeanderingProgrammer/render-markdown.nvim")
add("EdenEast/nightfox.nvim")
vim.cmd("colorscheme nordfox")
