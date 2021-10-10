#!/usr/bin/env bash

_REPOFILE=${REPOFILE:-/home/makepkg/mypersonalrepo.conf}

# Exit even if the sed command fails: https://www.shellcheck.net/wiki/SC2015
#[[ -v REPONAME ]] && sed -i "s/_REPONAME_/${REPONAME}/g" "${_REPOFILE}" || { printf "No reponame provided, exit"; exit 1; }
#[[ -v REPOURL ]] && sed -i "s,_URL_,${REPOURL},g" "${_REPOFILE}" || { printf "No repourl provided, exit"; exit 1; }

exec "$@"
