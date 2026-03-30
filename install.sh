#!/usr/bin/bash
HOME=/home/janko/code/pestow-test-env

BOLD_WHITE="\033[37;1m"
BOLD_RED="\033[31;1m"
WHITE="\033[37m"
RED="\033[31m"
THIN_WHITE="\033[37;2m"
C_END="\033[0m"

function abort_installation() {
  echo -e "\033[31;1mPestow installation aborded.\033[0m"
  exit 1
}

function create_pestowrc() {
  echo "# Profile variables:" > $1
  echo "PESTOW_ACTIVE_PATCHES=$PATCH" >> $1
  echo "" >> $1
  echo "# Path variables:" >> $1
  echo "PESTOW_DOT_PATH=$DOT_PATH" >> $1
  echo "PESTOW_TARGET_PATH=$TARGET_PATH" >> $1
  echo "" >> $1
  echo "# Stow flags:" >> $1
  echo "PESTOW_STOW_FLAGS='$(echo "$STOW_FLAGS")'" >> $1
}


# USER INTERFACE ---------
# read install path
echo ""
echo "--- Pestow 0.1.0 installer. Welcome! :) ---"

# read dotfiles path
echo -n "Enter dotfiles absolute path (default: ~/dotfiles):"
read -p "" DOT_PATH
DOT_PATH=${DOT_PATH:-"$HOME/dotfiles"}

# read dotfiles patch
echo -n "Enter name of the dotfiles patch (default: default):"
read -p "" PATCH
PATCH=${PATCH:-"default"}



# SETTING UP ---------
echo ""
pretty_echo 0 $WHITE "Checking environment.\n"

INSTALL_PATH=${INSTALL_PATH:-"$DOT_PATH/$PATCH/.dot-local/bin"}
RC_PATH=$DOT_PATH/$PATCH/dot-pestowrc
STOW_FLAGS="--dotfiles --no-fold"
TARGET_PATH=$HOME

function  {

}


# First make the directories
if [ -d $DOT_PATH ]; then
  echo ">> Found existing dotfiles folder. Checking for repositories."
  cd $DOT_PATH

  # Check git repository
  git_toplevel=git rev-parse --show-toplevel

  if [ $? -eq 0 ]; then
    echo -n ">> Dotfiles folder is already part of a .git repository: "
    if ! $(git status | grep -q "working tree clean"); then
      echo "tree is not clean. Commit everything before installing."
      abort_installation
    else
      echo "tree is clean, proceeding with installation."
    fi
  else
    echo -n ">> Dotfiles folder is not part of repository. Run git init? (y/N)"
    read -p "" INIT_DOT_PATH
    INIT_DOT_PATH=${INIT_DOT_PATH:-"n"}
    case "$INIT_DOT_PATH" in
      Y|Yes|y|yes) 
        git init;;
      N|No|n|no) 
        echo ">> Dotfiles need to be secured in a repo before installing pestow."
        abort_installation;;
      *)
        echo ">> Invalid input."
        abort_installation;;
    esac
  fi

  if [ -d $INSTALL_DIR ]; then 
    echo ">> $INSTALL_DIR directory already in place."
  else
    mkdir -p $INSTALL_PATH
    echo ">> Created $INSTALL_DIR"
  fi

else
  echo "> Could not find old dotfiles directory."
  echo ">> Configuring dotfiles filetree."

  create_pestowrc $RC_PATH
  echo ">> Generated dot-pestowrc"
  cp pestow $INSTALL_PATH/pestow
  echo ">> Installed pestow binary."
  cd $DOT_PATH; git init; git add --all; 
  git commit -m "Initial commit (by pestow installer)"
  echo ">> Setup git repository in $DOT_PATH"
else
  cd $DOT_PATH
  if ! [ -d 
  
end

echo $RUN_CMD
#
# source $ENV_PATH
#
# stow \
#   -d $PESTOW_DOT_PATH \
#   $PESTOW_ACTIVE_PATCHES \
#   $PESTOW_STOW_FLAGS \
#   -t $PESTOW_TARGET_PATH
#
# echo -ne "\033[37;2m-> Created and stowed pestow configuration:\033[0m "
# echo -e "\033[37m$(stat --format=%N $PESTOW_TARGET_PATH/.config/pestow/environment)\033[0m"
#
# echo -e "\033[37;1m> Installation succesful!"
# echo ""
