#!/bin/bash
  
  install_src_path="${BASH_SOURCE[0]%/*}/src/install.sh"
  [ ! -e "${install_src_path}" ] && echo "Missing ${install_src_path}!" && exit 1
  source "${install_src_path}" || exit 1
#echo "HOME_DIR:        $HOME_DIR"
#echo "SCRIPT_FILE:     $SCRIPT_FILE"
#echo "SCRIPT_ROOT_DIR: $SCRIPT_ROOT_DIR"
#echo "SCRIPT_HOME_DIR: $SCRIPT_HOME_DIR"
  
  
  
  ### ====================================================================================================
  ### [Config Files]
  ### ====================================================================================================
    
    copy_file ".gitignore"
    copy_file ".gitconfig" "GIT_USERNAME,GIT_EMAIL"
    copy_file ".git-completion.bash"
    
    
    
  ### ====================================================================================================
