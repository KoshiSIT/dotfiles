# ────────────────────────────────────────────────────────────────
# Powerlevel10k instant prompt — must be near the top
# ────────────────────────────────────────────────────────────────
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ────────────────────────────────────────────────────────────────
# Brew prefix cache & environment variables
# ────────────────────────────────────────────────────────────────
BREW_PREFIX=${BREW_PREFIX:-$(brew --prefix)}
export ZPLUG_HOME=$BREW_PREFIX/opt/zplug
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.nvm"

# ────────────────────────────────────────────────────────────────
# PATH settings
# ────────────────────────────────────────────────────────────────
typeset -U path
path=(
  $HOME/.nodebrew/current/bin
  $HOME/.cargo/bin
  "$HOME/git_lib/termpdf.py"
  $path
)

# ────────────────────────────────────────────────────────────────
# zplug init and plugins
# ────────────────────────────────────────────────────────────────
if [[ ! -f $ZPLUG_HOME/init.zsh.zwc || $ZPLUG_HOME/init.zsh -nt $ZPLUG_HOME/init.zsh.zwc ]]; then
  zcompile $ZPLUG_HOME/init.zsh
fi
source $ZPLUG_HOME/init.zsh

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

if ! zplug check --verbose; then
  printf "Installing missing zplug plugins...\n"
  zplug install
fi

zplug load

# ────────────────────────────────────────────────────────────────
# Prezto (if installed)
# ────────────────────────────────────────────────────────────────
ZPREZTO_INIT="${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
if [[ -f "$ZPREZTO_INIT" ]]; then
  if [[ ! -f "$ZPREZTO_INIT.zwc" || "$ZPREZTO_INIT" -nt "$ZPREZTO_INIT.zwc" ]]; then
    zcompile "$ZPREZTO_INIT"
  fi
  source "$ZPREZTO_INIT"
fi

# ────────────────────────────────────────────────────────────────
# Powerlevel10k theme and config
# ────────────────────────────────────────────────────────────────
source "${ZDOTDIR:-$HOME}/.zprezto/modules/prompt/external/powerlevel10k/powerlevel10k.zsh-theme"

P10K_CONFIG=~/.p10k.zsh
if [[ -f "$P10K_CONFIG" ]]; then
  if [[ ! -f "$P10K_CONFIG.zwc" || "$P10K_CONFIG" -nt "$P10K_CONFIG.zwc" ]]; then
    zcompile "$P10K_CONFIG"
  fi
  source "$P10K_CONFIG"
fi

# ────────────────────────────────────────────────────────────────
# Lazy-load NVM
# ────────────────────────────────────────────────────────────────
function load_nvm() {
  unset -f nvm node npm npx yarn
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
for cmd in nvm node npm npx yarn; do
  eval "${cmd}(){ load_nvm; ${cmd} \$@ }"
done

# ────────────────────────────────────────────────────────────────
# Lazy-load pyenv
# ────────────────────────────────────────────────────────────────
function load_pyenv() {
  unset -f pyenv python python3 pip pip3
  command -v pyenv >/dev/null || path=($PYENV_ROOT/bin $path)
  eval "$(pyenv init - --no-rehash zsh)"
}
for cmd in pyenv python python3 pip pip3; do
  eval "${cmd}(){ load_pyenv; ${cmd} \$@ }"
done

# ────────────────────────────────────────────────────────────────
# zoxide (fast cd)
# ────────────────────────────────────────────────────────────────
if [[ ! -f ${ZDOTDIR:-$HOME}/.zoxide.zsh || -z "$(command -v zoxide)" ]]; then
  zoxide init zsh > ${ZDOTDIR:-$HOME}/.zoxide.zsh
fi
source ${ZDOTDIR:-$HOME}/.zoxide.zsh

# ────────────────────────────────────────────────────────────────
# peco history search (Ctrl+R)
# ────────────────────────────────────────────────────────────────
function peco-history-selection() {
  local selected=$(fc -l -n 1 | awk '!a[$0]++' | tail -r | peco)
  if [[ -n "$selected" ]]; then
    BUFFER="$selected"
    CURSOR=$#BUFFER
    zle reset-prompt
  fi
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# ────────────────────────────────────────────────────────────────
# Misc environment settings
# ────────────────────────────────────────────────────────────────
export DYLD_FALLBACK_LIBRARY_PATH="$BREW_PREFIX/lib:$DYLD_FALLBACK_LIBRARY_PATH"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'

# Redundant fallback (safe)
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
