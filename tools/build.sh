#!/bin/bash
case $1 in
-k) keep="keep"; shift;;
*)  keep="";;
esac
set -o pipefail
# yes | crew install buildessential $keep
arch=`uname -m`
for i in "$@"; do
    version=$(awk -f <(cat <<EOF
        /<version *['"]/ { sub(/^.*version *['"]/, ""); sub(/['"].*$/, ""); print; exit; }
    EOF
    ) <"${i}.rb"
    yes | crew build $i $keep 2>&1 | tee "$i-$version-chromeos-$arch.log"
    case .$? in
    .141) ;;        # ignore SIGPIPE
    *)    exit 1;;  # abort at errors
    esac
done
