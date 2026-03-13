#!/usr/bin/bash
HOME=/home/janko/code/pestow-test-env

function create_pestow_environment_file() {
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

function abort_installation() {
  echo -e "\033[31;1mPestow Installation aborded.\033[0m"
  exit 1
}

`
abort_installation


# USER INTERFACE ---------
# read install path
echo ""
echo -e "\033[97;1m--- Pestow 0.1.0 installer. Welcome! :) ---\033[0m"
echo -ne "\033[37;m> Enter executable install path \033[0m"
echo -ne "\033[37;2m(default: ~/.local/bin): \033[0m"
read -p "" INSTALL_PATH
INSTALL_PATH=${INSTALL_PATH:-"$HOME/.local/bin"}

# read dotfiles path
echo -n "> Enter name of the dotfiles directory "
echo -ne "\033[37;2m(default: ~/dotfiles): \033[0m"
read -p "" DOT_PATH
DOT_PATH=${DOT_PATH:-"$HOME/dotfiles"}

# read dotfiles patch
echo -n "> Enter name of the first dotfiles patch "
echo -ne "\033[37;2m(default: default): \033[0m"
read -p "" PATCH
PATCH=${PATCH:-"default"}


# SETTING UP ---------
echo -ne "\033[37;2m Checking environment.\033[0m"
RUN_CMD=""
ENV_PATH=$DOT_PATH/$PATCH/dot-config/pestow/environment
STOW_FLAGS="--dotfiles --no-fold"
TARGET_PATH=$HOME

# install pestow executable
RUN_CMD+="cp pestow $INSTALL_PATH/pestow;"
RUN_CMD+="echo -ne '\033[37;2m-> Installed pestow executable in:\033[0m';"
RUN_CMD+="echo -e '\033[92;1m $INSTALL_PATH/pestow\033[0m';"

# aknowledge/create the dotfiles folder
if ! [ -d $DOT_PATH ]; then
  RUN_CMD+="mkdir -p $DOT_PATH;"
  RUN_CMD+="echo -ne '\033[37;2m-> Created dotfiles directory:\033[0m';"
  RUN_CMD+="echo -e '\033[34;1m$DOT_PATH\033[0m';"
else
  echo -e "\033[37;2m-> Detected preexisting dotfiles directory.\033[0m"
fi

# aknowledge/create the dotfiles folder
if ! [ -d $DOT_PATH ]; then
  RUN_CMD+="mkdir -p $DOT_PATH;"
  RUN_CMD+="echo -ne '\033[37;2m-> Created dotfiles directory:\033[0m';"
  RUN_CMD+="echo -e '\033[34;1m$DOT_PATH\033[0m';"
else
  echo -e "\033[37;2m-> Detected preexisting dotfiles directory.\033[0m"
fi

# aknowledge/create the patch folder
if ! [ -d $DOT_PATH/$PATCH ]; then
  RUN_CMD+="mkdir -p $DOT_PATH/$PATCH/;"
  RUN_CMD+="echo -ne '\033[37;2m-> Created patch directory:\033[0m';"
  RUN_CMD+="echo -e '\033[34;1m$DOT_PATH/$PATCH\033[0m';"
else
  echo -e "\033[37;2m-> Detected preexisting patch directory.\033[0m"
fi

# create the pestow config in the patch folder
RUN_CMD+="mkdir -p $DOT_PATH/$PATCH/.config/pestow;"
RUM_CMD+="create_pestow_environment_file $ENV_PATH;"
RUN_CMD+="echo -e '\033[37;2m-> Created pestow config in $PATCH.\033[0m';"

# aknowledge/init the git repo
cd $DOT_PATH/
git status > /dev/null 2>&1
if [ $? -ne 0 ]; then
  git init; git add --all; git commit -m "initial commit"
else
  echo -e "\033[37;2m-> Detected .git repository in $DOT_PATH.\033[0m"
  echo -e "\033[37;2m   I need to commit the changes I made with the\033[0m"
  echo -en "\033[37;2m   installation. Do you wish to proceed? [Y/n] \033[0m"
  read answer
  answer=${answer:-"y"}
  case $answer in
    y|Y|yes|Yes) 
      COMMIT_MSG="Added $PROFILE and pestow configuration"
      echo -en "\033[37;2m   > Insert commit message (default: $COMMIT_MSG)\033[0m"
      read commit_msg
      commit_msg=${commit_msg:-$COMMIT_MSG}
      git add --all; git commit -m "$commit_msg"


source $ENV_PATH

stow \
  -d $PESTOW_DOT_PATH \
  $PESTOW_ACTIVE_PATCHES \
  $PESTOW_STOW_FLAGS \
  -t $PESTOW_TARGET_PATH

echo -ne "\033[37;2m-> Created and stowed pestow configuration:\033[0m "
echo -e "\033[37m$(stat --format=%N $PESTOW_TARGET_PATH/.config/pestow/environment)\033[0m"

echo -e "\033[37;1m> Installation succesful!"
echo ""
