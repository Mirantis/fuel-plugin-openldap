#!/bin/bash

for ROLE in 'openldap-master'
do
  if $(/usr/bin/fuel role --rel 2 2>/dev/null| grep -q $ROLE)
  then
     echo "Role $ROLE exists, trying to update it from $INSTALLPATH/role_$ROLE.yaml."
     /usr/bin/fuel role --rel 2 --update --file $INSTALLPATH/role_$ROLE.yaml
  else
     echo "Role $ROLE does not exist, trying to create it from $INSTALLPATH/role_$ROLE.yaml."
     /usr/bin/fuel role --rel 2 --create --file $INSTALLPATH/role_$ROLE.yaml
  fi

  taskdir=/etc/puppet/modules/osnailyfacter/modular/${ROLE}
  if [ ! -d "$taskdir" ]; then
      mkdir -p "$taskdir"
  fi

  cat $INSTALLPATH/tasks_$ROLE.yaml > ${taskdir}/tasks.yaml
done


fuel rel --sync-deployment-tasks --dir /etc/puppet/2014.2.2-6.1/
