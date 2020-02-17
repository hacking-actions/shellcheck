#!/usr/bin/env bash
set -e

function die()
{
    echo "::error::$1"
    echo "------------------------------------------------------------------------------------------------------------------------"
    exit 1
}

cat << END
------------------------------------------------------------------------------------------------------------------------
                                         _          _ _      _               _    
                                        | |        | | |    | |             | |   
                                     ___| |__   ___| | | ___| |__   ___  ___| | __
                                    / __| '_ \ / _ \ | |/ __| '_ \ / _ \/ __| |/ /
                                    \__ \ | | |  __/ | | (__| | | |  __/ (__|   < 
                                    |___/_| |_|\___|_|_|\___|_| |_|\___|\___|_|\_\\
 
                        https://github.com/hacking-actions/shellcheck (c) 2019-2020 Max Hacking 
------------------------------------------------------------------------------------------------------------------------
GITHUB_ACTOR="${GITHUB_ACTOR}"
GITHUB_REPOSITORY="${GITHUB_REPOSITORY}"
GITHUB_REF="${GITHUB_REF}"
INPUT_SHELLCHECK_OPTIONS="${INPUT_SHELLCHECK_OPTIONS}"
------------------------------------------------------------------------------------------------------------------------
END

# Check for a GITHUB_WORKSPACE env variable
[[ -z "${GITHUB_WORKSPACE}" ]] && die "Must set GITHUB_WORKSPACE in env"
cd "${GITHUB_WORKSPACE}" || die "GITHUB_WORKSPACE does not exist"

exitval=0

while IFS= read -r -d '' f
do
    if [[ "$(mimetype -b "${f}")" == "application/x-shellscript" ]]; then
        echo "Checking ${f}"
        # shellcheck disable=SC2086
        shellcheck ${INPUT_SHELLCHECK_OPTIONS} "${f}" || exitval=1
    fi
done <   <(find . -type f ! -iname ".*" ! -path "./.*" -print0)

echo "------------------------------------------------------------------------------------------------------------------------"
exit ${exitval}
