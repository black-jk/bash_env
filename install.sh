#!/bin/bash
  
  ### ====================================================================================================
  ### [INSTALL]
  ### ====================================================================================================
    
    echo
    echo "[INSTALL]"
    
    ### ----------------------------------------------------------------------------------------------------
    
    install_src_path="${BASH_SOURCE[0]%/*}/src/install.sh"
    [ ! -e "${install_src_path}" ] && echo "Missing ${install_src_path}!" && exit 1
    source "${install_src_path}" || exit 1
    
    
    
    ### ----------------------------------------------------------------------------------------------------
    ### [Config Files]
    ### ----------------------------------------------------------------------------------------------------
    
                                 copy_file ".gitignore"
                                 copy_file ".gitconfig" "GIT_USERNAME,GIT_EMAIL"
    [ "${GIT_COMPLETETION}" ] && copy_file ".git-completion.bash"
    
    
    
    ### ----------------------------------------------------------------------------------------------------
    ### [Bash Shell]
    ### ----------------------------------------------------------------------------------------------------
    
    #copy_file ".bash_env" "" "/home/blackjk/.gitignore" "/home/blackjk/a" "/home/blackjk/.gitignorex"
    copy_file ".bash_env" "" "header.sh" "basic.sh" "local.sh" "footer.sh"
    
    #_compose_file "/home/blackjk/profile_test" "/home/blackjk/a" "/home/blackjk/a" "/home/blackjk/a"
    
    #files=("/home/blackjk/a" "/home/blackjk/ab" "/home/blackjk/a")
    #_compose_file "/home/blackjk/profile_test" ${files}
    
    
    ### ----------------------------------------------------------------------------------------------------
    
    echo
    echo "  [FINISHED]"
    echo
    
    
    
  ### ====================================================================================================
