#
# .zshrc
#
# @author Yadavalli Santosh
#

###########################
# ZSH Settings/Completions
###########################
# Set architecture-specific brew share path.
arch_name="$(uname -m)"
if [ "${arch_name}" = "x86_64" ]; then
    share_path="/usr/local/share"
elif [ "${arch_name}" = "arm64" ]; then
    share_path="/opt/homebrew/share"
else
    echo "Unknown architecture: ${arch_name}"
fi


# Colors.
unset LSCOLORS
export CLICOLOR=1
export CLICOLOR_FORCE=1

# Don't require escaping globbing characters in zsh.
unsetopt nomatch

# Nicer prompt.
# export PS1=$'\n'"%F{green} %*%F %3~ %F{white}"$'\n'"$ "
# export PS1=$''"%F{green} %*%F %3~ %F{white}"$''"$ "

# Enable plugins.
plugins=(sudo web-search brew history kubectl virtualenvwrapper zsh-autosuggestions fzf)

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'


if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

autoload -Uz compinit && compinit

# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

####################
# Homebrew Settings
####################
# Tell homebrew to not autoupdate every single time I run it (just once a week).
export HOMEBREW_AUTO_UPDATE_SECS=604800

#########################################
# Super useful Docker container oneshots
#########################################
# Usage: dr, or dr [centos7|fedora27|debian9|debian8|ubuntu1404|etc.]
dr() {
 docker run -it geerlingguy/docker-"${1:-ubuntu1604}"-ansible /bin/bash
}

# Enter a running Docker container.
function deti() {
 if [[ ! "$1" ]] ; then
     echo "You must supply a container ID or name."
     return 0
 fi

 docker exec -it $1 bash
 return 0
}

######################################################
# Delete a given line number in the known_hosts file
######################################################
known_rm() {
 re='^[0-9]+$'
 if ! [[ $1 =~ $re ]] ; then
   echo "error: line number missing" >&2;
 else
   sed -i '' "$1d" ~/.ssh/known_hosts
 fi
}

#############################################
# PyENV/Python Virtual Environment Settings #
#############################################
# Pyenv stuff
eval "$(pyenv init -)"

export PYENV_ROOT="/Users/yvsssantosh/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export WORKON_HOME=~/.virtualenvs
pyenv virtualenvwrapper_lazy

##################
# Golang Settings
##################
# export GOPATH=$HOME/golang
# export GOROOT=/usr/local/opt/go/libexec
# export GOBIN=$GOPATH/bin
# export PATH=$PATH:$GOPATH
# export PATH=$PATH:$GOROOT/bin

################
# AWS Settings #
################
# AWS CLI Alias
alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws amazon/aws-cli'

##############################################################
# New ZSHRC Settings
##############################################################
# Goto directories list
[[ -f ~/.zsh/goto.zsh ]] && source ~/.zsh/goto.zsh

# Include alias file (if present) containing aliases for ssh, etc.
[[ -f ~/.zsh/aliases.zsh ]] && source ~/.zsh/aliases.zsh
[[ -f ~/.zsh/starship.zsh ]] && source ~/.zsh/starship.zsh
[[ -f ~/.zsh/functions.zsh ]] && source ~/.zsh/functions.zsh
# [[ -f ~/.zsh/nvm.zsh ]] && source ~/.zsh/nvm.zsh

# Load Starship
eval "$(starship init zsh)"

# Load Direnv
eval "$(direnv hook zsh)"
