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
  
  if   [ "$(echo "${HOSTNAME}" | sed -r 's/^((ap[0-9]|dev)(\.(hemidemi|tintint)\.com)?)$/true/g')" == "true" ]; then
    ENV_NAME="${ENV_HEMIDEMI}"
  elif [ "$(echo "${HOSTNAME}" | sed -r 's/^(BlackJK-PC|BlackJK-NB(2)?|BlackJK-HD-NB1)$/true/g')" == "true" ]; then
    ENV_NAME="${ENV_BLACKJK}"
  else
    ENV_NAME="${ENV_DEFAULT}"
  fi
  
  
  
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
  
  
  
  ### ====================================================================================================
  ### [Functions]
  ### ====================================================================================================
    
    function copy_file {
      filename="${1}"
      variables="${2}"
      source_file_path="${SCRIPT_HOME_DIR}/${filename}"
      dest_file_path="${HOME_DIR}/${filename}"
      msg="[Install] ${dest_file_path} "
      
      
      if [ "${variables}" ]; then
        echo "  [Variable]"
        variables="${variables},"
        tmp_source_file_path="${SCRIPT_TEMP_DIR}/${filename}"
        tmp_source_file_dir="${tmp_source_file_path%/*}"
        
        mkdir -p "${tmp_source_file_dir}"
        cp "${source_file_path}" "${tmp_source_file_path}"
        
        while [ "${variables%,}" ]; do
          variable_name="${variables%%,*}"
          variable_value="${!variable_name}"
          variables="${variables#*,}"
          
          echo "    ${variable_name}: ${variable_value}"
          sed -r -i "s/\\$\\{${variable_name}\\}/${variable_value//\//\\/}/g" "${tmp_source_file_path}"
        done
      else
        tmp_source_file_path="${source_file_path}"
      fi
      
      
      if [ -e "${dest_file_path}" ]; then
        if [ "$(diff "${tmp_source_file_path}" "${dest_file_path}")" ]; then
          backup_file "${dest_file_path}"
        else
          echo "${msg}[SKIP]" && return
        fi
      fi
      
      cp "${tmp_source_file_path}" "${dest_file_path}" && echo "${msg}[OK]" || echo "${msg}[FAIL]"
    }
    
    ### ----------------------------------------------------------------------------------------------------
    
    function backup_file {
      file_path="${1}"
      backup_file_path="$(get_backup_path "${dest_file_path}")"
      cp "${file_path}" "${backup_file_path}" && echo "[Backup] [${file_path}] [${backup_file_path}]"
    }
    
    ### --------------------------------------------------
    
    function get_backup_path {
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
