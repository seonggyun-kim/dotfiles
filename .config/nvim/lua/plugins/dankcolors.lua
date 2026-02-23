return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#121414',
				base01 = '#121414',
				base02 = '#7b8485',
				base03 = '#7b8485',
				base04 = '#cad5d7',
				base05 = '#f8feff',
				base06 = '#f8feff',
				base07 = '#f8feff',
				base08 = '#ff9fc0',
				base09 = '#ff9fc0',
				base0A = '#cddee1',
				base0B = '#9ff6a8',
				base0C = '#f3fdff',
				base0D = '#cddee1',
				base0E = '#ecfcff',
				base0F = '#ecfcff',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#7b8485',
				fg = '#f8feff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#cddee1',
				fg = '#121414',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#7b8485' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#f3fdff', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#ecfcff',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#cddee1',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#cddee1',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#f3fdff',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#9ff6a8',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#cad5d7' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#cad5d7' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#7b8485',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
