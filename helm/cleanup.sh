helm delete iamlab
kubectl delete pvc iamlab-pvc-cfg
kubectl delete pvc iamlab-pvc-db
kubectl delete pvc iamlab-pvc-ldp
kubectl delete secret helm-isvaadmin
kubectl delete secret dockerlogin
kubectl delete secret openldap-keys
kubectl delete secret postgresql-keys
kubectl delete ingress iamlab-isvawrp-rp1
kubectl delete ingress iamlab-isvaconfig
