#!/bin/bash

rm -f /etc/fuel/client/config.yaml

DIR=`dirname ${BASH_SOURCE[0]}`
declare -a roles=(`ls $DIR/deployment_scripts/roles/`)

FUEL='/usr/bin/fuel'
REL=`$FUEL rel | grep -i ubuntu | awk '{print $1}'`
FUEL_REL=`$FUEL rel | grep -i ubuntu | awk '{print $NF}'`

function create_roles {
  #This will break if you try to apply to an upgraded env
  for role in ${roles[@]}; do
    $FUEL role --rel $REL | awk '{print $1}' | grep -qx ${role%.*}
      if [[ $? -eq 0 ]]; then
        $FUEL role --rel $REL --update --file ${DIR}/deployment_scripts/roles/${role}
      else
        $FUEL role --rel $REL --create --file ${DIR}/deployment_scripts/roles/${role}
      fi
  done
}

create_roles
cp -a ${DIR}/deployment_scripts/openldap /etc/puppet/$FUEL_REL/modules/osnailyfacter/modular/
$FUEL rel --sync-deployment-tasks --dir /etc/puppet/$FUEL_REL

