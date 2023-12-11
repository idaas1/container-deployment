echo "Creating Service Account"
oc create serviceaccount verifyaccess-config
oc create serviceaccount verifyaccess-anyuid
oc create serviceaccount verifyaccess-nonroot

echo "Creating verifyaccess Security Context Constraint"
oc create -f isva-security-constraint.yaml

echo "Adding service accounts to Security Constraints"
oc adm policy add-scc-to-user verifyaccess -z verifyaccess-config
oc adm policy add-scc-to-user anyuid -z verifyaccess-anyuid
oc adm policy add-scc-to-user nonroot -z verifyaccess-nonroot
echo "Done."
