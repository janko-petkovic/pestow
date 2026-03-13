# Structure of the idea


## Installation
Wtf is left to do? I forgot what I wanted to do
Ah yes, I need to do all the detecting at the beginning, and run the 
installation in the end


## Pestow

Pestow relies on the following ABSOLUTE LOCATIONS
$HOME/.config/pestow/environment

All the remaining information should be taken from the config file. 
The variables from the config file are for now

```
PESTOW_PRIMARY_PROFILE=default
PESTOW_FALLBACK_PROFILE=default

PESTOW_DOT_PATH=../dotfiles
PESTOW_LOCAL_IGNORE_PATH=../dotfiles/.stow-local-ignore
PESTOW_TARGET_PATH=..

PESTOW_STOW_FLAGS='--dotfiles --no-fold'
```

When unstowing, you always have to have a profile that's going to replace the
one you are unstowing.


pestow <patch> wipe everything and install that patch
pestow --add patch: add another patch to the ones already present
    CAVEAT: the order in which you add the patches seems to matter, since
    the last can overwrite things from all the previous ones
pestow --remove patch: opposite over the above one
pestow --refresh (-r --restow): see below

- RESTOW: we cannot call the restow directly from stow on hyprland, as it
  will break the configs and you will have to restart the pc.
  - Solution 1: after restowing, kill explicitly Hyprland. This is bad 
    since we don't want this to work only on Hyprland
  - Solution 2: stow with adopt. Something like this
    pestow -r --restow: 
        1. check that you have committed everything. If not ask to commit
           (interface) or exit the process
        2. stow --adopt from the primary profile
        3. stow --adopt --no-conflict from the secondary profile
           (this takes care also of files that have been removed from the
           primary patch and are now present in the fallback)
        4. git checkout HEAD (follow the instructions on the stow man)
        5. CHECK FOR DANGLING SYMLINKS

# Todos
- RESTRUCTURE INSTALLATION SO THAT IT DOESNT DO ANYTHING IF ABORT ANYWHERE
- for now make sure you delete previous pestow configs before installing
- pestow needs not to overwrite an already present dotfile configuration
  if it is already there > CHECK IFHOME 
