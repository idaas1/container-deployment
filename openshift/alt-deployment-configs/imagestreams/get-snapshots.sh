# Get docker container ID for isvaconfig container
ISVACONFIG="$(oc get --no-headers=true pods -l name=isva-config -o custom-columns=:metadata.name)"

# Copy the current snapshots from isvaconfig container
SNAPSHOTS=`oc exec ${ISVACONFIG} ls /var/shared/snapshots`
for SNAPSHOT in $SNAPSHOTS; do
oc cp ${ISVACONFIG}:/var/shared/snapshots/$SNAPSHOT .
done

