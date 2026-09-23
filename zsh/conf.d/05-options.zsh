# Changing directories
setopt auto_cd # bare path = cd

# Completion
setopt complete_in_word # complete from cursor position, not just end of word

# Expansion and Globbing
setopt numeric_glob_sort # sort globs numerically (file2 before file10)
setopt glob_dots         # * matches dotfiles too
setopt multios           # redirect to multiple targets without explicit tee

# History
setopt append_history       # append upon exit
setopt extended_history     # timestamp history
setopt hist_find_no_dups    # do not report dups
setopt hist_ignore_all_dups # no dups saved
setopt hist_ignore_space    # ignore lines starting with spaces
setopt hist_no_store        # don't save the `history` command itself

unsetopt share_history # share hist between ttys
alias h="fc -RI"       # manual cross-session import; use instead of share_history

# Input/Output
setopt interactive_comments # allow # comments in interactive shell
setopt no_beep
setopt pipe_fail # pipeline exit code = first failure, not last command

# Job control
setopt long_list_jobs # show PID in job listings
