# Counts code points, not bytes: mawk has no multibyte support and gawk
# only counts characters under a UTF-8 locale.
function chars(s) {
  gsub(/[\200-\277]/, "", s)
  return length(s)
}
BEGIN {
  RS = "\x02"
  FS = "\x01"
}
NF {
  n = split($2, lines, "\n")
  subject = lines[1]
  effective = subject
  if (prefix_re != "" && subject ~ prefix_re) sub(prefix_re, "", effective)
  print "COMMIT " $1
  if (chars(effective) > limit) print "  SUBJECT_TOOLONG(" chars(effective) "): " subject
  for (i = 1; i <= n; i++) {
    if (chars(lines[i]) > 72) print "  LINE" i "_TOOLONG(" chars(lines[i]) "): " lines[i]
  }
}
