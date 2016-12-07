#!/bin/bash
set -eu
# set -x

################################
# sshfs resmisc301.gene.com:/gne/home/your-login/ /gne/home/your-login \
#   -o defer_permissions -o volname=gnehome

##################### Variables

RESSERVER=resmisc301.gene.com
ACTION=${1:-"nothing"}
declare -a REMOTEMOUNTS
#list of mounts, these should have the same # of entries and paths *MUST* be terminated with a /
REMOTEMOUNTS=("/gne/home/$USER/"
              "/gne/research/workspace/$USER/"
              "/gne/research/scratch/$USER/"
              "/gne/research/apps/")
#this is the name that will be displayed in the finder
RMOUNTNAME=(gnehome
            workspace
            resscratch
            resapps)
mount_drive ()
{
  #mount position
  THANG=$1
  #make sure we aren't already mounted
  if [[ $(df -Ph | grep ${REMOTEMOUNTS[$THANG]}) ]]; then
      echo ${REMOTEMOUNTS[$THANG]} already mounted
  else
    echo ${REMOTEMOUNTS[$THANG]} ${RMOUNTNAME[$THANG]}
    mkdir -p ${REMOTEMOUNTS[$THANG]}
    sshfs -C $RESSERVER:${REMOTEMOUNTS[$THANG]} ${REMOTEMOUNTS[$THANG]} -o defer_permissions -o volname=${RMOUNTNAME[$THANG]}
  fi
}
unmount_drive ()
{
  #unmount
  THANG=$1
  echo "Umounting ${RMOUNTNAME[$THANG]}"
  umount -v ${REMOTEMOUNTS[$THANG]}
}

#work
RPOS="0"

case $ACTION in
  mount)
    while [[ $RPOS -lt ${#REMOTEMOUNTS[*]} ]]; do
      mount_drive $RPOS
      ((RPOS++))
    done
    ;;
  umount|unmount)
    while [[ $RPOS -lt ${#REMOTEMOUNTS[*]} ]]; do
      unmount_drive $RPOS
      ((RPOS++))
    done
    ;;
  *)
    echo "Please use 'mount|umount' instead of $ACTION"
    ;;
esac

###################################################################################################
#  $Rev:: 191672                                                        $:  Revision of last commit
#  $Author:: jonesc47                                                   $:  Author of last commit
#  $Date:: 2016-06-09 18:07:26 -0700 (Thu, 09 Jun 2016)                 $:  Date of last commit
#  $URL:: 								$:  URL of file
# End of file, if this is missing the file is truncated
###################################################################################################
