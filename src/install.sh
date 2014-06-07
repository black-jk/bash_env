#!/bin/bash
  
  ### ====================================================================================================
  ### [Definition]
  ### ====================================================================================================
  
  HOME_DIR="$(cd && pwd)"
  
  SCRIPT_FILE="${0##*/}"
  SCRIPT_ROOT_DIR="$(cd ${BASH_SOURCE%/*/${SCRIPT_FILE}} && pwd)"
  SCRIPT_HOME_DIR="${SCRIPT_ROOT_DIR}/home"
  SCRIPT_TEMP_DIR="${SCRIPT_ROOT_DIR}/tmp"
  
  ### ----------------------------------------------------------------------------------------------------
  
  ENV_HEMIDEMI="hemidemi"
  ENV_BLACKJK="blackjk"
  ENV_DEFAULT="default"
  
  OS_LINUX="linux"
  OS_WIN="win"
  
  if   [ "$(echo "${HOSTNAME}" | sed -r 's/^((ap[0-9]|dev)(\.(hemidemi|tintint)\.com)?)$/true/g')" == "true" ]; then
    ENV_NAME="${ENV_HEMIDEMI}"
    ENV_OS="${OS_LINUX}"
  elif [ "$(echo "${HOSTNAME}" | sed -r 's/^(BlackJK-HD-NB1)$/true/g')" == "true" ]; then
    ENV_NAME="${ENV_HEMIDEMI}"
    ENV_OS="${OS_WIN}"
  elif [ "$(echo "${HOSTNAME}" | sed -r 's/^(BlackJK-PC|BlackJK-NB(2)?)$/true/g')" == "true" ]; then
    ENV_NAME="${ENV_BLACKJK}"
    ENV_OS="${OS_WIN}"
  else
    ENV_NAME="${ENV_DEFAULT}"
    ENV_OS="${OS_WIN}"
  fi
#ENV_NAME="${ENV_BLACKJK}"
  
  
  
  ### ----------------------------------------------------------------------------------------------------
  ### [GIT]
  ### ----------------------------------------------------------------------------------------------------
  
  if [ "${ENV_NAME}" == "${ENV_HEMIDEMI}" ]; then
    GIT_USERNAME="blackjk"
    GIT_EMAIL="blackjkchen@hemidemi.com"
  else
    GIT_USERNAME="blackjk"
    GIT_EMAIL="blackjk0@gmail.com"
  fi
  
  if [ "${ENV_OS}" == "${OS_LINUX}" ]; then
    GIT_COMPLETETION="1"
  else
    GIT_COMPLETETION=""
  fi
  
  
  
  ### ====================================================================================================
  ### [Functions]
  ### ====================================================================================================
    
    function copy_file {
      filename="${1}"
      variables="${2}"
      source_file_path="${SCRIPT_HOME_DIR}/${filename}"
      dest_file_path="${HOME_DIR}/${filename}"
      echo "  "
      echo "  [Install] ${dest_file_path}"
      
      ### ------------------------------
      
      if [ "${variables}" ]; then
        tmp_source_file_path="$(_make_temp_file "${filename}" "${source_file_path}")"
        _handle_variables "${tmp_source_file_path}" "${variables}"
      else
        tmp_source_file_path="${source_file_path}"
      fi
      
      ### ------------------------------
      
      if [ -e "${dest_file_path}" ]; then
        if [ "$(diff "${tmp_source_file_path}" "${dest_file_path}")" ]; then
          echo -n "  "
          _backup_file "${dest_file_path}"
        else
          echo "    [SKIP]" && return
        fi
      fi
      
      cp "${tmp_source_file_path}" "${dest_file_path}" && echo "    [OK]" || echo "    [FAIL]"
    }
    
    ### ----------------------------------------------------------------------------------------------------
    
    function _compose_file {
      dest_file_path="${1}"
      files=${@:2}
      
      echo "    [Compose]"
      echo -n > "${dest_file_path}"
      for file_path in ${files[@]}
      do
        if [ -e "${file_path}" ]; then
          echo "    [ERROR] [_compose_file] Missing source file: '${file_path}'"
        else
          cat "${file_path}" >> "${dest_file_path}"
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
        
        echo "      ${variable_name}: ${variable_value}"
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
    
    
    
  ### ====================================================================================================
