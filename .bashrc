# load uswm display manager
if uwsm check may-start && uwsm select; then
        exec uwsm start default
fi

# Bail out early if non-interactive
#
# Note: We cannot produce any error messages here because, in some systems,
# /etc/gdm3/Xsession sources ~/.profile and checks stderr.  If there is any
# stderr ourputs, it refuses to start the session.
case $- in
  *i*) ;;
    *) return;;
esac

# load fish if installed (preferred shell)
if command -v fish &> /dev/null; then
  fish
  exit $?
elif command -v fish &> /dev/null; then
  fish
  exit $?
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

alias ls="ls --color=auto"
alias ll="ls -alhF"

