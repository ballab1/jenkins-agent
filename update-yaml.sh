#!/bin/bash

#--------------------------------------------------------------------------------
function main()
{
    local branch="$(ci::gitBranch)"

    # update (if needed) this project if we are on a developer branch
    if [[ ! $branch =~ HEAD|main|staging ]]; then
        [ "${JENKINS_URL:-}" ] || (ci::update_dependent_files)   # only perform updates in local environment
    fi
    return 0
}

#--------------------------------------------------------------------------------

if [ -e ci.bashlib ]; then
  source ci.bashlib
elif [ -e ci/ci.bashlib ]; then
  source ci/ci.bashlib
elif [ -e "$(dirname "$0")/ci.bashlib" ]; then
  source "$(dirname "$0")/ci.bashlib"
else
  echo 'cannot execute this script from current directory'
  exit
fi
ci::initialize

main "$@"
