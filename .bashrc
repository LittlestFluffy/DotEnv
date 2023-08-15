# Bail out early if non-interactive
#
# Note: We cannot produce any error messages here because, in some systems,
# /etc/gdm3/Xsession sources ~/.profile and checks stderr.  If there is any
# stderr ourputs, it refuses to start the session.
case $- in
  *i*) ;;
    *) return;;
esac

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

# Check for interactive bash and that we haven't already been sourced.
if [ "x${BASH_VERSION-}" != x -a "x${PS1-}" != x -a "x${BASH_COMPLETION_VERSINFO-}" = x ]; then
    # Check for recent enough version of bash.
    if [ "${BASH_VERSINFO[0]}" -gt 4 ] ||
        [ "${BASH_VERSINFO[0]}" -eq 4 -a "${BASH_VERSINFO[1]}" -ge 2 ]; then
        [ -r "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ] &&
            . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
        if shopt -q progcomp && [ -r /usr/share/bash-completion/bash_completion ]; then
            # Source completion code.
            . /usr/share/bash-completion/bash_completion
        fi
    fi
fi

alias ls="ls --color=auto"
alias ll="ls -alhF"

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#if [[ $(id -u) -eq 0 ]];then
#  PS1=$'\u@\h \e[0;35m\w\e[0m \e[0;33m$(parse_git_branch)\e[0;0m]$ '
#else
  PS1=$'[\u@\h \[\e[0;35m\]\w\[\e[0m\]\[\e[0;33m\]$(parse_git_branch)\[\e[0;0m\]]$ '
#fi

if command -v module &> /dev/null; then
  eb_env() {
    TARGET="${1:-default}"
    export EASYBUILD_MODULES_TOOL=EnvironmentModules
    export EASYBUILD_MODULE_SYNTAX=Tcl
    export EASYBUILD_BUILDPATH=/local

    if [[ "amd" == "${TARGET}" ]]; then
      export EASYBUILD_INSTALLPATH_SOFTWARE=/cm/shared/app/amd
      export EASYBUILD_INSTALLPATH_MODULES=/cm/shared/modules/amd
    elif [[ "intel" == "${TARGET}" ]]; then
      export EASYBUILD_INSTALLPATH_SOFTWARE=/cm/shared/app/int
      export EASYBUILD_INSTALLPATH_MODULES=/cm/shared/modules/int
    elif [[ "legacy" == "${TARGET}" ]]; then
      export EASYBUILD_INSTALLPATH_SOFTWARE=/cm/shared/apps
      export EASYBUILD_INSTALLPATH_MODULES=/cm/shared/modulefiles
    else
      export EASYBUILD_INSTALLPATH_SOFTWARE=${HOME}/cm/shared/apps
      export EASYBUILD_INSTALLPATH_MODULES=${HOME}/cm/shared/modules
    fi

    # reset loaded modules
    module purge
    module load slurm NewBuild/AMD EasyBuild

    echo -e "Easybuild (\033[0;33mv${EBVERSIONEASYBUILD}\033[0m) using the \033[0;32m${TARGET}\033[0m environment (\033[0;32m${EASYBUILD_INSTALLPATH_SOFTWARE}\033[0m). Change with: eb_env [amd|intel|legacy]"
  }

  eb_env
fi

