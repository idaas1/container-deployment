# Deploying Verify Access using the OpenShift Operator

1 - install operator (check version is 23.3 and OpenShift can pull images from icr.io)

2 - Deploy ISVA using template + use Ansible (or other) to configure containers with required junctions, access policies, federations, ect.

Demo does not include the OpenLDAP and PostgreSQL services. Administrators should deploy the required LDAP and HVDB
services before creating containers.

    oc process -f oshift-isva-standalone-template.yaml \
        -p APP_NAME='verify-access-demo' \
        -p ISVA_VERSION='10.0.5.0' \
        -p CONFIG_SERVICE='isvaconfig' \
        -p RUNTIME_SERVICE='isvaruntime' \
        -p WEBSEAL_SERVICE='isvawebeal' \
        -p DSC_SERVICE='isvadsc' \
        -p CONFIG_ID='cfgsvc' \
        -p CONFIG_PW='betterThanPassw0rd' \
        -p ISVA_IMAGE_NAME='icr.io/isva/verify-access' \
        -p TIMEZONE='Etc/UTC' \
        -p SERVICE_ACCOUNT='verifyaccess' \
        | oc create -f -

3 - Test deployment as required

4 - Upload generated (and tested) snapshot to operator using bash script

Secrets for operator can be read from operator namespace
`oc get secret verify-access-operator -n openshift-operators -o yaml`
A simple bash script is provided to read the verify-access-operator secret from the `openshift-operators` namespace, then 
attach to the configuration container and upload the specified snapshot to the Operator's snapshot manager service.

    $ bash upload_snapshot_to_operator.sh <configuration_container_id> <snapshot_name>

eg: `$ bash upload_snapshot_to_operator.sh isamconfig-8694c5fb66-77rr5 isva_10.0.5.0_published.snapshot`

>Note: the "snapshotId" property in the operator only refers to the "published" substring in the snapshot file name.

5 - Deploy containers using the Deploy Operator template
    be careful of "stale" secrets in your namespace: `oc delete secret verify-access-operator`


    oc process -f oshift-isva-operator-template.yaml \
        -p APP_NAME='verify-access-operator-demo' \
        -p ISVA_BASE_IMAGE_NAME='icr.io/isva/verify-access' \
        -p SERVICE_ACCOUNT='verifyaccess' \
        -p ISVA_VERSION='10.0.5.0' \
        -p INSTANCE='default' \
        -p SNAPSHOT='published' \
        -p LANGUAGE='en_US.utf8' \
        -p WRP_REPLICAS='1' \
        -p RUNTIME_REPLICAS='1' \
        -p DSC_REPLICAS='1' \
        | oc create -f -
