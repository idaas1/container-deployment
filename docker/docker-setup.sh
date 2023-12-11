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

if [ ! -f "${DOCKERKEYS}/openldap/ldap.key" ] || [ ! -f "${DOCKERKEYS}/openldap/ldap.crt" ] || [ ! -f "${DOCKERKEYS}/openldap/ca.crt" ] || [ ! -f "${DOCKERKEYS}/openldap/dhparam.pem" ] || [ ! -f "${DOCKERKEYS}/postgresql/server.pem" ]
then
  echo "Key files not found.  Restore or create keys before running this script."
  exit 1
fi

docker network create isva

docker volume create isvaconfig
docker volume create libldap
docker volume create libsecauthority
docker volume create ldapslapd
docker volume create pgdata

docker run -t -d --restart always -v pgdata:/var/lib/postgresql/data -v ${DOCKERKEYS}/postgresql:/var/local -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=Passw0rd -e POSTGRES_DB=isva -e POSTGRES_SSL_KEYDB=/var/local/server.pem --hostname postgresql --name postgresql --network isva ibmcom/verify-access-postgresql:${DB_VERSION}

docker run -t -d --restart always -v libldap:/var/lib/ldap -v ldapslapd:/etc/ldap/slapd.d -v libsecauthority:/var/lib/ldap.secAuthority -v ${DOCKERKEYS}/openldap:/container/service/slapd/assets/certs --hostname openldap --name openldap -e LDAP_DOMAIN=ibm.com -e LDAP_ADMIN_PASSWORD=Passw0rd -e LDAP_CONFIG_PASSWORD=Passw0rd -p ${MY_LMI_IP}:1636:636 --network isva ibmcom/verify-access-openldap:${LDAP_VERSION} --copy-service

docker run -t -d --restart always -v isvaconfig:/var/shared --hostname isvaconfig --name isvaconfig -e CONTAINER_TIMEZONE=Europe/London -e ADMIN_PWD=Passw0rd -p ${MY_LMI_IP}:443:9443 --network isva ibmcom/verify-access:${ISVA_VERSION}

docker run -t -d --restart always -v isvaconfig:/var/shared --hostname isvawrprp1 --name isvawrprp1 -e CONTAINER_TIMEZONE=Europe/London -p ${MY_WEB1_IP}:443:9443 -e INSTANCE=rp1 --network isva ibmcom/verify-access-wrp:${ISVA_VERSION}

docker run -t -d --restart always -v isvaconfig:/var/shared --hostname isvaruntime --name isvaruntime -e CONTAINER_TIMEZONE=Europe/London --network isva ibmcom/verify-access-runtime:${ISVA_VERSION}

docker run -t -d --restart always -v isvaconfig:/var/shared --hostname isvadsc --name isvadsc -e CONTAINER_TIMEZONE=Europe/London -e INSTANCE=1 --network isva ibmcom/verify-access-dsc:${ISVA_VERSION}
