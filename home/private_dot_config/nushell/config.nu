# config.nu
#
# Installed by:
# version = "0.101.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

# Disable nushell welcome banner
$env.config.show_banner = false

# Default editor
$env.config.buffer_editor = "nvim"

# Enable vi mode on command line
$env.config.edit_mode = "vi"

# Indicators for vi mode
$env.PROMPT_INDICATOR_VI_NORMAL = "󱊷 "
$env.PROMPT_INDICATOR_VI_INSERT = " "

# Completions
$env.config.completions.algorithm = "fuzzy"

# History
$env.config.history.file_format = "sqlite" # sqlite has more capabilities than plaintext

# Directory bookmarks, similar to bashmarks or wd
source ~/.config/nushell/bookmark_for_dir.nu

# Zoxide
source ~/.config/nushell/.zoxide.nu

# Oh My Posh
source ~/.config/nushell/.oh-my-posh.nu

# Aliases
alias clr = clear
alias xit = exit
# Show all files in long format
alias ll = ls -lsa
alias lt = eza --icons always --color=always -la --tree --level 5 --ignore-glob ".git"
# Output file listing in tree format
alias as-tree = tree --fromfile
# Use bat instead of cat
alias cat = bat --paging=never
# Tail systemd logs (with colors)
def syslog [] { ^journalctl -f | bat --paging=never -l log --style plain }
# Fuzzy find files (with preview) and open them in nvim
def ffv [] { ^fd --type file --color always --hidden --exclude .git | fzf --multi --bind "f1:toggle-all" --bind "enter:become(nvim {+})" --preview "bat --color=always --style=numbers,changes --line-range=:200 {}" }

# Aliases to make bookmark_for_dir.nu feel like bashmarks
alias g = bm
alias s = bm -a
alias d = bm -d
alias l = bm

# Alias nvim
alias e = nvim
