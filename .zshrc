# ---------------------------------------------------------------------------
#
# Description:  This file holds all of the shell configurations for ZSH
#
# Sections:
# 0. Custom Commands
# 1. Make Terminal Better
# 2. Process Management
# 3. Networking
# 4. Environment
# 5. Plugins

# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# 0. Custom Commands
# ---------------------------------------------------------------------------

# Moves a file to the MacOS trash
  function trash() {
    command mv "$@" ~/.Trash ;
  }

# Use exa [https://github.com/ogham/exa] instead of ls
  function myls() {
    exa -GlhF --no-user --no-permissions --icons --git --time-style long-iso --color-scale --group-directories-first "$@";
  }

# Use zoxide [https://github.com/ajeetdsouza/zoxide] instead of cd
  function mycd() {
    z "$@"; myls;
  }

# Use bat [https://github.com/sharkdp/bat] instead of cat
  function mycat() {
    bat --style=plain --theme=Nord "$@";
  }

# Remind yourself of an alias (given some part of it)
  function showa() {
    /usr/bin/grep --color=always -i -a1 $@ ~/.zshrc | grep -v '^\s*$';
  }

# Create a folder and move into it in one command
  function mcd() {
    mkdir -p "$@" && mycd "$_";
  }

# Display useful host related information
  function ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;ip
    echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
  }

# List processes owned by my user
  function myps() {
    ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ;
  }

# Export .env file to the environment
  function setenv() {
    unamestr=$(uname)
    if [ "$unamestr" = 'Linux' ]; then
      export $(grep -v '^#' .env | xargs -d '\n')
    elif [ "$unamestr" = 'FreeBSD' ] | [ "$unamestr" = 'Darwin' ]; then
      export $(grep -v '^#' .env | xargs -0)
    fi
  }

# ---------------------------------------------------------------------------
# 1. Make Terminal Better
# ---------------------------------------------------------------------------

# Use custom 'ls' command
  alias ls='myls'

# Use custom 'cd' command
  alias cd='mycd'

# Use custom 'cat' command
  alias cat='mycat'

# Preferred 'mkdir' implementation
  alias mkdir='mkdir -pv'

# Preferred 'cp' implementation
  alias cp='cp -iv'

# Preferred 'mv' implementation
  alias mv='mv -iv'

# Clear terminal display
  alias c='clear'

# Opens current directory in MacOS Finder
  alias f='open -a Finder ./'

# Source zshrc after making changes
  alias sz='source ~/.zshrc'

# History configuration
  HISTFILE=~/.zsh_history
  HISTSIZE=10000
  SAVEHIST=10000
  setopt appendhistory
  setopt HIST_IGNORE_ALL_DUPS
  setopt HIST_FIND_NO_DUPS

# ---------------------------------------------------------------------------
# 2. Process Management
# ---------------------------------------------------------------------------

# Recommended 'top' invocation to minimize resources
# ---------------------------------------------------------------------------
# Taken from this macosxhints article
# http://www.macosxhints.com/article.php?story=20060816123853639
# ---------------------------------------------------------------------------
  alias ttop="top -R -F -s 10 -o rsize"

# Find CPU hogs
  alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

# Find memory hogs
  alias memHogsTop='top -l 1 -o rsize | head -20'
  alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

# ---------------------------------------------------------------------------
# 3. Networking
# ---------------------------------------------------------------------------

# Display the current machine's IP address
  alias ip='echo -en \ - Public facing IP Address:\ ; curl ipecho.net/plain ; echo ; echo -en \ - Internal IP Address:\ ; ipconfig getifaddr en0'

# All listening connections
  alias openPorts='sudo lsof -i | grep LISTEN'

# Show all open TCP/IP sockets
  alias netCons='lsof -i'

# Display only open UDP sockets
  alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'

# Display only open TCP sockets
  alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'

# ---------------------------------------------------------------------------
# 4. Environment
# ---------------------------------------------------------------------------

# Set the default editor to vim
  export EDITOR='vim'

# Install to USER instead of root
  export HOMEBREW_CASK_OPTS="--appdir=$HOME/Applications"

# Docker
  export DOCKER_HOST="$(docker context inspect --format '{{ .Endpoints.docker.Host }}')"

# Enable Homebrew [https://docs.brew.sh/Installation]
  eval "$($HOME/.homebrew/bin/brew shellenv)"

# Enable starship theme [https://github.com/starship/starship]
  eval "$(starship init zsh)"

# Enable node version manager with fnm [https://github.com/Schniz/fnm]
  eval "$(fnm env --use-on-cd)"

# Enable zoxide [https://github.com/ajeetdsouza/zoxide]
  eval "$(zoxide init zsh)"

# Enable fzf [https://github.com/junegunn/fzf]
  source <(fzf --zsh)

# PNPM for Node in USER library
  export PNPM_HOME="~/Library/pnpm"
  case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
  esac

# ---------------------------------------------------------------------------
# 5. Plugins
# ---------------------------------------------------------------------------

# Syntax highlighting [https://github.com/zsh-users/zsh-syntax-highlighting]
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Auto suggestions [https://github.com/zsh-users/zsh-autosuggestions]
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Auto-completions [https://github.com/marlonrichert/zsh-autocomplete]
source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh