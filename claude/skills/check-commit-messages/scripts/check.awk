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
  if (length(effective) > limit) print "  SUBJECT_TOOLONG(" length(effective) "): " subject
  for (i = 1; i <= n; i++) {
    if (length(lines[i]) > 72) print "  LINE" i "_TOOLONG(" length(lines[i]) "): " lines[i]
    if (lines[i] ~ /—|;/) print "  LINE" i "_PUNCT: " lines[i]
  }
}
