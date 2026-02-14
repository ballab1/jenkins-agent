#!/bin/bash

#--------------------------------------------------------------------------------
function main()
{

    local -r longopts='help,build,docker_compose,env,update'
    local -r shortopts='hbceu'
    local params="$(getopt --longoptions "${longopts}" --options "${shortopts}" --name "$PROGRAM_NAME" -- "$@")" || usage $?
    eval set -- "$params"
    local -r kaniko_args="${ROOT_DIR}/kaniko.args"

    while true; do
        [ -z "${1:-}" ] && continue
        case "${1,,}" in
            -h|--help)
                usage 0
                shift 1
                ;;
            -b|--build)
               if [ ! -e "$kaniko_args" ]; then
                    ci::set_dot_env
                    ci::build 'native' "${PROGRAM_DIR}/.env" | tee "$kaniko_args"
                fi
                shift 1
                exit
                ;;
            -c|--docker_compose)
                ci::docker_compose 2>&1 | tee "${ROOT_DIR}/docker-compose.log"
                shift 1
                exit
                ;;
            -e|--env)
                ci::set_dot_env
                ci::build 'native' "${PROGRAM_DIR}/.env" | tee "$kaniko_args"
                shift 1
                exit
                ;;
            -u|--update)
                ci::update_dependent_files
                shift 1
                exit
                ;;
            --)
                shift 1
                break
                ;;
            *)
                echo "Not implemented: $1" >&2
                usage 1
                ;;
        esac
    done
    usage 0
    exit 0
}

#--------------------------------------------------------------------------------
function usage()
{
    local status="${1:-0}"

    echo "$0 [-b|-dc|-e|-u]"
    echo "    -b|build               - build the docker image using kaniko"
    echo "    -c|docker_compose      - build the docker image using docker-compose"
    echo "    -e|env                 - update the .env file"
    echo "    -u|update              - update ci files"
    exit "$status"
}

#--------------------------------------------------------------------------------

PGM_DIR="$(dirname "$(which "$0")")"

if [ -e ci.bashlib ]; then
  source ci.bashlib
elif [ -e ci/ci.bashlib ]; then
  source ci/ci.bashlib
elif [ "${PGM_DIR:-}" ] && [ -e "${PGM_DIR}/ci.bashlib" ]; then
  source "${PGM_DIR}/ci.bashlib"
else
  echo 'cannot execute this script from current directory'
  exit
fi
ci::initialize

main "$@"
