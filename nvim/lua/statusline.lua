-----------------------------------
--                               --
--  -jobcmax/natefr statusline-  --
--                               --
-----------------------------------

local feline = require('feline')
local vi_mode = require('feline.providers.vi_mode')

--
-- 1. define some constants
--

-- left and right constants (first and second items of the components array)
local LEFT = 1
local RIGHT = 2

-- vi mode color configuration
local MODE_COLORS = {
  ['NORMAL'] = 'green',
  ['COMMAND'] = 'blue',
  ['INSERT'] = 'blue',
  ['REPLACE'] = 'blue',
  ['LINES'] = 'violet',
  ['VISUAL'] = 'violet',
  ['OP'] = 'yellow',
  ['BLOCK'] = 'yellow',
  ['V-REPLACE'] = 'yellow',
  ['ENTER'] = 'yellow',
  ['MORE'] = 'yellow',
  ['SELECT'] = 'blue',
  ['SHELL'] = 'yellow',
  ['TERM'] = 'yellow',
  ['NONE'] = 'yellow',
}

local DECAY = {
  fg = '#dee1e6',
  bg = '#101419',
  black = '#1f2328',
  skyblue = '#74bee9',
  cyan = '#74bee9',
  green = '#78dba9',
  oceanblue = '#70a5eb',
  blue = '#70a5eb',
  magenta = '#c68aee',
  orange = '#f1cf8a',
  red = '#e05f65',
  violet = '#c68aee',
  white = '#dee1e6',
  yellow = '#f1cf8a',
}

local TOKYONIGHT = {
  fg = '#a9b1d6',
  bg = '#1a1b26',
  black = '#32344a',
  skyblue = '#449dab',
  cyan = '#449dab',
  green = '#9ece6a',
  oceanblue = '#7aa2f7',
  blue = '#7aa2f7',
  magenta = '#ad8ee6',
  orange = '#e0af68',
  red = '#f7768e',
  violet = '#ad8ee6',
  white = '#a9b1d6',
  yellow = '#e0af68',
}

--
-- 2. setup some helpers
--

--- get the current buffer's file type, defaults to '[not type]'
function get_filetype()
  local filetype = vim.bo.filetype
  if filetype == '' then
    filetype = '[no type]'
  end
  return filetype:lower()
end

--- get the cursor's line
function get_line_cursor()
  local cursor_line, _ = unpack(vim.api.nvim_win_get_cursor(0))
  return cursor_line
end

function get_cursor_position()
    local r,c = unpack(vim.api.nvim_win_get_cursor(0))
    return c
end

--- wrap a string with whitespaces
function wrap(string)
  return ' ' .. string .. ' '
end

--- wrap a string with whitespaces and add a '' on the left,
-- use on left section components for a nice  transition
function wrap_left(string)
  return ' ' .. string .. ' '
end

--- wrap a string with whitespaces and add a '' on the right,
-- use on left section components for a nice  transition
function wrap_right(string)
  return ' ' .. string .. ' '
end

--- decorate a provider with a wrapper function
-- the provider must conform to signature: (component, opts) -> string
-- the wrapper must conform to the signature: (string) -> string
function wrapped_provider(provider, wrapper)
  return function(component, opts)
    return wrapper(provider(component, opts))
  end
end

--
-- 3. setup custom providers
--

--- provide the vim mode (NOMRAL, INSERT, etc.)
function provide_mode(component, opts)
  return vi_mode.get_vim_mode()
end

--- provide the buffer's file name
function provide_filename(component, opts)
  return get_filename()
end

--- provide the line's information (curosor position and file's total lines)
function provide_linenumber(component, opts)
  return get_line_cursor() .. ':' .. get_cursor_position()
end

-- provide the buffer's file type
function provide_filetype(component, opts)
  return get_filetype()
end

--
-- 4. build the components
--

local components = {
  -- components when buffer is active
  active = {
    {}, -- left section
    {}, -- right section
  },
  -- components when buffer is inactive
  inactive = {
    {}, -- left section
    {}, -- right section
  },
}

-- insert the mode component at the beginning of the left section
table.insert(components.active[LEFT], {
  name = 'mode',
  provider = wrapped_provider(provide_mode, wrap),
  right_sep = '',
  -- hl needs to be a function to avoid calling get_mode_color
  -- before feline initiation
  hl = function()
    return {
      fg = 'bg',
      bg = vi_mode.get_mode_color(),
    }
  end,
})

-- insert the filename component after the mode component
table.insert(components.active[LEFT], {
  name = 'file_info',
  left_sep = 'block',
  provider = {
    name = 'file_info',
    opts = {
        type = 'unique',
        file_modified_icon = '*',
        file_readonly_icon = ' ',
    },
    hl = {
        bg = 'bg',
        fg = 'white',
    },
  },
  icon = '',
})

-- line scroll bar
-- table.insert(components.active[RIGHT], {
  -- name = 'scroll_bar',
  -- provider = 'scroll_bar',
  -- left_sep = '',
  -- hl = {
    -- bg = 'bg',
    -- fg = 'skyblue',
  -- },
-- })

-- insert the linenumber component at the end of the left right section
table.insert(components.active[RIGHT], {
  name = 'position',
  provider = wrapped_provider(provide_linenumber, wrap),
  left_sep = '',
  hl = {
    bg = 'bg',
    fg = 'fg',
  },
})

-- insert the filetype component before the linenumber component
table.insert(components.active[RIGHT], {
  name = 'filetype',
  provider = wrapped_provider(provide_filetype, wrap_right),
  left_sep = '',
  hl = function()
    return {
      fg = 'bg',
      bg = 'blue',
    }
  end,
})

table.insert(components.inactive[LEFT], {
  name = 'mode_inactive',
  provider = wrapped_provider(provide_mode, wrap),
  right_sep = '',
  -- hl needs to be a function to avoid calling get_mode_color
  -- before feline initiation
  hl = function()
    return {
      fg = 'fg',
      bg = 'black',
    }
  end,
})

-- insert the inactive filename component at the beginning of the left section
table.insert(components.inactive[LEFT], {
  name = 'file_info_inactive',
  left_sep = 'block',
  provider = {
    name = 'file_info',
    opts = {
        type = 'unique',
        file_modified_icon = '*',
        file_readonly_icon = ' ',
    },
    hl = {
        bg = 'bg',
        fg = 'white',
    },
  },
  icon = '',
})


--
-- 5. run the feline setup
--

feline.setup({
  theme = DECAY,
  components = components,
  vi_mode_colors = MODE_COLORS,
})

