#!/bin/bash

REPOS=mip
DIR=/opt/mip
BRANCH=master

if [ ! -d ${DIR}/.git ]; then
  echo "clone"
  mkdir -p ${DIR}
  git clone -b ${BRANCH} --single-branch --depth 1 git@github.com:MarketingApplications/${REPOS} ${DIR}
  git --git-dir=${DIR}/.git config core.autocrlf false
fi
[ ! -f ~/.composer/auth.json ] && mkdir -p ~/.composer && echo "{\"github-oauth\": {\"github.com\": \"9d79e8f6b6861c37b859f7523aed9ba9e80d427f\"}}" > ~/.composer/auth.json
[ ! -d ${DIR}/src/vendor ] && cd ${DIR}/src;composer install;php artisan key:generate;

chown -R mapps ${DIR}
chmod -R g+w   ${DIR}

umask 002
/usr/sbin/httpd -D FOREGROUND
