test -n "${NVIM}" || command -v nvr >/dev/null || return 0

# Set nvim CD to terminal PWD
ncd() {
    nvr -c ":cd $(realpath -s "${1:-.}")"
}

# Prevent nested nvim
alias nvim="nvr --remote"
export EDITOR='nvr -cc split --remote-wait'
export GIT_EDITOR='nvr -cc split --remote-wait'
export VISUAL='nvr -cc split --remote-wait'
