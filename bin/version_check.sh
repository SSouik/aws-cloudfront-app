#!/usr/bin/env bash

if [[ $# -eq 0 ]]; then
    echo "Please provide a github access token"
    exit 1;
fi

github_token=$1
upstream_version_json="https://raw.githubusercontent.com/SSouik/aws-cloudfront-app/main/version.json?token=${github_token}"

upstream_version=$(curl -s ${upstream_version_json} | grep '"version":' | cut -d\" -f4 | sed 's/[".]//g')
current_version=$(grep '"version":' version.json | cut -d\" -f4 | sed 's/[".]//g')

if [[ $upstream_version -ge $current_version ]]; then
    echo "Version number is invalid"
    exit 1;
fi

echo "Version checks out!"
