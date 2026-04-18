# Changing directories
setopt auto_cd				# bare path = cd

# Completion
setopt complete_in_word		# complete from cursor position, not just end of word

# Expansion and Globbing
setopt numeric_glob_sort	# sort globs numerically (file2 before file10)
setopt glob_dots			# * matches dotfiles too
setopt multios				# redirect to multiple targets without explicit tee

# History
setopt hist_no_store		# don't save the `history` command itself
alias h="fc -RI"			# manual cross-session import; use instead of share_history

# Input/Output
setopt interactive_comments	# allow # comments in interactive shell
setopt no_beep
setopt pipe_fail			# pipeline exit code = first failure, not last command

# Job control
setopt long_list_jobs		# show PID in job listings
