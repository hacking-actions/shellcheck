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
 
                           https://github.com/hacking-actions/shellcheck (c) 2019 Max Hacking 
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
        shellcheck -s bash "${f}" || exitval=1
    fi
done <   <(find . -type f ! -iname ".*" ! -path "./.*" -print0)

echo "------------------------------------------------------------------------------------------------------------------------"
exit ${exitval}
