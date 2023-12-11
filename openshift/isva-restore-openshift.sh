#!/bin/bash

# Create a temporary working directory
TMPDIR=/tmp/backup-$RANDOM$RANDOM
mkdir $TMPDIR

if [ $# -ne 1 ]
then
  echo "Usage: $0 <archive file>"
  exit 1
fi

if [ ! -f "$1" ]
then
  echo "File not found - $1"
  exit 1
fi

# Unpack archive to temporary directory
tar -xf $1 -C $TMPDIR

# Get docker cont ainer ID for openldap container
OPENLDAP="$(oc get --no-headers=true pods -l app=openldap -o custom-columns=:metadata.name)"

# Restore LDAP Data to OpenLDAP
echo "Loading LDAP Data..."
oc cp ${TMPDIR}/secauthority.ldif ${OPENLDAP}:/tmp/secauthority.ldif
oc exec ${OPENLDAP} -- ldapadd -c -f /tmp/secauthority.ldif -H "ldaps://localhost:636" -D "cn=root,secAuthority=Default" -w "Passw0rd" > /tmp/isva-restore.log 2>&1
oc cp ${TMPDIR}/ibmcom.ldif ${OPENLDAP}:/tmp/ibmcom.ldif
oc exec ${OPENLDAP} -- ldapadd -c -f /tmp/ibmcom.ldif -H "ldaps://localhost:636" -D "cn=root,secAuthority=Default" -w "Passw0rd" >> /tmp/isva-restore.log 2>&1
oc exec ${OPENLDAP} -- rm /tmp/secauthority.ldif
oc exec ${OPENLDAP} -- rm /tmp/ibmcom.ldif

# Get docker container ID for postgresql container
POSTGRESQL="$(oc get --no-headers=true pods -l app=postgresql -o custom-columns=:metadata.name)"

# Restore DB
echo "Loading DB Data..."
oc exec ${POSTGRESQL} -i -- /usr/local/bin/psql isva < ${TMPDIR}/isva.db >> /tmp/isva-restore.log 2>&1

# Get docker container ID for isvaconfig container
ISVACONFIG="$(oc get --no-headers=true pods -l name=verifyaccess-config -o custom-columns=:metadata.name)"

# Copy snapshots to the isvaconfig container
echo "Copying Snapshot..."
SNAPSHOTS=`ls ${TMPDIR}/*.snapshot`
for SNAPSHOT in $SNAPSHOTS; do
oc cp ${SNAPSHOT} ${ISVACONFIG}:/var/shared/snapshots
done

rm -rf $TMPDIR

# Restart config container to apply updated files
echo "Killing Config Pod (a new one will be started)..."
oc delete pod ${ISVACONFIG}

echo "Done."
