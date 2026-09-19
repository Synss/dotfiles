command -v glow >/dev/null || return 0

DOTFILES_DOC="${DOTFILES_ZSH:h}/docs"

doc() {
  local page name title line

  case "$1" in
    ''|-l)
      local -a listing
      local -i width=0 i
      for page in ${DOTFILES_DOC}/**/*.md(N.); do
        name="${${page#$DOTFILES_DOC/}%.md}"
        (( ${#name} > width )) && width=${#name}
        title=''
        while IFS= read -r line; do
          [[ "$line" == '# '* ]] && { title="${line#\# }"; break }
        done < "$page"
        listing+=("$name" "$title")
      done
      for ((i = 1; i <= $#listing; i += 2)); do
        printf "%-${width}s  %s\n" "$listing[i]" "$listing[i + 1]"
      done
      ;;
    -k)
      (( $# > 1 )) || { print -u2 'doc: -k requires a pattern'; return 2 }
      shift
      (cd -q "$DOTFILES_DOC" && rg --smart-case --heading --line-number "$@" -- **/*.md(N.))
      ;;
    -*)
      print -u2 "doc: unknown option: $1"
      return 2
      ;;
    *)
      page="${DOTFILES_DOC}/$1.md"
      if [[ ! -f "$page" ]]; then
        local -a found=(${DOTFILES_DOC}/**/${1:t}.md(N.))
        case ${#found} in
          0)
            print -u2 "doc: no reference for '$1'"
            return 1
            ;;
          1) page="${found[1]}" ;;
          *)
            print -u2 "doc: '$1' is ambiguous:"
            for name in "${found[@]}"; do
              print -u2 -- "  ${${name#$DOTFILES_DOC/}%.md}"
            done
            return 1
            ;;
        esac
      fi
      glow "$page"
      ;;
  esac
}
