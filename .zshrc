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
export PS1=$''"%F{green} %*%F %3~ %F{white}"$''"$ "

# Enable plugins.
plugins=(sudo web-search brew history kubectl virtualenvwrapper)

# Bash-style time output.
export TIMEFMT=$'\nreal\t%*E\nuser\t%*U\nsys\t%*S'

# Include alias file (if present) containing aliases for ssh, etc.
if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

autoload -Uz compinit && compinit

# Case insensitive.
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'

# Allow fuzzy search
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Load zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

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
knownrm() {
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

###################
# Google Cloud SDK
###################
# Enable below if installing google-cloud-sdk cask
# source "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"

# Ask for confirmation when 'prod' is in a command string.
#prod_command_trap () {
#  if [[ $BASH_COMMAND == *prod* ]]
#  then
#    read -p "Are you sure you want to run this command on prod [Y/n]? " -n 1 -r
#    if [[ $REPLY =~ ^[Yy]$ ]]
#    then
#      echo -e "\nRunning command \"$BASH_COMMAND\" \n"
#    else
#      echo -e "\nCommand was not run.\n"
#      return 1
#    fi
#  fi
#}
#shopt -s extdebug
#trap prod_command_trap DEBUG
