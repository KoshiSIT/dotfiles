# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Cache brew prefix for performance - only compute once at startup
BREW_PREFIX=${BREW_PREFIX:-$(brew --prefix)}

# Pre-compute environment variables for better performance
export ZPLUG_HOME=$BREW_PREFIX/opt/zplug
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"

# PATH settings (compile only once at startup)
typeset -U path  # Ensure PATH only contains unique entries
path=(
  $HOME/.nodebrew/current/bin
  $HOME/.cargo/bin
  "$HOME/git_lib/termpdf.py"
  $path
)

# Faster plugin loading with zcompile
if [[ ! -f $ZPLUG_HOME/init.zsh.zwc || $ZPLUG_HOME/init.zsh -nt $ZPLUG_HOME/init.zsh.zwc ]]; then
  zcompile $ZPLUG_HOME/init.zsh
fi
source $ZPLUG_HOME/init.zsh

# Plugin settings - minimal set
zplug "modules/prompt", from:prezto
zplug "zsh-users/zsh-autosuggestions"

# Function to efficiently lazy-load nvm
function load_nvm() {
  # Unset all the wrapped functions
  unset -f nvm node npm npx yarn
  
  # Load NVM only once
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # --no-use makes it faster
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# More efficient function wrapping using arrays
for cmd in nvm node npm npx yarn; do
  eval "${cmd}(){ load_nvm; ${cmd} \$@ }"
done

# Faster pyenv loading
function load_pyenv() {
  # Unset all the wrapped commands
  unset -f pyenv python python3 pip pip3
  
  # Add pyenv to PATH only if not already there
  command -v pyenv >/dev/null || path=($PYENV_ROOT/bin $path)
  
  # Use faster pyenv initialization
  eval "$(pyenv init - --no-rehash zsh)"
}

# Wrap Python commands
for cmd in pyenv python python3 pip pip3; do
  eval "${cmd}(){ load_pyenv; ${cmd} \$@ }"
done

# Load zoxide (cache the init script for faster loading)
if [[ ! -f ${ZDOTDIR:-$HOME}/.zoxide.zsh || -z "$(command -v zoxide)" ]]; then
  zoxide init zsh > ${ZDOTDIR:-$HOME}/.zoxide.zsh
fi
source ${ZDOTDIR:-$HOME}/.zoxide.zsh


# Load zplug with performance optimization
zplug load

# Load prezto with compilation check
ZPREZTO_INIT="${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
if [[ ! -f "$ZPREZTO_INIT.zwc" || "$ZPREZTO_INIT" -nt "$ZPREZTO_INIT.zwc" ]]; then
    zcompile "$ZPREZTO_INIT"
fi
source "$ZPREZTO_INIT"

# Compile p10k config if needed
P10K_CONFIG=~/.p10k.zsh
if [[ -f "$P10K_CONFIG" ]]; then
    if [[ ! -f "$P10K_CONFIG.zwc" || "$P10K_CONFIG" -nt "$P10K_CONFIG.zwc" ]]; then
        zcompile "$P10K_CONFIG"
    fi
    source "$P10K_CONFIG"
fi

# More efficient peco configuration
function peco-history-selection() {
    # Use fc instead of history for better performance
    local selected=$(fc -l -n 1 | awk '!a[$0]++' | tac | peco)
    if [[ -n "$selected" ]]; then
        BUFFER="$selected"
        CURSOR=$#BUFFER
        zle reset-prompt
    fi
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# Other environment variables
export DYLD_FALLBACK_LIBRARY_PATH="$BREW_PREFIX/lib:$DYLD_FALLBACK_LIBRARY_PATH"

