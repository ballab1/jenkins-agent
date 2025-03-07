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

source "$(git rev-parse --show-toplevel)/ci/ci.bashlib"
ci::initialize

main "$@"
