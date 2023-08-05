#!/bin/sh

env_var_name=$1
project_path=$2

pushd ${project_path}
grep -v "^${env_var_name}" .env > .env.tmp
mv .env.tmp .env
popd
