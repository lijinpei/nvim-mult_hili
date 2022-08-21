-- split rgb_str of the form '#rrggbb'
local function split_rgb_component(rgb_str)
	assert(type(rgb_str) == "string")
	local len = string.len(rgb_str)
	assert(len == 6 or len == 7)
	local r_start = 1
	if len == 7 then
		assert(rgb_str:sub(1, 1) == "#")
		r_start = 2
	end
	local r_str = rgb_str:sub(r_start, r_start + 1)
	local g_str = rgb_str:sub(r_start + 2, r_start + 3)
	local b_str = rgb_str:sub(r_start + 4, r_start + 6)
	return tonumber(r_str, 16), tonumber(g_str, 16), tonumber(b_str, 16)
end

local function get_rgb_complement_high_contrast(val)
	assert(type(val) == "number")
	local result = 255 - val
	if result < val then
		if result - val >= -50 then
			return result - 50
		else
			return result
		end
	else
		if result - val <= 50 then
			return result + 50
		else
			return result
		end
	end
end

local function get_rgb_str(r_val, g_val, b_val)
	return string.format("#%02x%02x%02x", r_val, g_val, b_val)
end

local function get_css_bg_name(css_name)
	return "CSS_" .. css_name .. "_BG"
end

local function get_css_fg_name(css_name)
	return "CSS_" .. css_name .. "_FG"
end

local css_colors = {}
local current_path = vim.fn.expand("<sfile>")
-- TODO: a better way to handle the lua path component
local css_named_colors_file = current_path:match("^.*/") .. "../lua/css_named_colors.txt"
for line in io.lines(css_named_colors_file) do
	name, rgb_str, r_str, g_str, b_str = string.match(line, "(%w+)%s*(#%w+)%s*(%d+)%s*(%d+)%s*(%d+)%s*")
	r1, g1, b1 = split_rgb_component(rgb_str)
	r2, g2, b2 = tonumber(r_str, 10), tonumber(g_str, 10), tonumber(b_str, 10)
	assert(r1 == r2 and g1 == g2 and b1 == b2)
	table.insert(css_colors, name)
	r3, g3, b3 =
		get_rgb_complement_high_contrast(r1), get_rgb_complement_high_contrast(g1), get_rgb_complement_high_contrast(b1)
	comp_str = get_rgb_str(r3, g3, b3)
	bg_cmd = "highlight " .. get_css_bg_name(name) .. " guifg=" .. comp_str .. " guibg=" .. rgb_str
	fg_cmd = "highlight " .. get_css_fg_name(name) .. " guifg=" .. rgb_str .. " guibg=" .. comp_str
	vim.api.nvim_command(bg_cmd)
	vim.api.nvim_command(fg_cmd)
end

-- print(vim.inspect(css_colors))
local match_patterns = {}
local base_vim_id = 10

local function get_vim_id(id)
	return id + base_vim_id
end

local function get_unused_id()
	return #match_patterns + 1
end

local function take_unused_id(pattern)
	local id = get_unused_id()
	assert(id <= #css_colors)
	match_patterns[id] = pattern
	return id
end

local function add_highlight(pattern)
	local id = take_unused_id(pattern)
	local vim_id = get_vim_id(id)
	local group = get_css_bg_name(css_colors[id])
	vim.fn.matchadd(group, pattern, 10, vim_id)
	return id
end

local function delete_highlight_id(id_to_delete)
	local old_item = match_patterns[id_to_delete]
	match_patterns[id_to_delete] = nil
	if old_item ~= nil then
		vim.fn.matchdelete(get_vim_id(id_to_delete))
	end
end

local function delete_highlight_pattern(pattern)
	for key, pat in pairs(match_patterns) do
		if pat == pattern then
			delete_highlight_id(key)
		end
	end
end

local function delete_highlight(to_delete)
	local type_str = type(to_delete)
	if type_str == "number" then
		return delete_highlight_id(to_delete)
	end
	if type_str == "string" then
		return delete_highlight_pattern(to_delete)
	end
	assert(false)
end

local function list_highlights()
	for key, pattern in pairs(match_patterns) do
		print(string.format("%3d %15s %s", key, css_colors[key], pattern))
	end
end

local function next_pos(id)
	pattern = match_patterns[id]
	vim.fn.search(pattern)
end

local function prev_pos(id)
	pattern = match_patterns[id]
	vim.fn.search(pattern, "b")
end

return {
	add_highlight = add_highlight,
	delete_highlight = delete_highlight,
	list_highlights = list_highlights,
	next_pos = next_pos,
	prev_pos = prev_pos,
}
