#!/bin/bash

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


[ -f test/test.log ] && rm test/test.log
for p in {0..4}; do
  (
    echo -e '\n----------p'"$p.settings"
    [ -f .env ] && rm .env
    PROJECT_SETTINGS=$PGM_DIR/p$p.settings
    echo '  ci::initialize'
    ci::initialize
    cat "test/p$p.settings"
    echo '  ci::set_dot_env'
    ci::set_dot_env
    [ -f .env ] && cat .env
    echo '  ci::update_dependent_files'
    ci::update_dependent_files
    echo '  dopcker-compose'
    docker-compose -f test/docker-compose.yml config || exit
  ) 2>&1 | tee -a test/test.log
done