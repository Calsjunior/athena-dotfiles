# =============================================================================
#  ZSH HISTORY
# =============================================================================
HISTFILE="$HOME/.zsh_history"    # Where to save history
HISTSIZE=10000                   # How many lines to keep in memory
SAVEHIST=10000                   # How many lines to save to disk
setopt SHARE_HISTORY             # Share history across terminals immediately
setopt HIST_IGNORE_DUPS          # Don't record duplicates
setopt HIST_IGNORE_SPACE         # Don't record commands starting with space

# =============================================================================
#  COMPLETION SETTINGS 
# =============================================================================
# Initialize completion system
autoload -Uz compinit
compinit

# Enable the "Interactive Menu" (Use arrow keys to select options!)
zstyle ':completion:*' menu select

# Case insensitive completion (cd doc -> cd Documents)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Pretty colors for the completion list
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# =============================================================================
#  EXPORTS
# =============================================================================
export EDITOR=nvim
export VISUAL=nvim
export BROWSER=zen-browser
export TERMINAL=kitty
export PATH="$HOME/.local/bin/:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
export GTK_THEME=adw-gtk3-dark

# =============================================================================
#  ALIASES
# =============================================================================
# Editor
alias v="nvim"

# Package Management (Pacman/Yay)
alias ip="sudo pacman -S"
alias rp="sudo pacman -Rns"
alias up="sudo pacman -Syu"
alias iy="yay -S"
alias ry="yay -Rns"
alias uy="yay -Syu"

# Search & File Operations
alias f="find . -iname"
alias g="grep --color=auto -R"
alias ls='ls --color=auto'
alias recent-installs='grep "installed" /var/log/pacman.log | grep -v "as dependency"'
alias duh="du -h --max-depth=1"
alias duu="du -sh *"

# =============================================================================
#  PLUGINS 
# =============================================================================
# 1. Autosuggestions 
if [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# 2. Syntax Highlighting 
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# =============================================================================
#  INITIALIZATION 
# =============================================================================

# Fastfetch 
if [[ $(tty) == *"pts"* ]]; then
    if [ -f "$HOME/.config/fastfetch/config.jsonc" ]; then
        fastfetch --config "$HOME/.config/fastfetch/config.jsonc"
    else
        fastfetch
    fi
else
    if [ -f /bin/hyprctl ]; then
        echo "Start Hyprland with command Hyprland"
    fi
fi

# Tools
eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

# FZF (Standard Arch setup)
source <(fzf --zsh)
