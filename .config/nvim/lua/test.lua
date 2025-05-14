local devicons = require('nvim-web-devicons')
local icon, color = devicons.get_icon_color_by_filetype('lua') -- 'lua' の部分を他のファイルタイプに変更可能
print(icon, color)
