#!/bin/bash
  
  ### ====================================================================================================
  ### [START]
  ### ====================================================================================================
    
    echo
    echo "[INSTALL]"
    
    
    
  ### ====================================================================================================

  install_src_path="${BASH_SOURCE[0]%/*}/src/install.sh"
  [ ! -e "${install_src_path}" ] && echo "Missing ${install_src_path}!" && exit 1
  source "${install_src_path}" || exit 1
  
  
  
  ### ====================================================================================================
  ### [Config Files]
  ### ====================================================================================================
    
                                 copy_file ".gitignore"
                                 copy_file ".gitconfig" "GIT_USERNAME,GIT_EMAIL"
    [ "${GIT_COMPLETETION}" ] && copy_file ".git-completion.bash"
    
    
    copy_file "profile_test" "" "/home/blackjk/.gitignore" "/home/blackjk/a" "/home/blackjk/.gitignorex"
    
    #_compose_file "/home/blackjk/profile_test" "/home/blackjk/a" "/home/blackjk/a" "/home/blackjk/a"
    
    #files=("/home/blackjk/a" "/home/blackjk/ab" "/home/blackjk/a")
    #_compose_file "/home/blackjk/profile_test" ${files}
    
    
  ### ====================================================================================================
  ### [END]
  ### ====================================================================================================
    
    echo
    echo "  [FINISHED]"
    echo
    
    
    
  ### ====================================================================================================
