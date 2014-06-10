  ### ====================================================================================================
  ### [Git]
  ### ====================================================================================================
    
    ### http://blog.xuite.net/sphjlc062218/thinking/63628944
    
    ### [git-completion]
    
    if [ -e ~/.git-completion.bash ]; then
      source ~/.git-completion.bash
    elif [ -e /etc/bash_completion.d/git ]; then
      source /etc/bash_completion.d/git
    fi
    
    __git_ps1_exist=$(type __git_ps1 > /dev/null 2>&1 && echo 1 || echo 0)
    
    if [ "${__git_ps1_exist}" == "1" ]; then
      PS1="[\[\e[32m\]\u@\h\[\e[33m\]\$(__git_ps1)\[\e[0m\] \[\e[1m\]\W\[\e[0m\]]$ "
    else
      function git_branch {
        ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
        echo " ("${ref#refs/heads/}")";
      }
      
      #PS1="[\[\[\e[1;32m\]\]\w\[\[\e[0m\]\]] \[\[\e[0m\]\]\[\[\e[1;36m\]\]\$(git_branch)\[\[\e[0;33m\]\]\$(git_since_last_commit)\[\[\e[0m\]\]$ "
      PS1="[\u@\h \W\$(git_branch)]$ "
    fi
    
    unset __git_ps1_exist
    
    
    
