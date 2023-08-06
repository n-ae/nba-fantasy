#!/bin/sh

env_var_name=$1
dotenv_file_path=$2

tmp_file_path="./.env.tmp"

grep -v "^${env_var_name}" ${dotenv_file_path} > ${tmp_file_path}
mv ${tmp_file_path} ${dotenv_file_path}
