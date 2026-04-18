# Changing directories
setopt auto_cd					# imply cd <cmd>
#setopt cdable_vars				# imply cd ~/<cmd>
#setopt chase_links				# resolve symlinks

# Completion
#setopt auto_param_slash		# add / to directories
setopt complete_in_word

# Expansion and Globbing
setopt numeric_glob_sort		# real count when globbing numbered files

# History
setopt hist_no_store
alias h="fc -RI"				# manual cross-session import; use instead of share_history

# initialization
# input/output
setopt correct					# spell check commands only
setopt interactive_comments		# quiet on #
setopt hash_dirs				# make correct right
setopt no_beep

# Job control
setopt auto_continue			# true disown

# Prompting

# Scripts and functions

# Shell emu

# Shell State

# Zle
bindkey -v
