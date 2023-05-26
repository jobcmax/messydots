require("startup").setup({
    -- every line should be same width without escaped \
    header = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Header",
        margin = 10,
        content = {
            "                                      ",
            "                                      ",
            "                                      ",
            "▄██████▄ ▄█████▄ ▄█████▄▄███▄ ▄███    ",
            "███████████████████████████████████   ",
            "████████████████████████ ████ ██ ███  ",
            "▀████▀  ████▀  ████▀  ███ ████▄ ▄████ ",
            "   ██▄▄██▀▀█▄▄███▀█▄▄███▀ ▀███▀ ▀███▀ ",
        },
        highlight = "Statement",
        default_color = "",
        oldfiles_amount = 0,
    },
    -- name which will be displayed and command
    body = {
        type = "mapping",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Basic Commands",
        margin = 5,
        content = {
            { "File Browser", "Lf", "<leader>o" },
            { "New File", "lua require'startup'.new_file()", "<leader>r" },
        },
        highlight = "String",
        default_color = "",
        oldfiles_amount = 0,
    },
    footer = {
        type = "text",
        oldfiles_directory = false,
        align = "center",
        fold_section = false,
        title = "Footer",
        margin = 5,
        content = { "I LOVE LEAAANNN" },
        highlight = "Number",
        default_color = "",
        oldfiles_amount = 0,
    },

    options = {
        mapping_keys = true,
        cursor_column = 0.5,
        empty_lines_between_mappings = true,
        disable_statuslines = false,
        -- paddings = { 1, 3, 3, 0 },
    },
    mappings = {
        open_file = "<c-o>",
    },
    parts = { "header", "body", "footer" },
})
