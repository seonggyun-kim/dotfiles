return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#111318',
				base01 = '#111318',
				base02 = '#77797f',
				base03 = '#77797f',
				base04 = '#979aa1',
				base05 = '#d9dbdf',
				base06 = '#d9dbdf',
				base07 = '#d9dbdf',
				base08 = '#cf8196',
				base09 = '#cf8196',
				base0A = '#7b85a9',
				base0B = '#78b882',
				base0C = '#b8bfd7',
				base0D = '#7b85a9',
				base0E = '#9ba5c8',
				base0F = '#9ba5c8',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#77797f',
				fg = '#d9dbdf',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#7b85a9',
				fg = '#111318',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#77797f' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#b8bfd7', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#9ba5c8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#7b85a9',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#7b85a9',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#b8bfd7',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#78b882',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#979aa1' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#979aa1' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#77797f',
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
