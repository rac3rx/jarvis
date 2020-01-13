#!/usr/bin/env bash
INSTALLDIR=$PWD
targetDir=${HOME}/.config/nvim

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Backup up current files.$(tput sgr 0)"
echo "---------------------------------------------------------"

# Backup files that are provided by Jarvis into a ~/$INSTALLDIR-backup directory
#BACKUP_DIR=$INSTALLDIR/backup
BACKUP_DIR=${targetDir}/backup

#set -e # Exit immediately if a command exits with a non-zero status.

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Creating backup directory at $BACKUP_DIR.$(tput sgr 0)"
echo "---------------------------------------------------------"
mkdir -p $BACKUP_DIR

rsync -avu ./config ${BACKUP_DIR}
files=("zsh/zshrc" "tmux/tmux.conf")
for filename in "${files[@]}"; do
    if [ ! -L $filename ]; then
      echo "---------------------------------------------------------"
      echo "$(tput setaf 2)JARVIS: Backing up $filename.$(tput sgr 0)"
      echo "---------------------------------------------------------"
      cp $filename $BACKUP_DIR 2>/dev/null
      backupFiles=($(find ${BACKUP_DIR}))
      echo "---------------------------------------------------------"
      echo "$(tput setaf 2)JARVIS: Files present in $BACKUP_DIR:
                                                        $(tput sgr 0)"
      printf "%s\n" $(tput setaf 2)${backupFiles[@]}$(tput sgr 0)
      echo "---------------------------------------------------------"
    else
      echo "---------------------------------------------------------"
      echo -e "$(tput setaf 3)JARVIS: $filename does not exist at this location or is a symlink.$(tput sgr 0)"
      echo "---------------------------------------------------------"
    fi
done

#
# Setting-up dotFiles and backing-up any existing ones
#
echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Setting-up dotFiles.$(tput sgr 0)"
echo "---------------------------------------------------------"
rsync -avu ./config/nvim/ ${targetDir}
rsync -avu ./config/Pecan/ ${targetDir}
for filename in "${files[@]}"; 
do
    if [ -e ${HOME}/.${filename#*/} ]
    then
        cp ${HOME}/.${filename#*/} ${HOME}/.${filename#*/}.`date +%d%b%y`
        echo "---------------------------------------------------------"
        echo "$(tput setaf 2)JARVIS: Backed-up dotFiles:
                                                          $(tput sgr 0)"
        printf "%s\n" $(tput setaf 2) ${HOME}/.${filename#*/}.`date +%d%b%y`$(tput sgr 0)
        echo "---------------------------------------------------------"
    fi
    cp ${filename} ${HOME}/.${filename#*/}
done

echo "---------------------------------------------------------"
echo "$(tput setaf 2)JARVIS: Backup completed.$(tput sgr 0)"
echo "---------------------------------------------------------"
