# OSC 133 shell integration (semantic prompts)
# Enables [[ / ]] navigation between prompts in Neovim's terminal

_osc133_precmd() { printf '\033]133;A\033\\' }
precmd_functions+=(_osc133_precmd)

_osc133_preexec() { printf '\033]133;C\033\\' }
preexec_functions+=(_osc133_preexec)

PROMPT+=$'%{\033]133;B\033\\%}'
