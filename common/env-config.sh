#!/bin/bash

# This script sets up environment variables for use by the rest of the Verify Access Container Deployment scripts.
# This script is designed to be sourced from within other scripts so that variables are available on exit.

# If IPs or Versions updated here, you must also run compose/update-env-file.sh to update docker-compose project .env file.
# Kubernetes YAML files do not accept environment variables.  They must be updated by hand.

# IP addresses on local machine used for exposing ports from Docker containers.
# These should be mapped in /etc/hosts to appropriate hostnames

# Bind to lmi.iamlab.ibm.com
MY_LMI_IP=127.0.0.2

# Bind to www.iamlab.ibm.com
MY_WEB1_IP=127.0.0.3

# Spare binding if needed
MY_WEB2_IP=127.0.0.4

# Versions
CONTAINER_BASE=icr.io/verify-access
ISVA_VERSION=10.0.6.0
LDAP_VERSION=10.0.6.0
DB_VERSION=10.0.6.0


# Get directory for this script
THISDIR="`dirname \"$0\"`"         # relative
THISDIR="`( cd \"$THISDIR/..\" && pwd )`"  # absolutized and normalized
if [ -z "$THISDIR" ] ; then
  echo "Failed to get local path"
  exit 1  # fail
fi

# Location where Keystores will be created
DOCKERKEYS=${THISDIR}/local/dockerkeys

# Location where Docker Shares will be created
# Note that this directory is also hardcoded into YAML files
DOCKERSHARE=${HOME}/dockershare
export DOCKERSHARE
