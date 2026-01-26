# config.nu - Nushell 配置文件
# 版本: 0.109.1

# ═══════════════════════════════════════════════════════════════════════════════
# 🎨 主题和外观设置
# ═══════════════════════════════════════════════════════════════════════════════

$env.config = {
    show_banner: false                   # 禁用默认 banner，使用自定义欢迎信息
    
    # 表格样式 - 像 bash 一样无边框
    table: {
        mode: none                        # 无边框，类似 bash
        index_mode: auto                  # 自动显示索引
        show_empty: true                  # 显示空值
        padding: { left: 1, right: 1 }    # 左右留空
        trim: {
            methodology: wrapping         # 自动换行
            wrapping_try_keep_words: true # 保持单词完整
        }
        header_on_separator: false
    }
    
    # 历史记录设置
    history: {
        max_size: 10000                   # 历史记录最大条目（减少以提高性能）
        sync_on_enter: true               # 每次执行命令后同步
        file_format: "sqlite"             # 使用 sqlite 格式，性能更好
        isolation: false                  # 共享历史记录
    }
    
    # 补全设置
    completions: {
        case_sensitive: false             # 大小写不敏感
        quick: true                       # 快速补全
        partial: true                     # 部分匹配
        algorithm: "fuzzy"                # 模糊匹配算法
        external: {
            enable: true                  # 启用外部命令补全
            max_results: 100
            completer: null
        }
        use_ls_colors: true               # 使用 LS_COLORS 着色
    }
    
    
    # 颜色配置
    color_config: {
        separator: white
        leading_trailing_space_bg: { attr: n }
        header: green_bold
        empty: blue
        bool: light_cyan
        int: white
        filesize: cyan
        duration: white
        date: purple
        range: white
        float: white
        string: white
        nothing: white
        binary: white
        cell_path: white
        row_index: green_bold
        record: white
        list: white
        block: white
        hints: dark_gray
        search_result: { bg: red fg: white }
        shape_and: purple_bold
        shape_binary: purple_bold
        shape_block: blue_bold
        shape_bool: light_cyan
        shape_closure: green_bold
        shape_custom: green
        shape_datetime: cyan_bold
        shape_directory: cyan
        shape_external: cyan
        shape_externalarg: green_bold
        shape_external_resolved: light_yellow_bold
        shape_filepath: cyan
        shape_flag: blue_bold
        shape_float: purple_bold
        shape_garbage: { fg: white bg: red attr: b }
        shape_glob_interpolation: cyan_bold
        shape_globpattern: cyan_bold
        shape_int: purple_bold
        shape_internalcall: cyan_bold
        shape_keyword: cyan_bold
        shape_list: cyan_bold
        shape_literal: blue
        shape_match_pattern: green
        shape_matching_brackets: { attr: u }
        shape_nothing: light_cyan
        shape_operator: yellow
        shape_or: purple_bold
        shape_pipe: purple_bold
        shape_range: yellow_bold
        shape_raw_string: light_purple
        shape_record: cyan_bold
        shape_redirection: purple_bold
        shape_signature: green_bold
        shape_string: green
        shape_string_interpolation: cyan_bold
        shape_table: blue_bold
        shape_variable: purple
        shape_vardecl: purple
    }
    
    # 编辑模式 (emacs 或 vi)
    edit_mode: emacs
    
    # Shell 集成 (WezTerm 兼容性修复)
    shell_integration: {
        osc2: true
        osc7: true
        osc8: true
        osc9_9: false
        osc133: false                     # 禁用以修复 WezTerm 换行问题
        osc633: false                     # 禁用以修复 WezTerm 换行问题
        reset_application_mode: true
    }
    
    # 渲染正确退出码
    render_right_prompt_on_last_line: false
    
    # 使用 kitty 键盘协议 (WezTerm 支持)
    use_kitty_protocol: true
    
    # 高亮搜索关键词
    highlight_resolved_externals: true
    
    # 递归监控模式
    recursion_limit: 50
    
    # 插件垃圾回收
    plugin_gc: {
        default: {
            enabled: true
            stop_after: 10sec
        }
        plugins: {}
    }
    
    # 钩子
    hooks: {
        pre_prompt: [{ null }]
        pre_execution: [{ null }]
        env_change: {
            PWD: [{|before, after| null }]
        }
        display_output: "if (term size).columns >= 100 { table -e } else { table }"
        command_not_found: { null }
    }
    
    # 菜单配置
    menus: [
        {
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
                layout: columnar
                columns: 4
                col_width: 20
                col_padding: 2
            }
            style: {
                text: green
                selected_text: { attr: r }
                description_text: yellow
                match_text: { attr: u }
                selected_match_text: { attr: ur }
            }
        }
        {
            name: history_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: list
                page_size: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
        {
            name: help_menu
            only_buffer_difference: true
            marker: "? "
            type: {
                layout: description
                columns: 4
                col_width: 20
                col_padding: 2
                selection_rows: 4
                description_rows: 10
            }
            style: {
                text: green
                selected_text: green_reverse
                description_text: yellow
            }
        }
    ]
    
    # 按键绑定
    keybindings: [
        {
            name: completion_menu
            modifier: none
            keycode: tab
            mode: [emacs vi_normal vi_insert]
            event: {
                until: [
                    { send: menu name: completion_menu }
                    { send: menunext }
                    { edit: complete }
                ]
            }
        }
        {
            name: completion_previous
            modifier: shift
            keycode: backtab
            mode: [emacs, vi_normal, vi_insert]
            event: { send: menuprevious }
        }
        {
            name: history_menu
            modifier: control
            keycode: char_r
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: history_menu }
        }
        {
            name: help_menu
            modifier: none
            keycode: f1
            mode: [emacs, vi_insert, vi_normal]
            event: { send: menu name: help_menu }
        }
        {
            name: escape
            modifier: none
            keycode: escape
            mode: [emacs, vi_normal, vi_insert]
            event: { send: esc }
        }
        {
            name: cancel_command
            modifier: control
            keycode: char_c
            mode: [emacs, vi_normal, vi_insert]
            event: { send: ctrlc }
        }
        {
            name: quit_shell
            modifier: control
            keycode: char_d
            mode: [emacs, vi_normal, vi_insert]
            event: { send: ctrld }
        }
        {
            name: clear_screen
            modifier: control
            keycode: char_l
            mode: [emacs, vi_normal, vi_insert]
            event: { send: clearscreen }
        }
        {
            name: open_editor
            modifier: control
            keycode: char_o
            mode: [emacs, vi_normal, vi_insert]
            event: { send: openeditor }
        }
        {
            name: move_left
            modifier: none
            keycode: left
            mode: [emacs, vi_normal, vi_insert]
            event: { edit: moveleft }
        }
        {
            name: move_right
            modifier: none
            keycode: right
            mode: [emacs, vi_normal, vi_insert]
            event: {
                until: [
                    { send: historyhintcomplete }
                    { send: menuright }
                    { edit: moveright }
                ]
            }
        }
        {
            name: move_word_left
            modifier: control
            keycode: left
            mode: [emacs, vi_normal, vi_insert]
            event: { edit: movewordleft }
        }
        {
            name: move_word_right
            modifier: control
            keycode: right
            mode: [emacs, vi_normal, vi_insert]
            event: { edit: movewordright }
        }
        {
            name: move_to_line_start
            modifier: none
            keycode: home
            mode: [emacs, vi_normal, vi_insert]
            event: { edit: movetolinestart }
        }
        {
            name: move_to_line_end
            modifier: none
            keycode: end
            mode: [emacs, vi_normal, vi_insert]
            event: { edit: movetolineend }
        }
        {
            name: delete_word
            modifier: control
            keycode: backspace
            mode: [emacs, vi_insert]
            event: { edit: backspaceword }
        }
        {
            name: history_previous
            modifier: none
            keycode: up
            mode: [emacs, vi_normal, vi_insert]
            event: { send: up }
        }
        {
            name: history_next
            modifier: none
            keycode: down
            mode: [emacs, vi_normal, vi_insert]
            event: { send: down }
        }
    ]
}

# ═══════════════════════════════════════════════════════════════════════════════
# 📁 常用别名
# ═══════════════════════════════════════════════════════════════════════════════

# 目录导航
alias .. = cd ..
alias ... = cd ../..
alias .... = cd ../../..
alias ~ = cd ~
alias dot = cd V:\Coding\dotfiles

# ls 增强
alias ll = ls -l
alias la = ls -a
alias lla = ls -la

# 常用命令简写
alias c = clear
alias e = exit
alias h = history

# Git 别名
alias g = git
alias gs = git status
alias ga = git add
alias gc = git commit
alias gp = git push
alias gl = git pull
alias gd = git diff
alias gb = git branch
alias gco = git checkout
alias glog = git log --oneline -20

# 编辑器
alias v = nvim
alias vi = nvim
alias vim = nvim

# scoop
alias sup = scoop update '*' 

# 美化工具替代 (需安装: scoop install bat lsd delta bottom)
alias cat = bat --style=auto
alias ls = lsd
alias ll = lsd -l
alias la = lsd -a
alias lla = lsd -la
alias tree = lsd --tree
alias diff = delta
alias top = btm


# ═══════════════════════════════════════════════════════════════════════════════
# 🔧 自定义函数
# ═══════════════════════════════════════════════════════════════════════════════

# 创建目录并进入
def mkcd [dir: string] {
    mkdir $dir
    cd $dir
}

# 查找文件（使用 fd 如果可用）
def ff [pattern: string] {
    if (which fd | is-not-empty) {
        fd $pattern
    } else {
        ls **/* | where name =~ $pattern | get name
    }
}

# 查看目录大小
def dsize [path: string = "."] {
    ls -a $path | get size | math sum
}

# 快速备份文件
def backup [file: string] {
    let backup_name = $"($file).bak.((date now) | format date '%Y%m%d_%H%M%S')"
    cp $file $backup_name
    print $"Backup created: ($backup_name)"
}

# 显示 PATH 环境变量（更易读）
def show-path [] {
    $env.PATH | each { |p| print $p }
}

# 快速查看 JSON 文件
def jcat [file: string] {
    open $file | to json -i 2
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🌈 提示符配置 (Starship)
# ═══════════════════════════════════════════════════════════════════════════════
# 安装: scoop install starship
# 配置: ~/.config/starship.toml

$env.STARSHIP_SHELL = "nu"
$env.PROMPT_COMMAND = { || starship prompt --cmd-duration $env.CMD_DURATION_MS }
$env.PROMPT_COMMAND_RIGHT = { || starship prompt --right }
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.PROMPT_MULTILINE_INDICATOR = "::: "

# 旧的自定义提示符（已被 Starship 替代）
# $env.PROMPT_COMMAND = {||
#     let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
#         null => $env.PWD
#         '' => '~'
#         $relative_pwd => ([~ $relative_pwd] | path join)
#     }
#     let path_color = (ansi green_bold)
#     let separator_color = (ansi cyan)
#     let git_color = (ansi magenta)
#     let reset = (ansi reset)
#     let git_branch = (do --ignore-errors { git rev-parse --abbrev-ref HEAD } | complete | get stdout | str trim)
#     let git_info = if ($git_branch | is-not-empty) { $" ($separator_color)on ($git_color)󰊢 ($git_branch)($reset)" } else { "" }
#     $"($path_color)($dir)($reset)($git_info) ($separator_color)❯($reset) "
# }


# yazi
# 定义 yazi 函数，实现退出时自动跳转目录
def --env yy [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -f $tmp
}

def oo [] {
    let os = (sys host | get name)
    if $os == "Windows" {
        explorer .
    } else if $os == "Darwin" {
        open .
    } else {
        xdg-open .
    }
}

# ═══════════════════════════════════════════════════════════════════════════════
# 🚀 启动时执行
# ═══════════════════════════════════════════════════════════════════════════════

# ═══════════════════════════════════════════════════════════════════════════════
# 🚀 Zoxide 智能目录跳转
# ═══════════════════════════════════════════════════════════════════════════════
# 用法: z <目录关键词>  |  zi <交互式选择>

source ~/.cache/.zoxide.nu

# ═══════════════════════════════════════════════════════════════════════════════
# 📜 Atuin 历史记录管理
# ═══════════════════════════════════════════════════════════════════════════════
# 安装: scoop install atuin
# 初始化: atuin init nu | save -f ~/.cache/.atuin.nu
# 用法: Ctrl+R 搜索历史  |  atuin stats 查看统计

source ~/.cache/.atuin.nu
