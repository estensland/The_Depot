# Alias generator that also echoes what the original command was
function run_and_tell(){
  echo
  echo Running: $@
  echo
  eval $@
  echo
}
function alias_gen(){
  alias $1="run_and_tell \"$2\""
}

function batch_alias_create(){
  for i in "$@"
  do
    alias_name=`echo $i| cut -d':' -f 1`
    alias_action=`echo $i| cut -d':' -f 2`
    alias_gen $alias_name "$alias_action"
  done
}

# Basic General Commands
batch_alias_create  \
"reshell:source ~/.bash_profile" \
"..:cd .." \
"...:cd ..." \
"lg:ls -G" \
"la:ls -AF" \
"ll:ls -alh" \
"l:ls -a" \
"l1:ls -1" \
"lo:ls -l | sed -e 's/--x/1/g' -e 's/-w-/2/g' -e 's/-wx/3/g' -e 's/r--/4/g' -e 's/r-x/5/g' -e 's/rw-/6/g' -e 's/rwx/7/g' -e 's/---/0/g'" \
"recent:ls -lAt | head" \
"old:ls -lAt | tail"


# Postgres Server Commands
batch_alias_create  \
"pgstart:pg_ctl -D /usr/local/var/postgres -l logfile start"\
"pgstop:pg_ctl -D /usr/local/var/postgres stop"

# MySql Server Commands
batch_alias_create  \
"mysqlstart:mysql.server start"


# ps aux command
function psaux(){
  ps aux | grep $1
}



# Grab from other alias files

if [ -f ~/coding/MeadHall/dotfiles/aliases/.bundler_aliases.sh ]; then
  source ~/coding/MeadHall/dotfiles/aliases/.bundler_aliases.sh
fi

if [ -f ~/coding/MeadHall/dotfiles/aliases/.custom_aliases.sh ]; then
  source ~/coding/MeadHall/dotfiles/aliases/.custom_aliases.sh
fi

if [ -f ~/coding/MeadHall/dotfiles/aliases/.homebrew_aliases.sh ]; then
  source ~/coding/MeadHall/dotfiles/aliases/.homebrew_aliases.sh
fi

if [ -f ~/coding/MeadHall/dotfiles/aliases/.heroku_aliases.sh ]; then
  source ~/coding/MeadHall/dotfiles/aliases/.heroku_aliases.sh
fi

if [ -f ~/coding/MeadHall/dotfiles/aliases/.git_aliases.sh ]; then
  source ~/coding/MeadHall/dotfiles/aliases/.git_aliases.sh
fi

if [ -f ~/coding/MeadHall/dotfiles/aliases/.rails_aliases.sh ]; then
  source ~/coding/MeadHall/dotfiles/aliases/.rails_aliases.sh
fi

if [ -f ~/coding/MeadHall/dotfiles/aliases/.url_aliases.sh ]; then
  source ~/coding/MeadHall/dotfiles/aliases/.url_aliases.sh
fi

if [ -f ~/coding/MeadHall/dotfiles/aliases/.zeus_aliases.sh ]; then
  source ~/coding/MeadHall/dotfiles/aliases/.zeus_aliases.sh
fi