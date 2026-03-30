#!/usr/bin/python

from textwrap import TextWrapper
import shutil
from pathlib import Path


BOLD_WHITE="\33[37;1m"
BOLD_RED="\33[31;1m"
WHITE="\33[37m"
THIN_WHITE="\33[34m"
C_END="\033[0m"

def indent_print(indent_level,msg,end='\n'):
    if indent_level == 0:
        initial_indent = ""
        subsequent_indent = ""
    else:
        initial_indent = ">" * indent_level + " "
        subsequent_indent = " " * (indent_level+1)

    wrapper = TextWrapper(
            width=80,
            initial_indent=initial_indent,
            subsequent_indent=subsequent_indent,
            )
    formatted_msg = wrapper.wrap(msg)

    for s in formatted_msg[:-1]:
        print(s)
    print(formatted_msg[-1], end=end)

def abort_installation():
    indent_print(0,f"{BOLD_RED}Pestow installation aborted{C_END}")



def get_user_choices():
    indent_print(
        1,
        f"{WHITE}Enter the absolute executable install path {C_END}"
        f"{THIN_WHITE}(default: ~/.local/bin): {C_END}",
        end='',
    )
    install_path = Path(input())
    print(install_path)

    indent_print(
        1,
        f"{WHITE}Enter executable install path {C_END}"
        f"{THIN_WHITE}(default: ~/.local/bin): {C_END}",
        end='',
    )
    install_path = Path(input())

    return ('sdfa', 'sdfsb')

    # echo -n "> Enter name of the dotfiles directory "
    # echo -ne "\033[37;2m(default: ~/dotfiles): \033[0m"
    # read -p "" DOT_PATH
    # DOT_PATH=${DOT_PATH:-"$HOME/dotfiles"}
    #
    # echo -n "> Enter name of the first dotfiles patch "
    # echo -ne "\033[37;2m(default: default): \033[0m"
    # read -p "" PATCH
    # PATCH=${PATCH:-"default"}
    #
    

def create_pestow_config_file(
    config_path,
    dot_path,
    target_path,
    stow_flags,
    patch_name,
) -> None:
    pass



if __name__ == "__main__":
    # pretty_print(0, BOLD_RED,'hello hows everyone doing today')
    # CWD = Path.cwd()
    # abort_installation()

    indent_print(
        0, 
        f"{BOLD_WHITE}--- Pestow 0.1.0 installer. Welcome! :) ---{C_END}"
    )

    get_user_choices()
    
    
