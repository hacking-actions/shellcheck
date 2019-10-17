#!/usr/bin/env bash
set -e

if [[ -z "${GITHUB_WORKSPACE}" ]]; then
    echo "Must set GITHUB_WORKSPACE in env"
    exit 1
fi

cd "${GITHUB_WORKSPACE}" || exit 2

ls -la
echo -e "\n"

exitval=0

for f in $(find . -type f ! -iname ".*" ! -path "./.*" -printf '%P\n')
do
    if [[ "$(mimetype -b "${f}")" == "application/x-shellscript" ]]; then
        shellcheck -s bash "${f}" || exitval=1
    fi
done

exit ${exitval}
