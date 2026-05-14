#!/usr/bin/bash
HOME=/home/janko/code/pestow-test-env

BOLD_WHITE="\033[37;1m"
BOLD_RED="\033[31;1m"
WHITE="\033[37m"
RED="\033[31m"
THIN_WHITE="\033[37;2m"
C_END="\033[0m"

function abort_installation() {
  echo -e "\033[31;1mPestow installation aborded. Nothing changed.\033[0m"
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
echo "Checking environment."

INSTALL_PATH=$DOT_PATH/$PATCH/dot-local/bin
RC_PATH=$DOT_PATH/$PATCH/dot-pestowrc
STOW_FLAGS="--dotfiles --no-fold"
TARGET_PATH=$HOME


# Check if pestow has already been installed
if [ -f $HOME/.local/bin/pestow ]; then
  echo "Pestow has already been installed."
  abort_installation
fi

# First make the directories
if [ -d $DOT_PATH ]; then
  echo ">> Found existing dotfiles folder. Checking for existing repo."
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
    echo  ">> Dotfiles folder is not part of repository. You need to make"
    echo  "   it a repository and commit the current state before installing"
    echo  "   pestow."
    abort_installation
  fi

  if [ -d $INSTALL_PATH ]; then 
    echo ">> $INSTALL_PATH directory already in place."
  else
    mkdir -p $INSTALL_PATH
    echo ">> Created $INSTALL_PATH"
  fi
else
  echo "> Could not find old dotfiles directory."
  mkdir -p $INSTALL_PATH
  echo ">> Created $INSTALL_PATH"
  cd $DOT_PATH; git init > /dev/null 2>&1; cd - > /dev/null
  echo ">> Initialized .git repository in $DOT_PATH"
fi

create_pestowrc $RC_PATH
echo ">> Created .pestowrc ($RC_PATH/dot-pestowrc)"
cp pestow $INSTALL_PATH/pestow
echo ">> Installed pestow binary in $INSTALL_PATH/pestow"

cd $DOT_PATH
stow $STOW_FLAGS $PATCH -t $TARGET_PATH
echo ">> Stowed $PATCH:"
echo "   pestow installed in $HOME/.local/bin/pestow"
echo "   .rcpestow installed in $HOME/.rcpestow"
