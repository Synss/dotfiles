# stop (XOFF) - ^S - XOFF - ^S - freeze terminal
# start (XON) - ^Q - resume terminal
# rprnt -       ^R
stty \
    stop undef \
    start undef \
    rprnt undef
