if [ $# -ne 1 ]; then
echo "Usage: $0 <snapshot>"
exit 1
fi

if [ ! -f $1 ]; then
echo "File not found: $1"
exit 1
fi

cp $1 build-runtime/temp.snapshot
cp $1 build-dsc/temp.snapshot
cp $1 build-wrp/temp.snapshot
oc start-build verifyaccess --from-dir build-runtime --follow
oc start-build verifyaccess --from-dir build-dsc --follow
oc start-build verifyaccess --from-dir build-wrp --follow
rm build-runtime/temp.snapshot
rm build-dsc/temp.snapshot
rm build-wrp/temp.snapshot
