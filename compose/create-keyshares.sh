#!/bin/bash

# Get directory for this script
RUNDIR="`dirname \"$0\"`"         # relative
RUNDIR="`( cd \"$RUNDIR\" && pwd )`"  # absolutized and normalized
if [ -z "$RUNDIR" ] ; then
  echo "Failed to get local path"
  exit 1  # fail
fi

# Get environment from common/env-config.sh
. $RUNDIR/../common/env-config.sh

KEY_DIR=${DOCKERSHARE}/composekeys

if [ ! -d "$KEY_DIR" ]; then mkdir -p $KEY_DIR; fi

if [ ! -f "$DOCKERKEYS/openldap/ldap.key" ] || [ ! -f "$DOCKERKEYS/openldap/ldap.crt" ] || [ ! -f "$DOCKERKEYS/openldap/ca.crt" ] || [ ! -f "$DOCKERKEYS/openldap/dhparam.pem" ] || [ ! -f "$DOCKERKEYS/postgresql/server.pem" ]
then
        echo "Key files not found.  Restore or create keys before running this script."
        exit 1
fi

echo "Creating key shares at $KEY_DIR"
cp -R $DOCKERKEYS/* $KEY_DIR
echo "Done."
