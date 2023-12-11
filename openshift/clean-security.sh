echo "Deleting Service Accounts"
oc delete serviceaccount verifyaccess-config
oc delete serviceaccount verifyaccess-anyuid
oc delete serviceaccount verifyaccess-nonroot

echo "Deleting Security Context Constraint"
oc delete -f isva-security-constraint.yaml

echo "Done."
