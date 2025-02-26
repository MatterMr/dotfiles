export PATH=/opt/homebrew/bin:$PATH
export XDG_CONFIG_HOME="$HOME/.config"
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export GTEST_COLOR=1

# Source ZSH plugins
# source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh


eval "$(starship init zsh)"
eval "$(zoxide init --cmd cd zsh)"

alias vim="nvim"
alias skim='/Applications/Skim.app/Contents/MacOS/Skim'
[ "$TERM" = "xterm-kitty" ] && alias ssh="kitty +kitten ssh"

# Python
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

