local null_ls = require "null-ls"
local formatting = null_ls.builtins.formatting

local sources = {
  formatting.gofmt,
  formatting.golines.with {
    extra_args = { "--max-len", "80" },
  },

  formatting.stylua,
}

null_ls.setup {
  sources = sources,
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
