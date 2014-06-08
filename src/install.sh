#!/bin/bash
  
  ### ====================================================================================================
  ### [Functions]
  ### ====================================================================================================
    
    function copy_file {
      filename="${1}"
      variables="${2}"
      
      compose_source_files=()
      if [ "${#@}" -ge "3" ]; then
        for file in "${@:2}"
        do
          if [ "${file}" ]; then
            compose_source_files=("${compose_source_files[@]}" "${file}")
          fi
        done
      fi
      
      source_file_path="${SCRIPT_HOME_DIR}/${filename}"
      dest_file_path="${HOME_DIR}/${filename}"
      echo -e "  "
      echo -e "  [Install] ${COLOR_HIGHTLIGHT1}${dest_file_path}${COLOR_CLEAR}"
      
      ### ------------------------------
      
      if [ "${#compose_source_files[@]}" -gt "0" ]; then
        tmp_source_file_path="$(_make_temp_file "${filename}")"
        
        #_compose_file "${tmp_source_file_path}" ${compose_source_files[@]}
        
        composed_dest_file_path="${tmp_source_file_path}"
        
        echo -e "    [Compose] ${COLOR_HIGHTLIGHT1}files: ${#compose_source_files[@]}${COLOR_CLEAR}"
        echo -n > "${composed_dest_file_path}"
        for file_path in ${compose_source_files[@]}
        do
          
          file_path="${source_file_path}.partial/${file_path}"
          
          echo -ne "      ${COLOR_HIGHTLIGHT1}$(_space "${file_path}" 64)${COLOR_CLEAR}"
          if [ ! -e "${file_path}" ]; then
            echo -e "   ${COLOR_ERROR}[ERROR] Missing file!${COLOR_CLEAR}"
          else
            cat "${file_path}" >> "${composed_dest_file_path}"
            echo
          fi
        done
      else
        tmp_source_file_path="$(_make_temp_file "${filename}" "${source_file_path}")"
      fi
      
      ### ------------------------------
      
      if [ "${variables}" ]; then
        _handle_variables "${tmp_source_file_path}" "${variables}"
      fi
      
      ### ------------------------------
      
      if [ -e "${dest_file_path}" ]; then
        if [ "$(diff "${tmp_source_file_path}" "${dest_file_path}")" ]; then
          echo -n "  "
          _backup_file "${dest_file_path}"
        else
          echo -e "    [${COLOR_SUCCESS}SKIP${COLOR_CLEAR}]" && return
        fi
      fi
      
      cp "${tmp_source_file_path}" "${dest_file_path}" && echo -e "    [${COLOR_SUCCESS}OK${COLOR_CLEAR}]" || echo -e "    [${COLOR_ERROR}FAIL${COLOR_CLEAR}]"
    }
    
    ### ----------------------------------------------------------------------------------------------------
    
    function _compose_file {
      composed_dest_file_path="${1}"
      files=${@:2}
echo "files: '${files}'"
      
      echo -e "    [Compose] ${COLOR_HIGHTLIGHT1}files: ${#files[@]}${COLOR_CLEAR}"
      echo -n > "${composed_dest_file_path}"
      for file_path in ${files[@]}
      do
        echo -ne "      ${COLOR_HIGHTLIGHT1}$(_space "${file_path}" 64)${COLOR_CLEAR}"
        if [ ! -e "${file_path}" ]; then
          echo -e "   ${COLOR_ERROR}[ERROR] Missing file!${COLOR_CLEAR}"
        else
          cat "${file_path}" >> "${composed_dest_file_path}"
          echo
        fi
      done
    }
    
    ### ----------------------------------------------------------------------------------------------------
    
    function _make_temp_file {
      file_path="${1}"
      source_file_path="${2}"
      
      tmp_file_path="${SCRIPT_TEMP_DIR}/${file_path}"
      tmp_file_dir="${tmp_file_path%/*}"
      mkdir -p "${tmp_file_dir}"
      
      if [ "${source_file_path}" ]; then
        if [ -e "${source_file_path}" ]; then
          cp "${source_file_path}" "${tmp_file_path}"
        else
          echo "    [ERROR] [_make_temp_file] Missing source file: '${source_file_path}'"
          echo -n > "${tmp_file_path}"
        fi
      else
        echo -n > "${tmp_file_path}"
      fi
      
      echo "${tmp_file_path}"
    }
    
    ### ----------------------------------------------------------------------------------------------------
    
    function _handle_variables {
      file_path="${1}"
      variables="${2},"
      
      echo "    [Variable]"
      while [ "${variables%,}" ]; do
        variable_name="${variables%%,*}"
        variable_value="${!variable_name}"
        variables="${variables#*,}"
        
        echo -e "      ${COLOR_HIGHTLIGHT1}$(_space "${variable_name}" 16): ${variable_value}${COLOR_CLEAR}"
        sed -r -i "s/\\$\\{${variable_name}\\}/${variable_value//\//\\/}/g" "${file_path}"
      done
    }
    
    ### ----------------------------------------------------------------------------------------------------
    
    function _backup_file {
      file_path="${1}"
      backup_file_path="$(_get_backup_path "${file_path}")"
      cp "${file_path}" "${backup_file_path}" && echo "  [Backup] ${backup_file_path}"
    }
    
    ### --------------------------------------------------
    
    function _get_backup_path {
      file_path="${1}"
      backup_file_path="${file_path}.bak"
      
      i=0
      while [ -e "${backup_file_path}" ]; do
        i=$((${i} + 1))
        backup_file_path="${file_path}.bak${i}"
      done
      
      echo "${backup_file_path}"
    }
    
    
    
    ### ----------------------------------------------------------------------------------------------------
    
    function _space {
      _msg="${1}                                                                                                                                "
      _num="${2}"
      echo "${_msg:0:${_num}}"
    }
    
    ### ----------------------------------------------------------------------------------------------------
    
    function _quit {
      echo -e "${COLOR_ERROR}${1}${COLOR_CLEAR}\n"
      exit 1
    }
    
    
    
  ### ====================================================================================================
  ### [Definition]
  ### ====================================================================================================
    
    
    ### --------------------------------------------------
    ### [COLOR]
    ### --------------------------------------------------
    
    COLOR_CLEAR="\e[0m"
    COLOR_ERROR="\e[0;31m"
    COLOR_CANCEL="\e[1;30m"
    COLOR_SUCCESS="\e[0;32m"
    
    COLOR_HIGHTLIGHT1="\e[1;1m"
    COLOR_HIGHTLIGHT2="\e[1;33m"
    
    ### --------------------------------------------------
    ### [ENV]
    ### --------------------------------------------------
    
    ENV_NAME_HEMIDEMI="hemidemi"
    ENV_NAME_BLACKJK="blackjk"
    
    ENV_OS_WIN="win"
    ENV_OS_LINUX="linux"
    
    ENV_SHELL_BASH="bash"
    ENV_SHELL_CYGWIN="cygwin"
    ENV_SHELL_GIT="git-bash"
    
    ENV_USER_ROOT="root"
    ENV_USER_BLACKJK="blackjk"
    
    
    
    ### ----------------------------------------------------------------------------------------------------
    
    HOME_DIR="$(cd && pwd)"
    
    SCRIPT_FILE="${0##*/}"
    SCRIPT_ROOT_DIR="$(cd ${BASH_SOURCE%/*/${SCRIPT_FILE}} && pwd)"
    SCRIPT_HOME_DIR="${SCRIPT_ROOT_DIR}/home"
    SCRIPT_TEMP_DIR="${SCRIPT_ROOT_DIR}/tmp"
    
    ### --------------------------------------------------
    
    ### ENV_NAME  : ENV_NAME_HEMIDEMI | ENV_NAME_BLACKJK
    ### ENV_OS    : ENV_OS_WIN | ENV_OS_LINUX
    ### ENV_SHELL : ENV_SHELL_BASH | ENV_SHELL_CYGWIN | ENV_SHELL_GIT
    ### ENV_USER  : ENV_USER_ROOT | ENV_USER_BLACKJK
    
    if   [ "$(echo "${HOSTNAME}" | sed -r 's/^((ap[0-9]|dev)(\.(hemidemi|tintint)\.com)?)$/true/g')" == "true" ]; then
      ENV_NAME="${ENV_NAME_HEMIDEMI}"
      ENV_OS="${ENV_OS_LINUX}"
    elif [ "$(echo "${HOSTNAME}" | sed -r 's/^(BlackJK-HD-NB1)$/true/g')" == "true" ]; then
      ENV_NAME="${ENV_NAME_HEMIDEMI}"
      ENV_OS="${ENV_OS_WIN}"
    elif [ "$(echo "${HOSTNAME}" | sed -r 's/^(BlackJK-PC|BlackJK-NB(2)?)$/true/g')" == "true" ]; then
      ENV_NAME="${ENV_NAME_BLACKJK}"
      ENV_OS="${ENV_OS_WIN}"
    else
      _quit "[Error] Unknow \$HOSTNAME: '${HOSTNAME}'"
    fi
#ENV_NAME="${ENV_NAME_BLACKJK}"
    
    if [ "${ENV_OS}" == "${ENV_OS_WIN}" ]; then
      if [ -d "/cygdrive" ]; then
        ENV_SHELL="${ENV_SHELL_CYGWIN}"
      else
        ENV_SHELL="${ENV_SHELL_GIT}"
      fi
    else
      ENV_SHELL="${ENV_SHELL_BASH}"
    fi
    
    ENV_USER="$(whoami)"
    
    
    
    ### ----------------------------------------------------------------------------------------------------
    ### [GIT]
    ### ----------------------------------------------------------------------------------------------------
    
    ### GIT_USERNAME     : blackjk
    ### GIT_EMAIL        : blackjk0@gmail.com | blackjkchen@hemidemi.com
    ### GIT_COMPLETETION : 0 | 1
    
    if [ "${ENV_NAME}" == "${ENV_NAME_HEMIDEMI}" ]; then
      GIT_USERNAME="blackjk"
      GIT_EMAIL="blackjkchen@hemidemi.com"
    else
      GIT_USERNAME="blackjk"
      GIT_EMAIL="blackjk0@gmail.com"
    fi
    
    if [ "${ENV_OS}" == "${ENV_OS_LINUX}" ]; then
      GIT_COMPLETETION="1"
    else
      GIT_COMPLETETION=""
    fi
    
    
    